## Chapter 14

## Network Monitoring

This chapter covers the following topics related to Objective 3.2 (Given a scenario, use network monitoring technologies) of the CompTIA Network+ N10-009 certification exam:

- Methods

  - [SNMP](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14lev2sec1)

    - Traps
    - Management information base (MIB)
    - Versions

      - v2c
      - v3
    - Community strings

      - Authentication
  - Flow data
  - Packet capture
  - Baseline metrics

    - Anomaly alerting/notification
  - Log aggregation

    - Syslog collector
    - Security information and event management (SIEM)
  - Application programming interface (API) integration
  - [Port mirroring](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14lev2sec3)
- Solutions

  - Network discovery

    - Ad hoc
    - Scheduled
  - Traffic analysis
  - Performance monitoring
  - Availability monitoring
  - Configuration monitoring

No one would argue with the statement that networks today are more critical than ever before for organizations. Fortunately, many tools and techniques are available to help us ensure that our networks are performing as we need them to and staying that way for as long as possible.

In this chapter you will learn about many metrics and statistics you can call upon to gauge the health of your network. These include simple metrics that indicate problems in the network as well as sophisticated logs that can be powerful sources of network operational information.

It is imperative to engage in careful and continuous network monitoring to create resources and reports that provide valuable information. For example, the primary network management protocol used by network management systems (NMSs) is Simple Network Management Protocol (SNMP), and this chapter discusses the various versions of SNMP. In addition, syslog servers and a variety of network monitoring reporting and logging solutions are considered.

### Foundation Topics

### Network Monitoring Methods

For several decades, SNMP–based software packages dominated in the enterprise monitoring space. Fortunately, SNMP evolved over several versions to include security enhancements. Even with these advancements, as you’ll learn later in this chapter, there are other methods and technologies to consider when it comes to monitoring a network. This section discusses some key performance metrics and sensors that you need to monitor.

#### SNMP

The first Request for Comments (RFC) for [***Simple Network Management Protocol (SNMP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_624) came out in 1988. Since then, SNMP has become the de facto standard for network management protocols. The original intent for SNMP was to manage network nodes, such as network servers, routers, and switches. SNMP Version 1 (SNMPv1) and [***SNMP Version 2c (SNMPv2c)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_635) specify three major components that makeup an SNMP solution, as detailed in [Table 14-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14tab01).

![](../images/key_topic_icon_158.jpg)


**Table 14-1** Components of an SNMPv1 and SNMPv2c Network Management Solution

| Component | Description |
| --- | --- |
| SNMP manager | An SNMP manager runs a network management application. This SNMP manager is sometimes referred to as a *network management system* (*NMS*). |
| SNMP agent | An SNMP agent is a piece of software that runs on a managed device (for example, a server, router, or switch). |
| [***Management information base (MIB)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_400) | Information about a managed device’s resources and activity is defined by a series of objects. The structure of these management objects is defined by a managed device’s MIB. Interfaces and their details—such as errors, utilization, discards, packet drops, resets, speed and duplex, system memory, utilization of bandwidth, storage, CPU, and memory—can be monitored and reported via SNMP. |

As illustrated in [Figure 14-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14fig01), an SNMP manager (an NMS) can send information to, receive request information from, or receive unsolicited information from a managed device (a managed router, in this example). The managed device runs an SNMP agent and contains the MIB.


![](../images/key_topic_icon_158.jpg)

![](../images/14fig01.jpg)


**Figure 14-1** SNMPv1 and SNMPv2c Network Management Components and Messages

Clearly, the MIB is a critical component in the functionality of SNMP. It is a hierarchical collection of MIB variables that stores the data that SNMP relies on. But how are these MIB variables identified? This is done using a unique *object identifier (OID)* for each variable. The OIDs are organized in a hierarchical tree-like structure. SNMP is very efficient at scanning this tree and extracting the exact OIDs and values of these variables that are needed to monitor or even reconfigure a network device.

Multiple SNMP messages might be sent between an SNMP manager and a managed device, and there are three broad categories of SNMP message types:

- **Get:** An SNMP get message retrieves information from a managed device.
- **Set:** An SNMP set message sets a variable in a managed device or triggers an action on a managed device.
- [***Trap***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_717): An SNMP trap message is an unsolicited message sent from a managed device to an SNMP manager, which can notify the SNMP manager about a significant event that occurred on the managed device.

SNMP management software can make requests for each of the MIB objects from an SNMP agent. This can be referred to as an SNMP *walk* because the management software is logically “walking” the entire MIB (also often called the *tree*) to gather information from the agent. SNMP offers security against malicious users attempting to collect information from a managed device, change the configuration of a managed device, or intercept information being sent to an NMS. However, the security integrated with SNMPv1 and SNMPv2c is considered weak. Specifically, SNMPv1 and SNMPv2c use [***community strings***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_158) to gain read-only access or read/write access to a managed device. You can think of a community string as a plaintext password. This is why there has been a big push in the networking industry as of late to move toward SNMPv3.

Also, be aware that multiple SNMP-compliant devices on the market today have the read-only community string set to *public* by default and have the read/write community string set to *private* by default. As a result, if such devices are left at their default SNMP settings, they could be compromised.

Note

Notice that this section refers to SNMPv2c as opposed to SNMPv2. SNMPv2 contained security enhancements as well as other performance enhancements. However, few network administrators adopted SNMPv2 because of the complexity of the newly proposed security system. Instead, Community-Based Simple Network Management Protocol (SNMPv2c) gained widespread acceptance because it included the performance enhancements of SNMPv2 without using SNMPv2’s complex security solution. Instead, SNMPv2c kept the SNMPv1 concept of community strings.

Fortunately, the security weaknesses of SNMPv1 and SNMPv2c are addressed in [***SNMP Version 3 (SNMPv3)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_636). To better understand these security enhancements, consider the concept of a security model and a security level:

- **Security model:** Defines an approach for user and group [***authentication***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_067) (for example, SNMPv1, SNMPv2c, and SNMPv3).
- **Security level:** Defines the type of security algorithm performed on SNMP packets. The following are the three security levels discussed here:

  - **noAuthNoPriv:** The noAuthNoPriv (no authorization, no privacy) security level uses community strings for authorization and does not use encryption to provide privacy.
  - **authNoPriv:** The authNoPriv (authorization, no privacy) security level provides authorization using Hashed Message Authentication Code (HMAC) with Message Digest 5 (MD5) or Secure Hash Algorithm (SHA). However, no encryption is used.
  - **authPriv:** The authPriv (authorization, privacy) security level offers HMAC MD5 or SHA authentication and provides privacy through encryption. Specifically, the encryption uses the Cipher Block Chaining (CBC) Data Encryption Standard (DES) (DES-56) algorithm.

Note

The security protocols originally featured in SNMPv3 are still considered strong enough for today’s networks. Since then, additions to SNMPv3 have made it even more secure. These additions enable high-security environments to call on the latest and strongest security mechanisms for key functions, such as encryption, and feature protocols such as AES.

As summarized in [Table 14-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14tab02), SNMPv3 supports all three security levels, and SNMPv1 and SNMPv2c support only the noAuthNoPriv security level.

**Table 14-2** Security Models and Security Levels

| Security Model | Security Level | Authentication Strategy | Encryption Type |
| --- | --- | --- | --- |
| SNMPv1 | noAuthNoPriv | Community string | None |
| SNMPv2c | noAuthNoPriv | Community string | None |
| SNMPv3 | noAuthNoPriv | Username | None |
| SNMPv3 | authNoPriv | MD5 or SHA | None |
| SNMPv3 | authPriv | MD5 or SHA | CBC-DES (DES-56) |

Through the use of security algorithms, as shown in [Table 14-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14tab02), SNMPv3 dramatically increases the security of network management traffic. Specifically, SNMPv3 offers three primary security enhancements over SNMPv1 and SNMPv2c:

- **Integrity:** Using hashing algorithms, SNMPv3 ensures that an SNMP message was not modified in transit.
- **Authentication:** Hashing allows SNMPv3 to validate the source of an SNMP message.
- **Encryption:** Using the CBC-DES (DES-56) encryption algorithm, SNMPv3 provides privacy for SNMP messages, making them unreadable by an attacker who might capture an SNMP packet.

In addition to its security enhancements, SNMPv3 differs architecturally from SNMPv1 and SNMPv2c. SNMPv3 defines SNMP entities, which are groupings of individual SNMP components. As shown in [Figure 14-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14fig02), SNMP applications and an SNMP manager combine into an NMS SNMP entity, whereas an SNMP agent and an MIB combine into a managed node SNMP entity.


![](../images/14fig02.jpg)


**Figure 14-2** SNMPv3 Entities

#### Performance Metrics/Sensors

As networks have become more and more important to the organizations that host them, metrics have increasingly become available to carefully monitor and assess the health of network components. In fact, you need to be careful not to overwhelm yourself by trying to monitor too many metrics for your devices.

The following are some key metrics that help you monitor a device and the device’s chassis:

- **Temperature:** Network equipment vendors make it very clear what temperature range is supported for inside the device chassis. Of course, you will not want the temperature to exceed or go too far below this recommended range. You might run into temperature problems, for example, if your network equipment was not installed following best practices and there is not adequate distance between a device and other objects. These other objects might be blocking airflow to the network device. Maybe the warm air that is supposed to be pushed out of the chassis is getting caught and trapped inside the chassis. Sensors can provide metrics regarding the temperature inside network devices to help you pinpoint such issues. Later in this chapter, you will learn about tools called *environmental monitors* that are specialized for monitoring things like temperature, humidity, and more.
- **Central processing unit (CPU) usage:** The CPU is the “brains” of a computer, often navigating the tricky waters of the control plane processing requirements for you. It is very important to monitor CPU utilization consistently over the life of a network device. Doing so can help you not only identify network attacks but also determine the busy times for network devices during which performance is suffering. In addition, monitoring the CPU can help you see when components are beginning to fail and causing high CPU utilization.
- **Memory:** To improve the performance of network devices, data is taken from nonvolatile storage and placed in (much faster) volatile memory. Of course, you need to make sure you have enough memory available for this at all times. Monitoring the various memory metrics can help you track down lots of current and potential performance issues.

As you can imagine, it is important to carefully monitor these metrics for a network device and its chassis. In addition, you should also carefully monitor the network itself. The following are some of the basic metrics for monitoring a network:

- **Bandwidth:** The “plumbing” of your network is the connections between the devices. Remember that these connections might be physical media that you can see, and they might also be wireless media that you cannot see. Carefully measuring the bandwidth available and bandwidth consumed by specific applications or traffic forms is imperative. Watch out for bottlenecks in the network design, which often occur when a network designer fails to consider the aggregate bandwidth required. For example, say that you have 100 10Gbps ports, and you need to plan for busy times when those 100 really fast ports all have lots of data they want to send. You might require multiple 40Gbps connections upstream to handle the aggregate bandwidth needs.
- **Latency:** Latency (that is, delay) is a fact of life. When a network device sends packets, there will be serialization delay, propagation delay, processing delay, and probably even more types of delay. You need to take baseline measurements (often termed [***baseline metrics***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_087)) so you can understand the latency in your network. You should also pay attention to the requirements for certain technologies. For example, perhaps your organization wants to engage with the latest Cisco collaboration solutions, including voice and video over IP. Cisco will give you documentation on just the latency that the solutions can handle. Cisco might say something like, “For this solution to perform well, you must not exceed 120 ms of delay consistently over time.” It is important to gather data on such metrics before you even consider rolling out a solution.
- **Jitter:** Jitter is what happens when you drink too much coffee, and it also refers to large variations in latency. Jitter is especially problematic for VoIP traffic. If the latency in a network is not predictable and fairly steady, it can be very difficult for VoIP quality to remain steady and satisfactory.

Note

Important concepts such as latency and jitter will appear again in [Chapter 24](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#ch24), “[Troubleshoot Common Performance Issues](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#ch24).”

For all of the major metric categories, you should ensure that you perform baselining and properly store the results for future analytics. A baseline provides a look at the metrics and their values during “normal” operation. If your network tends to run at 45% capacity, then you would want to watch for this level of usage and then start capturing your metric information to create a baseline (specifically, a baseline metric). This is incredibly important. The establishment of baselines also permits for the implementation of [***anomaly alerting***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_048) and [***notifications***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_460). When metric values leave baselines, you can alert administrators to examine the network for issues. This proactive approach to the network can have dramatic and positive effects.

#### Port Mirroring

For troubleshooting purposes, you might want to analyze packets flowing over a network. Back in the early days of networking, to capture packets (that is, store copies of packets on a local hard drive) for analysis, you could attach a *network sniffer* to a hub. Because a hub sends bits received on one port out all other ports, the attached network sniffer sees all traffic entering the hub.

Several standalone network sniffers are available. However, a low-cost way to perform [***packet capture***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_475) and analysis is to use software such as Wireshark ([www.wireshark.org](http://www.wireshark.org/)), as shown in [Figure 14-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14fig03).

![](../images/14fig03.jpg)


**Figure 14-3** Example: Wireshark Packet-Capture Software

A challenge arises, however, if you connect a network sniffer (for example, a laptop running the Wireshark software) to a switch port rather than to a hub port. Because a switch, by design, forwards frames out ports containing the frames’ destination addresses, a network sniffer attached to one port would not see traffic destined for a device connected to a different port.

For example, in [Figure 14-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14fig04), traffic enters a switch on port 1 and, based on the destination MAC addresses, exits via port 2. However, a network sniffer is connected to port 3 and is unable to see (and therefore capture) the traffic flowing between ports 1 and 2.

![](../images/14fig04.jpg)


**Figure 14-4** Example: Network Sniffer Unable to Capture Traffic

Fortunately, some switches support a [***port mirroring***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_507) feature, which makes a copy of traffic seen on one port and sends that duplicated traffic out another port (to which a network sniffer could be attached). As shown in [Figure 14-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14fig05), this switch is configured to mirror traffic on port 2 to port 3, allowing a network sniffer to capture the packets that need to be analyzed. Depending on the switch, locally captured traffic could be forwarded to a remote destination for centralized analysis of that traffic.

![](../images/14fig05.jpg)


**Figure 14-5** Example: Network Sniffer with Port Mirroring Configured on the Switch

Note

Does port mirroring place a higher burden on the switch that is performing it? The answer is yes! Remember, you want to engage in port mirroring only when you truly need to. This is most often when you are troubleshooting.


![](../images/key_topic_icon_158.jpg)

#### Port Mirroring Configuration

[Example 14-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#exa14_1) shows a sample configuration from a Cisco Catalyst switch that captures all the frames coming in on port Gig 0/1 and forwards them to port Gig 0/3.

**Example 14-1** Port Mirroring Configuration

[Click here to view code image](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14_images.xhtml#p0350-01)

```
SW1(config)# monitor session 1 source interface Gi0/1

SW1(config)# monitor session 1 destination interface Gi0/3
```

#### Logging

Network administrators routinely monitor network resources and review reports to be proactive in their administration. For example, a potential network issue might be averted by spotting a trend such as increasing router CPU utilization or increasing bandwidth demand on a WAN link. Monitoring resources and reports come from various sources, such as a syslog server, an SNMP server, Event Viewer logs on a Microsoft Windows server, and packet captures from a network sniffer. Remember that monitoring is also critical in the area of network security. For example, [***security information and event management (SIEM)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_598) software products and services combine security information management (SIM) and security event management (SEM). This section introduces a number of resources for monitoring network information.

An organization should consistently conduct *log reviews*. A log review should include the following, at a minimum:

- **Traffic logs:** You can use a variety of traffic logging mechanisms, many of which are built in to devices. For example, many devices today support NetFlow, which is a powerful traffic monitoring tool that can export traffic flow information to a central collector on a network. (NetFlow is covered in more detail later in this chapter.) Keep in mind that traffic logging mechanisms differ based on the network environment. For example, while you might rely on NetFlow in an on-premises network, you might be using VPC Flow Logs in your AWS infrastructure as a service environment.
- **Audit logs:** You might audit many actions in your network environment and record them in an audit log. For example, a network device might have a setting to log each time an administrator logs in to the system and uses admin powers. These logs can be very valuable in tracking and monitoring the admin activities in your network. AWS Cloud offers a tool called CloudTrail that can log every activity that takes place in your public cloud environment.

#### Syslog

![](../images/key_topic_icon_158.jpg)

A variety of network components (for example, routers, switches, and servers) can send their log information to a common *syslog* server. By having information for multiple devices in a common log and examining time stamps, network administrators can better correlate events occurring on one network device with events occurring on a different network device. Syslog messages and SNMP traps can be used to trigger notification messages that may be sent via email and SMS. A syslog logging solution typically consists of three primary components:

- **Syslog server:** A syslog server receives and stores log messages sent from syslog clients.
- **Syslog clients:** As shown in [Figure 14-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14fig06), various types of network devices can act as syslog clients and send logging information to a syslog server.
- [***Syslog collector***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_675): Networks today will often consist of many different syslog servers for the various categories of devices. A syslog collector can gather all the various syslog messages from the servers for centralized storage and analysis.

![](../images/14fig06.jpg)


**Figure 14-6** Sample Syslog Clients

Messages sent from a syslog client to a syslog server vary in their severity levels. [Table 14-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14tab03) lists the eight severity levels of syslog messages. The higher the syslog level, the more detailed the logs. Keep in mind that more detailed logs require additional storage space on a syslog server.

![](../images/key_topic_icon_158.jpg)


**Table 14-3** Syslog Severity Levels

| Level | Name | Description |
| --- | --- | --- |
| 0 | Emergencies | The most severe error conditions, which render the system unusable |
| 1 | Alerts | Conditions requiring immediate attention |
| 2 | Critical | A less-severe condition than an alert that should be addressed to prevent interruption of service |
| 3 | Errors | Notifications about error conditions within the system that do not render the system unusable |
| 4 | Warnings | Notifications that specific operations failed to complete successfully |
| 5 | Notifications | Non-error notifications that alert an administrator about state changes within a system |
| 6 | Informational | Detailed information about the normal operation of a system |
| 7 | Debugging | Highly detailed information (for example, information about individual packets) that is typically used for troubleshooting purposes |

[Figure 14-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14fig07) shows the format of a syslog message. The syslog log entries contain time stamps, which help you understand how one log message relates to another. The log entries also include severity level information, in addition to the text of the syslog messages.

![](../images/14fig07.jpg)


**Figure 14-7** Structure of a Syslog Message

Note

A variety of systems can act as syslog servers. You can download a free syslog utility from <https://solarwinds.com/downloads>.

#### Other Logs

In addition to logs generated by routers, switches, and other infrastructure gear, the operating systems powering network clients and servers generally have the capability to produce log output. Rather than containing general log information (that is, log information about all of a system’s tracked components), Microsoft Windows incorporates the Event Viewer application, which allows you to view various log types, including application, security, and system logs. These logs can be archived for later review and can be used to spot network trends and provide data for creating baselines.

Note

Logs are beneficial in your network management endeavors only if they are reviewed! Be sure to document standard operating procedures for periodic and careful review of the many logs incorporated into a network. Many networks today engage in [***log aggregation***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_387). This is the process of directing all or most logs to a single location or system. This permits the effective monitoring (and retention) of all log data in the network.

#### NetFlow

Cisco introduced *NetFlow* to the world around 1996. As discussed earlier in this chapter, NetFlow enables network administrators to collect IP network traffic statistics as traffic exits or enters interfaces. This type of network information is typically called [***flow data***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_275).

By analyzing the flow data provided by NetFlow, you can learn all kinds of valuable information about how your network is actually being used. NetFlow can also be a key tool for tracking down network bottlenecks, which tend to be somewhat inevitable. By using the data collected by NetFlow, you can often quickly determine root causes.

A typical implementation of NetFlow includes the following:

- **Flow exporter:** This component aggregates packets into flows and exports flow records toward one or more flow collectors.
- **Flow collector:** This component is responsible for reception, storage, and preprocessing of flow data received from a flow exporter.
- **Analysis application:** You use this application to analyze received flow data in various contexts. Perhaps you are most interested in performance issues during key times of the day. Or perhaps you are more concerned about security issues that NetFlow might be able to help pinpoint.

#### API Integration

Today, one of the most exciting areas in network monitoring is [***application programming interface (API) integration***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_057). This small revolution allows for the seamless exchange of data between different systems and network components. By leveraging APIs, network monitoring tools can access and retrieve data from a wide range of devices, including routers, switches, servers, and cloud services. This integration enables the monitoring software to collect detailed performance metrics, configuration data, and event logs, providing a comprehensive view of the network’s health and performance. APIs facilitate the extraction of real-time data, which is crucial for proactive monitoring and immediate detection of anomalies or potential issues.

One of the significant advantages of API integration in network monitoring is the ability to centralize and unify data from diverse sources into a single platform. This consolidation makes it easier to analyze the network as a whole, rather than in isolated segments. With APIs, network administrators can pull in data from various vendors and technologies, breaking down silos and ensuring that all relevant information is available in one place. This holistic view is essential for identifying trends, correlating events, and understanding the broader context of network behavior. It also simplifies the task of managing complex network environments, including those that span multiple locations or include a mix of on-premises and cloud-based resources.

### Monitoring Solutions

![](../images/key_topic_icon_158.jpg)

Today, more so than ever before, network software vendors have been providing robust network monitoring suites of software that address many functions of cutting-edge management. These network monitoring solutions include the following:

- [***Network discovery***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_441): Network discovery is the process of identifying and mapping devices, services, and components within a network to understand its structure, detect new or unauthorized devices, and ensure accurate inventory management. This process can be executed in an ad hoc manner ([***ad hoc network discovery***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_040)), where discovery tasks are performed as needed, typically in response to specific events or to gather immediate insights into the network’s current state. Conversely, [***scheduled network discovery***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_588) involves routine, automated scans that occur at regular intervals to consistently monitor changes and updates within the network infrastructure. Both approaches are critical for maintaining an up-to-date view of network assets and ensuring robust network management and security practices.
- [***Traffic analysis***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_708): Traffic analysis solutions for network monitoring are valuable tools that enable organizations to gain deep insights into their network performance, security, and efficiency. These solutions leverage various technologies and methodologies to collect, process, and analyze network traffic data in real time. By utilizing packet capture, flow analysis, and deep packet inspection, traffic analysis tools can identify and diagnose issues such as network congestion, latency, and bottlenecks. They also play a critical role in detecting security threats like intrusions, malware, and anomalous behaviors by monitoring traffic patterns and comparing them against known threat signatures and baselines. Advanced traffic analysis solutions often incorporate machine learning and AI to enhance detection capabilities and provide predictive analytics, helping network administrators proactively manage and secure their networks.
- [***Performance monitoring***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_486): Performance monitoring solutions are designed to continuously track and evaluate the efficiency and effectiveness of various components within an IT infrastructure, including servers, applications, networks, and databases. These solutions collect and analyze data on key performance indicators (KPIs) such as response time, throughput, and resource utilization, providing real-time insights and historical trends. By identifying performance bottlenecks, anomalies, and potential issues before they impact end users, performance monitoring solutions help ensure optimal system functionality, enhance user experience, and support proactive maintenance and troubleshooting efforts. Advanced features often include automated alerts, detailed reporting, and predictive analytics to facilitate informed decision-making and maintain system reliability.
- [***Availability monitoring***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_076): Availability monitoring solutions are valuable tools that ensure IT systems, applications, and services are accessible and operational at all times. These solutions continuously check the status and uptime of various components within an infrastructure, immediately detecting and alerting administrators to any outages or disruptions. By monitoring parameters such as server responsiveness, network connectivity, and service performance, availability monitoring helps organizations maintain high levels of reliability and minimize downtime. Advanced availability monitoring tools often include features like automated incident response, root cause analysis, and detailed reporting, enabling quick resolution of issues and helping to ensure that critical systems remain consistently available to users.
- [***Configuration monitoring***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_163): In [Chapter 13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13), “[Organizational Processes and Procedures](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13),” you learned about the importance of configuration management. It should be no surprise, therefore, that configuration monitoring is another important solution. Configuration monitoring solutions track and manage the settings and configurations of hardware, software, and network devices. These solutions continuously monitor configuration changes, ensuring compliance with predefined policies and standards while detecting unauthorized or unexpected modifications. By providing real-time visibility into the current state of configurations, they help prevent configuration drift, which can lead to security vulnerabilities, performance issues, and operational inefficiencies. Advanced configuration monitoring tools offer automated alerts, detailed audit trails, and comprehensive reporting, enabling IT teams to quickly identify and rectify configuration discrepancies, maintain system integrity, and ensure consistent and secure operations.

### Real-World Case Study

Acme, Inc. has decided to improve its network and operations by enhancing the observability of its network. Acme, Inc. has decided to employ NetFlow on many of the key network nodes so that these devices can share performance data with a central repository in the network. By enabling NetFlow, Acme, Inc. can gather detailed information about traffic flows, enabling the identification of network usage patterns, potential bottlenecks, and security issues. This data-driven approach allows for more efficient network management and troubleshooting, providing a clearer understanding of how network resources are being utilized and where improvements can be made.

In addition to implementing NetFlow, Acme, Inc. is also going to start using Splunk Enterprise (a popular SIEM) to make sense of the many logs and other machine data produced in the organization. Splunk Enterprise is a powerful platform for searching, monitoring, and analyzing machine-generated data. By aggregating logs from various network devices, servers, and applications, Splunk enables the creation of comprehensive dashboards and reports. These tools will help the network operations team at Acme, Inc. to visualize network performance, detect anomalies, and gain actionable insights into the health and status of their IT infrastructure.

The combination of NetFlow and Splunk Enterprise will significantly enhance Acme, Inc.’s ability to monitor and manage its network. NetFlow provides a granular view of traffic patterns, which, when analyzed alongside log data in Splunk, can reveal deeper insights into network behavior and performance. This integration allows for more proactive network management, as potential issues can be identified and addressed before they escalate into major problems. For instance, unusual traffic patterns that might indicate a security breach can be quickly detected and mitigated, ensuring the network remains secure and reliable.

### Summary

Here are the main topics covered in this chapter:

- This chapter described best practices for monitoring performance with metrics and sensors.
- This chapter discussed the operation of SNMP, providing insight into the operation of SNMPv1, SNMPv2c, and SNMPv3.
- This chapter described the operation of syslog and the syslog message severity levels.
- This chapter also discussed network monitoring solutions such as network discovery, traffic analysis, and performance monitoring.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 14-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14tab04) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 14-4** Key Topics for [Chapter 14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| [Table 14-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14tab01) | Components of an SNMPv1 and SNMPv2c Network Management Solution | 342 |
| [Figure 14-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14fig01) | SNMPv1 and SNMPv2c Network Management Components and Messages | 343 |
| [Figure 14-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14fig05) | Example: Network Sniffer with Port Mirroring Configured on the Switch | 350 |
| Section | Syslog | 351 |
| [Table 14-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#ch14tab03) | Syslog Severity Levels | 352 |
| Section | Monitoring Solutions | 355 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix B](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb),” or at least the section for this chapter and complete as many of the tables as possible from memory. [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[ad hoc network discovery](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_01)

[anomaly alerting](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_02)

[application programming interface (API) integration](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_03)

[authentication](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_04)

[availability monitoring](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_05)

[baseline metrics](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_06)

[community strings](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_07)

[configuration monitoring](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_08)

[flow data](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_09)

[log aggregation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_010)

[management information base (MIB)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_011)

[network discovery](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_012)

[notifications](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_013)

[packet capture](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_014)

[performance monitoring](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_015)

[port mirroring](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_016)

[scheduled network discovery](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_017)

[security information and event management (SIEM)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_018)

[Simple Network Management Protocol (SNMP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_019)

[SNMP Version 2c (SNMPv2c)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_020)

[SNMP Version 3 (SNMPv3)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_021)

[syslog collector](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_022)

[traffic analysis](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_023)

[traps](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#key_024)

### Additional Resources

**How Healthy Is Your Existing Network?:** <https://www.ajsnetworking.com/how-healthy-is-your-existing-network>

**SNMP Operation:** <https://www.youtube.com/watch?v=tg47MZdtcAE>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_1) SNMP uses a series of objects to collect information about a managed device. What is the name of the structure, similar to a database, that contains these objects?

1. RIB
2. MIB
3. Syslog
4. Baseline

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_2) Which syslog level is the most severe?

1. Informational
2. Critical
3. Errors
4. Warnings

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_3) What are the main categories of SNMP message types? (Choose three.)

1. Get
2. Put
3. Set
4. Trap

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_4) As you monitor a key area of your network, you discover that the average latency spans a wide range. You are seeing some periods of 50 ms and others of 300 ms. What is the term for this type of variation in delay?

1. CRC
2. DSCP
3. WRED
4. Jitter

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_5) Which SNMPv3 security level is the equivalent of SNMPv2c?

1. noAuthNoPriv
2. authPriv
3. authNoPriv
4. noAuthPriv

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_6) What syslog level is used for informational messages?

1. 0
2. 8
3. 7
4. 6

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_7) Which network assurance tool would most likely feature the use of a collector?

1. NetFlow
2. SNMP
3. Nmap
4. traceroute

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_8) Which version of SNMP introduced significant improvements in security, offering authentication, encryption, and access control mechanisms to protect SNMP communications?

1. SNMPv1
2. SNMPv2
3. SNMPv2c
4. SNMPv3

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_9) Which of the following will help you better understand latency in your network?

1. Baseline metrics
2. Jitter
3. Bandwidth
4. Latency

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_10) What do many switches support that makes a copy of network traffic seen on one port and sends that duplicated traffic out another port (to which a network sniffer could be attached)?

1. Managers
2. Agents
3. Port mirroring
4. MIBs

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_11) Which of the following network monitoring solutions specifically focuses on collecting and analyzing data on key performance indicators (KPIs) such as response time, throughput, and resource utilization, providing real-time insights and historical trends?

1. Network discovery
2. Traffic analysis
3. Availability monitoring
4. Performance monitoring

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz14_12) What is the process called by which SIEM systems combine similar events into a log to reduce event volume and consolidate data so that crucial events are not missed?

1. Application programming interface (API) integration
2. Ad hoc discovery
3. Log aggregation
4. Scheduled discovery