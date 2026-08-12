## Chapter 22

## Troubleshoot Common Cabling Problems

This chapter covers the following topics related to Objective 5.2 (Given a scenario, troubleshoot common cabling and physical interface issues) of the CompTIA Network+ N10-009 certification exam:

- Cable issues

  - Incorrect cable

    - Single mode vs. multimode
    - Category 5/6/7/8
    - Shielded twisted pair (STP) vs. unshielded twisted pair (UTP)
  - Signal degradation

    - Crosstalk
    - Interference
    - Attenuation
  - Improper termination
  - Transmitter (TX)/Receiver (RX) transposed
- Interface issues

  - Increasing interface counters

    - Cyclic redundancy check (CRC)
    - Runts
    - Giants
    - Drops
  - Port status

    - Error disabled
    - Administratively down
    - Suspended
- Hardware issues

  - Power over Ethernet (PoE)

    - Power budget exceeded
    - Incorrect standard
  - Transceivers

    - Mismatch
    - Signal strength

A lot can go wrong when it comes to the physical media (cables) that make up a network. But the great news is that there are more tools and techniques than ever before to proactively head off physical layer issues.

This chapter ensures that you understand the common problems to watch out for, as well as the tools that the best in the industry commonly use to solve these many potential issues.

### Foundation Topics

### Specifications and Limitations

There are some very basic requirements when it comes to thinking about the physical layer media of your infrastructure. You need to focus on at least these three aspects of the specifications and limitations for the media:

- **Throughput:** This is a measure of the total amount of data that media can send over a given time period.
- **Speed:** This is a measure of the data send rate; for example, Cat 6 media supports a maximum speed of 10Gbps.
- **Distance:** For both wired and wireless media, as you get farther away from the sender over the media, you start to suffer the effects of attenuation (that is, a weakening of the signal over distance). You need to pay attention to the maximum distances supported by various physical layer media options. For example, Cat 6 has become the minimum standard for new network cable installations. And while the speed of Cat 6 (10Gbps) is exciting, Cat 6 supports distances only up to 55 meters.

### Common Cable Issues

The following are some considerations you should keep in mind when considering physical cable:

- **Single mode versus multimode:** Remember to select the appropriate type of fiber cable, with your main two options being single mode and multimode. [***Single mode***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_625) fiber features a smaller core diameter supporting a single light mode. [***Multimode***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_420) fiber, with its larger core diameter, supports multiple light modes and is ideal for shorter distances and bandwidth-hungry applications. Note that these types of applications are often found in the LAN portion of enterprise networks today.

![](../images/key_topic_icon_158.jpg)
- **Shielded versus unshielded:** Physical cable often needs to be twisted or shielded (or both) in order not to suffer from electromagnetic interference (EMI). For example, in [***shielded twisted-pair (STP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_610) cables, a metallic shielding covers the twisted pair inside the cable. This shielding helps protect against EMI, but it does so at a cost: These types of cables can be much more expensive than unshielded cables due to the shielding.

With [***unshielded twisted-pair (UTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_730) cables, the twists in the cable are tighter to reduce EMI. This eliminates the need for the expensive shielding.

- **Category 5/6/7/8:** Choosing the correct category of UTP cable is crucial for optimizing network performance, ensuring signal integrity, minimizing interference, and future-proofing the infrastructure. Different UTP categories (5/6/7/8) offer varying levels of bandwidth, data transmission speeds, and resistance to crosstalk and EMI.
- **Plenum and riser rated:** If a twisted-pair cable is to be installed under raised flooring or in an open-air return, fire codes must be considered. For example, imagine that a fire breaks out in a building. If the outer insulation of a twisted-pair cable catches fire or starts to melt, it could release toxic fumes. If those toxic fumes were released in a location such as an open-air return, those fumes could be spread throughout a building, posing a huge health risk.

To mitigate the concern of pumping poisonous gas throughout a building’s heating, ventilation, and air-conditioning (HVAC) system, plenum-rated cabling can be used. The outer insulation of a plenum twisted-pair cable is fire retardant; in addition, some plenum cabling uses a fluorinated ethylene polymer (FEP) or a low-smoke polyvinyl chloride (PVC) to minimize dangerous fumes.

Note

Check your local fire codes before installing network cabling.

A *riser* is a vertical area that passes from one floor to another floor inside a building. Riser-rated cables are cables that run through risers; they should be fire-proof to prevent flames from traveling up the cable. However, the fire rating requirements for riser areas are less strict than the requirements for plenum areas.

- **Attenuation:** As mentioned earlier in this chapter, distance is one of the enemies of cabling. [***Attenuation***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_063) is the loss of signal experienced as data transmits over distance and across the network medium. The longer the signal travels through the media, the more it weakens (known as *signal degradation*). It is very important to know the maximum distances for the various media in your enterprise network. Attenuation is measured in decibels (dB), which is covered shortly.
- **Interference:** While they are not as sensitive to [***interference***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_326) as wireless media, cables can suffer from EMI and other types of interference that cause signal degradation. Just as with wireless networks, you need to do proper testing for interference issues before deploying physical media. In addition, to reduce interference, you should follow the recommendations of the cable manufacturer.
- **Crosstalk:** [***Crosstalk***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_178) refers to the unwanted transfer of signals between communication channels, often causing interference and degradation of the signal quality. This phenomenon is prevalent in various communication systems, including telephony, networking, and audio equipment. Crosstalk occurs when a signal transmitted on one circuit or channel creates an undesired effect on another circuit or channel. It can be caused by physical proximity of the wires, EMI, or poor shielding and insulation. Effective crosstalk management is essential to ensure clear and reliable communication, particularly in environments with high data transmission rates and dense wiring.
- **Decibel (dB) loss:** If physical cable has lots of different splits or splices in it, there might be a great deal of dB loss. This loss is also more prone to happen as the signal needs to go farther and farther in the media.
- **Bad cables, incorrect pinouts, or bent pins:** Faulty cables (with electrical characteristics preventing successful transmission) or faulty connectors (which do not properly make connections) can prevent successful data transmission at Layer 1. A bad cable could simply be an incorrect category of cable being used for a specific purpose. For example, using a Cat 5 cable (instead of a Cat 6 or higher cable) to connect two 1000BASE-TX devices would result in data corruption. Bent pins in a connector or incorrect pinouts could also cause data to become corrupted.
- **Bad ports:** A physical port on a network device might be bad. You can often easily confirm whether a port is bad by looking at the network connection LED and status indicators.
- **Open/short:** An *open* is a broken strand of copper that prevents current from flowing through a circuit. A *short* occurs when two copper connectors touch each other, resulting in current flowing through that short rather than through the attached electrical circuit because the short has lower resistance.
- **Light-emitting diode (LED) status indicators:** Many network devices are very specialized and require special types of indicators. Oftentimes, indicators are implemented in the form of special LED status indicators. Thanks to such indicators, with a single glance, a network administrator can ascertain whether there is a problem with the network device. For example, a solid green LED for a network card normally indicates that the card is connected or receiving a signal. If there are no lights present or if the lights are orange or red, the network may not be connected properly or may be receiving a signal from the network.
- **Speed and duplex issues:** Speed and duplex mismatches can be tricky to troubleshoot in a network, especially considering that connectivity is often maintained (although at unacceptable levels). Auto-negotiation of speed and duplex between network devices should be tested and verified before production deployment.
- **Transmitter (TX) and receiver (RX) transposed:** Some Ethernet switches support *media-dependent interface crossover (MDIX)*, which allows a switch port to properly configure its leads as transmit (TX) or receive (RX) leads. You can interconnect such switches by using a straight-through cable (as opposed to a crossover cable). However, if a network device does not support MDIX, it needs a crossover cable in order for its TX leads to connect to the RX leads on a connected device and vice versa. Therefore, you must take care when selecting cable types for interconnecting network components.
- **Dirty optical cables:** An often-overlooked aspect of fiber-optic media care and maintenance is keeping the fiber-optic connector end faces clean. A dirty fiber connection can either slow down or completely inhibit network traffic. One method to clean optical cables is to use a combination of wet and dry cleaning approaches. For example, you might use a small amount of solvent on a wiping material and immediately dry the surface.
- **Improper termination:** Improper termination occurs when the ends of a cable are not correctly connected to the connectors or devices, leading to poor signal transmission and potential data loss. Symptoms of improper termination include intermittent connectivity, slow network performance, and frequent data errors. This problem can result from incorrect wiring, loose connections, or the use of inappropriate connectors. Ensuring proper termination involves following standardized wiring schemes, using the right tools, and double-checking connections to maintain the integrity and performance of the cabling system.

### Common Interface Issues

Although many things can go wrong with your cables and interfaces, fortunately, network operating systems will typically help you by displaying *interface counters* to signal problems. Here are some of the more common interface metrics that you should be aware of:

- **Cyclic redundancy check:** [***Cyclic redundancy check (CRC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_181) errors on a network device indicate that data packets have been corrupted during transmission. These errors occur when the receiving device’s calculated CRC value does not match the value sent with the data packet, signaling that the data has been altered or damaged. What can cause these errors? Typically, CRC errors are the result of faulty cables, EMI, or hardware problems.

![](../images/key_topic_icon_158.jpg)
- **Runts:** Is your network interface reporting [***runts***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_584) on the network? Runts refer to data packets that are smaller than the minimum allowed size. For Ethernet networks, this is typically less than 64 bytes. What could cause such packet sizes? Typically, the issue is with collisions, faulty hardware, or improper network configurations.
- **Giants:** As you might guess, [***giant***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_286) errors are essentially the opposite of runt errors. Giants occur when data packets exceed the maximum allowed size. This is typically 1518 bytes for Ethernet networks. These oversized packets can result from faulty hardware, misconfigurations, or software failures.
- **Drops:** Interface [***drop***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_233) errors occur when a network interface discards incoming or outgoing packets due to congestion, buffer overflows, or other issues. These drops most often result from excessive network traffic, insufficient bandwidth, or hardware limitations.

Another important characteristic of your interfaces that you should monitor is the *port status*. The following are three important port statuses that you should monitor:

- **Error disabled:** A port might enter the [***error disabled***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_253) status when some violation has occurred on the network. For example, a switch port might enter the error disabled state when it is configured for BPDU Guard and a BPDU arrives on the interface. This is desired behavior, since the introduction of a rogue switch could have disastrous impacts on the Layer 2 infrastructure.
- **Administratively down:** Network interfaces will often default to this status, requiring network administrators to manually enable those interfaces they plan to use. On a Cisco router, for example, you would use the **no shutdown** command to enable an interface and force it to leave the [***administratively down***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_045) status.
- **Suspended:** While an error disabled state is common when there has been a violation based on a network engineer’s configuration of some protection mechanism, a [***suspended***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_670) port is often the result of an error in configuration or a hardware problem. Like error disabled ports, a suspended port will not send or receive traffic.

### Common Hardware Issues

At this point in the chapter, you might be thinking, “When is this list of potential problems going to end?” Well, let’s round out the list of potential issues with a couple of items that are more hardware-centric:

- [***Power over Ethernet (PoE)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_515) **:** Power over Ethernet (PoE) is a technology that makes it simple to connect devices such as cameras and access points to the network and have these devices get power from the single network connection. This relieves you from having to find an outlet for plugging in a number of smart devices. For PoE to work, you must use Cat 5e or better media. You also must ensure that you are providing enough total power for the device to operate properly. A common error you might see should you violate this principle is the *power budget exceeded* error. Finally, there are several PoE standards in use in networking today. Be sure you are following the correct standard in your hardware and software configurations.

![](../images/key_topic_icon_158.jpg)
- **Incorrect transceivers:** A *transceiver* is a device that is able to both send and receive analog or digital signals. You must be sure to select transceivers carefully. The transceiver you select for a network device must match the cable type used and the wavelengths (*signal strength*) that are in use on the network. A *transceiver mismatch* is often best avoided through careful documentation review.

### Common Tools

As we have seen in this chapter, there is a lot that can go wrong in your modern network. We have examined cabling issues, interface issues, and hardware issues. Fortunately, this chapter does contain some great news. There are many tools you can use to attack these problems and even prevent them from occurring. In this chapter, we present the tools that you can use to help identify or solve problems related to your interfaces, cables, and hardware. In [Chapter 25](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#ch25), “[Network Troubleshooting Tools](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#ch25),” you will learn about many more tools at your disposal for more general network troubleshooting. Some of our cable-centric tools include

- **Cable crimper:** A crimper, as pictured in [Figure 22-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22fig01), can be used to attach a connector (for example, an RJ45 connector) to the end of a UTP cable. To accompany a crimper, you might want to purchase a spool of cable (for example, Category 6 or higher UTP cable) and a box of RJ45 connectors. You will then be equipped to make your own Ethernet patch cables, which might be less expensive than buying pre-terminated UTP cables. Making your own is also convenient when you need a patch cable of a nonstandard length or when you need a nonstandard pinout on the RJ45 connectors (for example, when you need a T1 crossover cable). Many crimpers have a built-in wire stripper and wire snip function as well.

![](../images/22fig01.jpg)


**Figure 22-1** Crimper

- **Punchdown tool:** When terminating wires on a punchdown block (for example, a 110 block), you insert an insulated wire between two contact blades. These blades cut through the insulation and make electrical contact with the inner wire. As a result, you do not have to strip off the insulation. However, if you attempt to insert the wire between the two contact blades using a screwdriver, for example, the blades might be damaged to the point where they will not make a good connection. Therefore, you should use a punchdown tool, which is designed to properly insert an insulated wire between the two contact blades without damaging the blades.
- **Loopback plug:** When troubleshooting a network device, you might want to confirm that a network interface is functional (for example, ensure that it can transmit and receive traffic). One way to perform such a test is to attach a loopback plug to a network interface and run diagnostic software designed to use the loopback plug. A loopback plug takes the transmit pins on an Ethernet connector and connects them to the receive pins, such that everything that is transmitted is received back on the interface. Similarly, a fiber-optic loopback plug, as shown in [Figure 22-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22fig02), interconnects a fiber connector’s transmit fiber with a connector’s receive fiber. The diagnostic software can then transmit traffic out of a network interface and confirm its successful reception on that same interface.
- **Optical time-domain reflectometer (OTDR) and time-domain reflectometer (TDR):** Suppose that you have been troubleshooting a network cable (either copper or fiber optic), and you determine that there is a break in or physical damage to the cable. Identifying exactly where a break or damage exists in a long length of cable can be problematic. Fortunately, you can use a time-domain reflectometer (TDR) for copper cabling or an optical time-domain reflectometer (OTDR) for fiber-optic cabling to locate a cable fault. Both light and electricity travel at speeds approaching 3 × 108 meters per second (approximately 186,000 miles per second), although the speeds are a bit slower and vary depending on the media. A TDR can send an electrical signal down a copper cable or an OTDR can send light down a fiber-optic cable, and when the electrical signal or light encounters a cable fault, a portion of the electric signal or light reflects back to the source. Based on the speed of electricity or light in the medium and the amount of time required for the reflected electric signal or light to be returned to the source, a TDR or an OTDR can mathematically determine where the cable fault lies. [Figure 22-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22fig03) shows an example of an OTDR.

![](../images/22fig02.jpg)


**Figure 22-2** Fiber-Optic Loopback Plug (Photo Courtesy of DigiKey Corporation, [https://www.digikey.com](https://www.digikey.com/))


![](../images/22fig03.jpg)


**Figure 22-3** Optical Time-Domain Reflectometer (Photo Courtesy of Coral-i Solutions, [https://www.coral-i.co.za](https://www.coral-i.co.za/))

- **Multimeter:** When working with copper cabling (as opposed to fiber-optic cabling), you can use a multimeter to check a variety of electrical characteristics in a cable, including resistance (in ohms), current (in amps), and voltage (in volts). [Figure 22-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22fig04) shows an example of a multimeter.

![](../images/22fig04.jpg)


**Figure 22-4** Multimeter

For example, you could use the ohmmeter function of a multimeter (the resistance feature) to check the continuity of an Ethernet cable. If you connect the two leads of a multimeter to two pins of a cable, the resulting resistance is approximately 0 ohms if those two pins are connected, and the resulting resistance approaches an infinite number of ohms if the pins do not connect with one another.

Another common use of a multimeter is for measuring voltage. For example, you could check the leads of an Ethernet cable to see whether DC voltage is being applied to a device requiring PoE.

- **Wire map tester:** Wire map testing enables you to determine whether a wire has continuity and whether each conductor of a four-pair cable is correctly connected to the corresponding pin at the far end. Wire map testing tests for opens, shorts, reversed pairs, crossed pairs, and split pairs.
- **Fusion splicer:** Fusion splicing is a way to join two fibers by using heat. Prepared fiber ends are placed in the splicer and automatically aligned and then fused together. Fusion splicing ensures greater reliability with less light being scattered or reflected back by the splice. If you follow the instructions for a fusion splicer, you should end up with an optical cable that is as strong as the original cable.
- **Spectrum analyzer:** A spectrum analyzer measures the magnitude of an input signal versus frequency within the full frequency range of the instrument. The primary use is to measure the power of the spectrum of known and unknown signals.
- **Snips/cutters:** As a network administrator, you often need to precisely cut or snip cables and cabling accessories. It is important that you have a pair of well-maintained snips or cutters in your supply bag at all times.
- **Cable stripper:** Cable strippers, which allow you to remove the plastic shielding from cables, are often built in to cable crimpers.
- **Fiber light meter:** A fiber light meter is a device used to measure the power in an optical signal. It is a device for testing average power in fiber-optic systems.

### Real-World Case Study

At Acme, Inc., the IT department has recently embarked on a comprehensive training program focused on mastering the most common cable, interface, and hardware issues that the company encounters. Recognizing that even small, seemingly insignificant problems can lead to significant downtime and disruption, the leadership team decided that it was essential to equip the IT staff with the skills to quickly diagnose and resolve these issues. The training covers a wide range of topics, from identifying faulty cables and connectors to troubleshooting interface problems that can occur between different types of hardware.

The program includes hands-on workshops where IT staff can practice identifying and resolving these issues in a controlled environment. For instance, technicians learn to differentiate between various types of cables, such as Ethernet and fiber optics, and understand how to spot signs of wear and tear that could lead to connectivity problems. Interface training covers the intricacies of network interface cards (NICs), USB ports, and other connection points, ensuring that IT personnel are adept at recognizing and resolving compatibility and performance issues.

Finally, the workshops facilitate training with the latest in network troubleshooting tools. IT staff members get to practice what they have learned with hands-on tool usage in simulated failure scenarios.

### Summary

Here are the main topics covered in this chapter:

- This chapter covered cabling considerations and common issues.
- This chapter examined potential issues you should be aware of when it comes to network device interfaces, and the network device hardware itself.
- Finally, this chapter also covered common tools used to support the network media.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 22-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22tab1) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 22-1** Key Topics for [Chapter 22](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| List | Common cable issues | 502 |
| List | Common interface issues | 505 |
| List | Common hardware issues | 507 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[administratively down](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_01)

[attenuation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_02)

[crosstalk](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_03)

[cyclic redundancy check (CRC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_04)

[drops](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_05)

[error disabled](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_06)

[giants](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_07)

[interference](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_08)

[multimode](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_09)

[Power over Ethernet (PoE)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_010)

[runts](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_011)

[shielded twisted pair (STP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_012)

[single mode](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_013)

[suspended](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_014)

[unshielded twisted pair (UTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#key_015)

### Additional Resources

**Network Cable Testers:** <https://www.flukenetworks.com/expertise/learn-about/cable-testing>

**How to Use a Multimeter:** <https://www.youtube.com/watch?v=ts0EVc9vXcs>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_1) What type of cable must be used for PoE with network devices?

1. Cat 5e or greater
2. Cat 3 or greater
3. Cat 5 or greater
4. Cat 4 or greater

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_2) Which of the following can be a major issue for fiber-optic media?

1. Incorrect pinouts
2. Dirty optical media
3. EMI
4. dB loss

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_3) What type of cable testing device permits a network device to communicate with itself in order to test its ability to send and receive traffic?

1. Cable tester
2. Loopback plug
3. Cable crimper
4. Fusion splicer
5. Tone generator

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_4) Which types of cables would you install to meet most building codes today and prevent fires and poisonous gases from spreading? (Choose two.)

1. UTP rated
2. Rollover rated
3. Plenum rated
4. Riser rated

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_5) Which of the following terms are directly related to the weakening or loss of a signal as it travels farther down the network media? (Choose two.)

1. Attenuation
2. Throughput
3. OTDR
4. Interference
5. Decibel (dB) loss

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_6) You have configured your switch with a Spanning Tree Protocol protection feature. There has been a violation of this feature due to a new switch that has been introduced to your topology. What is the most likely status of the switch port where the violation occurred?

1. Administratively down
2. Error disabled
3. Suspended
4. Normal

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_7) You have a link between two network interfaces (devices) that is operating inefficiently. What would most likely be the cause of this problem?

1. Incorrect pinout
2. Bad ports
3. Duplex mismatch
4. Failed NIC

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_8) Which statements are true regarding fiber-optic cabling? (Choose two.)

1. It is immune to EMI.
2. Troubleshooting equipment is less expensive than UTP.
3. Multimode fiber is used for longer distances.
4. It is more difficult to install than UTP.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_9) What occurs when a network interface discards incoming or outgoing packets due to congestion, buffer overflows, or other issues?

1. Giants
2. Runts
3. Drops
4. Improper termination

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz22_10) What occurs when a signal transmitted on one circuit or channel creates an undesired effect on another circuit or channel?

1. Attenuation
2. Crosstalk
3. dB loss
4. Suspended port