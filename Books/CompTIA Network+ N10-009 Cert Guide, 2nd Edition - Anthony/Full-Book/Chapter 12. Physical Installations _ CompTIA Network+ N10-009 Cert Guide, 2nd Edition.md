## Chapter 12

## Physical Installations

This chapter covers the following topics related to Objective 2.4 (Explain important factors of physical installations) of the CompTIA Network+ N10-009 certification exam:

- [Important installation implications](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12lev1sec2)

  - [Locations](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12lev2sec1)

    - Intermediate distribution frame (IDF)
    - Main distribution frame (MDF)
  - Rack size
  - Port-side exhaust/intake
  - Cabling

    - Patch panel
    - Fiber distribution panel
  - Lockable
- [Power](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12lev1sec3)

  - Uninterruptible power supply (UPS)
  - Power distribution unit (PDU)
  - Power load
  - Voltage
- [Environmental factors](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12lev1sec4)

  - Humidity
  - Fire suppression
  - Temperature

As networking engineers, we need to give some attention to the physical characteristics of where we are locating our network equipment. In this chapter, we will take a fairly deep dive into things like the locations and cable management facilities of our networking equipment. We will also discuss the important aspects of power and environmental factors that we should consider when designing or outfitting our physical networking locations. These environmental factors include humidity, fire suppression, and temperature concerns.

### Foundation Topics

### Important Installation Implications

There are many physical installation aspects that you need to be concerned with. For example, you not only should carefully select the correct network media for your networking infrastructure, but also install that media as part of an organized cable distribution system. Typically, cable distribution systems are hierarchical in nature.

Consider the example profiled in [Figure 12-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12fig01). In this example, cable from end-user offices runs back to common locations within the building. These locations are sometimes referred to as *wiring closets*. Cables in these locations might terminate in a [***patch panel***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_480), or *patch bay*. The patch panel might consist of some sort of cross-connect block wired into a series of ports (for example, RJ45 ports), which can be used to quickly interconnect cables coming from end-user offices with a network device, such as an Ethernet switch. A common term for cross-connect blocks is *punchdown blocks*. This term indicates how you physically connect the media—“punching” the media into the appropriate slot.

![](../images/key_topic_icon_158.jpg)

![](../images/12fig01.jpg)


**Figure 12-1** Example: Cable Distribution System

#### Locations

The fiber connections into a wiring closet can terminate into a [***fiber distribution panel***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_266), also known as a *fiber-optic patch panel*. This cable management component is mainly used for accommodating fiber cable terminations, connections, and patching. The two major categories of fiber distribution panels are wall-mount and rack-mount types.

A building might have multiple patch panels (for example, on different floors of the building). Common locations where cables from nearby offices terminate are often called [***intermediate distribution frames (IDFs)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_328).

The two most popular types of cross-connect blocks found in an IDF are detailed here:

- **66 block:** 66 blocks were traditionally used in corporate environments for cross-connecting phone system cabling. As 10Mbps LANs grew in popularity, in the late 1980s and early 1990s, these termination blocks were used to cross-connect Cat 3 UTP cabling. The electrical characteristics (specifically, crosstalk) of a 66 block, however, do not support higher-speed LAN technologies, such as 100Mbps or greater Ethernet networks. [Figure 12-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12fig02) illustrates a 66 block.

![](../images/12fig02.jpg)


**Figure 12-2** 66 Block

- **110 block:** Because 66 blocks are subject to a lot of crosstalk (that is, interference between different pairs of wires) for higher-speed LAN connections, 110 blocks are often used to terminate cable (for example, a Cat 5e cable) used for higher-speed LANs. [Figure 12-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12fig03) illustrates a 110 block.

![](../images/12fig03.jpg)


**Figure 12-3** 110 Block

There are two other cross-connect blocks you should be familiar with:

- **Krone (or Krone LSA-PLUS):** Krone, a proprietary European alternative to 110 block, is used not only in data environments but also in television broadcasting.
- **BIX (or Building Industry Cross-connect):** A BIX terminates 25 pairs (that is, 50 wires). The 25 pairs may be punched down to one side of a “wafer” that is then inserted into a metal frame with the punched-down side against the wall, so you only see the unused side.

The centralized distribution frame, which connects out to multiple IDFs, is called the [***main distribution frame (MDF)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_398).

While cable management and distribution is certainly a major concern for your physical installations, another important aspect of installation is acquiring the correct equipment racks for mounting the various physical appliances that you require in your physical spaces. While it might not seem so at first glance, there are many options, with some important considerations as detailed here:

![](../images/key_topic_icon_158.jpg)

- [***Rack size***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_538): Rack sizes use a standard measure called a unit. One unit is 1.75 inches. Standard rack sizes are typically 19 inches wide and range from 42U (units) to 48U. These standard racks are designed to house your various network devices like servers, routers, switches, and patch panels. If you find yourself short on space, you might opt for a half-height-style rack. These tend to be from 18U to 22U. You might even opt for a wall-mount rack. These are even more compact and tend to be about 12U.
- [***Port-side exhausts***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_510) **and** [***intakes***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_324): Another important criterion with your equipment racks is how cooling is accommodated. Your rack design might feature a front-to-back airflow design. This is often found with your standard racks. Here, cool air is drawn in from the front and hot air is expelled from the back. Other racks might feature a side-to-side airflow. These racks accommodate devices that intake and exhaust air from the sides, requiring proper clearance and airflow management on the sides. Yet another option is a front-to-top airflow design. These more specialized racks facilitate airflow from the front intake to a top exhaust, useful in configurations where back exhausts are restricted.
- [***Lockable***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_386): To help with physical security, your network equipment racks might be lockable. Some might come with lockable front and rear doors, providing physical security to prevent unauthorized access to critical network equipment. Advanced options include electronic locks with keycard access or biometric systems, adding an extra layer of security. Some lockable racks use secure fasteners that require specific tools to open, adding another security measure for internal components.

### Power

Another important physical installation factor that you should consider is power. You need to make sure you have enough of it, and you need to implement mechanisms to ensure proper power distribution and proper power redundancy.

When it comes to the distribution of power, [***power distribution units (PDUs)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_513) are devices that distribute electrical power to networking equipment within a rack or a network room. PDUs come in various configurations, including basic, metered, and intelligent PDUs, each providing different levels of power monitoring and management:

- **Basic PDUs:** Simply distribute power without any additional functionality.
- **Metered PDUs:** Allow for monitoring of power usage at the outlet level, providing insights into power consumption and enabling efficient power management.
- **Intelligent PDUs:** Go a step further by offering remote monitoring and control, allowing network administrators to manage power distribution and consumption from a central console.

Proper selection and placement of PDUs are critical for ensuring balanced power distribution and avoiding overload conditions that could lead to equipment failure.

Note

Redundancy is often critical in networking, and it certainly is in the area of power. Therefore, redundant power sources and redundant PDUs often are used in key locations of the physical infrastructure.

When working with power in your physical installations, you will often be conscious of the [***power load***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_514), which refers to the total electrical power consumed by networking equipment in a physical installation. Understanding and managing power load is essential for ensuring that the electrical infrastructure can support the demands of the equipment without overloading circuits or causing power failures. Fortunately, there are many tools available online to assist you with determining the total power load for your networking devices.

It is important to calculate the power requirements of all devices to be installed in the network rack and ensure that the power supplies and PDUs are capable of handling the aggregate load. Overloading can lead to overheating, reduced efficiency, and increased risk of hardware failure. You should also consider future expansion and ensure that the power infrastructure has sufficient capacity to accommodate additional equipment without compromising reliability.

[***Voltage***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_754) is another critical consideration in the physical installation of networking equipment, as it affects the performance and longevity of the devices. Networking equipment typically requires a stable voltage supply to operate correctly and to avoid damage from voltage fluctuations. Most equipment operates on standard voltages, such as 120V or 240V, depending on the region and the specific requirements of the devices. It is essential to ensure that the power supply provides the correct voltage to match the equipment’s specifications.

Additionally, for Power over Ethernet (PoE) systems, specific voltage levels are required to power devices such as IP cameras and wireless access points through Ethernet cables. Consistent and proper voltage delivery ensures that networking equipment operates efficiently and reduces the risk of power-related issues.

Note

We covered Power over Ethernet (PoE) initially in [Chapter 10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10), “[Ethernet Switching Technologies](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10).” You will also encounter PoE again in [Chapter 22](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22), “[Troubleshoot Common Cabling Problems](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22).”

When it comes to redundancy in your power designs, the [***uninterruptable power supply (UPS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_729) is still king. Uninterruptible power supplies are crucial for maintaining network reliability and continuity in the event of power disruptions. UPS systems provide backup power to critical networking equipment, such as servers, switches, and routers, allowing them to continue functioning during power outages. This ensures that data transmission and network services remain uninterrupted, preventing data loss and downtime. There are different types of UPS systems, including offline, line-interactive, and online double-conversion UPS, each offering varying levels of protection and power conditioning. The choice of UPS depends on the specific requirements of the network environment, including load capacity and the criticality of the equipment being protected.

### Environmental Factors

When it comes to your physical computer networking facilities, it is also crucial to account for various environmental factors to ensure the reliability, efficiency, and longevity of the equipment. [***Temperature***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_686) control is a primary concern, as excessive heat can significantly impact the performance and lifespan of networking devices such as servers, switches, and routers. Ideal temperature ranges for data centers typically fall between 18°C and 27°C (64°F to 80°F).

Effective cooling systems, including air conditioning and ventilation, must be in place to maintain these temperatures and prevent overheating, which can lead to system failures and downtime. Additionally, the layout of the equipment should support proper airflow, minimizing the potential for hot spots that could overheat specific components.

[***Humidity***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_303) levels are equally important in networking facilities. Too much humidity can lead to condensation, which can cause short circuits and corrosion of electronic components. Conversely, too little humidity can result in static electricity, which poses a significant risk to sensitive equipment.

The recommended relative humidity range for data centers is typically between 40% and 60%. Monitoring and controlling humidity levels can be achieved through the use of humidifiers and dehumidifiers, ensuring that the environment remains stable and safe for the equipment.

Note

Specific network appliances and equipment you might need to install in your physical locations will have the recommended temperatures and humidity levels specified in the literature and/or documentation that accompany the devices. Be sure to check this documentation to ensure the health and longevity of your devices. Also, to keep up with environmental standards, you can consult websites such as the American Society of Heating, Refrigerating and Air-Conditioning Engineers (ASHRAE) at [https://www.ashrae.org](https://www.ashrae.org/) and Occupational Safety and Health Administration (OSHA) at [https://www.osha.gov](https://www.osha.gov/).

[***Fire suppression***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_270) is another critical aspect of environmental control in networking facilities. The presence of a significant amount of electrical equipment increases the risk of fire, making it essential to have an effective fire suppression system. Traditional water-based fire sprinklers are not ideal for such environments, as water can cause extensive damage to electronic components. Instead, gas-based fire suppression systems, such as those using clean agents like FM-200 or inert gases like nitrogen and argon, are preferred. These systems are designed to suppress fires without harming the equipment or leaving residue, allowing for minimal disruption and damage in the event of a fire.

Additionally, physical security measures should be considered to protect networking facilities from environmental hazards and unauthorized access. This includes securing entry points, implementing access control systems, and monitoring for potential threats. [Chapter 18](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#ch18), “[Network Security Concepts](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#ch18),” will have more to say about physical security in your physical installations.

### Real-World Case Study

Acme, Inc. is in the process of designing a new, state-of-the-art physical installation for its networking equipment. The company’s engineering team has undertaken a comprehensive project to design this new installation with a focus on optimal performance, reliability, and scalability.

Category 6a is the cabling media for the main Ethernet network. Cat6a cables provide superior performance with data transfer rates of up to 10Gbps and are ideal for high-bandwidth applications, ensuring that the network can handle the increasing data demands. The cabling infrastructure is being designed with a structured cabling approach, with cables neatly organized into horizontal and vertical pathways using cable trays and ladder racks. This not only facilitates easier maintenance, but also minimizes interference and signal loss. The decision to invest in high-quality, shielded cables will help to reduce electromagnetic interference (EMI), critical for maintaining network integrity in a busy data center environment.

When it comes to server racks, Acme is opting for modular, scalable racks that can accommodate various server types and network equipment. These racks are equipped with adjustable mounting rails and cable management features, allowing for flexible configurations and efficient use of space. The engineering team is choosing racks with high airflow designs to support effective cooling and prevent overheating of the equipment. Each rack is also fitted with power distribution units (PDUs) capable of monitoring power usage in real time, providing the IT team with the necessary data to manage and optimize energy consumption. This approach not only maximizes the physical space but also enhances the manageability and scalability of the data center.

Power considerations have been crucial in Acme’s planning. The company is installing an uninterruptible power supply (UPS) system to ensure that the network equipment can continue operating smoothly during power outages or fluctuations. The UPS system is complemented by a backup generator to provide additional redundancy. To further safeguard the network, Acme is implementing a dual power feed system for critical equipment, ensuring that each device has two independent power sources. This redundancy will minimize the risk of downtime and ensure continuous operation, a critical factor for maintaining the reliability and availability of Acme’s services.

Acme is also paying close attention to environmental factors. To maintain optimal temperatures, the data center is to be equipped with a precision cooling system capable of maintaining temperatures between 18°C and 24°C (64°F and 75°F). This system includes hot and cold aisle containment to prevent hot air from mixing with cold air, thereby improving cooling efficiency. Humidity levels are to be controlled using advanced humidifiers and dehumidifiers to maintain a relative humidity of 45% to 55%, preventing both condensation and static electricity. For fire suppression, Acme is installing a gas-based system using FM-200, which can quickly extinguish fires without damaging electronic equipment. This comprehensive approach to environmental management will help to ensure that the data center can operate reliably and efficiently while protecting valuable equipment from environmental hazards.

### Summary

Here are the main topics covered in this chapter:

- This chapter began with a look at important installation implications when it comes to physical installations of networking equipment. This included such topics as locations, equipment rack sizes, ventilation, and cabling infrastructure.
- This chapter also covered important topics regarding power implications for the physical installation. This included a discussion of uninterruptible power supplies (UPSs), power distribution units (PDUs), power load, and voltage.
- Finally, this chapter examined some of the most important environmental factors for physical installations. This included a discussion of humidity, temperature, and fire suppression techniques.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 12-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12tab01) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 12-1** Key Topics for [Chapter 12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| [Figure 12-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#ch12fig01) | Example: Cable Distribution System | 312 |
| List | Equipment rack considerations | 314 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[fiber distribution panel](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_01)

[fire suppression](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_02)

[humidity](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_03)

[intake](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_04)

[intermediate distribution frame (IDF)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_05)

[lockable](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_06)

[main distribution frame (MDF)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_07)

[patch panel](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_08)

[port-side exhaust](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_09)

[power distribution unit (PDU)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_010)

[power load](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_011)

[rack size](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_012)

[temperature](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_013)

[uninterruptible power supply (UPS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_014)

[voltage](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#key_015)

### Additional Resources

**Real-World Network Cable Management:** <https://www.youtube.com/watch?v=CV3-is8Yd8U>

**Network Rack Installation – Start to Finish:** <https://www.youtube.com/watch?v=QQmoZ1GrgA0>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz12_1) What is a common method of terminating cable runs in a wiring closet of an organization?

1. Server racks
2. UPS
3. PDU
4. Patch panel

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz12_2) Networking equipment racks typically use a standard measurement to help indicate the size of the rack. What is this measurement called?

1. Load
2. Unit
3. Area
4. Block

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz12_3) What is often used to disperse power to the various devices in a network equipment rack?

1. Punchdown block
2. Patch panel
3. PDU
4. UPS

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz12_4) What measurement is typically used to present the total electrical power consumed by the networking equipment in a physical installation?

1. Power load
2. Voltage
3. PDU
4. UPS

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz12_5) What networking physical installation component focuses on the redundancy of electric power?

1. Power load
2. Voltage
3. PDU
4. UPS

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz12_6) Which of the following is the primary wiring closet for a network that typically holds the majority of the network gear, including routers, switches, wiring, servers, and more?

1. IDF
2. MDF
3. PoE
4. FM-200