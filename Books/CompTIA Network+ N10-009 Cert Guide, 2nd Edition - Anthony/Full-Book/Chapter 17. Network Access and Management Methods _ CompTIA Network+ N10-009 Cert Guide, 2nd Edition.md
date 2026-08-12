## Chapter 17

## Network Access and Management Methods

This chapter covers the following topics related to Objective 3.5 (Compare and contrast network access and management methods) of the CompTIA Network+ N10-009 certification exam:

- Site-to-site VPN
- Client-to-site VPN

  - Clientless VPN
  - Split tunnel vs. full tunnel
- Connection methods

  - SSH
  - Graphical user interface (GUI)
  - API
  - Console
- Jump box/host
- In-band vs. out-of-band management

In this chapter, we examine how many different methods there are today to access your network or networks, and also the popular methods of device management. Sure enough, you will notice that many of the methods and technologies discussed in this chapter emphasize remote access. More than ever, we want to be able to access and securely manage our networks from anywhere in the world.

This is particularly true in the case of cloud technologies. After all, one of the defining characteristics of cloud (according to the NIST) is broad network access. Fortunately, there are more options than ever before in this regard. Advancements in WAN technologies (such as SD-WAN) are making it easier than ever before to create and manage network access connections for a wide variety of purposes.

### Foundation Topics

### Virtual Private Networks (VPNs)

Thanks in good part to the COVID-19 virus, much of today’s workforce is located outside a corporate headquarters location. But even before the pandemic, some employees worked in remote offices, and others telecommuted. Remote employees can connect to their main corporate network by using a variety of WAN technologies, such as leased lines or high-speed fiber connections. However, these WAN technologies typically cost more than widely available broadband technologies, such as cable, which might also offer faster speeds, or at least comparable speeds.

Virtual private networks (VPNs) support secure communication between sites over an untrusted network (for example, the Internet). The two primary categories of VPNs are site-to-site and client-to-site VPNs:

![](../images/key_topic_icon_158.jpg)

- [***Site-to-site VPN***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_629): A site-to-site VPN interconnects two sites, as an alternative to a leased line, at a reduced cost. [Figure 17-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17fig01) shows an example of a site-to-site VPN.

![](../images/17fig01.jpg)


  **Figure 17-1** Site-to-Site VPN
- [***Client-to-site VPN***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_147): A client-to-site VPN (also known as a *remote access VPN*) interconnects a remote user with a site, as an alternative to dial-up or ISDN connectivity, at a reduced cost. [Figure 17-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17fig02) shows an example of a client-to-site VPN.

![](../images/17fig02.jpg)


**Figure 17-2** Client-to-Site VPN

Although a VPN tunnel might physically pass through multiple service provider routers, the tunnel appears to be a single router hop from the perspective of the routers at each end of the tunnel.

A client-to-site VPN allows a user with software on a client computer to connect to a centralized VPN termination device, and a site-to-site VPN interconnects two sites without requiring the computers at those sites to have any specialized VPN software installed. Client-to-site VPNs could be implemented using a VPN-compatible device, such as a router, a firewall, or a special-purpose device called a *VPN concentrator* that is custom-built for handling remote access client-to-site VPN connections. It is also possible, with the correct software, for two computers to connect to each other directly using a host-to-host IPsec VPN connection.

One very popular option in client-to-site VPNs is a [***clientless VPN***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_148) (although this is a bit of a misnomer). With a clientless VPN, there is a client software piece, but it is not a separate piece of software; rather, the client’s web browser acts as the VPN client software. This type of VPN connection leverages the SSL/TLS capabilities of the modern Internet and web browsers to provide a secured connection.

Another important consideration when it comes to VPN configuration is whether you will be using a split tunnel or full tunnel configuration:

- With a [***full tunnel***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_280) configuration, you have all the end-user traffic go through the VPN tunnel.
- With a [***split tunnel***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_650) configuration, you don’t have all the end-user traffic go through the VPN tunnel. For example, you might choose to have just the traffic that needs to access the corporate network sent through the VPN tunnel, while allowing traffic destined for the Internet (perhaps Office 365 traffic) to bypass the tunnel. Split tunneling is often an advantageous configuration because the bandwidth required by the VPN connection (and the overhead associated with it) can be minimized.

#### IPsec

Broadband technologies, such as cable, in addition to other VPN transport mechanisms, often traverse an untrusted network, such as the Internet. Therefore, a primary concern with using a broadband technology as a VPN transport is security.

VPN technologies such as IP Security (IPsec), Generic Routing Encapsulation (GRE), Layer 2 Tunneling Protocol (L2TP), and Layer 2 Forwarding (L2F) offer a variety of features, but IPsec VPNs offer strong security features. Specifically, IPsec offers CIA protection for traffic. CIA is considered the foundation for a secure network and consists of the following:

- **Confidentiality:** Data confidentiality is provided by encrypting data. A third party who intercepts the encrypted data will not be able to interpret it.
- **Integrity:** Data integrity ensures that data is not modified in transit. For example, routers at each end of a tunnel can calculate a checksum value or a hash value for the data, and if both routers calculate the same value, the data has most likely not been modified in transit.
- **Authentication:** Data authentication allows parties involved in a conversation to verify that the other party is the party they claim to be.

IPsec also scales to a wide range of networks. IPsec operates at Layer 3 of the OSI model (the network layer). As a result, IPsec is transparent to applications, which means that applications do not require any sort of integrated IPsec support.

#### IKE

IPsec uses a collection of protocols to provide its features. One of the primary protocols that IPsec uses is Internet Key Exchange (IKE). Specifically, IPsec can provide encryption between authenticated peers using encryption keys that are periodically changed. IKE, however, allows an administrator to manually configure keys.

As outlined in [Table 17-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17tab01), IKE can use three modes of operation to set up a secure communication path between IPsec peers.


**Table 17-1** IKE Modes

| Mode | Description |
| --- | --- |
| Main mode | Main mode involves three exchanges of information between the IPsec peers:  **Exchange 1:** The responder selects a proposal it received from the initiator.  **Exchange 2:** Diffie-Hellman (DH) is used to securely establish a shared secret key over the unsecured medium.  **Exchange 3:** An Internet Security Association and Key Management Protocol (ISAKMP) session is established. This secure session is then used to negotiate an IPsec session.  One peer, called the *initiator*, sends one or more proposals to the other peer, called the *responder*. The proposals include supported encryption and authentication protocols and key lifetimes. In addition, the proposals indicate whether perfect forward secrecy (PFS) should be used. PFS ensures that a session key remains secure, even if one of the private keys used to derive the session key becomes compromised. |
| Aggressive mode | Aggressive mode more quickly achieves the same results as main mode, using only three packets. The initiator sends the first packet, which contains all the information necessary to establish a security association (SA)—that is, an agreement between the two IPsec peers about the cryptographic parameters to be used in the ISAKMP session. The responder sends the second packet, which contains the security parameters selected by the responder (the proposal, the keying material, and its ID). The responder uses this second packet to authenticate the session. The third and final packet, which is sent by the initiator, finalizes the authentication of the ISAKMP session. |
| Quick mode | Quick mode negotiates the parameters (the SA) for the IPsec session. This negotiation occurs within the protection of an ISAKMP session. |

The IKE modes reflect the two primary phases of establishing an IPsec tunnel. For example, during IKE Phase 1, a secure ISAKMP session is established, using either main mode or aggressive mode. During IKE Phase 1, the IPsec endpoints establish transform sets (which are collections of encryption and authentication protocols), hash methods, and other parameters needed to establish a secure ISAKMP session (sometimes called an ISAKMP tunnel or an IKE Phase 1 tunnel). This collection of parameters is called a *security association* (*SA*). With IKE Phase 1, the SA is bidirectional, which means that the same key exchange is used for data flowing across the tunnel in either direction.

IKE Phase 2 occurs within the protection of an IKE Phase 1 tunnel, using the previously described *quick mode* of parameter negotiation. A session formed during IKE Phase 2 is sometimes called an *IKE Phase 2 tunnel* or simply an *IPsec tunnel*. However, unlike IKE Phase 1, IKE Phase 2 performs unidirectional SA negotiations, which means that each data flow uses a separate key exchange.

Although an IPsec tunnel can be established using just IKE Phase 1 and IKE Phase 2, an optional IKE Phase 1.5 can be used. IKE Phase 1.5 uses the Extended Authentication (XAuth) protocol to perform user authentication of IPsec tunnels. Like IKE Phase 2, IKE Phase 1.5 is performed within the protection of an IKE Phase 1 tunnel. The user authentication provided by this phase adds a layer of authentication for VPN clients. Also, parameters such as IP, WINS, and DNS server information can be provided to a VPN client during this optional phase.

A newer version of IKE called IKEv2 (discussed more a bit later in this chapter) combines many of the same functions of IKEv1 and uses an initial IKEv2 tunnel (instead of IKEv1 Phase 1) and child security associations (SAs/tunnels) for the IPsec tunnels instead of calling them IKE Phase 2 tunnels.

#### Authentication Header and Encapsulating Security Payload

In addition to IKE, which establishes the IPsec tunnel, IPsec relies on either the Authentication Header (AH) protocol (IP protocol number 51) or the Encapsulating Security Payload (ESP) protocol (IP protocol number 50). Both AH and ESP offer origin authentication and integrity services, which ensure that IPsec peers are who they claim to be and that the data was not modified in transit.

However, the main distinction between AH and ESP is encryption support. ESP encrypts the original packet, whereas AH does not offer encryption. As a result, ESP is much more popular on today’s networks.

Both AH and ESP can operate in one of two modes: transport mode or tunnel mode. [Figure 17-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17fig03) illustrates the structure of an ESP transport mode packet versus an ESP tunnel mode packet.

![](../images/17fig03.jpg)


**Figure 17-3** Transport Mode Versus Tunnel Mode

Note

You might be concerned that transport mode allows the IP address of the IPsec peers to remain visible during transit because the original packet’s IP header is used to route a packet. However, IPsec is often used in conjunction with the *Generic Routing Encapsulation* (*GRE*) tunneling protocol. With transport mode, the original IP packet is encapsulated inside a GRE tunnel packet, which adds a new GRE tunnel header. The GRE packet is then sent over an IPsec tunnel. Even if the IPsec tunnel were running in transport mode, the original packet’s IP header would still not be visible. Instead, the GRE packet’s header would be visible.

![](../images/key_topic_icon_158.jpg)

Following is a detailed description of these two modes:

- **Transport mode:** Uses a packet’s original IP header, as opposed to adding an additional tunnel header. This approach works well in networks where increasing a packet’s size might cause an issue. Also, transport mode is often used for client-to-site VPNs, where a PC running VPN client software connects back to a VPN termination device at a headquarters location.
- **Tunnel mode:** Unlike transport mode, tunnel mode encapsulates an entire packet. As a result, the encapsulated packet has a new header (an IPsec header). This new header has source and destination IP address information that reflects the two VPN termination devices at different sites. Therefore, tunnel mode is often used in an IPsec site-to-site VPN.

One reason a GRE tunnel might be used with an IPsec tunnel is as a limitation on the part of IPsec. Specifically, an IPsec tunnel can only transmit unicast IP packets. The challenge is that large enterprise networks might have a significant amount of broadcast or multicast traffic (for example, routing protocol traffic). GRE can take any traffic type and encapsulate the traffic in a GRE tunnel packet, which is a unicast IP packet that can then be sent over an IPsec tunnel. Take, for example, a multicast packet used by a routing protocol. Although IPsec cannot directly transport the multicast packet, if the packet is first encapsulated by GRE, the GRE packet can then be sent over an IPsec tunnel, thereby securing the transmission of the multicast packet.

#### The Five Steps in Setting Up and Tearing Down an IPsec Site-to-Site VPN Using IKEv1

The process of establishing, maintaining, and tearing down an IPsec site-to-site VPN consists of five primary steps, which are illustrated in [Figure 17-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17fig04) and described in detail in the list that follows:

![](../images/key_topic_icon_158.jpg)

![](../images/17fig04.jpg)


**Figure 17-4** IPsec VPN Steps

**Step 1.** PC1 sends traffic destined for PC2. Router1 classifies the traffic as “interesting” traffic, and this classification initiates the creation of an IPsec tunnel.

**Step 2.** Router1 and Router2 negotiate an SA used to form an IKE Phase 1 tunnel, which is also known as an ISAKMP tunnel.

**Step 3.** Within the protection of the IKE Phase 1 tunnel, an IKE Phase 2 tunnel is negotiated and set up. An IKE Phase 2 tunnel is also known as an IPsec tunnel.

**Step 4.** After the IPsec tunnel is established, interesting traffic (for example, traffic classified by an ACL) flows through the protected IPsec tunnel. Note that traffic not deemed interesting can still be sent between PC1 and PC2. However, the noninteresting traffic is transmitted outside the protection of the IPsec tunnel.

**Step 5.** After no interesting traffic is seen for a specified amount of time, the IPsec tunnel is torn down and the IPsec SA is deleted.

This example describes an IPsec site-to-site VPN, but the procedure is similar for a client-to-site VPN. IPsec is typically deployed using IKEv1, with its two phases (Phase 1 and Phase 2).

#### IKEv2

As you might guess, IKE Version 2 (IKEv2) offers many great improvements over IKEv1. IKEv2 uses fewer packets in setting up the SAs between VPN peers and does not use the terms *Phase 1* and *Phase 2*. Instead, the initial tunnel is called the *IKEv2 SA*, and the IPsec SA is referred to as a *child tunnel* (instead of being called an IKE Phase 2 tunnel).

Additional features that are integrated into IKEv2 include the following:

- Extensible Authentication Protocol (EAP)
- NAT traversal (that is, the ability to detect NAT in the path between the peers)
- The ability to validate the tunnel

IKEv1 requires additional configuration and vendor add-ons to implement similar types of features.

Note

Is there an IKE version 3? There sure is. IKEv3 simplifies the negotiation of security associations and improves security with stronger cryptographic algorithms. It introduces features like built-in NAT traversal and support for multiple authentication methods. IKEv3 also streamlines the protocol, reducing the number of message exchanges required to establish secure connections.

#### Other VPN Technologies

Although IPsec VPNs are popular for securely interconnecting sites or connecting a remote client to a site, you need to be aware of other VPN protocols, examples of which are provided in [Table 17-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17tab02).

![](../images/key_topic_icon_158.jpg)


**Table 17-2** Examples of VPN Protocols

| Protocol | Description |
| --- | --- |
| SSL | Secure Socket Layer (SSL) provides cryptography and reliability for the upper layers (Layers 5–7) of the OSI model. SSL, which was introduced in 1995, has largely been replaced by Transport Layer Security (TLS). However, recent versions of SSL (for example, SSL 3.3) have been enhanced to be more comparable with TLS. Both SSL and TLS provide secure web browsing via Hypertext Transfer Protocol Secure (HTTPS). |
| L2TP | Layer 2 Tunneling Protocol (L2TP) is a VPN protocol that lacks security features, such as encryption. However, L2TP can still be used for a secure VPN connection if it is combined with another protocol that does provide encryption. |
| L2F | Layer 2 Forwarding (L2F) is a VPN protocol designed (by Cisco Systems) with the goal of providing a tunneling protocol for PPP. Like L2TP, L2F lacks native security features. |
| PPTP | Point-to-Point Tunneling Protocol (PPTP) is an older VPN protocol (which supported the dial-up networking feature in older versions of Microsoft Windows). Like L2TP and L2F, PPTP lacks native security features. However, Microsoft’s versions of PPTP bundled with various versions of Microsoft Windows were enhanced to offer security features. |
| TLS | Transport Layer Security (TLS) has largely replaced SSL as the VPN protocol of choice for providing cryptography and reliability to upper layers of the OSI model. For example, when you securely connect to a website using HTTPS, you are probably using TLS. |
| SSTP | Secure Socket Tunneling Protocol (SSTP) is a VPN tunnel that transports PPP traffic through an SSL/TLS channel. SSL/TLS provides transport-level security. SSTP’s use of SSL/TLS over TCP port 443 allows SSTP to pass through virtually all firewalls and proxy servers. |
| OpenVPN | OpenVPN is a software VPN system that creates secure point-to-point or site-to-site connections in routed or bridged configurations and remote access facilities. It implements both client and server applications. |

### Other Network Access Technologies

When it comes to network access solutions, it is not surprising that varying amounts of security are possible today and can be implemented in a wide variety of ways. Your organization might require the strongest possible protections over one network access connection, while another might require the mildest possible security treatment. Fortunately, remote network access technologies abound today, and these varying degrees of security can be accommodated with no problem.

Although ACLs can be used to permit or deny specific connections flowing *through* a router (or switch), you also need to control connections *to* network devices (for example, routers, switches, or servers). [Table 17-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17tab03) summarizes many of these network access technologies.

![](../images/key_topic_icon_158.jpg)


**Table 17-3** Network Access Technologies

| Method | Description |
| --- | --- |
| Virtual desktop | Virtual desktop technology is growing at a fast pace, thanks in large part to the adoption of cloud technologies and increased bandwidth between data centers and end users. Using this approach, a user accesses a desktop that is housed on a server in the data center. The user might not even realize that the operating system is not hosted on the local PC or laptop.  Note that the virtual desktop concept discussed here is different from other types of virtual desktops in IT. For example, in both Windows and macOS systems, you can create virtual desktops. These are just running “spaces” on the local system that have different windows and programs running within them, which makes it easier to multitask. Notice how very different this technology is from the virtual desktops referenced here. |
| SSH | [***Secure Shell (SSH)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_595) is a protocol used to securely connect to a remote host (typically via a terminal emulator). Secure Shell has enjoyed such widespread success that it is even used as the basis for several other security protocols and techniques. For example, SCP calls on SSH for some of its functionality. SSH uses port 22.  As mentioned earlier, Linux administrators often prefer to use the command line for all operation and work in the operating system, and SSH is a perfect secure remote access tool for such users. Administrators can use the CLI to connect securely with SSH, and then they can operate in a BASH CLI environment to manage or work within the system. |
| Graphical user interface (GUI) | Many systems still provide a [***graphical user interface (GUI)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_289) for management access, no matter if this is local or remote access. Always be sure that appropriate bandwidth exists for a seamless experience with these GUIs. |
| API | [***Application programming interfaces (APIs)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_056) are increasingly being used to access and manage networks by providing a standardized way for software applications to communicate with network devices and services. Through APIs, developers can programmatically configure network settings, monitor network performance, and automate network management tasks. This allows for greater flexibility, scalability, and efficiency in network operations, as tasks that once required manual intervention can now be automated. |
| Console | Most network devices permit local access through what is termed a [***console***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_168) port. Notice this console port should be protected with the appropriate logical and physical security controls. |
| AAA | Authentication, authorization, and accounting (AAA, pronounced “triple A”) allows a network to have a single repository of user credentials. A network administrator can, for example, supply the same credentials to log in to various network devices (for example, routers and switches). RADIUS and TACACS+ are protocols commonly used to communicate with a AAA server. |
| RADIUS | Remote Authentication Dial-In User Service (RADIUS) is a UDP-based protocol used to communicate with a AAA server. Unlike TACACS+, RADIUS does not encrypt an entire authentication packet; rather, it encrypts only the password. However, RADIUS does offer more robust accounting features than TACACS+. Also, RADIUS is a standards-based protocol, whereas TACACS+ is a Cisco-proprietary protocol. |
| TACACS+ | Terminal Access Controller Access-Control System Plus (TACACS+) is a Cisco-proprietary TCP-based AAA protocol. TACACS+ has three separate and distinct sessions or functions for authentication, authorization, and accounting. |
| NAC | Network access control (NAC) can be used to permit or deny access to a network based on characteristics of the device seeking admission rather than just checking user credentials. For example, a client’s operating system and version of antivirus software could be checked against a set of requirements before allowing the client to access a network. This process of checking a client’s characteristics is called *posture assessment*. |
| IEEE 802.1X | IEEE 802.1X is a type of NAC that can permit or deny a wireless or wired LAN client access to a network. If IEEE 802.1X is used to permit access to a LAN via a switch port, then IEEE 802.1X is being used for port security.  While covered elsewhere in this text, to summarize, in 802.1X, the device seeking admission to the network is called the *supplicant*. The device to which the supplicant connects (either wirelessly or through a wired connection) is called the *authenticator*. The device that checks the supplicant’s credentials and permits or denies the supplicant to access the network is called an *authentication server*. Usually, an authentication server is a RADIUS server. |
| EAP | Extensible Authentication Protocol (EAP) specifies how authentication is performed by IEEE 802.1X. A variety of EAP types exist (see [Chapter 11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11)), such as Extensible Authentication Protocol-Flexible Authentication via Secure Tunneling (EAP-FAST), Extensible Authentication Protocol-Message Digest 5 (EAP-MD5), and Extensible Authentication Protocol-Transport Layer Security (EAP-TLS). |
| Two-factor authentication | Two-factor authentication (TFA) requires two types of authentication from a user seeking admission to a network. For example, a user might have to *know* something (for example, a password) and *have* something (such as a specific fingerprint, which can be checked with a biometric authentication device). |
| Multifactor authentication | Multifactor authentication requires two or more types of successful authentication factors before granting access to a network. |
| Single sign-on | Single sign-on (SSO) allows a user to authenticate only once to gain access to multiple systems rather than needing to independently authenticate with each system. |
| Local authentication | Local authentication refers to a network device authenticating the user with a database of user account information stored on the device itself; this is often an important fallback method of authentication used when another external method fails. |
| Captive portal | A captive portal is a web page that appears before a user is able to access the network resource; this web page accepts the credentials of the user for authentication and presents them to the authentication server. |
| Jump box/host | A [***jump box***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_353), or [***jump host***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_354), is a secure intermediary server used to access and manage devices within a protected network. It acts as a gateway, allowing administrators to connect to the internal network from an external or less secure network. By requiring all remote connections to go through the jump box, organizations can enforce strict access controls, monitor activity, and reduce the attack surface. This added layer of security helps protect sensitive network resources and ensures that only authorized users can perform administrative tasks within the network, enhancing overall network security. |

### Authentication and Authorization Considerations

There is a strong emphasis in IT on *authentication* and *authorization* for remote access as this area continues to explode in popularity and usage. For example, multifactor authentication (MFA) is currently surging in popularity due to its ability to help secure networks and their data. You will learn more about MFA in [Chapter 18](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#ch18).

Technology has also progressed in the specific area of authorization. New technologies such as data loss prevention (DLP) enable mechanisms for the protection of data throughout its lifetime and use in all locations related to the enterprise. This type of technology is especially useful in heavily mobile environments. In fact, DLP functions are often a key aspect of mobile device management (MDM) solutions.

DLP systems are designed to detect and prevent unauthorized use and transmission of confidential information based on one of the three states of data:

- In use
- In motion/transit
- At rest

A well-designed DLP strategy allows control over sensitive data, reduces the cost of data breaches, and achieves greater insight into organizational data use.

### In-Band vs. Out-of-Band Management

One reason for the explosion in remote access technologies and their adoption is the growing number of solutions emphasizing out-of-band management. [***Out-of-band management***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_474) means that the network management traffic never mingles with the user data traffic. Your network device can have a separate network interface for this purpose. This separate network interface connects to a separate WAN connection, and this separate connection is used only for the network management traffic. Consider the advantages of out-of-band versus [***in-band network management***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_314). With in-band management, security issues are possible because the network management traffic shares the same path. There is also a contention for bandwidth in this scenario.

While out-of-band management may sound like the de facto answer and solution you should implement, keep in mind that not all designs are optimal for all different topologies, technologies, and solutions. There are plenty of in-band management solutions that run securely and optimally. In fact, well-designed network management solutions tend to involve low bandwidth consumption as part of their excellent design.

### Real-World Case Study

Acme, Inc. has implemented a new site-to-site VPN between the main HQ location and a large branch office that has just been brought online. Acme, Inc. decided on a site-to-site VPN because of the high volume of sensitive corporate data that needs to be sent frequently between these two locations. Having the VPN always available for these transfers is a major requirement.

Acme, Inc. has also decided to implement out-of-band network management traffic whenever possible. This includes the conversion of several types of management traffic from the current use of in-band management traffic.

An important exception to this new rule has been established. The IT Support Team will still be permitted to use SSH to several key systems using the main data network. Note that this is only permitted due to the strong encryption that is used with SSH.

### Summary

Here are the main topics covered in this chapter:

- This chapter discussed VPN technologies in general.
- This chapter discussed client-based and site-to-site based VPNs. Technologies covered included clientless VPNs, as well as split tunnel and full tunnel configurations.
- This chapter covered a wide variety of network access technologies and approaches, including SSH, GUIs, APIs, console ports, and more.
- Finally, this chapter covered both in-band and out-of-band network management.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 17-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17tab04) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 17-4** Key Topics for [Chapter 17](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| List | Two primary categories of VPNs | 406 |
| [Figure 17-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17fig03) | Transport Mode Versus Tunnel Mode | 411 |
| [Figure 17-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17fig04) | IPsec VPN Steps | 412 |
| [Table 17-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17tab02) | Examples of VPN Protocols | 414 |
| [Table 17-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17tab03) | Network Access Technologies | 415 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” or at least the section for this chapter, and complete as many of the tables as possible from memory. [Appendix D](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appd.xhtml#appd), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appd.xhtml#appd),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[application programming interface (API)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_01)

[client-to-site VPN](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_02)

[clientless VPN](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_03)

[console](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_04)

[full tunnel](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_05)

[graphical user interface (GUI)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_06)

[in-band management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_07)

[jump box](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_08)

[jump host](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_09)

[out-of-band management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_010)

[Secure Shell (SSH)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_011)

[site-to-site VPN](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_012)

[split tunnel](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#key_013)

### Additional Resources

**Remote Desktop Protocol (RDP) Using an SSL VPN:** <https://www.youtube.com/watch?v=NOytvWA0ZQwIPsec>

**Virtual Private Network (VPN) – Deep Dive:** <https://www.youtube.com/watch?v=7WhEk7Ga-Bw>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz17_1) What type of VPN might feature the use of a clientless VPN solution?

1. Site-to-site
2. Client-to-site
3. Client-to-client
4. Server-to-server

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz17_2) What VPN method permits only certain traffic to flow over the secure VPN connection while other traffic flows directly over the Internet?

1. Split tunnel
2. Full tunnel
3. In-band
4. Out-of-band

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz17_3) What remote access technology is considered a secure alternative to Telnet for making a secure connection to a remote network device and operating at the CLI?

1. SCP
2. SFTP
3. SSH
4. SSL

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz17_4) What is an out-of-band physical port that an administrator can use to configure a network device?

1. Loopback
2. API
3. Console
4. Monitor

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz17_5) A user clicks Accept, views an advertisement, provides an email address, or performs some other required action, and the network grants access to the user. Which of the following is being described here?

1. Virtual network computing (VNC)
2. Remote desktop connection (RDC)
3. SSH
4. Captive portal

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz17_6) What data state describes data stored on a hard drive or tape drive?

1. Data in use
2. Data at rest
3. Data in an inconsistent state
4. Data in transit

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz17_7) Which protocol has largely replaced SSL as the VPN protocol of choice for providing cryptography and reliability to upper layers of the OSI model?

1. PPTP
2. L2TP
3. L2F
4. TLS

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz17_8) Which is a method of managing and monitoring network devices using the same communication path or network infrastructure that carries user data traffic?

1. Jump box/host
2. In-band management
3. Out-of-band management
4. SSO

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz17_9) What is a secure intermediary server used to access and manage devices within a protected network?

1. Jump box
2. VPC
3. SSH
4. API