## Chapter 1

## The OSI Model and Encapsulation

This chapter covers the following topics related to Objective 1.1 (Explain concepts related to the Open Systems Interconnection [OSI] reference model) of the CompTIA Network+ N10-009 certification exam:

- [OSI model](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01lev1sec3)

  - [Layer 1—Physical](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01lev2sec1)
  - [Layer 2—Data link](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01lev2sec2)
  - [Layer 3—Network](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01lev2sec5)
  - [Layer 4—Transport](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01lev2sec6)
  - [Layer 5—Session](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01lev2sec7)
  - [Layer 6—Presentation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01lev2sec8)
  - [Layer 7—Application](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01lev2sec9)

Way back in 1977, the International Organization for Standardization (ISO) developed a subcommittee to focus on the interoperability of multivendor communications systems. This is fancy language for getting network “stuff” to communicate with other network “stuff,” even if different companies made the network “stuff.” What sprang from this subcommittee was the [***Open Systems Interconnection (OSI) reference model***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_469) (also referred to as the *OSI model* or the *OSI stack*). Thanks to this model, you can talk about any networking technology and categorize that technology as residing at one or more of the seven layers of the model.

This chapter defines those seven layers and offers examples of what you might find at each layer. It also contrasts the OSI model with another model—the TCP/IP stack, also known as the Department of Defense (DoD) model—that focuses on Internet Protocol (IP) communications.

### Foundation Topics

### The Purpose of Reference Models

Throughout this book, various protocols and devices that play a role in your network (and your networking career) are introduced. To better understand how a technology fits in, it helps to have a common point of reference against which various technologies from different vendors can be compared. The OSI model provides us an ideal point of reference for our learning and discovery.

Understanding the OSI model is also very useful in troubleshooting networks. In fact, [Chapter 21](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#ch21), “[A Network Troubleshooting Methodology](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#ch21),” provides some concrete methods for using the OSI model in conjunction with thorough network troubleshooting.

One of the most common ways of categorizing the function of a network technology is to say at what layer (or layers) of the OSI model that technology runs. Understanding how that technology performs a certain function at a certain layer of the OSI model helps you determine whether one device is going to be able to communicate with another device, which might or might not be using a similar technology, at that layer of the OSI reference model.

For example, when your end-user device connects to a web server on the Internet, your service provider assigns your device an IP address. Similarly, the web server to which you are communicating has an IP address. As described in this chapter, an IP address lives at Layer 3 (the network layer) of the OSI model. Because your device and the web server use a common protocol (that is, IP) at Layer 3, they are capable of communicating with one another.

Notice also in this example that you are interested in receiving the data from the web server, which will be web pages filled with text and graphics and maybe even videos. This is the information you are really after. You (typically) do not care about the IP addresses in use or any of the other information required by the network devices to make this transfer happen. In technical terms, you are interested in the *payload* of the packets sent from the web server. The [***payload***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_482) provides a simple and generic method of describing the data itself, which is separate and distinct from any of the other information required for proper transmission.

Personally, I have been in the computer-networking industry since 1996, and I have had the OSI model explained in many classes I have attended and books I have read. From this, I have taken away a collection of metaphors to help describe the operation of the different layers of the OSI model. Some of the metaphors involve sending a letter from one location to another or placing a message in a series of envelopes. These are often excellent metaphors for encapsulation and decapsulation (covered later in this chapter), but they do not work all that well for the OSI model in general. My favorite way to describe the OSI model is to simply think of it as being analogous to a bookcase, such as the one shown in [Figure 1-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig01).

![](../images/01fig01.jpg)


**Figure 1-1** A Bookcase Is Analogous to the OSI Model

If you were to look at this or any other bookcase in my home office, you would see that I have organized diverse types of books on different shelves. One shelf holds my collection of technical books, another shelf holds the books I wrote for Pearson and other publishers, another shelf holds books regarding self-improvement and finance. I have grouped similar books together on each shelf, just as the OSI model groups similar protocols and functions together in a layer.

A common pitfall my readers meet when studying the OSI model is to try to neatly fit all the devices and protocols in their network into one of the OSI model’s seven layers. However, not every technology fits perfectly into these layers. In fact, some networks might not have any technologies running at one or more of these layers. This reminds me of my favorite statement about the OSI model. It comes from Rich Seifert’s book *The Switch Book*. In that book, Rich reminds us that the OSI model is a *reference* model, not a *reverence* model. That is, no cosmic law states that all technologies must cleanly plug into the model. So, as you discover the characteristics of the OSI model layers throughout this chapter, remember that these layers are like shelves for organizing similar protocols and functions, not immutable laws.

### The OSI Model

As previously described, the OSI model consists of seven layers:

![](../images/key_topic_icon_158.jpg)

- **Layer 1:** The physical layer
- **Layer 2:** The data link layer
- **Layer 3:** The network layer
- **Layer 4:** The transport layer
- **Layer 5:** The session layer
- **Layer 6:** The presentation layer
- **Layer 7:** The application layer

Graphically, we depict these layers with Layer 1 at the bottom of the stack, as shown in [Figure 1-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig02).

![](../images/01fig02.jpg)


**Figure 1-2** The OSI Stack

Note

Various mnemonics are available to help memorize these layers in their proper order. A top-down (that is, starting at the top of the stack with Layer 7 and working your way down to Layer 1) memory aid is ***A****ll* ***P****eople* ***S****eem* ***T****o* ***N****eed* ***D****ata* ***P****rocessing*. Another common technique is ***P****lease* ***D****o* ***N****ot* ***T****hrow* ***S****ausage* ***P****izza* ***A****way*, which begins at Layer 1 and works up to Layer 7.

At the physical layer, binary expressions (that is, a series of 1s and 0s) represent data. A binary expression is created using bits, where a bit is a single 1 or a single 0. At upper layers, however, bits are grouped together, into what is known as a [***protocol data unit (PDU)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_529) or a *data service unit*.

Engineers tend to use the term *packet* generically to refer to these PDUs. However, PDUs might have an added name, depending on their OSI layer. [Figure 1-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig03) illustrates these PDU names. A common memory aid for these PDUs is ***S****ome* ***P****eople* ***F****ear* ***B****irthdays,* where the *S* in *Some* reminds us of the *S* in *Segments*. The *P* in *People* reminds us of the *P* in *Packets*, and the *F* in *Fear* reflects the *F* in *Frames*. Finally, the *B* in *Birthdays* reminds us of the *B* in *Bits.*

![](../images/key_topic_icon_158.jpg)

![](../images/01fig03.jpg)


**Figure 1-3** PDU Names

#### Layer 1: The Physical Layer

The concern of the [***physical layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_491), as shown in [Figure 1-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig04), is the transmission of bits on the network along with the physical and electrical characteristics of the network.

![](../images/key_topic_icon_158.jpg)

![](../images/01fig04.jpg)


**Figure 1-4** Layer 1: The Physical Layer

The physical layer defines the following:

- **How to represent bits on the medium:** Data on a computer network is represented as a binary expression. [Chapter 7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07), “[IPv4 Addressing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07),” discusses binary in much more detail. Electrical voltage (on copper wiring) or light (carried via fiber-optic cabling) can represent these 1s and 0s.

  For example, the presence or absence of voltage on a wire portrays a binary 1 or a binary 0, respectively, as illustrated in [Figure 1-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig05). Similarly, the presence or absence of light on a fiber-optic cable renders a 1 or 0 in binary. This type of approach is called [***current state modulation***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_179).

![](../images/01fig05.jpg)


  **Figure 1-5** Current State Modulation

  An alternative approach to portraying binary data is [***state transition modulation***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_655), as shown in [Figure 1-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig06), where the transition between voltages or the presence of light shows a binary value.

![](../images/01fig06.jpg)


**Figure 1-6** Transition Modulation

Note

Other modulation types you might be familiar with from radio include amplitude modulation (AM) and frequency modulation (FM). AM uses a variation in a waveform’s amplitude (that is, signal strength) to portray the original signal. FM uses a variation in frequency to stand for the original signal.

- **Wiring standards for connectors and jacks:** [Chapter 5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05), “[Transmission Media and Transceivers](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05),” describes several standards for network connectors. For example, the TIA/EIA-568-B standard describes how to wire an RJ-45 connector for use on a 100BASE-TX Ethernet network, as shown in [Figure 1-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig07).

![](../images/01fig07.jpg)


**Figure 1-7** TIA/EIA-568-B Wiring Standard for an RJ-45 Connector

- **Physical topology:** Layer 1 devices view a network as a physical topology (as opposed to a logical topology). Examples of a physical topology include star and hub-and-spoke topologies, as described in [Chapter 6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06), “[Network Topologies, Architectures, and Types](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06).”
- **Synchronizing bits:** For two networked devices to successfully communicate at the physical layer, they must agree on when one bit stops and another bit starts. Specifically, the devices need a method to synchronize the bits. Two basic approaches to bit synchronization are *asynchronous* and *synchronous* synchronization:

  - **Asynchronous:** With this approach, a sender states that it is about to start transmitting by sending a start bit to the receiver. When the receiver sees this, it starts its own internal clock to measure the next bits. After the sender transmits its data, it sends a stop bit to say that it has finished its transmission.
  - **Synchronous:** This approach synchronizes the internal clocks of the sender and the receiver to ensure that they agree on when bits begin and end. A common approach to make this synchronization happen is to use an external clock (for example, a clock provided by a service provider). The sender and receiver then reference this external clock.
- **Bandwidth usage:** The two fundamental approaches to bandwidth usage on a network are *broadband* and *baseband*:

  - **Broadband:** Broadband technologies divide the bandwidth available on a medium (for example, copper or fiber-optic cabling) into different channels. A sender can then transmit different communication streams over the various channels. For example, consider frequency-division multiplexing (FDM) used by a cable modem. Specifically, a cable modem uses certain ranges of frequencies on the cable coming into your home from the local cable company to carry incoming data, another range of frequencies for outgoing data, and several other frequency ranges for various TV stations.
  - **Baseband:** Baseband technologies use all the available frequencies on a medium to send data. Ethernet is an example of a networking technology that uses baseband.
- **Multiplexing strategy:** Multiplexing allows multiple communications sessions to share the same physical medium. Cable TV, as previously mentioned, allows you to receive multiple channels over a single physical medium (for example, a coaxial cable plugged into the back of your television). Here are some of the most common approaches to multiplexing:

  - [***Time-division multiplexing (TDM)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_699): TDM supports different communication sessions (for example, different telephone conversations in a telephony network) on the same physical medium by causing the sessions to take turns. For a brief period, defined as a *time slot*, data from the first session is sent, followed by data from the second session. This continues until all sessions have had a turn, and the process repeats.
  - **Statistical time-division multiplexing (StatTDM):** A downside to TDM is that each communication session receives its own time slot, even if one of the sessions does not have any data to send at the moment. To make more efficient use of available bandwidth, StatTDM dynamically assigns time slots to communications sessions on an as-needed basis.
  - **Frequency-division multiplexing (FDM):** FDM divides a medium’s frequency range into channels, and different communication sessions send their data over different channels. As previously described, this approach to bandwidth usage is called *broadband*.
  - **Orthogonal frequency-division multiplexing (OFDM):** OFDM encodes digital data onto multiple carrier frequencies. OFDM is very popular today and is used in wideband digital communication. This makes OFDM useful in applications such as digital television and audio broadcasting, DSL Internet access, wireless networks, powerline networks, and 4G/5G mobile communications.
  - **Orthogonal frequency-division multiple access (OFDMA):** OFDMA is a multiuser version of the popular OFDM digital modulation scheme. It divides a wireless channel into subchannels to allow simultaneous data transmission from multiple users, enhancing network efficiency and reducing latency.

Examples of devices defined by physical layer standards include legacy hubs, wireless access points, and network cabling.

Note

Hubs are not used in modern computer networks. So why are we even bothering to mention them? Well, they really did help give rise to our modern switches. A hub interconnects PCs in a LAN; it is considered a physical layer device because it takes bits coming in on one port and retransmits those bits out all other ports. At no point does the hub learn any addressing information from the data as our modern switches do.

#### Layer 2: The Data Link Layer

The [***data link layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_187) is concerned with the following:

- Packaging data into frames and transmitting those frames on the network
- Ensuring that frames do not exceed the [***maximum transmission unit (MTU)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_402) of the physical media
- Performing error detection/correction
- Uniquely finding network devices with addresses
- Handling flow control

Note

Network interfaces use the MTU to define the largest packet size the interface will forward. For example, a 1500-byte packet could not be forwarded via a router interface with an MTU of 1470 bytes. In [Chapter 22](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22), “[Troubleshoot Common Cabling Problems](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#ch22),” you will learn about *giants* and *runts*—packets that are too large or too small for the network on which they reside.

Data link layer processes, collectively referred to as *data link control* (*DLC*), are illustrated in [Figure 1-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig08).

![](../images/key_topic_icon_158.jpg)

![](../images/01fig08.jpg)


**Figure 1-8** Layer 2: The Data Link Layer

In fact, the data link layer is distinct from the other layers in that it has two sublayers: MAC and LLC.

#### Media Access Control

Characteristics of the Media Access Control (MAC) sublayer of the data link layer include the following:

- **Physical addressing:** A common example of a Layer 2 address is a MAC address, which is a 48-bit address assigned to a device’s network interface card (NIC). MAC addresses are written in hexadecimal notation (for example, 58:55:ca:eb:27:83). The first 24 bits of the 48-bit address are the *vendor code*. The IEEE Registration Authority assigns a manufacturer one or more unique vendor codes. You can use the list of vendor codes at <https://standards-oui.ieee.org/oui/oui.txt> to identify the manufacturer of a networking device, based on the first half of the device’s MAC address. The last 24 bits of a MAC address are assigned by the manufacturer, and they act as a serial number for the device. No two MAC addresses in the world should have the same value.
- **Logical topology:** Layer 2 devices view a network as a logical (as opposed to physical) topology. [Chapter 6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06) has lots more to say regarding physical and logical topologies.
- **Method of transmitting on the media:** With several devices connected to a network, there needs to be some strategy for deciding when a device sends on the media. Otherwise, multiple devices might send at the same time and interfere with one another’s transmissions.

#### Logical Link Control

Characteristics of the Logical Link Control (LLC) sublayer of the data link layer include the following:

- **Connection services:** When a device on a network receives a message from another device on the network, that recipient device can give feedback to the sender in the form of an acknowledgment message. The two main functions provided by these acknowledgment messages are as follows:

  - **Flow control:** Limits the amount of data a sender can send at one time; this prevents the sender from overwhelming the receiver with too much information.
  - **Error control:** Allows the recipient of data to let the sender know whether the expected data frame was not received or whether it was received but is corrupted. The recipient figures out whether the data frame is corrupt by mathematically calculating a checksum of the data received. If the calculated checksum does not match the checksum received with the data frame, the recipient of the data draws the conclusion that the data frame is corrupted and can then notify the sender via an acknowledgment message.
- **Synchronizing transmissions:** Senders and receivers of data frames need to coordinate when a data frame is being transmitted and should be received. The three methods of performing this synchronization are detailed here:

  - **Isochronous:** With isochronous transmission, network devices look to a common device in the network as a clock source, which creates fixed-length time slots. Network devices can determine how much free space, if any, is available within a time slot and then insert data into an available time slot. A time slot can accommodate more than one data frame. Isochronous transmission does not need to provide clocking at the beginning of a data string (as does synchronous transmission) or for every data frame (as does asynchronous transmission). As a result, isochronous transmission uses little overhead compared to asynchronous or synchronous transmission methods.
  - **Asynchronous:** With asynchronous transmission, network devices reference their own internal clocks, and network devices do not need to synchronize their clocks. Instead, the sender places a start bit at the beginning of each data frame and a stop bit at the end of each data frame. These start and stop bits tell the receiver when to monitor the medium for the presence of bits.

    An additional bit, called the *parity bit*, might also be added to the end of each byte in a frame to detect an error in the frame. For example, if even parity error detection (as opposed to odd parity error detection) is used, the parity bit (with a value of either 0 or 1) would be added to the end of a byte, causing the total number of 1s in the data frame to be an even number. If the receiver of a byte is configured for even parity error detection and receives a byte where the total number of bits (including the parity bit) is even, the receiver can conclude that the byte was not corrupted during transmission.

Note

Using a parity bit to detect errors might not be effective if a byte has more than one error (that is, if more than one bit has been changed from its original value).

- **Synchronous:** With synchronous transmission, two network devices that want to communicate between themselves must agree on a clocking method to show the beginning and ending of data frames. One approach to providing this clocking is to use a separate communications channel over which a clock signal is sent. Another approach relies on specific bit combinations or control characters to indicate the beginning of a frame or a byte of data.

  Like asynchronous transmissions, synchronous transmissions can perform error detection. However, rather than using parity bits, synchronous communication runs a mathematical algorithm on the data to create a [***cyclic redundancy check (CRC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_181). If the sender and the receiver calculate the same CRC value for the same chunk of data, the receiver can conclude that the data was not corrupted during transmission.

Examples of devices defined by data link layer standards include switches, bridges, and NICs.

Note

NICs are not entirely defined at the data link layer because they are partially based on physical layer standards, such as a NIC’s network connector.

#### Layer 3: The Network Layer

The [***network layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_445), as shown in [Figure 1-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig09), is primarily concerned with forwarding data based on logical addresses.

![](../images/key_topic_icon_158.jpg)

![](../images/01fig09.jpg)


**Figure 1-9** Layer 3: The Network Layer

Although many network administrators think of routing and IP addressing when they hear about the network layer, this layer is actually responsible for a variety of tasks:

- **Logical addressing:** Whereas the data link layer uses physical addresses to make forwarding decisions, the network layer uses logical addressing to make forwarding decisions. By far the most widely deployed routed protocol is Internet Protocol (IP). [Chapter 7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07) discusses IP addressing in detail.
- **Switching:** Engineers often associate the term *switching* with Layer 2 technologies; however, the concept of switching also exists at Layer 3. Switching, at its essence, is making decisions about how data should be forwarded. At Layer 3, three common switching techniques exist:

  - **Packet switching:** With packet switching, a data stream is divided into packets. Each packet has a Layer 3 header that includes source and destination Layer 3 addresses. Another term for packet switching is *routing*, which is discussed in more detail in [Chapter 9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09), “[Routing Technologies](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09).”
  - **Circuit switching:** Circuit switching dynamically brings up a dedicated communication link between two parties for those parties to communicate.

    As a simple example of circuit switching, think of making a phone call from your home to a business. In fact, let’s go “old school” and pretend you have a traditional landline servicing your phone, the telephone company’s switching equipment interconnects your home phone with the phone system of the business you are calling. This interconnection (that is, *circuit*) exists only for the duration of the phone call.
  - **Message switching:** Unlike packet switching and circuit switching technologies, message switching is usually not well suited for real-time applications because of the delay involved. Specifically, with message switching, a data stream is divided into messages. Each message is tagged with a destination address, and the messages travel from one network device to another network device on the way to their destination. Because these devices might briefly store the messages before forwarding them, a network using message switching is sometimes called a *store-and-forward* network. Metaphorically, you could visualize message switching like routing an email message, where the email message might be briefly stored on an email server before being forwarded to the recipient.
- **Route discovery and selection:** Because Layer 3 devices make forwarding decisions based on logical network addresses, a Layer 3 device might need to know how to reach various network addresses. For example, a common Layer 3 device is a router. A router can maintain a routing table indicating how to forward a packet based on the packet’s destination network address.

  A router can have its routing table populated via manual configuration (that is, by entering static routes), via a dynamic routing protocol (for example, OSPF or EIGRP), or simply by being directly connected to certain networks.

Note

Routing protocols are discussed in [Chapter 9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09).

- **Connection services:** Just as the data link layer offers connection services for flow control and error control, connection services also exist at the network layer. Connection services at the network layer can improve the communication reliability if the data link’s LLC sublayer is not performing connection services. The following functions are performed by connection services at the network layer:

  - **Flow control (also known as congestion control):** Helps prevent a sender from sending data more rapidly than the receiver is capable of receiving it.
  - **Packet reordering:** Allows packets to be placed in the proper sequence as they are sent to the receiver. This might be necessary because some networks support load balancing, where multiple links are used to send packets between two devices. Because multiple links exist, packets might arrive out of order.

Examples of devices found at the network layer include routers and multilayer switches. The most common Layer 3 protocol in use, and the protocol on which the Internet is based, is IPv4. However, IPv6 is beginning to be more common on networks today.

#### Layer 4: The Transport Layer

The [***transport layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_714), as shown in [Figure 1-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig10), acts as a dividing line between the upper layers and lower layers of the OSI model. Specifically, messages are taken from upper layers (Layers 5–7) and are encapsulated into segments for transmission to the lower layers (Layers 1–3). Similarly, data streams coming from lower layers are decapsulated and sent to Layer 5 (the session layer), or some other upper layer, depending on the protocol.

![](../images/01fig10.jpg)


**Figure 1-10** Layer 4: The Transport Layer

Two common transport layer protocols are TCP and UDP:

- [***Transmission Control Protocol (TCP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_712): TCP is a connection-oriented transport protocol. Connection-oriented transport protocols offer reliable transport, in that if a segment is dropped, the sender can detect the drop and retransmit the dropped segment. Specifically, a receiver acknowledges segments that it receives. Based on those acknowledgments, a sender can decide which segments were successfully received and which segments need to be transmitted again.
- [***User Datagram Protocol (UDP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_734): UDP is a connectionless transport protocol. Connectionless transport protocols offer unreliable transport, in that if a segment is dropped, the sender is unaware of the drop, and no retransmission occurs.

![](../images/key_topic_icon_158.jpg)

Just as Layer 2 and Layer 3 offer flow control services, flow control services also exist at Layer 4. Two common flow control approaches at Layer 4 are windowing and buffering:

- **Windowing:** TCP communication uses windowing, in that one or more segments are sent at one time, and a receiver can attest to the receipt of all the segments in a window with a single acknowledgment. In some cases, as illustrated in [Figure 1-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig11), TCP uses a sliding window, where the window size begins with one segment. If there is a successful acknowledgment of that one segment (that is, the receiver sends an acknowledgment asking for the next segment), the window size doubles to two segments. Upon successful receipt of those two segments, the next window holds four segments. This exponential increase in window size continues until the receiver does not acknowledge successful receipt of all segments within a certain amount of time—known as the *round-trip time* (RTT), which is sometimes called *real transfer time*—or until a configured maximum window size is reached.

![](../images/01fig11.jpg)


**Figure 1-11** TCP Sliding Window

- **Buffering:** With buffering, a device (for example, a router) uses a chunk of memory (sometimes called a *buffer* or a *queue*) to store segments if bandwidth is not available to send those segments. A queue has finite capacity, however, and can overflow (that is, drop segments) in the event of sustained network congestion.

![](../images/key_topic_icon_158.jpg)

In addition to TCP and UDP, Internet Control Message Protocol (ICMP) is another transport layer protocol you are likely to meet. ICMP is used by utilities such as ping and traceroute, which are discussed in [Chapter 25](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#ch25), “[Network Troubleshooting Tools](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#ch25).”

#### Layer 5: The Session Layer

The [***session layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_609), as shown in [Figure 1-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig12), is responsible for setting up, maintaining, and tearing down sessions. You can think of a session as a conversation that needs to be treated separately from other sessions to avoid the intermingling of data from different conversations.

![](../images/key_topic_icon_158.jpg)

![](../images/01fig12.jpg)


**Figure 1-12** Layer 5: The Session Layer

Here is a detailed look at the functions of the session layer:

- **Setting up a session:** Examples of the procedures involved in setting up a session include the following:

  - Checking user credentials (for example, username and password)
  - Assigning numbers to a session’s communication flows to uniquely find each one
  - Negotiating services needed during the session
  - Negotiating which device begins sending data
- **Maintaining a session:** Examples of the procedures involved in supporting a session include the following:

  - Transferring data
  - Reestablishing a disconnected session
  - Acknowledging receipt of data
- **Tearing down a session:** A session can be disconnected based on agreement of the devices in the session. Alternatively, a session might be torn down because one party disconnects (either intentionally or because of an error condition). If one party disconnects, the other party can detect a loss of communication with that party and tear down its side of the session.

Session Initiation Protocol (SIP) is an example of a session layer protocol, which can help set up, support, and tear down a voice or video connection. Keep in mind, however, that not every network application neatly maps directly to all seven layers of the OSI model.

#### Layer 6: The Presentation Layer

The [***presentation layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_520), as shown in [Figure 1-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig13), formats the data being exchanged and secures that data with encryption.

![](../images/key_topic_icon_158.jpg)

![](../images/01fig13.jpg)


**Figure 1-13** Layer 6: The Presentation Layer

The following list describes the functions involved in data formatting and encryption in more detail:

- **Data formatting:** As an example of how the presentation layer handles data formatting, consider how text is formatted. Some applications might format text using American Standard Code for Information Interchange (ASCII), while other applications might format text using Extended Binary Coded Decimal Interchange Code (EBCDIC). The presentation layer handles formatting the text (or other types of data, such as multimedia or graphics files) in a format that allows compatibility between the communicating devices.
- **Encryption:** Imagine that you are sending sensitive information over a network (for example, your credit card number or bank password). If a malicious user were to intercept your transmission, they might be able to obtain this sensitive information. To add a layer of security for such transmissions, encryption can be used to scramble (encrypt) the data in such a way that if the data were intercepted, a third party would not be able to unscramble (decrypt) it. However, the intended recipient would be able to decrypt the transmission.

Encryption is discussed in detail in [Chapter 18](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#ch18), “[Network Security Concepts](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#ch18).”

#### Layer 7: The Application Layer

The [***application layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_054), as shown in [Figure 1-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig14), gives application services to a network. An important (and often-misunderstood) concept is that end-user applications (such as Microsoft Word) live at the application layer. Instead, the application layer supports services used by end-user applications. For example, email is an application layer service that does exist at the application layer, whereas Microsoft Outlook (an example of an email client) is an end-user application that does not live at the application layer. Another function of the application layer is advertising available services.

![](../images/key_topic_icon_158.jpg)

![](../images/01fig14.jpg)


**Figure 1-14** Layer 7: The Application Layer

The following list describes the functions of the application layer in more detail:

- **Application services:** Examples of the application services living at the application layer include file sharing and email.
- **Service advertisement:** Some applications’ services (for example, some networked printers) periodically send out advertisements, making their availability known to other devices on the network. Other services, however, register themselves and their services with a centralized directory (for example, Microsoft Active Directory), which can be queried by other network devices seeking such services.

Recall that even though the application layer is numbered as Layer 7, it is at the top of the OSI stack because its networking functions are closest to the end user.

### The TCP/IP Stack

The ISO developed the OSI reference model to be generic, in terms of what protocols and technologies could be categorized by the model. However, most of the traffic on the Internet (and traffic on corporate networks) is based on the TCP/IP protocol suite. Therefore, a more relevant model for many network designers and administrators to reference is a model developed by the U.S. Department of Defense (DoD). This model is known as the *DoD model*, or the [***TCP/IP stack***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_683).

Note

An older protocol known as Network Control Protocol (NCP) was similar to TCP/IP. NCP was used on ARPANET (the predecessor to the Internet), and it provided features like those offered by the TCP/IP suite of protocols on the Internet, although they were not as robust.

#### Layers of the TCP/IP Stack

The TCP/IP stack has only four defined layers, as opposed to the seven layers of the OSI model. [Figure 1-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig15) contrasts these two models.

![](../images/key_topic_icon_158.jpg)

![](../images/01fig15.jpg)


**Figure 1-15** TCP/IP Stack

The TCP/IP stack is composed of the following layers:

- **Network interface:** The TCP/IP stack’s [***network interface layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_444) encompasses the technologies offered by Layers 1 and 2 (the physical and data link layers) of the OSI model.

Note

Some literature refers to the network interface layer as the *network access layer*.

- **Internet:** The [***Internet layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_333) of the TCP/IP stack maps to Layer 3 (the network layer) of the OSI model. Although multiple routed protocols live at the OSI model’s network layer, the Internet layer of the TCP/IP stack focuses on IP as the protocol to be routed through a network. [Figure 1-16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig16) shows the format of an IP version 4 (IPv4) packet.

![](../images/key_topic_icon_158.jpg)

![](../images/01fig16.jpg)


  **Figure 1-16** IPv4 Packet Format

  Notice that there are fields in the IP packet header for both source and destination IP addresses. The Protocol field shows the transport layer protocol from which the packet was sent or to which the packet should be sent. Also of note is the Time-to-Live (TTL) field. The value in this field is decremented by 1 every time this packet is routed from one IP network to another (that is, when it passes through a router). If the TTL value ever reaches 0, the packet is discarded from the network. This behavior helps prevent routing loops, and we will revisit this concept in [Chapter 2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02), “[Networking Appliances, Applications, and Functions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02).” As a common practice, the OSI layer numbers 1, 2, and 3 are still used when referring to physical, data link, and network layers of the TCP/IP stack, even though the TCP/IP stack does not explicitly separate the physical and data link layers.
- **Transport:** The [***transport layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_715) of the TCP/IP stack maps to Layer 4 (the transport layer) of the OSI model. The two primary protocols found at the TCP/IP stack’s transport layer are TCP and UDP.

  [Figure 1-17](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig17) details the structure of a TCP segment. Notice the fields for source and destination ports. As described later in this chapter, these ports identify to which upper-layer protocol data should be forwarded or from which upper-layer protocol the data is being sent.

![](../images/key_topic_icon_158.jpg)

![](../images/01fig17.jpg)


  **Figure 1-17** TCP Segment Format

  Also notice the field for window size. The value in this field determines how many bytes a device can receive before expecting an acknowledgment. As previously described, this feature offers flow control.

  The header of a TCP segment also contains sequence numbers for segments. With sequence numbering, if segments arrive out of order, the recipient can put them back in the proper order based on the sequence numbers.

  The acknowledgment number in the header shows the next sequence number the receiver expects to receive. This is a way for the receiver to let the sender know that all segments up to and including that point have been received. Due to the sequencing and acknowledgments, TCP is considered to be a *connection-oriented* transport layer protocol.

Note

You might have noticed that both the [***IP header***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_343) and the [***TCP header***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_682) make use of a Flags field. Including this field is a very common technique in networking to permit the data unit to convey specific settings. For example, the IP header uses the IP Flags field (3 bits) to help manage (or prevent) fragmentation. [***TCP flags***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_681) are used to indicate a particular connection state or provide additional information. They are often used for troubleshooting purposes or to control how a particular connection is handled.

[Figure 1-18](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig18) presents the structure of a UDP segment. UDP is a connectionless, unreliable protocol. UDP lacks the sequence numbering, window size, and acknowledgment numbering present in the header of a TCP segment. The UDP segment’s header simply contains source and destination port numbers, a UDP checksum (which is an optional field used to detect transmission errors), and the segment length (measured in bytes).

![](../images/key_topic_icon_158.jpg)

![](../images/01fig18.jpg)


**Figure 1-18** UDP Segment Format

Because a [***UDP header***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_724) is much smaller than a TCP header, UDP is a good candidate for the transport layer protocol for applications that need to maximize bandwidth and do not require acknowledgments (for example, audio or video streams).

- **Application:** The biggest difference between the TCP/IP stack and the OSI model is at the TCP/IP stack’s [***application layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_055). This layer addresses concepts described by Layers 5, 6, and 7 (the session, presentation, and application layers) of the OSI model.

With the reduced complexity of a four-layer model like the TCP/IP stack, network designers and administrators can more easily categorize a given networking technology into a specific layer. For example, although SIP was shown earlier as a session layer protocol within the OSI model, you would have to know more about the behavior of SIP to properly categorize it in that model. However, with the TCP/IP stack, you could quickly figure out that SIP is a higher-level protocol that gets encapsulated inside TCP, and you could thus classify SIP in the application layer of the TCP/IP stack.

#### Common Application Protocols in the TCP/IP Stack

Application layer protocols in the TCP/IP stack are identifiable by unique port numbers. For example, when you enter a web address in an Internet browser, you are (by default) communicating with that remote web address using TCP port 80. Specifically, Hypertext Transfer Protocol (HTTP), which is the protocol used by web servers, uses TCP port 80. Therefore, the data you send to that remote web server has a destination port number of 80. That data is encapsulated into a TCP segment at the transport layer. That segment is further encapsulated into a packet at the Internet layer and sent out on the network using an underlying network interface layer technology such as Ethernet.

Note

Thanks to awareness of network security today, you do not see HTTP (port 80) actually being used on the Internet very much anymore. It has been replaced with a secured version, HTTPS, which uses TCP port 443 in its operation.

Consider the example illustrated in [Figure 1-19](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig19). When you send traffic to the remote website, the packet you send out to the network needs not only the destination IP address (172.16.1.2 in this example) of the web server and the destination port number for HTTP (that is, 80) but also the source IP address of your computer (10.1.1.1 in this example). Because your computer is not acting as a web server, its port is not 80. Instead, your computer selects a source port number greater than 1023. In this example, let’s imagine that the client PC selects the source port 1248.

![](../images/key_topic_icon_158.jpg)

![](../images/01fig19.jpg)


**Figure 1-19** Example: Port Numbers and IP Addresses

Notice that when the web server sends content back, the IP addresses and port numbers have now switched, with the web server as the source and your PC as the destination. With both source and destination port numbers, along with source and destination IP addresses, two-way communication becomes possible.

Note

Ports numbered 1023 and below are called *well-known* ports, and ports numbered above 1023 are called *ephemeral* ports. The maximum value of a port is 65535. Well-known port number assignments are available at <https://www.iana.org/assignments/port-numbers>.

### Real-World Case Study

Bob, a manager of the networking team at Acme, Inc., is paying extra attention to the specific words he uses as he talks to his team in preparation for the implementation of the network. When referring to transport protocols such as the connection-oriented TCP and the connectionless UDP, the word Bob uses to describe those protocol data units is *segment*.

In discussing the applications that Acme, Inc. will be using over its network, Bob notes that many of these applications will be using TCP at the transport layer. This includes HTTPS for secure web traffic and Simple Mail Transfer Protocol (SMTP) and Internet Message Access Protocol (IMAP) for email services.

The company will use the Secure Shell (SSH) protocol, which also uses TCP at the transport layer, as a secure method to remotely connect to and manage its network devices. A common connectionless UDP protocol is Domain Name System (DNS), which will be used thousands of times a day to translate a friendly name like [https://www.pearson.com](https://https//www.pearson.com) to an IP address that is reachable over the network. Another protocol based on UDP that will be used often is Dynamic Control Host Protocol (DHCP), which assigns client computers on the network an IP address that is required for sending and receiving Layer 3 packets.

For the traffic on the LAN, the Ethernet cables and electronic signals being sent as bits going over those cables represent Layer 1 from an OSI perspective. On the LAN, they will be using Ethernet technology, and as a result, the Layer 2 frames that are sent on the LAN will be encapsulated and sent as Ethernet Layer 2 frames.

For datagrams being sent across the serial WAN connections provided by the service provider, it is likely that protocols and technologies such as High-Level Data Link Control (HDLC), Layer 2 Tunneling Protocol (L2TP), Point-to-Point Protocol (PPP), Point-to-Point Tunneling Protocol (PPTP), Spanning Tree Protocol (STP), and virtual LANs (VLANs) are in operation at Layer 2 (the data link layer). On both the LAN and the WAN, at Layer 3 (the network layer), IPv4 will be used for host addressing and defining networks. The same Layer 1, Layer 2, and Layer 3 infrastructure is also capable of transporting IPv6, if desired.

Inside the Layer 3 IP headers, each packet contains the source and destination addresses, in addition to the information to tell the receiving network device about which Layer 4 transport protocol is encapsulated or carried inside the Layer 3 packet. When a network device receives the packet and opens it up to look at the contents, this process is called *decapsulation*. As the recipient decapsulates and looks at the Layer 4 information, it identifies the application layer protocol or service being used. A segment going to a web server is likely to have a TCP destination port of 80 or 443, depending on whether encryption is being used for a secure connection. A DNS request uses a UDP destination port of 53.

### Summary

Here are the main topics covered in this chapter:

- The ISO’s OSI reference model consists of seven layers: physical (Layer 1), data link (Layer 2), network (Layer 3), transport (Layer 4), session (Layer 5), presentation (Layer 6), and application (Layer 7). The purpose of each layer was presented, along with examples of technologies present at the individual layers, as it pertains to networking.
- The TCP/IP stack was presented as an alternative model to the OSI reference model. The TCP/IP stack consists of four layers: network interface, Internet, transport, and application. These layers were compared with the seven layers of the OSI model.
- Data encapsulation and decapsulation within the OSI model context were covered.
- This chapter also discussed how port numbers are used to associate data at the transport layer with a proper application layer protocol.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 1-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01tab01) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 1-1** Key Topics for [Chapter 1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| List | Layers of the OSI model | 6 |
| [Figure 1-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig03) | PDU Names | 7 |
| [Figure 1-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig04) | Layer 1: The Physical Layer | 7 |
| [Figure 1-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig08) | Layer 2: The Data Link Layer | 12 |
| [Figure 1-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig09) | Layer 3: The Network Layer | 15 |
| [Figure 1-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig10) | Layer 4: The Transport Layer | 17 |
| [Figure 1-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig11) | TCP Sliding Window | 18 |
| [Figure 1-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig12) | Layer 5: The Session Layer | 19 |
| [Figure 1-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig13) | Layer 6: The Presentation Layer | 20 |
| [Figure 1-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig14) | Layer 7: The Application Layer | 21 |
| [Figure 1-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig15) | TCP/IP Stack | 22 |
| [Figure 1-16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig16) | IPv4 Packet Format | 23 |
| [Figure 1-17](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig17) | TCP Segment Format | 24 |
| [Figure 1-18](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig18) | UDP Segment Format | 25 |
| [Figure 1-19](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01fig19) | Example: Port Numbers and IP Addresses | 26 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[application layer (OSI model)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_01)

[application layer (TCP/IP stack)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_02)

[current state modulation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_03)

[cyclic redundancy check (CRC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_04)

[data link layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_05)

[Internet layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_06)

[IP header](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_07)

[maximum transmission unit (MTU)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_08)

[network interface layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_09)

[network layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_010)

[Open Systems Interconnection (OSI) reference model](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_011)

[payload](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_012)

[physical layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_013)

[presentation layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_014)

[protocol data unit (PDU)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_015)

[session layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_016)

[state transition modulation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_017)

[TCP header](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_018)

[TCP flags](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_019)

[TCP/IP stack](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_020)

[time-division multiplexing (TDM)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_021)

[Transmission Control Protocol (TCP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_022)

[transport layer (OSI model)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_023)

[transport layer (TCP/IP stack)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_024)

[UDP header](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_025)

[User Datagram Protocol (UDP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#key_026)

### Additional Resources

**A Review of the OSI Model for Ethical Hackers:** <https://youtu.be/S2OM0IYZcR0?si=uIqE7nV4cNBEX0Wm>

**The OSI Model Challenge:** <https://ajsnetworking.com/osiquiz1>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_1) Which layer of the OSI reference model contains the MAC and LLC sublayers?

1. Network layer
2. Transport layer
3. Physical layer
4. Data link layer

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_2) Which approach to bandwidth usage consumes all the available frequencies on a medium to transmit data?

1. Broadband
2. Baseband
3. Time-division multiplexing
4. Simplex

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_3) Windowing is provided at what layer of the OSI reference model?

1. Data link layer
2. Network layer
3. Transport layer
4. Physical layer

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_4) IP addresses reside at which layer of the OSI reference model?

1. Network layer
2. Session layer
3. Data link layer
4. Transport layer

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_5) Which of the following is a connectionless transport layer protocol?

1. IP
2. TCP
3. UDP
4. SIP

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_6) What setting ultimately controls the size of packets that are moving through the modern network?

1. TTL
2. MTU
3. SSH
4. CSMA/CD

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_7) What is the range of well-known TCP and UDP ports?

1. Below 2048
2. Below 1024
3. 16,384–32,768
4. Above 8192

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_8) What port number is used by HTTPS?

1. 80
2. 443
3. 69
4. 23

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_9) What value is decremented by 1 for each router hop on the network?

1. Count
2. Type
3. TTL
4. Dead timer

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_10) Windowing is a technology that applies to which transport layer protocol?

1. UDP
2. FTP
3. ICMP
4. TCP

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_11) What happens to data as it moves from the upper layers to the lower layers of the OSI model on a host system?

1. The data moves from the physical layer to the application layer.
2. The data is encapsulated with a header at the beginning and a trailer at the end.
3. The header and trailer are stripped off through decapsulation.
4. The data is sent in groups of segments that require two acknowledgments.

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz1_12) Which layer of the OSI reference model is responsible for ensuring that frames do not exceed the maximum transmission unit (MTU) of the physical media?

1. Network layer
2. Transport layer
3. Physical layer
4. Data link layer