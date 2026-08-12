## Chapter 9

## Routing Technologies

This chapter covers the following topics related to Objective 2.1 (Explain characteristics of routing technologies) of the CompTIA Network+ N10-009 certification exam:

- Static routing
- Dynamic routing

  - Border Gateway Protocol (BGP)
  - Enhanced Interior Gateway Routing Protocol (EIGRP)
  - Open Shortest Path First (OSPF)
- Route selection

  - Administrative distance
  - Prefix length
  - [Metric](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09lev2sec5)
- [Address translation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09lev1sec6)

  - [NAT](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09lev2sec10)
  - Port address translation (PAT)
- [First Hop Redundancy Protocol (FHRP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09lev1sec7)
- Virtual IP (VIP)
- Subinterfaces

In [Chapter 7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07), “[IPv4 Addressing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07),” you learned how Internet Protocol (IP) networks can be divided into subnets. Each subnet is its own broadcast domain, and the device that separates broadcast domains is a router (which this text considers synonymous with a multilayer switch). A multilayer switch is a network device that can perform the Layer 2 switching of frames as well as the Layer 3 routing of IP packets. Multilayer switches generally use dedicated chips to perform these functions and, as a result, may be faster than traditional routers in forwarding packets.

For traffic to flow between subnets, the traffic has to be routed; this routing is a router’s primary job. This chapter discusses how routing occurs and introduces a variety of approaches for performing routing, including dynamic routing, static routing, and default routing. The chapter also breaks down the various categories of routing protocols and provides specific examples of each.

The chapter concludes with a discussion of address translation and first hop redundancy protocols.

### Foundation Topics

### Routing

To understand basic routing processes, consider [Figure 9-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig01). In this topology, PC1 needs to send traffic to Server1. Notice that these devices are on different networks. In this topology, how does a packet from the source IP address 192.168.1.2 get routed to the destination IP address 192.168.3.2?

![](../images/09fig01.jpg)


**Figure 9-1** Basic Routing Topology

It might help to walk through this process systematically:

![](../images/key_topic_icon_158.jpg)

**Step 1.** PC1 compares its IP address and subnet mask 192.168.1.2/24 with the destination IP address and subnet mask 192.168.3.2/24. PC1 concludes that the destination IP address resides on a remote subnet. Therefore, PC1 needs to send the packet to its default gateway, which could have been manually configured on PC1 or dynamically learned via Dynamic Host Configuration Protocol (DHCP). In this example, PC1 has the default gateway 192.168.1.1 (router R1). However, to construct a Layer 2 frame, PC1 also needs the MAC address of its default gateway. PC1 sends an Address Resolution Protocol (ARP) request for router R1’s MAC address. After PC1 receives an ARP reply from router R1, PC1 adds router R1’s MAC address to its ARP cache. PC1 now sends its data in a frame destined for Server1, as shown in [Figure 9-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig02).

Note

ARP is a broadcast-based protocol and, therefore, does not travel beyond the local subnet of the sender.

![](../images/09fig02.jpg)


**Figure 9-2** Basic Routing: Step 1

**Step 2.** Router R1 receives the frame sent from PC1 and interrogates the IP header. An IP header contains a Time-to-Live (TTL) field, which is decremented once for each router hop. Therefore, router R1 decrements the packet’s TTL field. If the value in the TTL field is reduced to 0, the router discards the frame and sends a “time exceeded” Internet Control Message Protocol (ICMP) message back to the source. As long as the TTL has not been decremented to 0, router R1 checks its routing table to determine the best path to reach network 192.168.3.0/24. In this example, router R1’s routing table has an entry stating that network 192.168.3.0/24 is accessible via interface Serial 1/1. Note that ARP is not required for serial interfaces because these interface types do not have MAC addresses. Router R1, therefore, forwards the frame out its Serial 1/1 interface, as shown in [Figure 9-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig03).

![](../images/09fig03.jpg)


**Figure 9-3** Basic Routing: Step 2

**Step 3.** When router R2 receives the frame, it decrements the TTL in the IP header, just as router R1 did. Again, as long as the TTL has not been decremented to 0, router R2 interrogates the IP header to determine the destination network. In this case, the destination network 192.168.3.0/24 is directly attached to router R2’s Fast Ethernet 0/0 interface. Similar to the way PC1 sent out an ARP request to determine the MAC address of its default gateway, router R2 sends an ARP request to determine the MAC address of Server1. After an ARP reply is received from Server1, router R2 forwards the frame out its Fast Ethernet 0/0 interface to Server1, as illustrated in [Figure 9-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig04).

![](../images/09fig04.jpg)


**Figure 9-4** Basic Routing: Step 3

The previous steps identified two router data structures:

- **IP routing table:** When a router needed to route an IP packet, it consulted its IP routing table to find the best match. The best match is the route that has the longest prefix (referred to as [***prefix length***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_518)). Specifically, a route entry with the longest prefix is the most specific network. For example, imagine that a router has an entry for network 10.0.0.0/8 and for network 10.1.1.0/24. Also, imagine that the router is seeking the best match for destination address 10.1.1.1/24. The router would select the 10.1.1.0/24 route entry as the best entry because that route entry has the longest prefix (/24 is longer than /8, which is a more specific entry).
- **Layer 3 to Layer 2 mapping:** In the previous example, router R2’s ARP cache contained Layer 3 to Layer 2 mapping information. Specifically, the ARP cache had a mapping that said MAC address 2222.2222.2222 corresponded to IP address 192.168.3.2.

As shown in the preceding example, routers rely on their internal routing table to make packet-forwarding decisions. So how does a router’s routing table become populated with entries? That is the focus of the next section.

### Sources of Routing Information

A router’s routing table can be populated from various sources. As an administrator, you could statically configure a route entry. We refer to this process as [***static routing***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_658). A route could be learned via a [***dynamic routing***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_241) protocol (for example, OSPF or EIGRP), or a router could know how to get to a specific network because the router is physically attached to that network. Dynamic routing protocols are covered later in this chapter.

#### Directly Connected Routes

A router that has an interface directly participating in a network knows how to reach that specific destination network. For example, consider [Figure 9-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig05).

In [Figure 9-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig05), router R1’s routing table knows how to reach the 192.168.1.0/24 and 192.168.2.0/30 networks because router R1 has an interface physically attached to each network. Similarly, router R2 has interfaces participating in the 10.1.1.0/30 and 192.168.2.0/30 networks and therefore knows how to reach those networks. The entries currently shown to be in the routing tables of routers R1 and R2 are called *directly connected routes*.

![](../images/09fig05.jpg)


**Figure 9-5** Directly Connected Routes

#### Static Routes

It is also possible to statically configure routes in a router’s routing table. Continuing to expand on the previous example, consider router R1. As shown in [Figure 9-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig06), router R1 does not need knowledge of each route on the Internet. Specifically, router R1 already knows how to reach devices on its locally attached networks. All router R1 really needs to know at this point is how to get out to the rest of the world. As you can see from [Figure 9-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig06), any traffic destined for a nonlocal network (for example, any of the networks available on the public Internet) can simply be sent to router R2. Because R2 is the next router hop along the path to reach all those other networks, router R1 could be configured with a *default static route*, which says, “If traffic is destined for a network not currently in the routing table, send that traffic out interface Serial 1/1.”

![](../images/09fig06.jpg)


**Figure 9-6** Static Routes


Note

A static route does not always reference a local interface. Instead, a static route might point to a *next-hop IP address* (that is, an interface’s IP address on the next router to which traffic should be forwarded). The network address of a default route is 0.0.0.0/0.

Similarly, router R2 can reach the Internet by sending traffic out its Serial 1/0 interface. However, router R2 does need information about how to reach the 192.168.1.0/24 network available off router R1. To educate router R2 about how this network can be reached, a network administrator can add a static route pointing to 192.168.1.0/24 to router R2’s routing table.

#### Dynamic Routing Protocols

In complex networks, such as the topology shown in [Figure 9-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig07), static routing does not scale well. Fortunately, a variety of dynamic routing protocols are available that allow a router’s routing table to be updated as network conditions change.

![](../images/09fig07.jpg)


**Figure 9-7** Dynamic Routes

In [Figure 9-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig07), router R2 is advertising a default route to its neighbors (routers R1, R3, and R4). What happens if PC1 wants to send traffic to the Internet? PC1’s default gateway is router R3, and router R3 has received three default routes. Which one does it use?

Router R3’s path selection depends on the dynamic routing protocol being used. As you will see later in this chapter, a routing protocol such as Routing Information Protocol (RIP) would make the path selection based on the number of routers that must be used to reach the Internet (that is, *hop count*). Based on the topology presented, router R3 would select the 128Kbps link (where Kbps stands for kilobits per second, meaning thousands of bits per second) connecting to router R2 because the Internet would be only one hop away. If router R3 instead selected a path pointing to either router R1 or R4, the Internet would be two hops away.

However, based on the link bandwidths, you can see that the path from router R3 to router R2 is suboptimal. Unfortunately, RIP does not consider available bandwidth when making its route selection. Some other protocols, such as Open Shortest Path First (OSPF), can consider available bandwidth when making their routing decisions.

Dynamic routes also allow a router to reroute around a failed link. For example, in [Figure 9-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig08), router R3 prefers to reach the Internet via router R4. However, the link between routers R3 and R4 goes down. Thanks to a dynamic routing protocol, router R3 knows of two other paths to reach the Internet, and it selects the next-best path, which is via router R1 in this example. This process of failing over from one route to a backup route is called *convergence*.

![](../images/09fig08.jpg)


**Figure 9-8** Route Redundancy

### Routing Protocol Characteristics

Before examining the characteristics of routing protocols, we need to look at the important distinction between a *routing protocol* and a *routed protocol*:

- A *routing protocol* (for example, OSPF, BGP, or EIGRP) is a protocol that advertises route information between routers.
- A *routed protocol* is a protocol with an addressing scheme (for example, IP) that defines different network addresses. Traffic can then be routed between defined networks, perhaps with the assistance of a routing protocol.

This section looks at routing protocol characteristics, such as how believable a routing protocol is compared to other routing protocols. In addition, in the presence of multiple routes, different routing protocols use different [***metrics***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_410) to determine the best path. A distinction is made between *interior gateway protocols (IGPs)* and *exterior gateway protocols (EGPs)*. Finally, this section discusses different approaches to making route advertisements.

#### Believability of a Route

If a network is running more than one routing protocol (maybe as a result of a corporate merger), and a router receives two route advertisements from different routing protocols for the same network, which route advertisement does the router believe? Interestingly, some routing protocols are considered to be more believable that others. For example, a Cisco router would consider EIGRP to be more believable than RIP.

The index of believability is called [***administrative distance (AD)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_044). [Table 9-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09tab01) shows the AD values for various sources of routing information. Note that lower AD values are more believable than higher AD values.

![](../images/key_topic_icon_158.jpg)


**Table 9-1** Administrative Distance

| Routing Information Source | AD Value |
| --- | --- |
| Directly connected network | 0 |
| Statically configured network | 1 |
| EIGRP | 90 |
| OSPF | 110 |
| RIP | 120 |
| External EIGRP | 170 |
| Unknown or unbelievable | 255 (considered to be unreachable) |

#### Metrics

Some networks might be reachable via more than one path. If a routing protocol knows of multiple paths to reach such a network, which route (or routes) does the routing protocol select? Actually, it varies depending on the routing protocol and what that routing protocol uses as a metric (that is, a value assigned to a route). Lower metrics are preferred over higher metrics.

Some routing protocols support load balancing across equal-cost paths; this is useful when a routing protocol knows of more than one route to reach a destination network and those routes have equal metrics. EIGRP can even be configured to do load balancing across unequal-cost paths.

Different routing protocols can use different parameters in their calculation of a metric. The specific parameters used for a variety of routing protocols are presented later in this chapter.

Note

Remember, routers will use three main criteria when performing [***route selection***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_575). They will use the longest matching prefix length, the lowest administrative distance value, and the most preferred metric.

#### Interior Versus Exterior Gateway Protocols

Routing protocols can also be categorized based on the scope of their operation. Interior gateway protocols (IGPs) operate within an autonomous system, where an autonomous system is a network under a single administrative control. Conversely, exterior gateway protocols (EGPs) operate between autonomous systems.

Consider [Figure 9-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig09). Routers R1 and R2 are in one autonomous system (AS 65002), and routers R3 and R4 are in another autonomous system (AS 65003). Within those autonomous systems, an IGP is used to exchange routing information. However, router ISP1 is a router in a separate autonomous system (AS 65001) that is run by a service provider. An EGP (typically, Border Gateway Protocol) is used to exchange routing information between the service provider’s autonomous system and each of the other autonomous systems.

![](../images/09fig09.jpg)


**[Figure 9-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig09)** IGPs Versus EGPs

#### Route Advertisement Method

Another characteristic of a routing protocol is how it receives, advertises, and stores routing information. The two fundamental approaches are *distance vector* and *link state*.

![](../images/key_topic_icon_158.jpg)

#### Distance Vector

A *distance-vector routing protocol* sends a full copy of its routing table to its directly attached neighbors. This is a periodic advertisement, meaning that even if there have been no topological changes, a distance-vector routing protocol will, at regular intervals, advertise again its full routing table to its neighbors.

Obviously, this periodic advertisement of redundant information is inefficient. Ideally, you want a full exchange of route information to occur only once and subsequent updates to be triggered by topological changes.

Another drawback to distance-vector routing protocols is the time they take to converge, which is the time required for all routers to update their routing tables in response to a topological change in a network. *Hold-down timers* can speed the convergence process. After a router makes a change to a route entry, a hold-down timer prevents any subsequent updates for a specified period of time. This approach helps stop flapping routes (which are routes that oscillate between being available and unavailable) from preventing convergence.

Yet another issue with distance-vector routing protocols is the potential of a routing loop. To illustrate, consider [Figure 9-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig10). In this topology, the metric being used is *hop count*, which is the number of routers that must be crossed to reach a network. As one example, router R3’s routing table has a route entry for network 10.1.1.0/24 available off router R1. For router R3 to reach that network, two routers must be transited (routers R2 and R1). As a result, network 10.1.1.0/24 appears in router R3’s routing table with a metric (hop count) of 2.

![](../images/09fig10.jpg)


**Figure 9-10** Routing Loop: Before Link Failure

Continuing with the example, imagine that interface Ethernet 1/0 on router R3 goes down. As shown in [Figure 9-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig11), router R3 loses its directly connected route (with a metric of 0) to network 10.1.4.0/24. However, router R2 had a route to 10.1.4.0/24 in its routing table (with a metric of 1), and this route was advertised to router R3. Router R3 adds this entry for 10.1.4.0 to its routing table and increments the metric by 1.

![](../images/09fig11.jpg)


**Figure 9-11** Routing Loop: After Link Failure

The problem with this scenario is that the 10.1.4.0/24 entry in router R2’s routing table was due to an advertisement router R2 received from router R3. Now, router R3 is relying on that route, which is no longer valid. The routing loop continues as router R3 advertises its newly learned route 10.1.4.0/24 with a metric of 2 to its neighbor, router R2. Because router R2 originally learned the 10.1.4.0/24 network from router R3, when it sees router R2 advertising that same route with a metric of 2, the network gets updated in router R2’s routing table to have a metric of 3, as shown in [Figure 9-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig12).

![](../images/09fig12.jpg)


**Figure 9-12** Routing Loop: Routers R2 and R3 Incrementing the Metric for 10.1.4.0/24

The metric for the 10.1.4.0/24 network continues to increment in the routing tables for both routers R2 and R3 until the metric reaches a value considered to be an unreachable value. This process is referred to as a *routing loop*.

Distance-vector routing protocols typically use one of two approaches for preventing routing loops:

![](../images/key_topic_icon_158.jpg)

- **Split horizon:** The split-horizon feature prevents a route learned on one interface from being advertised back out that same interface.
- **Poison reverse:** The poison-reverse feature causes a route received on one interface to be advertised back out that same interface with a metric that is considered to be infinite.

In the previous example, either approach would have prevented router R3 from adding the 10.1.4.0/24 network to its routing table based on an advertisement from router R2.

#### Link State

Rather than having neighboring routers exchange their full routing tables with one another, a *link-state* routing protocol allows routers to build a topological map of the network. Then, much like a Global Positioning System (GPS) device in a car, a router can execute an algorithm to calculate an optimal path (or paths) to a destination network.

Routers send *link-state advertisements (LSAs)* to advertise the networks they know how to reach. Routers then use those LSAs to construct the topological map of a network. The algorithm that runs against this topological map is *Dijkstra’s shortest path first* algorithm.

Unlike distance-vector routing protocols, *link-state routing protocols* exchange full routing information only when two routers initially form their adjacency. Then routing updates are sent in response to changes in the network, as opposed to being sent periodically. Also, link-state routing protocols benefit from shorter convergence times compared to distance-vector routing protocols.

### Routing Protocol Examples

Now that you understand some of the characteristics that distinguish one routing protocol from another, this section contrasts some of the most popular routing protocols used in modern networks:

![](../images/key_topic_icon_158.jpg)

- [***Open Shortest Path First (OSPF)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_468)**:** OSPF is a link-state routing protocol that uses the metric *cost*, which is based on the link speed between two routers. OSPF is a popular IGP because of its scalability, fast convergence, and vendor interoperability.
- **Intermediate System-to-Intermediate System (IS-IS):** This link-state routing protocol is similar in operation to OSPF. It uses a configurable, yet dimensionless, metric associated with an interface and runs Dijkstra’s shortest path first algorithm. Although IS-IS is an IGP that offers the scalability, fast convergence, and vendor-interoperability benefits of OSPF, it has not been as widely deployed as OSPF.
- [***Enhanced Interior Gateway Routing Protocol (EIGRP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_251): EIGRP is a Cisco-proprietary protocol that is popular in Cisco-only networks but less popular in mixed-vendor environments. Like OSPF, EIGRP is an IGP that offers fast convergence and scalability. EIGRP is more challenging to classify as a distance-vector or a link-state routing protocol.

By default, EIGRP uses bandwidth and delay in its metric calculation; however, other parameters can be considered, including reliability, load, and maximum transmission unit (MTU) size. Using delay as part of the metric, EIGRP can take into consideration the latency caused by the slowest links in the path.

Some literature calls EIGRP an *advanced distance-vector* routing protocol, and some literature calls it a *hybrid routing protocol* (mixing characteristics of both distance-vector and link-state routing protocols). EIGRP uses information from its neighbors to help select an optimal route (like distance-vector routing protocols). However, EIGRP also maintains a database of topological information (like a link-state routing protocol). The algorithm EIGRP uses for its route selection is not Dijkstra’s shortest path first algorithm. Instead, EIGRP uses Diffusing Update Algorithm (DUAL).

- [***Border Gateway Protocol (BGP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_095): BGP is the only EGP in widespread use today. In fact, BGP is considered to be the routing protocol that runs the Internet, which is an interconnection of multiple autonomous systems. Although some literature classifies BGP as a distance-vector routing protocol, it can more accurately be described as a *path-vector* routing protocol, meaning that it can use as its metric the number of autonomous system hops that must be transited to reach a destination network, as opposed to a number of required router hops. BGP’s path selection is not solely based on autonomous system hops, however. BGP can consider a variety of other parameters. Interestingly, none of those parameters are based on link speed. In addition, although BGP is incredibly scalable, it does not quickly converge in the event of a topological change.

Note

When studying for the CompTIA Network+ exam, be sure to focus on OSPF, EIGRP, and BGP, as these are the dynamic routing protocols that the exam is sure to cover. Also be sure to understand the differences between static and dynamic routing.

[Table 9-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09tab02) compares the key characteristics of dynamic routing protocols.

![](../images/key_topic_icon_158.jpg)


**Table 9-2** Comparing Dynamic Routing Protocols

| Routing Protocol | IGP or EGP | Type | Metric |
| --- | --- | --- | --- |
| OSPF | IGP | Link state | Cost (based on bandwidth) |
| EIGRP | IGP | Hybrid | Composite (bandwidth and delay by default) |
| BGP | EGP | Path vector | Path attributes |

A network can simultaneously support more than one routing protocol through the process of *route redistribution*. For example, a router could have one of its interfaces participating in an OSPF area of the network and have another interface participating in an EIGRP area of the network. This router could then take routes learned via OSPF and inject those routes into the EIGRP routing process. Similarly, EIGRP-learned routes could be redistributed into the OSPF routing process.

### Address Translation

You must remember, some IP addresses are routable through the public Internet, and other IP addresses are considered private and are intended for use within an organization. [***Network address translation (NAT)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_437) allows *private IP addresses* (as defined in *RFC1918*) to be translated into Internet-routable IP addresses (that is, public IP addresses). This section examines the operation of basic NAT and a variant called [***port address translation (PAT)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_506). Address translation can also be done for specific ports associated with an IP address. When this is done, it’s often referred to as *port forwarding*.

Note

If RFC1918 is not the most famous document in our field, it is certainly in the top five. RFC1918 was so important and had such a major impact on TCP/IP networks that we often refer to private IP addresses as simply RFC1918 addresses.

#### NAT

Consider [Figure 9-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig13), which shows a basic NAT topology. Note that, even though the IP networks 172.16.1.0/24 and 192.168.1.0/24 are actually private IP networks, for this discussion, assume that they are publicly routable IP addresses. The reason for the use of these private IP addresses to represent public IP addresses is to avoid using an entity’s registered IP addresses in the example.

![](../images/09fig13.jpg)


**Figure 9-13** Basic NAT Topology

In the topology shown in [Figure 9-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig13), two clients with private IP addresses 10.1.1.1 and 10.1.1.2 want to communicate with a web server on the public Internet. The server’s IP address is 192.168.1.1. Router R1 is configured for NAT. As an example, router R1 takes packets coming from 10.1.1.1 destined for 192.168.1.1 and changes the source IP address in the packets’ headers to 172.16.1.101 (which we assume is a publicly routable IP address for the purposes of this discussion). When the server at IP address 192.168.1.1 receives traffic from the client, the server’s return traffic is sent to the destination address 172.16.1.101. When router R1 receives traffic from the outside network destined for 172.16.1.101, the router translates the destination IP address to 10.1.1.1 and forwards the traffic to the inside network, where client 1 receives the traffic. Similarly, client 2’s IP address 10.1.1.2 is translated into the IP address 172.16.1.102.

![](../images/key_topic_icon_158.jpg)

[Table 9-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09tab03) introduces the terminology used when describing the various IP addresses involved in a translation.

![](../images/key_topic_icon_158.jpg)


**Table 9-3** Names of NAT IP Addresses

| NAT IP Address | Definition |
| --- | --- |
| Inside local | A private IP address referencing an inside device |
| Inside global | A public IP address referencing an inside device |
| Outside local | A private IP address referencing an outside device |
| Outside global | A public IP address referencing an outside device |

As a memory aid, remember that *inside* always refers to an inside device (source), and *outside* always refers to an outside device (destination). Also, think of the word *local* being similar to the Spanish word *loco*, meaning crazy. That is how a local address could be thought of. It is a crazy, made-up address (a private IP address that is not routable on the Internet). Finally, let the *g* in *global* remind you of the *g* in *good*, because a global address is a good (routable on the Internet) IP address.

Based on these definitions, [Table 9-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09tab04) categorizes the IP addresses shown in [Figure 9-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig13).


**Table 9-4** Classifying the NAT IP Addresses in [Figure 9-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig13)

| NAT IP Address | NAT IP Address |
| --- | --- |
| Inside local | 10.1.1.1 |
| Inside local | 10.1.1.2 |
| Inside global | 172.16.1.101 |
| Inside global | 172.16.1.102 |
| Outside local | None |
| Outside global | 192.168.1.1 |

NAT does not always have to be between private and public addresses. For example, NAT could be implemented between two private address ranges or two public address ranges.

Whether an inside local address is randomly assigned an inside global address from a pool of available addresses or is assigned an address from a static configuration determines the type of NAT in use. These two approaches to NAT are called *DNAT* and *SNAT*:

![](../images/key_topic_icon_158.jpg)

- **DNAT:** In the preceding example, the inside local addresses were automatically assigned an inside global address from a pool of available public addresses. This approach to NAT is referred to as Dynamic NAT (DNAT). This is often referred to as “many-to-many,” as many inside local users (a network) are mapped to a pool of inside global addresses.
- **SNAT:** Sometimes, you want to statically configure the inside global address assigned to a specific device inside your network. For example, you might have an email server inside your company and want other email servers on the Internet to send email messages to your server. Those email servers on the Internet need to point to a specific IP address, not one that was randomly picked from a pool of available IP addresses. In such a case, you can statically configure the mapping of an inside local address (the IP address of your internal email server) to an inside global address (the IP address to which email servers on the Internet will send email for your company). This approach to NAT is referred to as Static NAT (SNAT). This is often called a “one-to-one” mapping.

#### PAT

A challenge with basic NAT is that there is a one-to-one mapping of inside local addresses to inside global addresses, meaning that a company would need as many publicly routable IP addresses as it had internal devices needing IP addresses. This does not scale well because, often, a service provider provides a customer with only a single IP address or a small block of IP addresses.

Fortunately, many routers support port address translation (PAT), which allows multiple inside local addresses to share a single inside global address (a single publicly routable IP address). For this reason, PAT is referred to as “many-to-one.” In [Chapter 1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01), you learned about how IP communications rely on port numbers. As a review, when a client sends an IP packet, not only does that packet have a source and destination IP address, it has a source and destination port number. PAT leverages these port numbers to track separate communication flows.

For instance, consider [Figure 9-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig14). Unlike in the example shown in [Figure 9-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig13), in which each inside local address is translated to its own inside global address, the example shown in [Figure 9-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig14) has only one inside global address. This single inside global address is shared among all the devices inside a network. The different communication flows are kept separate in router R1’s NAT translation table by considering port numbers.

![](../images/key_topic_icon_158.jpg)

![](../images/09fig14.jpg)


**Figure 9-14** PAT Topology

When Client 1 sends a packet to the web server (with IP address 192.168.1.1), the client’s ephemeral port number (its selected source port, which is greater than 1023) is 1025. Router R1 notes that port number and translates the inside local address 10.1.1.1 with port number 1025 to the inside global address 172.16.1.100 with port number 2025. When Client 2 sends a packet to the same web server, its inside local address 10.1.1.2 with port number 1050 is translated into the inside global address 172.16.1.100 with port number 2050.

Notice that both Client 1 and Client 2 have their inside local addresses translated into the same inside global address, 172.16.1.100. Therefore, when the web server sends packets back to Client 1 and Client 2, those packets are destined for the same IP address (172.16.1.100). However, when router R1 receives those packets, it knows to which client each packet should be forwarded based on the destination port number. For example, if a packet from the web server (192.168.1.1) arrived at router R1 with destination IP address 172.16.1.100 and destination port number 2050, router R1 would translate the destination IP address to 10.1.1.2 and port number 1050, which would be forwarded to Client 2.

### First Hop Redundancy Protocol (FHRP)

![](../images/key_topic_icon_158.jpg)

End systems not running a routing protocol point to a default gateway. The default gateway is traditionally the IP address of a router on the local subnet. However, if the default gateway router fails, the end systems are unable to leave their subnet. There are four [***First Hop Redundancy Protocol (FHRP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_273) technologies (which offer Layer 3 redundancy):

- **Hot Standby Router Protocol (HSRP):** HSRP is a Cisco-proprietary approach to first-hop redundancy. [Figure 9-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig15) shows a sample HSRP topology.

![](../images/09fig15.jpg)


**Figure 9-15** HSRP Sample Topology

In [Figure 9-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig15), Workstation A is configured with the default gateway (that is, the next-hop gateway) 172.16.1.3. To prevent the default gateway from becoming a single point of failure, HSRP enables routers R1 and R2 to each act as the default gateway, supporting the [***virtual IP (VIP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_741) of the HSRP group (172.16.1.3), although only one of the routers will act as the default gateway at any one time. Under normal conditions, router R1 (that is, the *active router*) forwards packets sent to virtual IP address 172.16.1.3. However, if router R1 is unavailable, router R2 (that is, the *standby router*) can take over and start forwarding traffic sent to 172.16.1.3. Notice that neither router R1 nor R2 has a physical interface with IP address 172.16.1.3. Instead, a logical router (called a *virtual router*), which is serviced by either router R1 or R2, maintains the 172.16.1.3 IP address.

- **Common Address Redundancy Protocol (CARP):** CARP is an open-standard variant of HSRP.
- **Virtual Router Redundancy Protocol (VRRP):** VRRP is an IETF open standard that operates in a similar method to Cisco’s proprietary HSRP. As with HSRP, with VRRP, many routers can operate in a group and ensure that there is always a router available for the hosts to use as a default gateway. Also as with HSRP, a virtual IP address is assigned to the hosts for their default gateway setting. The routers in the VRRP group can also respond (if needed) to that virtual IP address.
- **Gateway Load Balancing Protocol (GLBP):** GLBP is another first-hop redundancy protocol that is proprietary to Cisco Systems.

With each of these technologies, the MAC address and the IP address of a default gateway can be serviced by more than one router (or multilayer switch). Therefore, if a default gateway becomes unavailable, the other router (or multilayer switch) can take over and still service the same MAC and IP addresses.

Another type of Layer 3 redundancy is achieved by having multiple links between devices and selecting a routing protocol that balances the load over the links. Link Aggregation Control Protocol (LACP) enables you to assign multiple physical links to a logical interface, which appears as a single link to a route processor. [Figure 9-16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig16) illustrates a network topology using LACP.

![](../images/09fig16.jpg)


**Figure 9-16** LACP Sample Topology


Note

Do not confuse the LACP technology shown in [Figure 9-16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig16) with the concepts of network device [***subinterfaces***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_664). Subinterfaces are logical interfaces that can be created under the physical device interface. Notice that while this technique is a convenient way to make the interface more flexible (and service different subnets), if the physical interface fails, all subinterfaces are no longer available.

Finally, another important redundancy technique is to ensure that your default gateways can connect to multiple Internet service providers (ISPs) using diverse paths when redundant Internet connectivity is required. Note that such a solution protects against internal device failures as well as ISP failures that are beyond your control. Your network design can even incorporate periodic reachability tests to ensure that your ISPs are truly available and able to direct you to remote resources successfully.

### Real-World Case Study

Acme, Inc. has decided to use a link-state routing protocol for dynamic routing between its LANs and the remote offices, which are connected over the WANs. The link-state protocol the company has chosen is OSPF. Each of the routers that has connections to the LAN and WAN subnets will learn about and advertise OSPF routes with its OSPF neighbors.

Acme selected OSPF because of its features that promote scalability. Acme plans to grow its infrastructure dramatically over the coming years and wanted a routing protocol that can easily grow with the organization. The hierarchical use of area and special area types was of particular interest to the engineers within Acme, Inc.

The branch offices will have a default route that points toward the headquarters’ routers, and at the headquarters’ site, they will use a default route that points toward the service provider. Acme, Inc. itself will not be using BGP, but its WAN and Internet service provider, which is interacting with other service providers, will use BGP.

The branch offices have configured their edge routers in GLBP groups to help ensure high availability connections to the HQ routers. GLBP also provides load balancing of the many connection requests from clients in the remote offices.

### Summary

Here are the main topics covered in this chapter:

- This chapter discussed how routers forward traffic through a network based on source and destination IP addresses.
- This chapter also covered the sources of route information used to populate a router’s routing table. These sources include directly connected routes, statically configured routes, and dynamically learned routes.
- This chapter distinguished between routed protocols (for example, IP) and routing protocols (such as OSPF or EIGRP).
- Some routing sources are more trustworthy than other routing sources, based on their administrative distances. This chapter presented the commonly used administrative distance values.
- Different routing protocols use different metrics to select the best route in the presence of multiple routes. This chapter provided many examples of dynamic routing protocol metrics.
- This chapter distinguished between IGPs (which run within an autonomous system) and EGPs (which run between autonomous systems).
- This chapter contrasted the behavior of distance-vector and link-state routing protocols and showed how split horizon and poison reverse can prevent routing loops in a distance-vector routing protocol environment.
- This chapter described today’s most popular routing protocols (including OSPF, EIGRP, and BGP), along with their characteristics.
- This chapter explained NAT and PAT and the importance of these technologies for permitting communications between private and public IP addresses.
- Finally, this chapter described First Hop Redundancy Protocols and provided examples such as HSRP and VRRP.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 9-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09tab05) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 9-5** Key Topics for [Chapter 9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| Step list | Basic routing process | 230 |
| [Table 9-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09tab01) | Administrative Distance | 237 |
| [Figure 9-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig09) | IGPs Versus EGPs | 239 |
| List | Preventing routing loops | 241 |
| List | Routing protocol examples | 242 |
| [Table 9-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09tab02) | Comparing Dynamic Routing Protocols | 243 |
| [Figure 9-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig13) | Basic NAT Topology | 245 |
| [Table 9-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09tab03) | Names of NAT IP Addresses | 245 |
| List | Types of NAT | 246 |
| [Figure 9-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09fig14) | PAT Topology | 247 |
| Section | First Hop Redundancy Protocol (FHRP) | 248 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” or at least the section for this chapter and complete as many of the tables as possible from memory. [Appendix D](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appd.xhtml#appd), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appd.xhtml#appd),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[administrative distance (AD)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_01)

[Border Gateway Protocol (BGP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_02)

[dynamic routing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_03)

[Enhanced Interior Gateway Routing Protocol (EIGRP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_04)

[First Hop Redundancy Protocol (FHRP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_05)

[metric](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_06)

[network address translation (NAT)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_07)

[Open Shortest Path First (OSPF)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_08)

[port address translation (PAT)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_09)

[prefix length](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_010)

[route selection](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_011)

[static routing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_012)

[subinterfaces](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_013)

[virtual IP (VIP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#key_014)

### Additional Resources

**An OSPF Review:** <https://www.ajsnetworking.com/an-ospf-review/>

**EIGRP’s Composite Metric:** <https://www.ajsnetworking.com/eigrp-metric>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_1) If a PC on an Ethernet network attempts to communicate with a host on a different subnet, what destination IP address and destination MAC address will be placed in the packet/frame header sent by the PC?

1. Destination IP: IP address of the default gateway. Destination MAC: MAC address of the default gateway.
2. Destination IP: IP address of the remote host. Destination MAC: MAC address of the default gateway.
3. Destination IP: IP address of the remote host. Destination MAC: MAC address of the remote host.
4. Destination IP: IP address of the remote host. Destination MAC: MAC address of the local PC.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_2) What protocol is used to request a MAC address that corresponds to a known IPv4 address on the local network?

1. IGMP
2. TTL
3. ICMP
4. ARP

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_3) What is the network address and subnet mask of a default route?

1. 255.255.255.255/32
2. 0.0.0.0/32
3. 255.255.255.255/0
4. 0.0.0.0/0

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_4) What routing protocol characteristic indicates the believability of the routing protocol (compared to other routing protocols)?

1. Weight
2. Metric
3. Administrative distance
4. SPF algorithm

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_5) Which of the following are distance-vector routing protocol features that can prevent routing loops? (Choose two.)

1. Reverse path forwarding (RPF) check
2. Split horizon
3. Poison reverse
4. Rendezvous point

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_6) Which of the following is a distance-vector routing protocol with a maximum usable hop count of 15?

1. BGP
2. EIGRP
3. RIP
4. OSPF

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_7) Which of the following routing protocols is an EGP?

1. BGP
2. EIGRP
3. RIP
4. OSPF

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_8) When you are configuring PAT as part of your address translation configuration, what is the source IP address used for translation with a large potential number of inside hosts?

1. The IP address on the physical outside interface
2. The IP address on a loopback interface
3. The IP address on the physical interface with the lowest interface identifier
4. The IP address automatically assigned to the backplane on the device

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_9) What specifically does NAT allow to be translated into Internet-routable IP addresses?

1. Virtual IP addresses
2. RFC1918 private IP addresses
3. APIPA addresses
4. Variable-length subnet masks

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_10) Which of the following technologies is an example of a Cisco-proprietary FHRP?

1. VRRP
2. LACP
3. HSRP
4. CARP

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz9_11) Which of the following is a value used by routers to determine the trustworthiness or reliability of routing information received from various sources?

1. Virtual IP address (VIP)
2. Time-to-Live (TTL)
3. Metric
4. Administrative distance (AD)