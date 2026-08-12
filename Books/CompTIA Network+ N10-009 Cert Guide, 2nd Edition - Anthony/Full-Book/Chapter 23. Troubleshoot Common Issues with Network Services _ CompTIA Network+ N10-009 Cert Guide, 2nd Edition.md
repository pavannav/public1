## Chapter 23

## Troubleshoot Common Issues with Network Services

This chapter covers the following topics related to Objective 5.3 (Given a scenario, troubleshoot common issues with network services) of the CompTIA Network+ N10-009 certification exam:

- Switching issues

  - STP

    - Network loops
    - Root bridge selection
    - Port roles
    - Port states
  - Incorrect VLAN assignment
  - ACLs
- Route selection

  - Routing tables
  - Default routes
- Address pool exhaustion
- Incorrect default gateway
- Incorrect IP address

  - Duplicate IP address
- Incorrect subnet mask

In the previous chapter, our troubleshooting focus was entrenched in the physical layer. We examined just some of the many things that can go wrong with things like cables, interfaces, and even the wireless radio frequency signals traveling through the air.

This chapter details many of the network service issues you might encounter today, why they occur, and what you can often do about them. It is worth noting that sometimes you need to troubleshoot and verify that things are working properly at the lower layers (like the physical layer) before you begin looking at the potential for network service problems.

### Foundation Topics

### Considerations for General Network Troubleshooting

How much can go wrong in a network today? *A lot!* In fact, the list of potential issues grows all the time as new services and data types are provided by networks. Fortunately, there are some common considerations that can help you greatly as you approach this vast and challenging topic. Here are some common considerations and best practices that you should keep in mind:

- **Device configuration:** You should consistently review the configurations of network devices to ensure that your network is not suffering from *configuration drift* (that is, configurations gradually changing from their original documented defaults for a network). Many software packages and tools, such as Ansible, can assist you in making sure all your network devices remain in a constant, stable, and known configuration state.

![](../images/key_topic_icon_158.jpg)
- [***Routing tables***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_583)**:** It is important to carefully monitor and analyze the routing tables of Layer 3 devices. Forwarding decisions (*route selection*) are critical to the operation of a network, and you want to ensure that packets are flowing exactly as you want and expect them to. Remember, these routing tables will also typically include [***default routes***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_194) that are of critical importance. The default route is used when no specific route exists for a network destination. Always remember to check routing tables to make certain that the routes within are the most cost effective in terms of hops and routes taken.
- **Interface status:** One embarrassing network issue that you do not want to experience is the administratively down interface scenario. In this scenario, you try desperately to reach a key network device, only to discover that you failed to enable the interface that you are trying to contact. Remember that there are simple commands you can use, and even GUI-based web pages that can give you status information on your critical network interfaces. Knowing which interfaces are healthy and which are not can be critical in network troubleshooting.
- **Incorrect network layer settings:** Often the status of an interface in a network is contingent on the network layer settings. The physical and data link layer settings might be fine (for example, a Cisco device displays the status as UP/UP), but if the IP settings are incorrect, the physical and data link layer health of the interface is not of great benefit to you. The following settings should be perfect: default gateway IP address, subnet mask, IP address, and DNS address or addresses. Think about the symptoms you might see for each of these potential misconfigurations. For example, if you have an *incorrect default gateway IP address*, you might be able to communicate with your local subnet peers just fine, but you will not be able to successfully reach any remote destinations—which would not be good! What if you have an *incorrect subnet mask* assignment? Now the system will have issues communicating with its local subnet peers, and possibly the remote systems as well. Notice this is basically the same scenario if your IP address assignment is incorrect. If the address is far off from what it should be, you will not be able to communicate with local or remote hosts. You must ensure proper IP addresses, subnet masks, default gateways, and DNS assignments. There is simply no question about this.
- **VLAN assignment:** Remember that a virtual local area network (VLAN) allows you to create groups of users and systems and segment them on the network. This segmentation lets you hide segments of the network from other segments and thereby control access. As a result, *incorrect VLAN assignments* can cause communication issues within the network. In fact, these types of misconfigurations can be more difficult to pinpoint because the VLAN assignment is “behind the scenes” in the network. These issues also present no obvious signs of trouble outside of communication difficulties.
- **Network performance baselines:** As you have probably noticed throughout this book, it is critical that you know the details about how your network performs under “normal” conditions and what its speeds and throughput really are. (How can you know that you are having a problem if you do not even know what your network should be performing like when there are no problems?) Fortunately, as this book has discussed, there are many tools and techniques for capturing accurate and detailed network performance baselines and using the data you collect to keep tabs on the network. Remember that creating baselines is only a part of the equation; you also have to analyze them. Unfortunately, too many network administrators collect information that they never do anything with. Be sure to examine the baseline data on a regular basis and track current conditions to see what needs to be improved upon.

### Common Network Service Issues

The following list of common general network issues may be a bit intimidating, and it is not even an exhaustive list. As a network administrator and as a candidate for the CompTIA Network+ certification, you need to understand the following common issues:

- **Duplicate IP address:** Hosts on a subnet should have unique IP addresses. If two hosts are configured with the same IP address, unpredictable traffic patterns can occur for those hosts. One reason (of many) this might happen is because a DHCP server is inadvertently leasing out an address that has been statically assigned on the network. These statically assigned addresses should be excluded from the DHCP scope.

![](../images/key_topic_icon_158.jpg)
- **Duplicate MAC address:** Although it’s rarer than a duplicate IP address on a network, a MAC address could be duplicated. A MAC address on a network is typically taken from the address that is “burned in” to the hardware by the device vendor. To ensure uniqueness between vendors, each network device vendor is assigned a MAC prefix, and the vendor can control the remaining bits. Therefore, when a MAC address is duplicated on a network, it is most often a human error that occurs when MAC addresses are software defined to override the hardware addresses that are burned in.
- **Expired IP address:** Perhaps a leased DHCP address has expired for a workstation. This might be the case, for example, if the lease duration has been set to a small value, perhaps because of an IP address shortage in a particular area of the network.
- **DHCP scope exhaustion:** If your end-user network device population has grown, you might have issues with *address pool exhaustion* that are innocent in nature. DHCP scope exhaustion refers to the scope being completely out of IP addresses that it can lease to clients. If your population is outgrowing your design, a redesign is expected, and you should not be surprised by this. Sadly, issues are not always innocent in nature. Cybercriminals can launch attacks that intentionally exhaust the address space in the DHCP pool. DHCP scope exhaustion attacks can be very disruptive because you will not know it is coming. Suddenly, clients in your network cannot communicate properly because they have lost their IP address configuration.
- **Rogue DHCP server:** This security concern could certainly cause troubleshooting headaches on a network due to the incorrect IP configurations that could result. When rogue DHCP servers appear on a network, it is often because users have brought in their own devices, either maliciously or accidentally. Fortunately, as you learned in our chapters regarding network security, there are many features to help guard against this problem, including DHCP snooping, port security, and even rogue AP detection mechanisms in the latest wireless LAN technologies.
- **Untrusted SSL certificate:** If you are using certificates for authentication, you might have an issue with an SSL certificate preventing such authentication. Perhaps a certificate is invalid due to time, or perhaps it has been manually revoked for some reason.
- **Incorrect time:** Because many network configurations rely on the correct time, you might have problems in a network due to a workstation, server, or network appliance having the wrong time set. Remember that you should strongly consider using Network Time Protocol (NTP) or a competing technology to help ensure that your network devices are all set to the correct time.
- **Blocked TCP/UDP ports, services, or addresses:** A trouble ticket may be about blocked TCP or UDP ports. This type of blockage is often the result of misconfigured security devices in the network path. There might be other security mechanisms that are blocking specific IP addresses or services. These are all worthy of inspection when you are experiencing unexpected connectivity issues in a network.
- **Incorrect firewall settings:** Host-based firewall settings and network-based firewall settings may cause problems. Firewalls are great, but you need to make sure they are not blocking traffic that you need to pass through the network.
- **Incorrect access control list (ACL) settings:** ACLs can have effects on network traffic, and if their settings are incorrect, you could end up with trouble tickets. Imagine an ACL setting that accidentally blocks TCP port 443. This would end up stopping almost all Internet traffic as a result of the HTTPS protocol being blocked.
- **Unresponsive service:** Services that have failed in a network are common sources of problems.
- **Collisions:** You should not see any collisions taking place if you have built a network using modern techniques and standards. Remember that microsegmentation of a network means keeping single devices in collision domains so that you do not experience collisions on the network. Often, if you are seeing collisions on a network, it is an indicator that you have a misconfiguration or a hardware device that is malfunctioning.
- **Broadcast storms:** It might sound crazy, but it is possible to go to a Layer 2 switch and turn off [***Spanning Tree Protocol (STP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_644). This is *never* recommended. Even in cases where you don’t need STP because you have used technologies like port channels, you need to make sure STP is still enabled and running in the background. If STP isn’t running, a broadcast storm may occur as a result of a Layer 2 loop (often just termed [***network loops***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_446)). You might experience broadcast storms for other reasons as well, such as a NIC malfunctioning and flooding the network with erroneous broadcast frames.
- **STP misconfigurations:** While there are many potential Spanning Tree Protocol tuning configurations you can make, one of the most critical configurations is the [***root bridge***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_570) selection. This selection influences all of the *port roles* and *port states* of the spanning tree topology. If this root bridge is incorrect or suboptimal, it can have devastating effects on the network. Imagine how slow a network might perform if the root bridge ends up being a very underpowered, access layer, basic Layer 2 switch. Most administrators will be sure to configure the best possible root bridge and then place STP enhancements like Root Guard and BPDU Guard to ensure this device remains the root bridge.
- **Multicast flooding:** You need to be concerned about broadcast, unknown unicast, and multicast (BUM) traffic in your network. This is the traffic that Layer 2 switches must flood. You want to minimize the amount of traffic flooding your network must perform, and you therefore often need to closely analyze the amount of BUM traffic flooding. In addition, you can use protection mechanisms such as network storm control to guard against excessive amounts of BUM traffic hampering network operations.
- **Asymmetrical routing:** Sometimes packets take very different paths back to you than they took toward the destination. This situation, called asymmetrical routing, is not always a bad thing, and sometimes you even engineer it to happen for some specific reason. Often, however, asymmetrical routing is not wanted and can cause issues.
- **Switching loops:** If STP is not running correctly—or not running at all—it will not be long before you have broadcast storms and switching loops. These are the enemies that STP is engineered to protect you from.
- **Routing loops:** The dynamic routing protocols in use today do an excellent job of protecting themselves against loops. In fact, a loop could never get terribly bad because of the Time-to-Live (TTL) mechanism at Layer 3, which prevents a packet from circulating on the network endlessly in a loop. Layer 3 routing loops can still happen, though, especially when redistribution between routing protocols is configured incorrectly, and they are still awful. Be very careful when performing redistribution.
- **Missing routes:** When a user indicates that a remote destination must be down, be sure to run through your methodical troubleshooting steps; in many cases you may discover that the issue is simply a missing route in the local routing table. Remember that networks change, and you need to ensure that your dynamic routing protocols (or even static routes) are being updated properly. When you are troubleshooting, don’t forget the excellent tools at your disposal, such as **ping**, **tracert**, and the other useful utilities that are covered in [Chapter 25](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#ch25), “[Network Troubleshooting Tools](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#ch25).”
- **Hardware failure:** Network devices or parts sometimes fail, and components can burn out. Such failures are rare, but you need to consider them in your troubleshooting flow.
- **Low optical link budget:** A fiber-optic link budget, also known as a *loss budget*, indicates the total acceptable amount of optical power loss (expressed in decibels) that a fiber-optic link can withstand. Such power loss results from cables, connectors, splices, and couplers in the installed system.
- **BYOD challenges:** Perhaps the investigation of a trouble ticket reveals that an end user is trying to interact with your network by using a tablet the user brought in from home. Whether or not your organization’s bring your own device (BYOD) policy allows this type of use and how you control this potential nightmare—such as through a mobile device management (MDM) policy—is an area of networking that deserves your attention.
- **Licensed feature issues:** Sometimes a network does not function properly because the organization lacks the appropriate licensing. Licensing of network devices can get quite complicated. You might need a license for a network device itself, and then you might also need additional licenses for certain features or levels of scalability.
- **Network performance issues:** Sometimes you know exactly why a network is not performing well. For example, you might have to fail over to another service provider and a very slow backup WAN link when the main service provider is down for maintenance. It is always an excellent idea to inform end users about these kinds of issues up front to prevent the disruption that would be caused by a flood of trouble tickets.

### Real-World Case Study

To be better prepared for network issues, Acme, Inc. has introduced a training program for its support team that focuses on common issues that have been occurring in the network. This training focuses on the following areas:

- Spanning Tree Protocol (STP) issues
- Layer 2 configurations such as VLAN assignments
- Route selection issues
- IP addressing issues

IT personnel are receiving training on the most common symptoms and causes for each of these areas. The team is also receiving training on the most effective tools and techniques that can be used for each area.

The IT team is also receiving recurring training on the overall troubleshooting methodology, with a focus on documentation maintenance and improvements. Since initiating this training program, Acme, Inc. has reported far fewer hours committed to troubleshooting, and much more up-to-date and useful documentation.

### Summary

Here are the main topics covered in this chapter:

- This chapter focused on the considerations you frequently need to make while engaged in general network troubleshooting.
- This chapter examined many common problematic issues in networks today.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 23-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#ch23tab01) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 23-1** Key Topics for [Chapter 23](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#ch23)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| List | Common considerations for general network troubleshooting | 518 |
| List | Common network service issues | 519 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[default route](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#key_01)

[network loops](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#key_02)

[root bridge](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#key_03)

[routing table](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#key_04)

[Spanning Tree Protocol (STP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#key_05)

### Additional Resources

**How to Troubleshoot Issues in Computer Networks:** <https://www.youtube.com/watch?v=kthHizueMiY>

**What Is STP (Spanning Tree Protocol)?:** <https://www.youtube.com/watch?v=i_q-kIgz9Wk>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_1) What might you want to investigate if you can reach a web server by using its IP address but not its name?

1. NTP
2. DHCP
3. DNS
4. ARP

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_2) What device would most likely be unreachable if your default gateway IP address is misconfigured on the client?

1. A remote web server
2. A local printer
3. Your neighbor’s laptop
4. Your loopback

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_3) In the absence of STP, what issues might result from a Layer 2 loop in a network? (Choose two.)

1. A router interface’s MTU decrementing
2. MAC address table corruption
3. Broadcast storms
4. Packet fragmentation

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_4) If you successfully ping from host A to host B, what can you conclude about host A?

1. OSI Layers 1–4 are functional.
2. OSI Layers 1–3 are functional.
3. OSI Layers 1–7 are functional.
4. You must have a fully functional default gateway.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_5) What configuration on a Layer 2 switch is used to define broadcast domains where they would not exist naturally on their own?

1. ARP
2. STP
3. VTP
4. VLAN

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_6) To what subnet does a host with the IP address 172.16.155.10/18 belong?

1. 172.16.0.0 /18
2. 172.16.96.0 /18
3. 172.16.128.0 /18
4. 172.16.154.0 /18

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_7) What will likely occur if STP is not running correctly—or not running at all? (Choose two.)

1. Broadcast storms
2. Microsegmentation
3. Low optical link budget
4. Switching loops

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_8) Which of the following refers to a lack of IP addresses that can be leased to clients?

1. Incorrect time
2. Address pool exhaustion
3. Untrusted SSL certificates
4. Incorrect ACL settings

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_9) An administrator excludes statically assigned addresses from a DHCP scope. What is the administrator trying to avoid?

1. Duplicate IP addresses
2. Duplicate MAC addresses
3. Expired IP address
4. Rogue DHCP server

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz23_10) In STP, what is the central reference point of the network topology, selected based on the lowest bridge ID, to which all other network switches determine their best path to ensure a loop-free network?

1. Core switch
2. Root port
3. Root bridge
4. Designated port