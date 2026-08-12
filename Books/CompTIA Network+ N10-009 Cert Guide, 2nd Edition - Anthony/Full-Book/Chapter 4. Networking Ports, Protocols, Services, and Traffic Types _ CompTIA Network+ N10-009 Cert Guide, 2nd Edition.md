## Chapter 4

## Networking Ports, Protocols, Services, and Traffic Types

This chapter covers the following topics related to Objective 1.4 (Explain common networking ports, protocols, services, and traffic types) of the CompTIA Network+ N10-009 certification exam:

- [File Transfer Protocol (FTP): Ports 20/21](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec1)
- [Secure File Transfer Protocol (SFTP): Port 22](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec2)
- [Secure Shell (SSH): Port 22](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec3)
- [Telnet: Port 23](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec4)
- [Simple Mail Transfer Protocol (SMTP): Port 25](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec5)
- [Domain Name System (DNS): Port 53](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec6)
- [Dynamic Host Configuration Protocol (DHCP): Ports 67/68](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec7)
- [Trivial File Transfer Protocol (TFTP): Port 69](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec8)
- [Hypertext Transfer Protocol (HTTP): Port 80](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec9)
- [Network Time Protocol (NTP): Port 123](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec10)
- [Simple Network Management Protocol (SNMP): Ports 161/162](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec11)
- [Lightweight Directory Access Protocol (LDAP): Port 389](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec12)
- [Hypertext Transfer Protocol Secure (HTTPS): Port 443](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec13)
- [Server Message Block (SMB): Port 445](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec14)
- [Syslog: Port 514](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec15)
- [Simple Mail Transfer Protocol Secure (SMTPS): Port 587](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec16)
- [Lightweight Directory Access Protocol over SSL (LDAPS): Port 636](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec17)
- [Structured Query Language (SQL) Server: Port 1433](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec18)
- [Remote Desktop Protocol (RDP): Port 3389](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec19)
- [Session Initiation Protocol (SIP): Ports 5060/5061](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec20)
- [Internet Protocol (IP) types](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev1sec3)

  - [Internet Control Message Protocol (ICMP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec22)
  - [Transmission Control Protocol (TCP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec23)
  - [User Datagram Protocol (UDP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec24)
  - [Generic Routing Encapsulation (GRE)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec25)
  - [Internet Protocol Security (IPsec)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec26)

    - Authentication Header (AH)
    - Encapsulating Security Payload (ESP)
    - Internet Key Exchange (IKE)
  - [Traffic types](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev1sec4)

    - [Unicast](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec28)
    - [Multicast](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec30)
    - [Anycast](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec31)
    - [Broadcast](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04lev2sec29)

This chapter might initially look like a reference chapter, and it can certainly serve that function, but this chapter is much more than that. This chapter also helps prepare you for more in-depth explanations of many of these protocols in later chapters of this book. Additionally, this chapter teaches you about the various IP protocol types in use today and the traffic types that help make our networks so incredibly useful.

### Foundation Topics

### Ports and Protocols

I know it might be very intimidating to look at this section of the chapter and realize just how many different protocols (and ports) are needed in a typical network today. Resist the urge to panic! Through study and practice, you will master these different protocols and the ports they use.

As you will quickly learn in this chapter, there are several common networking ports that are used frequently. Ports 0 through 1023 are defined as well-known ports. Registered ports are from 1024 to 49151. The remainder of the ports from 49152 to 65535 are used dynamically by applications.

#### FTP (File Transfer Protocol)

[***File Transfer Protocol (FTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_269) can be used to transfer files with a remote host (which typically requires authentication of user credentials). It uses TCP ports 20 and 21 in its operation. Unfortunately, FTP users authenticate using cleartext mechanisms. It is one of many protocols that lacks security (and is becoming rarely used as a result).

#### SFTP

[***Secure File Transfer Protocol (SFTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_594) provides FTP file transfer service over an SSH connection. Just like SSH, this secure protocol uses TCP port 22 in its operation.

#### SSH

[***Secure Shell (SSH)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_595) is used to securely connect to a remote host (typically via a terminal emulator). SSH has become the new de facto standard method of remote access for devices that use a command-line interface. SSH uses TCP port 22 in its operation.

#### Telnet

[***Telnet***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_685) is used to connect to a remote host (typically via a terminal emulator). This remote access protocol should be used only in a lab or practice environment because it does not provide security. The alternative to this protocol that you should use in production is SSH. Telnet uses TCP port 23 in its operation.

#### SMTP

[***Simple Mail Transfer Protocol (SMTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_622) is used for sending email throughout a network. This protocol uses TCP port 25 in its operation.

#### DNS (Domain Name System)

[***Domain Name System (DNS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_231) is used to translate domain names, such as [www.pearsonitcertification.com](http://www.pearsonitcertification.com/), into IP addresses, such as 165.193.123.44. DNS uses a hierarchical namespace that enables the database of hostname-to-IP address mappings to be distributed across multiple servers. DNS uses both TCP and UDP in its operation. The port used in both cases is port 53.

#### DHCP (Dynamic Host Configuration Protocol)

You can use [***Dynamic Host Configuration Protocol (DHCP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_239) to dynamically assign IP address information (for example, IP address, subnet mask, DNS server IP address, and default gateway IP address) to a network device. DHCP uses UDP ports 67 and 68 in its operation.

#### TFTP

[***Trivial File Transfer Protocol (TFTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_718) transfers files with a remote host (and does not require authentication of user credentials). TFTP uses UDP port 69 in its operation.

#### HTTP

[***Hypertext Transfer Protocol (HTTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_308) retrieves content from a web server. This protocol operates using TCP port 80. Many web server administrators liked to move the protocol to port 8080 in an attempt to circumvent the massive number of attacks against the default port 80. HTTP lacks security, and as a result, today, it is hard to find websites that are running HTTP. HTTPS is now the de facto standard for web servers.

#### NTP

Network devices use [***Network Time Protocol (NTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_450) to synchronize their clocks with a time server (that is, an NTP server). This protocol relies on UDP port 123 in its operation.

#### SNMP

[***Simple Network Management Protocol (SNMP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_624) is used to monitor and manage network devices. SNMP uses UDP ports 161 and 162 in its operation. You will learn many details about SNMP in [Chapter 14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14), “[Network Monitoring](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14).”

#### LDAP

[***Lightweight Directory Access Protocol (LDAP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_372) provides directory services (for example, a user directory that includes username, password, email, and phone number information) to network clients. LDAP is used to access and query compliant directory services systems, such as Microsoft Active Directory. TCP port 389 is used in its operation.

#### HTTPS

[***Hypertext Transfer Protocol Secure (HTTPS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_309) is used to securely retrieve content from a web server. This secure version of HTTP uses TCP port 443 in its operation. HTTPS was originally made possible by the [***Secure Sockets Layer (SSL)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_596) protocol. [***Transport Layer Security (TLS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_716) is the latest version of this technology. Because TLS is closely related to SSL, we often simply say that HTTPS is made possible by SSL/TLS.

#### SMB

[***Server Message Block (SMB)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_603) is used to share files, printers, and other network resources. This protocol was originally used by Microsoft clients only. Since then, UNIX and Linux clients can install software to also use SMB for file sharing. Older versions of SMB used both UDP and TCP port 3020. Today, newer versions of SMB (after Windows 2000) use port 445 on top of a TCP stack in order to communicate over the Internet.

#### Syslog

[***Syslog***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_674) is the standard used by network devices (and other computer systems) to report and send log messages on status information and health events to network administrators. In fact, to centrally store these messages, they are often sent to a Syslog server. This data is often called *machine data*. Storing and analyzing this information, which may include driver failures, device conflicts, read/write errors, timeouts, and bad block errors, can be very important. Syslog uses UDP port 514 in its operation.

#### SMTPS

[***Simple Mail Transfer Protocol Secure (SMTPS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_623) uses TCP port 587 in its operation and is the secure version of SMTP. SMTPS uses Transport Layer Security to provide authentication of the communication partners along with data integrity and confidentiality by wrapping SMTP data in TLS. This is like how HTTPS wraps HTTP data inside TLS.

#### LDAPS

[***Lightweight Directory Access Protocol over SSL (LDAPS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_373) is the secure version of LDAP. It operates over TCP port 636.

#### Structured Query Language (SQL) Server

SQL (Structured Query Language) is a standardized programming language used to manage and manipulate relational databases by performing tasks such as querying, updating, and managing data. You can use this SQL language via a specialized server to run powerful queries against data that is stored in databases. A [***Structured Query Language (SQL) Server***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_663) can use TCP and UDP in its operation. Port 1433 was reserved for this Microsoft invention.

#### RDP

[***Remote Desktop Protocol (RDP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_550) is a Microsoft protocol that allows a user to view and control the desktop of a remote computer. RDP is a presentation layer protocol that supports a Windows-based Remote Desktop Connection (RDC) between an RDP client (formerly known as Windows Terminal Client) and a server. This remote access technology uses both TCP and UDP port 3389 in its operation.

#### SIP

[***Session Initiation Protocol (SIP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_608) is used to create and end sessions for one or more media connections, including Voice over IP (VoIP) calls. SIP can use both TCP and UDP ports 5060 and 5061 in its operation.

#### Protocol/Port Summary

[Table 4-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04tab01) provides a summary of protocols and their assigned ports

![](../images/key_topic_icon_158.jpg)


**Table 4-1** Port Assignments for Commonly Used Protocols

| Protocol | Description | Port Assignment |
| --- | --- | --- |
| DHCP (Dynamic Host Configuration Protocol) | Dynamically assigns IP address information (for example, IP address, subnet mask, DNS server IP address, and default gateway IP address) to a network device | UDP 67, 68 |
| DNS (Domain Name System) | Resolves domain names to corresponding IP addresses | TCP/UDP 53 |
| FTP (File Transfer Protocol) | An insecure protocol used to transfer files with a remote host (typically requires authentication of user credentials) | TCP 20, 21 |
| HTTP (Hypertext Transfer Protocol) | An insecure protocol used to retrieve content from a web server | TCP 80 |
| HTTPS (Hypertext Transfer Protocol Secure) | Used to securely retrieve content from a web server | TCP 443 |
| LDAP (Lightweight Directory Access Protocol) | Provides directory services (for example, a user directory that includes username, password, email, and phone number information) to network clients | TCP 389 |
| LDAPS (Lightweight Directory Access Protocol over SSL) | The secure version of LDAP | TCP 636 |
| NTP (Network Time Protocol) | Used by a network device to synchronize its clock with a time server (NTP server) | UDP 123 |
| RDP (Remote Desktop Protocol) | A Microsoft protocol that allows a user to view and control the desktop of a remote computer | TCP/UDP 3389 |
| SFTP (Secure File Transfer Protocol) | Provides FTP file transfer service over an SSH connection | TCP 22 |
| SIP (Session Initiation Protocol) | Used to create and end sessions for one or more media connections, including Voice over IP (VoIP) calls | TCP/UDP 5060, 5061 |
| SMB (Server Message Block) | Used to share files, printers, and other network resources | TCP 445 |
| SMTP (Simple Mail Transfer Protocol) | Used for sending email throughout the network | TCP 25 |
| SMTPS (Simple Mail Transfer Protocol Secure) | Allows for secure communication between email clients and mail servers, ensuring that email messages are encrypted during transmission | TCP 587 |
| SNMP (Simple Network Management Protocol) | Used to monitor and manage network devices; SNMPv3 is the latest and most secure version of SNMP and allows for the use of strong cryptographic algorithms, such as HMAC-SHA, HMAC-MD5, and AES, to ensure data integrity and confidentiality | UDP 161, 162 |
| SQL (Structured Query Language) Server | A server that specializes in SQL and is used to run powerful queries against data that is stored in databases | TCP/UDP 1433 |
| SSH (Secure Shell) | Used to securely connect to a remote host (typically via a terminal emulator) | TCP 22 |
| Syslog | The standard used by network devices (and other computer systems) to report on status information and events | UDP 514 |
| Telnet | An insecure protocol used to connect to a remote host (typically via a terminal emulator) | TCP 23 |
| TFTP (Trivial File Transfer Protocol) | Used to transfer files with a remote host (does not require authentication of user credentials) | UDP 69 |

### Internet Protocol (IP) Types

As you have probably realized, there are many, many protocols that are considered part of the TCP/IP protocol suite. This section provides an overview of several of the IP protocol types used within TCP/IP. Many of these protocols are discussed in detail in other chapters.

Remember, [***Internet Protocol (IP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_336) is a network layer protocol, documented in RFC 791, that offers a connectionless internetwork service. IP provides features for addressing, packet fragmentation and reassembly, type-of-service specification, and security.

#### Internet Control Message Protocol (ICMP)

In addition to TCP and UDP, [***Internet Control Message Protocol (ICMP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_330) is another transport layer protocol you are likely to meet. ICMP is a network layer Internet protocol documented in RFC 792 that reports errors and provides other information relevant to IP packet processing. It is used by utilities such as ping and traceroute.

#### Transmission Control Protocol (TCP)

The transport layer of the OSI model offers an important protocol for reliable transport—[***Transmission Control Protocol (TCP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_712). What does *reliable transport* mean, in networking terms? It means that if a segment is dropped, the sender can detect that drop and retransmit the dropped segment. Specifically, a receiver acknowledges segments that it receives. Based on those acknowledgments, a sender can decide which segments were successfully received and which segments need to be transmitted again.

#### User Datagram Protocol (UDP)

[***User Datagram Protocol (UDP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_734) can be considered an opposite approach to TCP. Unlike TCP, UDP offers unreliable transport. This means that if a segment is dropped, the sender is unaware of the drop, and no retransmission occurs. Note that UDP is another option at the transport layer of the OSI model. This works as an ideal alternative to TCP.

Note

The reliability of TCP versus the unreliability of UDP is often referred to as [***connectionless***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_167) versus [***connection-oriented***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_166) communications. You might use the analogy of a phone call versus a postcard. With a phone call (which represents TCP), as you send messages, you ensure that the connection remains strong and that communications are clear. For example, you might ask “can you hear me now?” as you move to a different part of the house for a better cell connection. In fact, you begin the connection with a “hello” and end the connection with a “goodbye.” UDP operates more like a postcard: There is no connection maintained at all. You drop the postcard in the mail and hope that it reaches its destination.

#### Generic Routing Encapsulation (GRE)

[***Generic Routing Encapsulation (GRE)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_284), as its name implies, is a multipurpose, simple tunneling protocol that you might call on in a wide variety of circumstances. For example, let’s say you have traffic that you want to protect over an IPsec tunnel, but this traffic is multicast traffic. IPsec does not support securing this type of traffic. That is where GRE can come into play. The multicast can be encapsulated inside GRE, and then this GRE traffic can be protected by IPsec. This is just one example of many where GRE can come in handy.

#### Internet Protocol Security (IPsec)

[***Internet Protocol Security (IPsec)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_337) is a complex suite of protocols that is used to create secured connections between network systems. In fact, IPsec is quickly becoming the de facto standard for VPN connections. IPsec features the use of [***Authentication Header (AH)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_068) and [***Encapsulating Security Payload (ESP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_246). As you would guess, AH handles authentication functions, while ESP takes care of encryption. IPsec also takes advantage of the [***Internet Key Exchange (IKE)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_332) protocol. IKE negotiates cryptographic keys and security parameters to facilitate the secure IPsec data transmissions over the Internet.

#### Internet Protocol (IP) Types Summary

[Table 4-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04tab02) provides a summary of the TCP/IP suite protocols described so far in this chapter.

![](../images/key_topic_icon_158.jpg)


**Table 4-2** Internet Protocol (IP) Types Summary

| Protocol | Complete Protocol Name | Description |
| --- | --- | --- |
| IPsec | Internet Protocol Security | A complex suite of protocols that is used to create secured connections between network systems. |
| GRE | Generic Routing Encapsulation | A tunneling protocol used to encapsulate a wide variety of network layer protocols inside virtual point-to-point links or point-to-multipoint links over an IP network. |
| IP | Internet Protocol | A network layer protocol, documented in RFC 791, that offers a connectionless internetwork service. IP provides features for addressing, packet fragmentation and reassembly, type-of-service specification, and security. |
| TCP | Transmission Control Protocol | A connection-oriented protocol that offers flow control, sequencing, and retransmission of dropped packets. |
| UDP | User Datagram Protocol | A connectionless alternative to TCP used for applications that do not require the functions offered by TCP. |
| ICMP | Internet Control Message Protocol | Sends error messages and operational information indicating issues with packet delivery in IP networks. |
| ESP | Encapsulating Security Payload | Provides for encryption in the IPsec suite of protocols. |
| AH | Authentication Header | Provides for authentication in the IPsec suite of protocols. |
| IKE | Internet Key Exchange | Negotiates cryptographic keys and security parameters for IPsec. |

### Traffic Types

In our IP-based networks of today, traffic flows in different manners as dictated by the various traffic types we create. In this section, we examine these different traffic types and how data moves throughout the network with each.

#### Unicast

Most network traffic is [***unicast***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_726) in nature, meaning that traffic travels from a single source device to a single destination device. [Figure 4-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig01) illustrates an example of a unicast transmission.

![](../images/key_topic_icon_158.jpg)

![](../images/04fig01.jpg)


**Figure 4-1** Sample Unicast Transmission

Notice the Layer 3 IP addresses shown in [Figure 4-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig01). We delve deep into these addresses in [Chapter 7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07), “[IPv4 Addressing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07),” but for now it is worth noting that these are unicast IP addresses to facilitate this most common form of IP traffic.

It is at this point that you might ask, “Why do we even need other forms of traffic in the IP network?” This is a great question. The answer lies with how inefficient unicast traffic would be when we have something (let’s say a large video file) that we want to send to all devices on the network. Creating a separate copy of the video for every single recipient and then sending the data to every single network node would be horribly inefficient. This is a big part of the reason why we have other network traffic types that we see in this section of the chapter.

#### Broadcast

[***Broadcast***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_103) traffic travels from a single source to all destinations on a network (that is, a *broadcast domain*) as shown in [Figure 4-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig02). Notice the use of a very special IP address to facilitate the broadcast traffic type—it is 255.255.255.255.

![](../images/key_topic_icon_158.jpg)

![](../images/04fig02.jpg)


**Figure 4-2** Sample Broadcast Transmission

It might seem as though the broadcast address 255.255.255.255 would reach all hosts on all interconnected networks. However, 255.255.255.255 targets all devices on a single network—specifically, the network local to the device sending a packet destined for 255.255.255.255. Another type of broadcast address is a *directed broadcast address*, which targets all devices in a remote network. For example, the address 172.16.255.255 /16 is a directed broadcast address targeting all devices in the 172.16.0.0 /16 network.

#### Multicast

[***Multicast***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_414) technology offers an efficient mechanism for a single host to send traffic to multiple specific destinations. For example, say that a network has 100 users, and 20 of those users want to receive a video stream from a video server. With a unicast solution, the video server would have to send 20 individual streams, 1 for each recipient. As described earlier in this section, such a solution could consume a significant amount of network bandwidth and put a heavy processor burden on the video server.

With a broadcast solution, the video server would only have to send the video stream once; however, it would be received by every device on the local subnet, even devices not wanting to receive the video stream. Even though a lot of the devices do not want to receive the video stream, they still must pause what they are doing and take time to check each of these unwanted packets.

As shown in [Figure 4-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig03), multicast offers a compromise, allowing the video server to send the video stream only once and sending the video stream only to devices on the network that want to receive the stream. Multicast is possible thanks to the use of what is called a Class D IP address. A Class D address, such as 239.1.2.3, represents the address of a *multicast group*. The video server could, in this example, send a single copy of each video stream packet destined for 239.1.2.3. Devices wanting to receive the video stream could join the multicast group. Based on the device request, switches and routers in the topology could then dynamically determine out of which ports the video stream should be forwarded.

![](../images/key_topic_icon_158.jpg)

![](../images/04fig03.jpg)


**Figure 4-3** Sample Multicast Transmission

Are there other classes of IP addresses? There sure are, and you will learn all about them in [Chapter 7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07).

#### Anycast

With [***anycast***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_050), a single IP address is assigned to multiple devices, as illustrated in [Figure 4-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig04). It is a one-to-nearest (from the perspective of a router’s routing table) communication flow.

![](../images/04fig04.jpg)


**Figure 4-4** An IPv6 Anycast Example

Notice the IP addresses shown in [Figure 4-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig04), which might look quite odd to you. These are IPv6 addresses. As you will learn in [Chapter 8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08), “[Evolving Use Cases](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08),” IPv6 is the next-generation version of IP and it is becoming more and more common in our networks today. While anycast traffic is possible in IPv4, it is going to be much more commonly used in the new IPv6 protocol suite.

![](../images/key_topic_icon_158.jpg)

In [Figure 4-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig04), a client with IPv6 address AAAA::1 wants to send traffic to destination IPv6 address AAAA::2. Notice that two servers (Server A and Server B) have the IPv6 address AAAA::2. In the figure, the traffic destined for AAAA::2 is sent to Server A, via router R2, because the network on which Server A resides appears to be closer than the network on which Server B resides, from the perspective of router R1’s IPv6 routing table.

Remember that you need to distinguish among these four network traffic types:

- With unicast, traffic is one-to-one communication between a single sender and a single receiver, and this is the most common type of traffic in IP networks. It is used for point-to-point communication between devices, such as client-server interactions and most Internet browsing.
- Multicast is a mechanism by which groups of network devices can send and receive data between the members of the group at one time (one-to-many), instead of separately sending messages to each device in the group.
- Anycast traffic is one-to-nearest communication from a sender to the nearest of multiple receivers. Multiple devices share the same anycast IP address, but packets are routed to the nearest (or best) destination based on routing metrics such as shortest path or lowest latency.
- A broadcast is at the opposite end of the spectrum from a unicast. Broadcast traffic is one-to-all communication from a single sender to all devices within a specific network segment. Each packet in a broadcast transmission is addressed to a special broadcast IP address (e.g., 255.255.255.255 in IPv4) or a Layer 2 broadcast address (e.g., MAC address FF:FF:FF:FF:FF:FF).

Note

IPv6 was engineered to provide many advantages over the IPv4 protocol. One of the massive advantages is that broadcast frames and packets from IPv4 do not exist in an IPv6-only network. IPv6 uses only unicasts, multicasts, and anycasts, as described in this section. With IPv6, if you want to send a frame or packet to all nodes in the local network, you use a special all-nodes IPv6 multicast address. This completely eliminates the need for the broadcast traffic type in IPv6-only networks.

#### Traffic Types Summary

[Table 4-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04tab03) provides a summary of the traffic types described in this chapter.

![](../images/key_topic_icon_158.jpg)


**Table 4-3** Traffic Types Summary

| Traffic Type | Description |
| --- | --- |
| Unicast | Traffic is one-to-one communication between a single sender and a single receiver, and this is the most common type of traffic in IP networks. It is used for point-to-point communication between devices, such as client-server interactions and most Internet browsing. |
| Multicast | A mechanism by which groups of network devices can send and receive data between the members of the group at one time (one-to-many), instead of separately sending messages to each device in the group. |
| Anycast | Anycast traffic is one-to-nearest communication from a sender to the nearest of multiple receivers. Multiple devices share the same anycast IP address, but packets are routed to the nearest (or best) destination based on routing metrics such as shortest path or lowest latency. |
| Broadcast | A broadcast is at the opposite end of the spectrum from a unicast. Broadcast traffic is one-to-all communication from a single sender to all devices within a specific network segment. |

### Summary

Here are the main topics covered in this chapter:

- The focus of this chapter was to ensure you are well versed in the most common protocols we work with in the modern network. Notice that these protocols are often recognized by their well-known port numbers. When you see 443, you should immediately think about HTTPS traffic.
- This chapter also covered the most important IP protocol types in use today, including TCP, UDP, ICMP, GRE, and IPsec.
- Finally, this chapter covered the traffic types found in computer networks today, including unicast, multicast, anycast, and broadcast.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 4-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04tab04) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 4-4** Key Topics for [Chapter 4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| [Table 4-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04tab01) | Port Assignments for Commonly Used Protocols | 86 |
| [Table 4-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04tab02) | Internet Protocol (IP) Types Summary | 89 |
| [Figure 4-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig01) | Sample Unicast Transmission | 90 |
| [Figure 4-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig02) | Sample Broadcast Transmission | 91 |
| [Figure 4-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig03) | Sample Multicast Transmission | 92 |
| [Figure 4-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04fig04) | An IPv6 Anycast Example | 93 |
| [Table 4-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04tab03) | Traffic Types Summary | 94 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix B](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb),” or at least the section for this chapter and complete as many of the tables as possible from memory. [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[anycast](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_01)

[Authentication Header (AH)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_02)

[broadcast](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_03)

[connection-oriented](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_04)

[connectionless](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_05)

[Domain Name System (DNS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_06)

[Dynamic Host Configuration Protocol (DHCP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_07)

[Encapsulating Security Payload (ESP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_08)

[File Transfer Protocol (FTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_09)

[Generic Routing Encapsulation (GRE)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_010)

[Hypertext Transfer Protocol (HTTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_011)

[Hypertext Transfer Protocol Secure (HTTPS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_012)

[Internet Control Message Protocol (ICMP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_013)

[Internet Key Exchange (IKE)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_014)

[Internet Protocol (IP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_015)

[Internet Protocol Security (IPsec)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_016)

[Lightweight Directory Access Protocol (LDAP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_017)

[Lightweight Directory Access Protocol over SSL (LDAPS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_018)

[multicast](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_019)

[Network Time Protocol (NTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_020)

[Remote Desktop Protocol (RDP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_021)

[Secure File Transfer Protocol (SFTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_022)

[Secure Shell (SSH)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_023)

[Secure Sockets Layer (SSL)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_024)

[Server Message Block (SMB)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_025)

[Session Initiation Protocol (SIP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_026)

[Simple Mail Transfer Protocol (SMTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_027)

[Simple Mail Transfer Protocol Secure (SMTPS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_028)

[Simple Network Management Protocol (SNMP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_029)

[Structured Query Language (SQL) Server](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_030)

[Syslog](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_031)

[Telnet](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_032)

[Transmission Control Protocol (TCP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_033)

[Transport Layer Security (TLS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_034)

[Trivial File Transfer Protocol (TFTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_035)

[unicast](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_036)

[User Datagram Protocol (UDP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#key_037)

### Additional Resources

**IP, ICMP, UDP, and TCP:** <https://www.ajsnetworking.com/udp-and-tcp/>

**Ports and Protocols Quiz for Network+:** <https://www.ajsnetworking.com/ports_protocols_net_plus>

### Review Questions

The answers to these review questions are in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_1) What protocol is considered the de facto standard when it comes to secure access to remote systems for management purposes?

1. Telnet
2. SSH
3. IPsec
4. IMAP

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_2) You are interested in dynamically assigning the IP address information in your IPv4-based network infrastructure. What protocol can you use to accomplish this?

1. DNS
2. TFTP
3. FTP
4. DHCP

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_3) What global hierarchical system is used to resolve domain names to IP addresses?

1. TFTP
2. DHCP
3. NTP
4. DNS

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_4) What port and protocol are used by HTTPS? (Choose two.)

1. TCP
2. UDP
3. 443
4. 123
5. 8080
6. 80

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_5) What are the port and protocol used by Syslog? (Choose two.)

1. TCP
2. UDP
3. 148
4. 514
5. 240

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_6) What IP protocol do ping and traceroute use in their operation?

1. IPsec
2. DNS
3. ICMP
4. DHCP

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_7) What port is used for SSH?

1. 80
2. 443
3. 22
4. 23

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_8) What protocol negotiates cryptographic keys and security parameters for IPsec?

1. AH
2. ESP
3. IKE
4. GRE

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_9) What type of traffic uses a destination Layer 3 address of 255.255.255.255 and is no longer used in IPv6 environments?

1. Unicast
2. Multicast
3. Broadcast
4. Anycast

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_10) Which of the following is a Microsoft protocol that allows a user to view and control the desktop of a remote computer?

1. Syslog
2. SNMP
3. NTP
4. RDP

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz4_11) Which is a mechanism by which groups of network devices can send and receive data between the members of the group at one time (one-to-many), instead of separately sending messages to each device in the group?

1. Unicast
2. Multicast
3. Anycast
4. Broadcast