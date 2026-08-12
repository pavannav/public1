## Chapter 16

## IPv4 and IPv6 Network Services

This chapter covers the following topics related to Objective 3.4 (Given a scenario, implement IPv4 and IPv6 network services) of the CompTIA Network+ N10-009 certification exam:

- [Dynamic addressing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16lev1sec2)

  - [DHCP](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16lev2sec1)

    - Reservations
    - Scope
    - Lease time
    - Options
    - Relay/IP helper
    - Exclusions
  - Stateless address autoconfiguration (SLAAC)
- [Name resolution](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16lev1sec3)

  - [DNS](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16lev2sec3)

    - Domain Name Security Extensions (DNSSEC)
    - DNS over HTTPS (DoH) and DNS over TLS (DoT)
    - Record types

      - Address (A)
      - Quad A (AAAA)
      - Canonical name (CNAME)
      - Mail exchange (MX)
      - Text (TXT)
      - Nameserver (NS)
      - Pointer (PTR)
    - Zone types

      - Forward
      - Reverse
    - Authoritative vs. non-authoritative
    - Primary vs. secondary
    - Recursive
  - [Hosts file](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16lev2sec4)
- [Time Protocols](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16lev1sec4)

  - [NTP](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16lev2sec5)
  - [Precision Time Protocol (PTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16lev2sec6)
  - [Network Time Security (NTS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16lev2sec7)

While there are many network services available today, three services are so commonplace that we encounter them at every turn in the modern network: DHCP, DNS, and NTP. In this chapter, you’ll learn the important basics of these critical network components.

### Foundation Topics

### Dynamic Addressing

You might not be surprised to learn that [***Dynamic Host Configuration Protocol (DHCP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_239) is the star of the show when it comes to dynamic addressing for IPv4 in our corporate networks. But what might be surprising is the fact that IPv6 has a built-in mechanism for dynamic assignments of addresses. You will learn about that in this section of the chapter as well.

#### DHCP

Statically assigning IP address information to individual networked devices can be time-consuming, error prone, and subject to scalability problems. Instead of using static IP address assignments, many corporate networks dynamically assign IP address parameters to their devices. This is typically referred to as *dynamic address assignment*. The alternative approach is referred to as manual assignment, or *static assignment*.

An early choice for performing automatic assignment of IP addresses was Bootstrap Protocol (BOOTP). Currently, however, the most popular approach for dynamic IP address assignment is the use of DHCP.

Engineers developed BOOTP as a method of assigning IP address, subnet mask, and default gateway information to diskless workstations. In the early days of Microsoft Windows (for example, Microsoft Windows 3.1), Microsoft Windows did not natively support TCP/IP. To include TCP/IP support, an add-on TCP/IP application (for example, Trumpet Winsock) could be run. Such an application would typically support BOOTP.

DHCP offers a more robust solution to IP address assignment than does BOOTP. DHCP does not require a statically configured database of MAC-address-to-IP-address mappings. Also, DHCP has a wide variety of options beyond basic IP address, subnet mask, and default gateway parameters. For example, a DHCP server can educate a DHCP client about the IP address of a TFTP server from which a configuration file could be downloaded.

[Figure 16-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16fig01) illustrates the exchange of messages that occurs as a DHCP client obtains IP address information from a DHCP server. The list that follows describes these steps in further detail:

![](../images/16fig01.jpg)


**Figure 16-1** Obtaining IP Address Information from a DHCP Server


![](../images/key_topic_icon_158.jpg)

**Step 1.** When a DHCP client initially boots, it has no IP address, default gateway, or other such configuration information. Therefore, the way a DHCP client initially communicates is by sending a broadcast message (that is, a DHCPDISCOVER message to the destination broadcast address 255.255.255.255) in an attempt to discover a DHCP server.

**Step 2.** When a DHCP server receives a DHCPDISCOVER message, it can respond with a unicast DHCPOFFER message. Because the DHCPDISCOVER message is sent as a broadcast, more than one DHCP server might respond to this discover request. However, the client typically selects the server that sent the first DHCPOFFER response received by the client.

**Step 3.** The DHCP client communicates with this selected server by sending a unicast DHCPREQUEST message, asking the DHCP server to provide IP configuration parameters.

**Step 4.** The DHCP server responds to the client with a unicast DHCPACK message. This DHCPACK message contains a collection of IP configuration parameters.

Note

A method for remembering the four main steps of DHCP is to think of the acronym DORA: discover, offer, request, and acknowledge.

Notice that in step 1, the DHCPDISCOVER message is sent as a broadcast. By default, a broadcast cannot cross a router boundary. Therefore, if a client resides on a different network than the DHCP server, the client’s next-hop router should be configured as a DHCP relay agent, which allows a router to relay DHCP requests to either a unicast IP address or a directed broadcast address for a network. The DHCP relay agent is often referred to as an [***IP helper***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_344), or simply a [***DHCP relay***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_204).

Using a DHCP relay agent allows you to centrally locate a DHCP server that can simultaneously service many different TCP/IP subnets in your enterprise infrastructure. This is often a very desirable configuration because centralizing this information often makes it easier to manage. Of course, the risk in this configuration is that you must ensure that the DHCP relay agents are configured properly and that they are available; otherwise, the client broadcasts for DHCP services will not be successful.

A DHCP server can be configured to assign IP addresses to devices belonging to different subnets. Specifically, a DHCP server can determine the source subnet of a DHCP request and select an appropriate address pool from which to assign an address. One of these address pools (which typically corresponds to a single subnet) is called a [***scope***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_589).

When a network device is assigned an IP address from an appropriate DHCP scope, that assignment is not permanent. Rather, it is a temporary assignment referred to as a *lease* (the duration of your lease is the [***lease time***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_365)). Although most client devices on a network work well with this dynamic addressing, some devices (for example, servers) might need to be assigned specific IP addresses. Fortunately, you can configure a [***DHCP reservation***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_205). A DHCP reservation maps a specific MAC address to a specific IP address, ensuring that a certain device in your network receives the reserved address.

Another frequent configuration you might make in a DHCP implementation is to configure an [***exclusion range***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_257). This is a portion of the address pool that you never want leased out to clients in the network. Perhaps you have numbered your servers 192.168.1.1–192.168.1.10. Because the servers are statically configured with these addresses, you exclude these addresses from the 192.168.1.0/24 pool of addresses. Your DHCP server then leases out addresses beginning at the first available in the range; in this example, that would be 192.168.1.11.

As an example of DHCP client configuration, in Microsoft Windows 11, you can select the **Obtain an IP address automatically** and **Obtain DNS server address automatically** options in the Internet Protocol Version 4 (TCP/IPv4) Properties window, as shown in [Figure 16-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16fig02).

![](../images/16fig02.jpg)


**Figure 16-2** Configuring Microsoft Windows 11 to Obtain IP Address Information via DHCP

Perhaps you have noticed that DHCP dynamically assigns IP addresses and subnet masks to clients, but they need more IP addressing information than that in order to communicate properly on the network. For example, clients need DNS server addresses, they need a default gateway assigned, and they might even need the IP addresses associated with other key services, such as NTP and TFTP servers on the network. Your DHCP server can provide all this required IP addressing information. You enable this as part of the [***scope options***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_590) you can configure on the DHCP server. The scope options include the additional address information that must be distributed and can also include settings such as the lease time. Most DHCP servers permit a client to retain IP address information for 24 hours by default. If you have an environment with relatively few available addresses (and, therefore, few *available leases*), you can set the lease time to a shorter duration so that clients cannot retain the address information for excessive time periods.

#### SLAAC

IPv6 [***stateless address autoconfiguration (SLAAC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_656) is a method that allows devices on an IPv6 network to automatically configure their own IP addresses without the need for a central (DHCP) server. This makes it easier to set up and manage networks, especially as the number of connected devices continues to grow.

When a device connects to an IPv6 network, it first generates a unique link-local address, which is only valid within that local network segment. The device then uses this address to communicate with other devices on the same network and to discover routers. These routers send out Router Advertisement (RA) messages, which contain important network information, including the network prefix.

Using the information from the RA messages, the device combines the network prefix with its own unique identifier (often derived from its MAC address) to create a global unicast address. This address can be used for communication both within the local network and with devices on other networks, including the Internet.

SLAAC simplifies network administration by reducing the need for manual IP address configuration or the deployment of a DHCP server, which is commonly used in IPv4 networks. Instead, devices can independently generate their own addresses and configure themselves, making the network more flexible and scalable.

In addition to basic address configuration, SLAAC also supports address renumbering, allowing devices to update their addresses automatically if the network prefix changes. This is particularly useful in dynamic environments where network configurations might change frequently.

Notice there are many elements to DHCP in modern networks. To help you master these components, [Table 16-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16tab01) summarizes these DHCP elements for you.

![](../images/key_topic_icon_158.jpg)


**Table 16-1** DHCP Components

| DHCP Element | Description |
| --- | --- |
| DHCP reservation | A configuration on a DHCP server that assigns a specific IP address to a particular device or client on a network. Reservations allow administrators to assign specific IP addresses to devices based on their MAC addresses, ensuring that a device always receives the same IP address each time it connects to the network. |
| DHCP scope | A range of IP addresses and configuration parameters that a DHCP server is responsible for assigning to client devices on a network. |
| DHCP lease time | The duration for which an IP address is allocated to a client device by a DHCP server. |
| DHCP relay/IP helper | A network device or service that forwards DHCP requests from clients on one subnet to a DHCP server on a different subnet. |
| DHCP exclusions | Specific IP addresses or ranges of IP addresses that are intentionally excluded from being dynamically assigned by a DHCP server. |
| SLAAC | An IPv6 feature that allows devices to automatically configure their own IP addresses without the need for a DHCP server. |

### Name Resolution

As humans, we love to give our network devices “friendly” names. For example, my laptop might be known as ANTMAN on the network. While this makes it obvious for me when I see that device in a list of network devices, other systems need to find this device using its IP address and MAC address. The process of resolving these friendly names to other identifiers is called [***name resolution***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_428). As you will learn in this section, [***Domain Name System (DNS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_231) is a critical name resolution service powering the modern Internet. This section also covers a bit of a name resolution shortcut. It is a hosts file approach on a local system.

#### DNS

A Domain Name System server performs the task of resolving a domain name (for example, [www.ciscopress.com](http://www.ciscopress.com/)) to a corresponding IP address (for example, 159.182.74.49). Because routers (or multilayer switches) make their forwarding decisions based on Layer 3 information (for example, IP addresses), an IP packet needs to contain IP address information, not DNS names. However, we humans recall meaningful names more readily than we recall 32-bit numbers.

As shown in [Figure 16-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16fig03), an end user who wants to navigate to the [www.ciscopress.com](http://www.ciscopress.com/) website enters that fully qualified domain name (FQDN) into a web browser; however, the browser cannot immediately send a packet destined for [www.ciscopress.com](http://www.ciscopress.com/). First, the end user’s computer needs to resolve the FQDN [www.ciscopress.com](http://www.ciscopress.com/) to a corresponding IP address, which can be inserted as the destination IP address in an IP packet. This resolution is made possible by a DNS server, which maintains a database of local FQDNs and their corresponding IP addresses, in addition to pointers to other servers that can resolve IP addresses for other domains.

![](../images/key_topic_icon_158.jpg)

![](../images/16fig03.jpg)


**Figure 16-3** DNS Server

An FQDN is a series of strings, delimited by a period (such as [www.ciscopress.com](http://www.ciscopress.com/)). The rightmost part of the FQDN is the top-level domain. Examples of top-level domains include .com, .mil, and .edu, as shown in [Figure 16-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16fig04). Although there are many other top-level domains, these are among the most common top-level domains in the United States.

![](../images/key_topic_icon_158.jpg)

![](../images/16fig04.jpg)


**Figure 16-4** Hierarchical Domain Name Structure

Lower-level domains can point upward to higher-level DNS servers to resolve nonlocal FQDNs, as illustrated in [Figure 16-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16fig04).

DNS follows this strict hierarchy. And because public DNS is shared around the globe, it has a *global hierarchy*. In fact, the top-level domains include country references. For example, to enjoy a version of the [Amazon.com](http://amazon.com/) domain tailored to India, you can visit [www.amazon.in](http://www.amazon.in/).

In addition to the global hierarchy of the DNS name system, the organization of DNS servers throughout the world follows a global hierarchy. The following DNS server types exist:

- **Root DNS servers:** These authoritative name servers serve the DNS root zone; they are a network of hundreds of servers in many countries around the world.
- **Internal DNS servers:** These servers exist inside an organization to resolve the names of private hosts and servers within the organization. These servers can also forward requests for outside resources to the appropriate external DNS servers when internal clients need to access external resources.
- **External DNS servers:** These servers reside outside an organization (typically on the public Internet) and can resolve names of systems that are located outside the organization.
- [***Authoritative name server***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_071): This DNS server is usually the last step in the journey for an IP address. The authoritative name server contains information specific to the domain name it serves (for example, [ajsnetworking.com](http://ajsnetworking.com/)). The authoritative name server is able to resolve queries thanks to the records it contains.
- [***Non-authoritative name server***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_455): This DNS server provides DNS query responses based on information it has cached from previous queries rather than being the original source of the DNS records. It does not have the definitive, authoritative information but can quickly respond to requests using cached data. This type of server is typically used to reduce query times and network traffic.

A DNS server’s database contains not only FQDNs and corresponding IP addresses but also [***DNS record types***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_226). For example, a mail exchange (MX) record would be the record type for an email server. As a few examples, [Table 16-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16tab02) lists a collection of common DNS record types.

![](../images/key_topic_icon_158.jpg)


**Table 16-2** Common DNS Record Types

| Record Type | Description |
| --- | --- |
| [***A***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_041) | An *address* record (that is, A record) maps a hostname to an IPv4 address. |
| [***AAAA***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_031) | An IPv6 address record (that is, AAAA record) maps a hostname to an IPv6 address. |
| [***CNAME***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_119) | A *canonical name* record (that is, CNAME record) is an alias of an existing record that allows multiple DNS records to map to the same IP address. |
| [***MX***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_397) | A *mail exchange* record (that is, MX record) maps a domain name to an email (or message transfer agent) server for that domain. |
| [***NS***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_429) | A *nameserver* record (that is, NS record) delegates a DNS zone to use the given authoritative name server. |
| [***PTR***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_501) | A *pointer* record (that is, PTR record) points to a canonical name. A PTR record is commonly used when performing a reverse DNS lookup to determine what domain name is associated with a known IP address. |
| SOA | A *start of authority* record (that is, SOA record) provides authoritative information about a DNS zone, such as email contact information for the zone’s administrator, the zone’s primary name server, and various refresh timers. |
| SRV | A *service* location record (that is, SRV record) is used for newer protocols instead of creating protocol-specific records such as MX records. |
| [***TXT***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_691) | A *text* record (that is, TXT record) originally was for arbitrary human-readable text in a DNS record. Since the early 1990s, however, this record has carried machine-readable data, such as data specified by RFC 1464, opportunistic encryption, Sender Policy Framework (SPF), or DomainKeys Identified Email (DKIM). |

A potential challenge when setting up DNS records is when you want to point to the IP address of a device that might change its IP address. For example, if you have a cable modem or digital subscriber line (DSL) modem in your home, that device might obtain its IP address from your service provider via DHCP. As a result, if you add the IP address of your cable modem or DSL modem to a DNS record (to allow users on the Internet to access one or more devices inside your network), that record could be incorrect if your device obtains a new IP address from your service provider.

To overcome this challenge, you can use dynamic DNS (DDNS). A DDNS provider supplies software you run on one of your PCs that monitors the IP address of the device referenced in the DNS record (such as your cable modem or DSL modem). If the software detects a change in the monitored IP address, that change is reported to your service provider, which is also providing DNS service.

Another option is IP address management (IPAM), which is a means of planning, tracking, and managing the Internet Protocol address space used in a network. IPAM integrates DNS and DHCP so that each is aware of changes in the other (for instance, DNS knowing of the IP address taken by a client via DHCP and updating itself accordingly).

Yet another DNS variant is Extension Mechanisms for DNS (EDNS). The original specification for DNS had size limitations that prevented the addition of certain features, such as security. EDNS supports these additional features while maintaining backward compatibility with the original DNS implementation. Rather than using new flags in the DNS header, which would negate backward compatibility, EDNS sends optional pseudo-resource records between devices supporting EDNS. These records can use 16 new DNS flags. If a legacy DNS server were to receive one of these optional records, the record would simply be ignored. Therefore, backward compatibility is maintained, while new features can be added for newer DNS servers.

When you enter a web address into your browser in the form https://*FQDN* (for example, [https://www.ajsnetworking.com](https://www.ajsnetworking.com/)), notice that you not only indicate the FQDN of your web address but also specify that you want to access that location by using the HTTPS protocol. Such a string, which indicates both an address (for example, [www.ajsnetworking.com](http://www.ajsnetworking.com/)) and a method for accessing that address (for example, https://), is called a *uniform resource locator* (*URL*).

Here are some other DNS concepts that you should be familiar with:

- **Zone transfers:** Because DNS servers will always need to be available (to make the Internet function), it is a common approach to use primary and secondary backup name servers. In order to keep the primary and secondary servers in sync with each other and updated with the same information, DNS zone transfers can be performed. There are multiple types of zone transfers, including full zone transfers and incremental zone transfers.
- **DNS time to live (TTL):** Do not confuse DNS TTL with the TTL that is in an IP packet header. Whereas the TTL in an IP packet header is a loop-prevention mechanism to ensure that a packet does not circulate endlessly on an IP network, the DNS TTL specifies the number of seconds a DNS server (or client) caches name resolution entries without having to perform a search of the DNS database. As you might guess, there is a lot of *DNS caching* going on in the *global DNS system* (both on servers and on clients). This is why name resolution for popular destinations like [google.com](http://google.com/) appears to happen instantaneously.

Note

The caching of DNS resolution information is another reason changes in the global DNS system can take hours, or even days, to be fully propagated. All the cached information must age out (that is, the TTL must expire), and new information must be requested.

- [***Primary zone***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_522): A primary zone is the main authoritative database for a specific domain, where all the original and authoritative DNS records for that domain are stored. It is hosted on the primary DNS server, which has read-write access to the zone file, allowing it to create, modify, and delete DNS records. Any changes to the DNS information must be made on this server, and it serves as the source of truth for the domain’s DNS data. Secondary DNS servers can be set up to hold copies of the primary zone, but these are read-only and rely on the primary server for updates.
- [***Secondary zone***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_592): A secondary zone is a read-only copy of the primary zone, used to provide redundancy and load balancing for DNS queries. It is hosted on secondary DNS servers, which periodically receive updates from the primary DNS server through a process called *zone transfer*. The secondary zone contains all the same DNS records as the primary zone, ensuring that if the primary server becomes unavailable, the secondary server can still respond to DNS queries. However, since it is a read-only copy, any changes to DNS records must be made on the primary server and then propagated to the secondary zone.
- [***Forward lookup zone***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_277): You might not have realized this, but when you have a DNS server resolve a name (such as [ajsnetworking.com](http://ajsnetworking.com/)) into an IP address, you are having the DNS server perform a *forward lookup*. A forward lookup zone in DNS is the database that maps domain names to their corresponding IP addresses. This zone is essential for directing Internet traffic to the correct servers based on domain names.
- [***Reverse lookup zone***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_555): DNS servers are also able to perform *reverse lookups*. As you might guess, this is when the client has the IP address of the resource and needs the resolution to work in reverse: the client is looking for the name that goes with the IP address. The reverse lookup zone is that database that makes these reverse lookups possible.
- [***Recursive lookup***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_544): In this type of DNS query, the client instructs the DNS server to respond with an answer (if possible), and the client does not want to be referred to another DNS server. Contrast this with the iterative (or nonrecursive) query type covered next.
- **Iterative lookup:** In this type of DNS query, the client indicates that it would like the answer from the DNS server, or it will take a referral to another DNS server that might have the answer.
- [***Domain Name Security Extensions (DNSSEC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_230): Domain Name Security Extensions is a set of security measures added to DNS to protect it from attacks. DNSSEC works by digitally signing data to ensure that the responses to DNS queries are authentic and haven’t been tampered with, helping to prevent attackers from redirecting users to malicious websites. This makes the Internet more secure by ensuring that when you type a web address into your browser, you are directed to the correct and intended website.
- [***DNS over HTTPS (DoH)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_223): DNS over HTTPS is a security protocol that encrypts DNS queries by sending them over HTTPS, the same protocol used to secure websites. This ensures that your Internet service provider and other potential eavesdroppers cannot see the websites you are trying to visit, enhancing your privacy and security online. By using DoH, your DNS requests are protected from interception and manipulation, making your Internet browsing more secure and private.
- [***DNS over TLS (DoT)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_224): DNS over TLS is a similar protocol to DoH. It differs slightly in its encryption and delivery of packets, but its job is the same: protect DNS queries as they are transmitted on the Internet.

#### Hosts File

A ***hosts file*** is a plain text file used by operating systems to map hostnames to IP addresses. This file helps your computer find and connect to other devices on a network without needing to query a DNS server.

The hosts file is usually located in a specific directory on your computer. On Windows, you can find it at C:\Windows\System32\drivers\etc\hosts, while on macOS and Linux, it’s located at /etc/hosts. You can open and edit this file with any text editor, like Notepad on Windows or TextEdit on macOS.

Each line in the hosts file represents a mapping between an IP address and a hostname. For example, a line might read “127.0.0.1 localhost,” which tells your computer that the hostname localhost corresponds to the IP address 127.0.0.1. You can add your own entries to this file to create custom mappings for your network.

Using the hosts file can be helpful for testing new websites or services before they go live. By adding an entry to the hosts file, you can make your computer resolve a hostname to a specific IP address, bypassing the DNS server. This allows you to see how a website will look and function without changing the actual DNS records.

### Time Protocols

The correct time shared throughout network devices is an important part of networking. Why is this so important? Correct time is crucial for network devices because it ensures the proper synchronization of logs, security certificates, and scheduled tasks across the network. Accurate timekeeping is essential for troubleshooting, as logs from different devices need to be aligned to trace issues accurately. It is also vital for security, as time-sensitive protocols like Kerberos require synchronized clocks to prevent authentication failures. Furthermore, incorrect time can lead to issues with data integrity, as time stamps are used to validate the order of events, updates, and transactions. Without synchronized time, network operations can become unreliable, leading to potential vulnerabilities and operational inefficiencies. This section ensures you are knowledgeable about several different [***time protocols***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_700).

#### NTP

[***Network Time Protocol (NTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_450) is the final critical service we examine in this chapter. This protocol might be easy for you to overlook—or at least not think of as being very important. After all, who cares if the time is a bit off on your network devices?

For many reasons, it is actually very important that network devices possess times that are as accurate as possible. Perhaps the biggest reason is the fact that devices can then stamp Syslog and other messages with the accurate time. This can often be critical for helping you catch and prevent security attacks against your network or for helping you troubleshoot faults that are occurring as a result of failed components or configurations.

Another reason you typically need accurate time is that many services cannot properly integrate with other network services if the time is not within a certain threshold between the devices.

The configuration of NTP involves three main components:

![](../images/key_topic_icon_158.jpg)

- **Client:** Your network device is typically the NTP client and is consuming the correct time from an NTP server system.
- **Server:** The server is the network node that provides the correct time to NTP clients. The most common servers these days are located regionally on the Internet.
- **Stratum:** The stratum is an important value in NTP operations. It is like a hop count and measures how far the client is from the accurate time source. The larger the stratum value, the more chance the time on the client could be inaccurate because it is more hops away from the accurate time source.

NTP does not require connection-oriented transport. As a result, NTP relies on UDP at the transport layer. Specifically, NTP uses UDP port 123.

#### PTP

[***Precision Time Protocol (PTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_517) is another protocol used to synchronize clocks across a computer network with very high accuracy. It is particularly useful in situations where precise timing is critical, such as in financial transactions, telecommunications, and industrial automation.

PTP works by exchanging timing messages between a primary clock and one or more member clocks within the network. The primary clock serves as the reference time source, and the member clocks adjust their time based on the messages received from the primary. This communication helps ensure that all devices in the network are synchronized to the same time.

The synchronization process involves several steps to account for network delays and other factors that can affect timing accuracy. PTP measures the time it takes for messages to travel between the primary and member clocks, and uses this information to correct any discrepancies. This allows PTP to achieve synchronization accuracy within nanoseconds, much higher than other protocols like NTP.

One of the key features of PTP is its ability to work in various network configurations, including Ethernet and Wi-Fi. It can also be used in both small and large networks, making it a versatile solution for different applications. Additionally, PTP supports different clock hierarchies, where multiple layers of primary and member clocks can be used to improve synchronization across complex networks.

#### NTS

[***Network Time Security (NTS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_452) is a protocol designed to secure time synchronization over a network, specifically enhancing the security of Network Time Protocol. As you learned earlier in this section, NTP is used to synchronize the clocks of computers and devices to a precise time source, but it has vulnerabilities that can be exploited by attackers to disrupt or manipulate timekeeping.

NTS works by adding security features to NTP to protect against these threats. It uses cryptographic techniques to ensure that the time information exchanged between devices is authentic and has not been tampered with. This helps to prevent attacks such as spoofing, where an attacker could send false time information to devices, and replay attacks, where old messages are resent to disrupt the synchronization process.

When a device using NTS requests time from an NTP server, it first establishes a secure connection using Transport Layer Security (TLS), the same technology that secures websites. This secure connection is used to exchange keys and other information needed to authenticate future time requests. Once this initial setup is complete, the device and the server can communicate securely, with each time message being authenticated to ensure its integrity.

The adoption of NTS is important for critical systems that rely on precise and accurate timekeeping, such as financial systems, telecommunications, and industrial control systems. By securing the time synchronization process, NTS helps to ensure that these systems operate reliably and are protected against malicious attacks that could cause disruptions or inaccuracies.

### Real-World Case Study

Acme, Inc. has been busy improving the DHCP implementation in the main end-user locations of the network. These improvements have involved increasing the availability of centralized DHCP server nodes. This increase in the availability has been made possible by the use of DHCP relay agents. These strategically placed network nodes ensure DHCP broadcasts from client systems can be routed effectively to the DHCP servers of Acme, Inc.

The DHCP enhancements also include the setting and configuration of key network parameters through the DHCP information disseminated using the scope options feature.

Acme, Inc. has also improved the dissemination of accurate time by configuring all network nodes with fallback NTP servers to use should the main, Internet-based NTP server fail.

Finally, Acme, Inc. has recently implemented Network Time Security to enhance the accuracy and reliability of its time-sensitive network operations. By deploying NTS, Acme, Inc. ensures that all its network devices, from servers to routers, are synchronized with a highly secure and accurate time source. This implementation helps protect against potential time spoofing attacks, where malicious actors could otherwise disrupt network operations by altering time synchronization.

### Summary

Here are the main topics covered in this chapter:

- This chapter covered DHCP in detail, including important components of DHCP such as reservations, scopes, lease times, and many more topics.
- This chapter also covered name resolution systems. DNS is critical for a network system, especially one that is connected to the Internet and requires access to remote resources. Resolving “friendly” names against an IP address is a fundamental necessity of the modern network.
- This chapter concluded with a look at time protocols. Ensuring network nodes all agree on the correct time is another fundamental necessity in the typical network. Network Time Protocol, Precision Time Protocol, and Network Time Security were all covered.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 16-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16tab03) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 16-3** Key Topics for [Chapter 16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| Step list | Four-step DHCP process | 386 |
| [Figure 16-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16fig01) | DHCP Components | 390 |
| [Figure 16-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16fig03) | DNS Server | 391 |
| [Figure 16-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16fig04) | Hierarchical Domain Name Structure | 392 |
| [Table 16-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16tab02) | Common DNS Record Types | 393 |
| List | NTP components | 398 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix B](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb),” or at least the section for this chapter, and complete as many of the tables as possible from memory. [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[AAAA](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_01)

[address (A)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_02)

[authoritative name server](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_03)

[canonical name (CNAME)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_04)

[DHCP relay](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_05)

[DHCP reservation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_06)

[DNS over HTTPS (DoH)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_07)

[DNS over TLS (DoT)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_08)

[DNS record types](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_09)

[Domain Name Security Extensions (DNSSEC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_010)

[Domain Name System (DNS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_011)

[Dynamic Host Configuration Protocol (DHCP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_012)

[exclusion range](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_013)

[forward lookup zone](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_014)

[IP helper](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_015)

[lease time](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_016)

[mail exchange (MX)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_017)

[name resolution](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_018)

[name server (NS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_019)

[Network Time Protocol (NTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_020)

[Network Time Security (NTS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_021)

[non-authoritative name server](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_022)

[pointer (PTR)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_023)

[Precision Time Protocol (PTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_024)

[primary zone](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_025)

[recursive lookup](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_026)

[reverse lookup zone](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_027)

[scope](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_028)

[scope options](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_029)

[secondary zone](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_030)

[stateless address autoconfiguration (SLAAC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_031)

[text (TXT)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_032)

[time protocols](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#key_033)

### Additional Resources

**What Is DHCP?:** <https://www.spiceworks.com/tech/networking/articles/what-is-dhcp/>

**NTP – As Easy as 1, 2, 3:** <https://youtu.be/LtMWTmQqRfA>

### Review Questions

The answers to these review questions are in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_1) What is the name of the DHCP message that a client sends when it needs to obtain IP address information? This message is the first step in the four-step DHCP process.

1. DHCPOFFER
2. DHCPREQUEST
3. DHCPDISCOVER
4. DHCPACK

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_2) Where might you set the lease duration for a DHCP server that is servicing many clients in the network?

1. The zone record
2. Scope options
3. The DHCP forwarder
4. The relay agent

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_3) What type of DNS message is often used to perform reverse lookups?

1. PTR
2. SRV
3. TXT
4. MX

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_4) What value in DNS dictates how long a DNS server or client might cache DNS name resolution information?

1. Hop count
2. Increment duration
3. Backoff timer
4. TTL

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_5) What port and protocol are used by NTP? (Choose two.)

1. TCP
2. UDP
3. 69
4. 443
5. 123

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_6) Which component of NTP is a measure of how far the NTP client is from the server?

1. Administrative distance
2. Stratum
3. MED
4. Metric

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_7) Which is a range of IP addresses and configuration parameters that a DHCP server is responsible for assigning to client devices on a network?

1. Reservation
2. Least time
3. Exclusions
4. Scope

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_8) Which is a feature of IPv6 networks that allows devices to connect to the Internet without requiring any intermediate IP support from a DHCP server?

1. IPAM
2. SLAAC
3. Root DNS servers
4. Authoritative name server

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_9) Which DNS record maps a hostname to an IPv6 address?

1. A
2. AAAA
3. MX
4. PTR

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz16_10) Which is a protocol that encrypts DNS queries and responses using the HTTPS protocol?

1. DoH
2. DoT
3. DNSSEC
4. DNS TTL