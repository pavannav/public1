## Chapter 7

## IPv4 Addressing

This chapter covers the following topics related to Objective 1.7 (Given a scenario, use appropriate IPv4 network addressing) of the CompTIA Network+ N10-009 certification exam:

- Public vs. private

  - [Automatic Private IP Addressing (APIPA)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07lev2sec10)
  - RFC1918
  - Loopback/localhost
- [Subnetting](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07lev1sec5)

  - Variable Length Subnet Mask (VLSM)
  - [Classless Inter-domain Routing (CIDR)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07lev2sec31)
- IPv4 address classes

  - Class A
  - Class B
  - Class C
  - Class D
  - Class E

When two devices on a network want to communicate, they need logical addresses (that is, Layer 3 addresses, as described in [Chapter 1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01), “[The OSI Model and Encapsulation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01)”). Most modern networks use Internet Protocol (IP) addressing. Therefore, the focus of this chapter is IP.

While there are two versions of IP in use today, IP version 4 (IPv4) and IP version 6 (IPv6), this chapter focuses exclusively on IPv4. Even with IPv6 making strides of adoption throughout the Internet, IPv4 will be with us for a long, long time, especially when we consider how well the two versions integrate with each other.

This chapter begins with coverage of how IP addresses are represented in binary notation. You will learn about the structure of an IPv4 address and learn to distinguish between different categories of IPv4 addresses.

Next, this chapter details various options for assigning IP addresses to end stations. As you will see, one of the benefits of IP addressing is that you have flexibility in how you can subdivide a network address into multiple subnets. This discussion of subnetting is a bit mathematical, and multiple practice exercises are provided to help solidify these concepts in your mind.

### Foundation Topics

### Binary Numbering

[Chapter 1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01) describes how a network transmits data as a series of binary 1s and 0s. Similarly, IP addresses are represented as series of binary digits (that is, *bits*). An IPv4 address consists of 32 bits.

Note

An IPv6 address has a whopping 128 bits. As you will learn in [Chapter 8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08), “[Evolving Use Cases](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08),” this four-times expansion of the bits used for addressing creates an incredible number of available addresses for future use.

Later in this chapter, you will need to be able to convert between the decimal representation of a number and that number’s binary equivalent. This skill is needed for things such as subnet mask calculations. This section describes this mathematical procedure and provides you with practice exercises.

#### Principles of Binary Numbering

You are accustomed to using base 10 numbering on a day-to-day basis. In a base 10 numbering system, you have 10 digits, in the range 0 through 9, at your disposal. Binary numbering, however, uses a base 2 numbering system, where there are only two digits: 0 and 1.

Because computer systems divide 32-bit IPv4 addresses into four 8-bit octets each, this discussion focuses on converting between 8-bit binary numbers and decimal numbers. To convert a binary number to decimal, you can create a table like [Table 7-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab01).

![](../images/key_topic_icon_158.jpg)


**Table 7-1** Binary Conversion Table

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

Note the structure of this table. There are eight columns, representing the 8 bits in an octet. The column headings are the powers of 2, from 0 to 7, beginning in the rightmost column. Specifically, 2 raised to the power of 0 (20) is 1. (In fact, any number raised to the power of 0 is 1.) If you raise 2 to the first power (21), that equals 2, and 2 raised to the second power (that is, 22, or 2 × 2) is 4. This continues through 2 raised to the power of 7 (that is, 27, or 2 × 2 × 2 × 2 × 2 × 2 × 2), which equals 128. You can use this table for converting binary numbers to decimal and decimal numbers to binary. The skill of binary-to-decimal and decimal-to-binary conversion is critical for working with subnet masks, as discussed later in this chapter.

#### Converting a Binary Number to a Decimal Number

![](../images/key_topic_icon_158.jpg)

To convert a binary number to a decimal number, you populate the previously described binary table with the given binary digits. Then you add up the column heading values for the columns that contain a binary 1.

For example, consider [Table 7-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab02). Only the 128, 16, 4, and 2 columns contain a 1, and all the other columns contain a 0. If you add all the column headings containing a 1 in their column (that is, 128 + 16 + 4 + 2), you get the result 150. Therefore, you can conclude that the binary number 10010110 equates to the decimal value 150.

**Table 7-2** Binary Conversion Example 1

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0 | 0 | 1 | 0 | 1 | 1 | 0 |

#### Converting a Decimal Number to a Binary Number

![](../images/key_topic_icon_158.jpg)

To convert numbers from decimal to binary, starting with the leftmost column, ask the question, “Is this number equal to or greater than the column heading?” If the answer to that question is no, place a 0 in that column and move to the next column. If the answer is yes, place a 1 in that column and subtract the value of the column heading from the number you are converting. When you then move to the next column (to your right), again ask yourself, “Is this number (which is the result of your earlier subtraction) equal to or greater than the column heading?” This process continues (to the right) for all the remaining column headings.

For example, say that you want to convert the number 167 to binary. The following steps walk you through the process:

**Step 1.** Ask the question, “Is 167 equal to or greater than 128?” Because the answer is yes, you place a 1 in the 128 column, as shown in [Table 7-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab03), and subtract 128 from 167, which yields the result 39.

**Table 7-3** Binary Conversion Example 2: Step 1

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 |  |  |  |  |  |  |  |

**Step 2.** Now that you are done with the 128 column, move (to the right) to the 64 column. Ask the question, “Is 39 equal to or greater than 64?” Because the answer is no, you place a 0 in the 64 column, as shown in [Table 7-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab04), and continue to the next column (the 32 column).

**Table 7-4** Binary Conversion Example 2: Step 2

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0 |  |  |  |  |  |  |

**Step 3.** Under the 32 column, ask the question, “Is 39 equal to or greater than 32?” Because the answer is yes, you place a 1 in the 32 column, as shown in [Table 7-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab05), and subtract 32 from 39, which yields the result 7.

**Table 7-5** Binary Conversion Example 2: Step 3

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0 | 1 |  |  |  |  |  |

**Step 4.** Now you are under the 16 column and ask, “Is 7 equal to or greater than 16?” Because the answer is no, you place a 0 in the 16 column, as shown in [Table 7-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab06), and move to the 8 column.

**Table 7-6** Binary Conversion Example 2: Step 4

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0 | 1 | 0 |  |  |  |  |

**Step 5.** As with the 16 column, the number 7 is not equal to or greater than 8. So, you place a 0 in the 8 column, as shown in [Table 7-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab07).

**Table 7-7** Binary Conversion Example 2: Step 5

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0 | 1 | 0 | 0 |  |  |  |

**Step 6.** Because 7 is greater than or equal to 4, you place a 1 in the 4 column, as shown in [Table 7-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab08), and subtract 4 from 7, yielding 3 as the result.

**Table 7-8** Binary Conversion Example 2: Step 6

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0 | 1 | 0 | 0 | 1 |  |  |

**Step 7.** Now under the 2 column, you ask the question, “Is 3 greater than or equal to 2?” Because the answer is yes, you place a 1 in the 2 column, as shown in [Table 7-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab09), and subtract 2 from 3, yielding 1 as the result.

**Table 7-9** Binary Conversion Example 2: Step 7

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0 | 1 | 0 | 0 | 1 | 1 |  |

**Step 8.** Finally, in the rightmost column (that is, the 1 column), you ask whether the number 1 is greater than or equal to 1. Because it is, you place a 1 in the 1 column, as shown in [Table 7-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab10).

**Table 7-10** Binary Conversion Example 2: Step 8

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0 | 1 | 0 | 0 | 1 | 1 | 1 |

You can now conclude that the decimal number 167 equates to the binary value 10100111. In fact, you can check your work by adding up the values for the column headings that contain a 1 in their column. In this example, the 128, 32, 4, 2, and 1 columns contain a 1. If you add these values, the result is 167 (that is, 128 + 32 + 4 + 2 + 1 = 167).

#### Binary Numbering Practice

Because binary number conversion is a skill developed through practice, you will now be challenged with a few conversion exercises. The first two exercises ask you to convert a binary number to a decimal number, and the last two exercises ask you to convert a decimal number to a binary number.

##### Binary Conversion Exercise 1

Using [Table 7-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab11) as a reference, convert the binary number 01101011 to a decimal number.

**Table 7-11** Binary Conversion Exercise 1: Base Table

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

Write your answer here: \_\_\_\_\_\_\_\_\_\_\_

##### Binary Conversion Exercise 1: Solution

Given the binary number 01101011 and filling in a binary conversion table, as shown in [Table 7-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab12), you find that the 64, 32, 8, 2, and 1 columns contain a 1. Each of the other columns contains a 0. By adding up the column headings for the columns that contain a 1 (that is, 64 + 32 + 8 + 2 + 1), you get the decimal value 107.

**Table 7-12** Binary Conversion Exercise 1: Solution Table

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | 1 | 1 | 0 | 1 | 0 | 1 | 1 |

##### Binary Conversion Exercise 2

Using [Table 7-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab13) as a reference, convert the binary number 10010100 to a decimal number.

**Table 7-13** Binary Conversion Exercise 2: Base Table

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

Write your answer here: \_\_\_\_\_\_\_\_\_\_\_

##### Binary Conversion Exercise 2: Solution

Given the binary number 10010100 and filling in a binary conversion table, as shown in [Table 7-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab14), you find that the 128, 16, and 4 columns contain a 1. Each of the other columns contains a 0. By adding up the column headings for the columns that contain a 1 (that is, 128 + 16 + 4), you get the decimal value 148.

**Table 7-14** Binary Conversion Exercise 2: Solution Table

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0 | 0 | 1 | 0 | 1 | 0 | 0 |

##### Binary Conversion Exercise 3

Using [Table 7-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab15) as a reference, convert the decimal number 49 to a binary number.

**Table 7-15** Binary Conversion Exercise 3: Base Table

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

Write your answer here: \_\_\_\_\_\_\_\_\_\_\_

##### Binary Conversion Exercise 3: Solution

You can begin your conversion of the decimal number 49 to a binary number by asking the following questions and performing the following calculations:

1. Is 49 greater than or equal to 128? No. Put a 0 in the 128 column.
2. Is 49 greater than or equal to 64? No. Put a 0 in the 64 column.
3. Is 49 greater than or equal to 32? Yes. Put a 1 in the 32 column and subtract 32 from 49. 49 – 32 = 17.
4. Is 17 greater than or equal to 16? Yes. Put a 1 in the 16 column and subtract 16 from 17. 17 – 16 = 1.
5. Is 1 greater than or equal to 8? No. Put a 0 in the 8 column.
6. Is 1 greater than or equal to 4? No. Put a 0 in the 4 column.
7. Is 1 greater than or equal to 2? No. Put a 0 in the 2 column.
8. Is 1 greater than or equal to 1? Yes. Put a 1 in the 1 column.

Combining these 8 binary digits, you form the binary number 00110001, as shown in [Table 7-16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab16). Verify your work by adding the values of the column headings whose columns contain a 1. In this case, columns 32, 16, and 1 each contain a 1. By adding these values (that is, 32 + 16 + 1), you get the value 49.

**Table 7-16** Binary Conversion Exercise 3: Solution Table

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | 0 | 1 | 1 | 0 | 0 | 0 | 1 |

##### Binary Conversion Exercise 4

Using [Table 7-17](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab17) as a reference, convert the decimal number 236 to a binary number.

**Table 7-17** Binary Conversion Exercise 4: Base Table

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

Write your answer here: \_\_\_\_\_\_\_\_\_\_\_

##### Binary Conversion Exercise 4: Solution

You can begin your conversion of the decimal number 236 to a binary number by asking the following questions and performing the following calculations:

1. Is 236 greater than or equal to 128? Yes. Put a 1 in the 128 column and subtract 128 from 236. 236 – 128 = 108.
2. Is 108 greater than or equal to 64? Yes. Put a 1 in the 64 column and subtract 64 from 108. 108 – 64 = 44.
3. Is 44 greater than or equal to 32? Yes. Put a 1 in the 32 column and subtract 32 from 44. 44 – 32 = 12.
4. Is 12 greater than or equal to 16? No. Put a 0 in the 16 column.
5. Is 12 greater than or equal to 8? Yes. Put a 1 in the 8 column and subtract 8 from 12. 12 – 8 = 4.
6. Is 4 greater than or equal to 4? Yes. Put a 1 in the 4 column and subtract 4 from 4. 4 – 4 = 0.
7. Is 0 greater than or equal to 2? No. Put a 0 in the 2 column.
8. Is 0 greater than or equal to 1? No. Put a 0 in the 1 column.

By combining these 8 binary digits, you form the binary number 11101100, as shown in [Table 7-18](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab18). You can verify your work by adding the values of the column headings whose columns contain a 1. In this case, columns 128, 64, 32, 8, and 4 each contain a 1. By adding these values (that is, 128 + 64 + 32 + 8 + 4), you get the value 236.

**Table 7-18** Binary Conversion Exercise 4: Solution Table

| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 0 | 1 | 1 | 0 | 0 |

### IPv4 Addressing

Although IPv6 is increasingly being adopted in corporate networks, IPv4 is by far the most popular Layer 3 addressing scheme in today’s networks. For brevity in this section, the term *IPv4 address* is used interchangeably with the more generic term *IP address*.

Devices on an IPv4 network use unique IP addresses to communicate with one another. Metaphorically, you can relate this to sending a letter through the postal service. You place a destination address on an envelope containing the letter, and in the upper-left corner of the envelope, you place your return address. Similarly, when an IPv4 network device sends data on a network, it places both a destination IP address and a source IP address in the packet’s IPv4 header.

#### IPv4 Address Structure

An IPv4 address is a 32-bit address. However, rather than write out each individual bit value, you write the address in dotted-decimal notation. Consider the IP address 10.1.2.3. Notice that this IP address is divided into four separate numbers, separated by periods. Each number represents one-fourth of the IP address. Specifically, each number represents an 8-bit portion of the 32 bits in the address. Because each of these four divisions of an IP address represents 8 bits, these divisions are called *octets*. For example, [Figure 7-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig01) shows the binary representation of the 10.1.2.3 IP address. In [Figure 7-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig01), notice that the 8 leftmost bits of 00001010 equate to the decimal value 10. (The calculation for this is described in the previous section.) Similarly, 00000001 in binary equates to 1 in decimal, and 00000010 in binary equals 2 in decimal. Finally, 00000011 yields the decimal value 3.

![](../images/07fig01.jpg)


**Figure 7-1** Binary Representation of a Dotted-Decimal IP Address

Interestingly, an IP address is composed of two types of addresses: a network address and a host address. Specifically, a group of contiguous left-justified bits represent the network address, and the remaining bits (that is, a group of contiguous right-justified bits) represent the address of a host on a network. The IP address component that determines which bits refer to the network and which bits refer to the host is called the *subnet mask*. You can think of the subnet mask as a dividing line separating an IP address’s 32 bits into a group of network bits (on the left) and a group of host bits (on the right).

A subnet mask typically consists of a series of contiguous 1s followed by a set of contiguous 0s. In total, a subnet mask contains 32 bits, which correspond to the 32 bits found in an IPv4 address. The 1s in a subnet mask correspond to network bits in an IPv4 address, and 0s in a subnet mask correspond to host bits in an IPv4 address.

For example, consider [Figure 7-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig02). The 8 leftmost bits of the subnet mask are 1s, and the remaining 24 bits are 0s. As a result, the 8 leftmost bits of the IP address represent the network address, and the remaining 24 bits represent the host address.

![](../images/key_topic_icon_158.jpg)

![](../images/07fig02.jpg)


**Figure 7-2** Dividing an IP Address into a Network Portion and a Host Portion

When you write a network address, all host bits are set to 0s. Once again, consider the example shown in [Figure 7-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig02). The subnet mask in this example is an *8-bit subnet mask*, meaning that the 8 leftmost bits in the subnet mask are 1s. If the remaining bits are set to 0, as shown in [Figure 7-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig03), the network address is 10.0.0.0.

![](../images/07fig03.jpg)


**Figure 7-3** Network Address Calculation

When writing a network address, or an IP address for that matter, you need to provide more detail than just a dotted-decimal representation of an IP address’s 32 bits. For example, just being told that a device has IP address 10.1.2.3 does not tell you the network on which the IP address resides. To know the network address, you need to know the subnet mask, which could be written in dotted-decimal notation or in prefix notation (also known as *slash notation*). In the example with the IP address 10.1.2.3 and an 8-bit subnet mask, the IP address could be written as 10.1.2.3 255.0.0.0 or 10.1.2.3 /8. Similarly, the network address could be written as 10.0.0.0 255.0.0.0 or 10.0.0.0 /8.

#### Classes of Addresses

Although for an IP address (or a network address) you need subnet mask information to determine which bits represent the network portion of the address, there are default subnet masks with which you should be familiar. The default subnet mask for a given IP address is solely determined by the value in the IP address’s first octet. [Table 7-19](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab19) shows the default subnet masks for various ranges of IP addresses.

![](../images/key_topic_icon_158.jpg)


**Table 7-19** IP Address Classes

| Address Class | Value in First Octet | Classful Mask (Dotted Decimal) | Classful Mask (Prefix Notation) |
| --- | --- | --- | --- |
| Class A | 1–126 | 255.0.0.0 | /8 |
| Class B | 128–191 | 255.255.0.0 | /16 |
| Class C | 192–223 | 255.255.255.0 | /24 |
| Class D | 224–239 | — | — |
| Class E | 240–255 | — | — |

These IP address ranges, which you should memorize, are referred to as the different [***IPv4 address classes***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_348). [***Class A***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_137), [***Class B***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_138), and [***Class C***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_139) addresses are assigned to network devices. [***Class D***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_140) addresses are used as destination IP addresses (that is, not assigned to devices sourcing traffic) for multicast networks, and [***Class E***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_141) addresses are reserved for experimental use. The default subnet masks associated with address Classes A, B, and C are called *classful masks*.

For example, consider the IP address 172.16.40.56. If you are told that this IP address uses its classful mask, you should know that it has subnet mask 255.255.0.0, which is the classful mask for a Class B IP address. You should know that 172.16.40.56 is a Class B IP address, based on the value of the first octet (172), which falls in the Class B range 128–191.

Note

You might have noticed that in the ranges of values in the first octet, the number 127 seems to have been skipped. The reason is that 127 is used as a [***loopback***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_393) IP address, which is a locally significant IP address representing the device itself. For example, if you are working on a network device and want to verify that the device has a TCP/IP stack loaded, you can try to ping IP address 127.0.0.1. If you receive ping responses, you can conclude that the device is running a TCP/IP stack. To make this testing even more convenient, most computer operating systems automatically resolve the name [***localhost***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_384) to 127.0.0.1.

The nonprofit corporation Internet Corporation for Assigned Names and Numbers (ICANN) globally manages publicly routable IP addresses. ICANN does not directly assign a block of IP addresses to your Internet service provider (ISP) but rather assigns a block of IP addresses to a regional Internet registry. One example of a regional Internet registry is the American Registry for Internet Numbers (ARIN), which acts as an Internet registry for North America.

The Internet Assigned Numbers Authority (IANA) is yet another entity responsible for IP address assignment. ICANN operates IANA and is responsible for IP address assignment outside North America.

Note

Some literature references the *Internet Network Information Center* (*InterNIC*), which was the predecessor to ICANN and existed until September 18, 1998.

When an organization is assigned one or more publicly routable IP addresses by its service provider, that organization often needs more IP addresses to accommodate all of its devices. One solution is to use [***private IP addressing***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_524) within an organization, in combination with network address translation (NAT).

Specific Class A, B, and C networks have been designated for private use. Although these networks are routable (with the exception of the 169.254.0.0–169.254.255.255 address range) within the organization, ISPs do not route these private networks over the public Internet. These private IP address ranges are often referred to as [***RFC1918***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_557) addresses. This is due to the Request for Comments document that helped to make them a reality in networking today. [Table 7-20](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab20) shows the IP networks reserved for internal use.

![](../images/key_topic_icon_158.jpg)


**Table 7-20** Private IP Networks

| Address Class | Address Range | Default Subnet Mask |
| --- | --- | --- |
| Class A | 10.0.0.0–10.255.255.255 | 255.0.0.0 |
| Class B | 172.16.0.0–172.31.255.255 | 255.255.0.0 |
| Class B | 169.254.0.0–169.254.255.255 | 255.255.0.0 |
| Class C | 192.168.0.0–192.168.255.255 | 255.255.255.0 |

Note

The 169.254.0.0–169.254.255.255 address range is not routable. Addresses in this range are only usable on their local subnet and are dynamically assigned to network hosts using Automatic Private IP Addressing (APIPA), which is discussed later in this chapter.

NAT, which is available on routers, allows private IP addresses used within an organization to be translated into a pool of one or more publicly routable IP addresses.

### Assigning IPv4 Addresses

At this point in the discussion, you should understand that networked devices need IP addresses. However, beyond just an IP address, what extra IP address–related information needs to be provided to a device, and how does an IP address get assigned to a device?

This section begins by discussing various parameters that might be assigned to a network device, followed by discussions covering various approaches to assigning IP addresses to devices.

#### IP Addressing Components

As discussed in the previous section, an IP address has two portions: a network portion and a host portion. A subnet mask is required to delineate between these two portions.

In addition, if traffic is destined for a different subnet than the subnet on which the traffic originates, a default gateway needs to be defined. A default gateway routes traffic from the sender’s subnet toward the destination subnet. [Chapter 9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09), “[Routing Technologies](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09),” covers the concept of routing.

Another consideration is that end users typically do not type in the IP address of the destination device with which they want to connect (for example, a web server on the Internet). Instead, end users typically type in fully qualified domain names (FQDNs), such as [www.ajsnetworking.com](http://www.ajsnetworking.com/). When connecting to devices on the public Internet, a Domain Name System (DNS) server translates an FQDN into the corresponding IP address.

For a very long time, in a company’s internal network (that is, an intranet), a Microsoft Windows Internet Name Service (WINS) was used to convert the names of network devices into their corresponding IP addresses. For example, say that you attempted to navigate to the shared folder \\server1\hrdocs. A WINS server could be used to resolve the network device name server1 to a corresponding IP address. The path \\server1\hrdocs is in *universal naming convention* (*UNC*) form, where you are specifying a network device name (in this case, server1) and a resource available on that device (in this case, hrdocs). Companies today use DNS even for internal network name resolution.

To summarize, network devices (for example, an end-user PC) can benefit from a variety of IP address parameters, such as the following:

- IP address
- Subnet mask
- Default gateway
- Server address

#### Static Configuration

A simple way of configuring a PC with, for example, IP address parameters is to statically configure that information. For example, on a PC running Microsoft Windows as the operating system, you can navigate to the Control Panel, as shown in [Figure 7-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig04), and click **Network and Internet**.

![](../images/07fig04.jpg)


**Figure 7-4** Windows Control Panel

In the Network and Internet control panel, click **Network and Sharing Center**, as shown in [Figure 7-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig05).

![](../images/07fig05.jpg)


**Figure 7-5** Network and Internet Control Panel

You can then click the **Change adapter settings** link, as shown in [Figure 7-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig06).

![](../images/07fig06.jpg)


**Figure 7-6** Network and Sharing Center

In the Network Connections window, double-click the network adapter whose settings you want to change, as shown in [Figure 7-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig07).

![](../images/07fig07.jpg)


**Figure 7-7** Network Connections Window

You are then taken to the Local Area Connection Status window, as shown in [Figure 7-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig08), where you can click the **Properties** button.

![](../images/07fig08.jpg)


**Figure 7-8** Local Area Connection Status Window

As shown in [Figure 7-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig09), you can highlight **Internet Protocol Version 4 (TCP/IPv4)** and click the **Properties** button.

![](../images/07fig09.jpg)


**Figure 7-9** Local Area Connection Properties

You can enter an IP address, a subnet mask, a default gateway, and DNS server information into the Internet Protocol Version 4 (TCP/IPv4) Properties window, shown in [Figure 7-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig10). Although DNS server information can be entered in this window, more advanced DNS options are available by clicking the **Advanced** button.

![](../images/07fig10.jpg)


**Figure 7-10** Internet Protocol Version 4 (TCP/IPv4) Properties

By clicking the **DNS** tab in the Advanced TCP/IP Settings window, as shown in [Figure 7-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig11), you can add, remove, or reorder DNS servers, and you can adjust various other DNS parameters. Recall that a DNS server converts an FQDN to an IP address.

![](../images/07fig11.jpg)


**Figure 7-11** Advanced TCP/IP Settings: DNS Tab

#### Dynamic Configuration

Statically assigning IP address information to individual networked devices can be time-consuming, error-prone, and lacking in scalability. Instead of using static IP address assignments, many corporate networks dynamically assign IP address parameters to their devices. An early choice for performing this automatic assignment of IP addresses was the *Bootstrap Protocol (BOOTP)*. Currently, however, the most popular approach for dynamic IP address assignment is *Dynamic Host Configuration Protocol (DHCP)*. We cover DHCP in detail for you in [Chapter 16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16), “[IPv4 and IPv6 Network Services](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16).”

#### Automatic Private IP Addressing

If a networked device does not have a statically configured IP address and is unable to contact a DHCP server, it still might be able to communicate on an IP network thanks to [***Automatic Private IP Addressing (APIPA)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_073). The APIPA feature allows a networked device to self-assign an IP address from the 169.254.0.0/16 network. Note that this address is usable only on the device’s local subnet. (The IP address is not routable.)

As shown in [Figure 7-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig12), Microsoft Windows 11 defaults to APIPA if a client is configured to automatically obtain IP address information and that client fails to obtain IP address information from a DHCP server.

![](../images/07fig12.jpg)


**Figure 7-12** APIPA Configuration Enabled by Default

### Subnetting

Earlier in this chapter, you were introduced to the purpose of a subnet mask and the default subnet masks for the various IP address classes. Default subnet masks (that is, classful subnet masks) are not always the most efficient choice. Fortunately, you can add additional network bits to a subnet mask (thereby extending the subnet mask) to create subnets within a classful network. We refer to this process as [***subnetting***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_666) and this section explains why you might want to perform this process and describes how you mathematically perform subnet calculations.

#### Purpose of Subnetting

Consider the number of assignable IP addresses in the various classes of IP addresses shown in [Table 7-21](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab21). Recall that the host bits of an IP address cannot be all 0s (which represents the network address) or all 1s (which represents the directed broadcast address). Therefore, the number of assignable IP addresses in a subnet can be determined by the following formula:

![](../images/key_topic_icon_158.jpg)


**Table 7-21** Assignable IP Addresses

| Address Class | Assignable IP Addresses |
| --- | --- |
| Class A | 16,777,214 (224 – 2) |
| Class B | 65,534 (216 – 2) |
| Class C | 254 (28 – 2) |

Number of assignable IP addresses in a subnet = 2*h* – 2

where *h* is the number of host bits in a subnet mask.

Suppose that you decide to use a private Class B IP address (for example, 172.16.0.0/16) for your internal IP addressing. For performance reasons, you would not want to support as many as 65,534 hosts in a single broadcast domain. Therefore, a best practice with such a network address is to subnet the network (thereby extending the number of network bits in the network’s subnet mask) into additional subnetworks. In fact, you could subnet your major network address space and then further subnet one of your unused subnet addresses! This practice, known as [***Variable-Length Subnet Masking (VLSM)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_736), enables you to design the network the best way possible in terms of the number of IP addresses required in different areas. Of course, this network also uses a variety of subnet masks to accomplish this task.

#### Subnet Mask Notation

As previously mentioned, the number of bits in a subnet mask can be represented in dotted-decimal notation (for example, 255.255.255.0) or in prefix notation (for example, /24). As a reference, [Table 7-22](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab22) shows valid subnet masks in dotted-decimal notation and the corresponding prefix notation.

![](../images/key_topic_icon_158.jpg)


**Table 7-22** Dotted-Decimal and Prefix-Notation Representations for IPv4 Subnets

| Dotted-Decimal Notation | Prefix Notation |
| --- | --- |
| 255.0.0.0 | /8 (classful subnet mask for Class A networks) |
| 255.128.0.0 | /9 |
| 255.192.0.0 | /10 |
| 255.224.0.0 | /11 |
| 255.240.0.0 | /12 |
| 255.248.0.0 | /13 |
| 255.252.0.0 | /14 |
| 255.254.0.0 | /15 |
| 255.255.0.0 | /16 (classful subnet mask for Class B networks) |
| 255.255.128.0 | /17 |
| 255.255.192.0 | /18 |
| 255.255.224.0 | /19 |
| 255.255.240.0 | /20 |
| 255.255.248.0 | /21 |
| 255.255.252.0 | /22 |
| 255.255.254.0 | /23 |
| 255.255.255.0 | /24 (classful subnet mask for Class C networks) |
| 255.255.255.128 | /25 |
| 255.255.255.192 | /26 |
| 255.255.255.224 | /27 |
| 255.255.255.240 | /28 |
| 255.255.255.248 | /29 |
| 255.255.255.252 | /30 |

Recall that any octet with a value of 255 contains eight 1s. Also, you should memorize valid octet values for an octet and the corresponding number of 1s (that is, continuous, left-justified 1s) in that octet, as shown in [Table 7-23](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab23). Based on this information, you should be able to see the dotted-decimal notation of a subnet mask and quickly determine the corresponding prefix notation.

![](../images/key_topic_icon_158.jpg)


**Table 7-23** Subnet Octet Values

| Subnet Octet Value | Number of Contiguous Left-Justified 1s |
| --- | --- |
| 0 | 0 |
| 128 | 1 |
| 192 | 2 |
| 224 | 3 |
| 240 | 4 |
| 248 | 5 |
| 252 | 6 |
| 254 | 7 |
| 255 | 8 |

For example, consider the subnet mask 255.255.192.0. Because each of the first two octets has a value of 255, you know that you have sixteen 1s from the first two octets. You then recall that a value of 192 in the third octet requires two 1s from that octet. By adding the sixteen 1s from the first two octets to the two 1s from the third octet, you can determine that the subnet mask 255.255.192.0 has the corresponding prefix notation /18.

To help you develop the skill of making these calculations quickly, work through the following two exercises.

#### Subnet Notation: Practice Exercise 1

Given the subnet mask 255.255.255.248, what is the corresponding prefix notation? \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Subnet Notation: Practice Exercise 1 Solution

Given the subnet mask 255.255.255.248, you should recognize that the first three octets, each containing a value of 255, represent twenty-four 1s. To those twenty-four 1s, you add five additional 1s, based on your memorization of how many contiguous, left-justified 1s in an octet are required to produce various octet values. The sum of 24 bits (from the first three octets) and the 5 bits (from the fourth octet) gives you a total of 29 bits. Therefore, you can conclude that a subnet mask with dotted-decimal notation 255.255.255.248 has equivalent prefix notation /29.

#### Subnet Notation: Practice Exercise 2

Given the subnet mask /17, what is the corresponding dotted-decimal notation? \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

#### Subnet Notation: Practice Exercise 2 Solution

You know that each octet contains 8 bits. So, given the subnet mask /17, you can count by 8s to determine that there are eight 1s in the first octet, eight 1s in the second octet, and one 1 in the third octet. You already knew that an octet containing all 1s has the decimal value 255. From that knowledge, you conclude that each of the first two octets has the value 255. Also, based on your memorization of [Table 7-23](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab23), you know that one 1 (that is, a left-justified 1) in an octet has the decimal equivalent value 128. Therefore, you can conclude that a subnet mask with prefix notation /17 can be represented in dotted-decimal notation as 255.255.128.0.

#### Extending a Classful Mask

The way to take a classful network (that is, a network using a classful subnet mask) and divide that network into multiple subnets is by adding 1s to the network’s classful subnet mask. However, the class of the IP address does not change, regardless of the new subnet mask. For example, if you took the 172.16.0.0/16 network and subnetted it into multiple networks using a 24-bit subnet mask (172.16.0.0/24, 172.16.1.0/24, 172.16.2.0/24, …), those networks would still be Class B networks.

Specifically, the class of a network is entirely determined by the value of the first octet. The class of a network has nothing to do with the number of bits in a subnet, which makes this an often-misunderstood concept. For example, the network 10.2.3.0/24 has the subnet mask of a Class C network (that is, a 24-bit subnet mask). However, the 10.2.3.0/24 network is a Class A network because the value of the first octet is 10. It is simply a Class A network that happens to have a 24-bit subnet mask.

#### Borrowed Bits

When you add bits to a classful mask, the bits you add are referred to as *borrowed bits*. The number of borrowed bits you use determines how many subnets are created and the number of usable hosts per subnet.

#### Calculating the Number of Created Subnets

To determine the number of subnets created when adding bits to a classful mask, you can use the following formula:

Number of created subnets = 2*s*

![](../images/key_topic_icon_158.jpg)

where *s* is the number of borrowed bits.

For example, let’s say you subnetted the 192.168.1.0 network with a 28-bit subnet mask, and you want to determine how many subnets were created. First, you determine how many borrowed bits you have. Recall that the number of borrowed bits is the number of bits in a subnet mask beyond the classful mask. In this case, because the first octet in the network address has the value 192, you can conclude that this is a Class C network. Also recall that a Class C network has 24 bits in its classful (that is, its default) subnet mask. Because you now have a 28-bit subnet mask, the number of borrowed bits can be calculated as follows:

![](../images/key_topic_icon_158.jpg)

Number of borrowed bits = Bits in custom subnet mask – Bits in classful subnet mask

Number of borrowed bits = 28 – 24 = 4

Now that you know you have 4 borrowed bits, you can raise 2 to the power of 4 (24, or 2 × 2 × 2 × 2), which equals 16. From this calculation, you conclude that subnetting 192.168.1.0/24 with a 28-bit subnet mask yields 16 subnets.

#### Calculating the Number of Available Hosts

Earlier in this section, you saw the formula for calculating the number of available (that is, assignable) host IP addresses, based on the number of host bits in a subnet mask. Here again is the formula:

![](../images/key_topic_icon_158.jpg)

Number of assignable IP addresses in a subnet = 2*h* – 2

where *h* is the number of host bits in the subnet mask.

Using the previous example, let’s say you want to determine the number of available host IP addresses in one of the 192.168.1.0/28 subnets. First, you need to determine the number of host bits in the subnet mask. Because you know that an IPv4 address consists of 32 bits, you can subtract the number of bits in the subnet mask (28, in this example) from 32 to determine the number of host bits:

![](../images/key_topic_icon_158.jpg)

Number of host bits = 32 – Number of bits in subnet mask

Number of host bits = 32 – 28 = 4

Now that you know the number of host bits, you can apply it to the previously presented formula:

![](../images/key_topic_icon_158.jpg)

Number of assignable IP addresses in a subnet = 2*h* – 2

where *h* is the number of host bits in the subnet mask.

Number of assignable IP addresses in a subnet = 24 – 2 = 14

From this calculation, you can conclude that each of the 192.168.1.0/28 subnets has 14 usable IP addresses.

To reinforce your skill with these calculations, you are now challenged with a few practice exercises.

#### Basic Subnetting Practice: Exercise 1

Using a separate sheet of paper, solve the following scenario:

Your company has been assigned the 172.20.0.0/16 network for use at one of its sites. You need to use a subnet mask that will accommodate 47 subnets while simultaneously accommodating the maximum number of hosts per subnet. What subnet mask will you use?

#### Basic Subnetting Practice: Exercise 1 Solution

To determine how many borrowed bits are required to accommodate 47 subnets, you can write out a table that lists the powers of 2, as shown in [Table 7-24](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab24). In fact, you might want to sketch out a similar table on the dry-erase card (or electronic notepad) you are given when you take the CompTIA Network+ exam.

![](../images/key_topic_icon_158.jpg)


**Table 7-24** Number of Subnets Created by a Specified Number of Borrowed Bits

| Borrowed Bits | Number of Subnets Created (2*s*, Where *s* Is the Number of Borrowed Bits) |
| --- | --- |
| 0 | 1 |
| 1 | 2 |
| 2 | 4 |
| 3 | 8 |
| 4 | 16 |
| 5 | 32 |
| 6 | 64 |
| 7 | 128 |
| 8 | 256 |
| 9 | 512 |
| 10 | 1024 |
| 11 | 2048 |
| 12 | 4096 |

In this example, where you want to support 47 subnets, 5 borrowed bits are not enough, and 6 borrowed bits are more than enough. Because 5 borrowed bits are not enough, you round up and use 6 borrowed bits.

The first octet in the network address 172.20.0.0 has the value 172, which means you are dealing with a Class B address. Because a Class B address has 16 bits in its classful mask, you can add the 6 borrowed bits to the 16-bit classful mask, which results in a 22-bit subnet mask.

One might argue that although a 22-bit subnet mask would accommodate 47 subnets, so would a 23-bit subnet mask or a 24-bit subnet mask. Although that is true, recall that the scenario said you should have the maximum number of hosts per subnet. This suggests that you should not use more borrowed bits than necessary. Therefore, you can conclude that to meet the scenario’s requirements, you should use a subnet mask of /22, which could also be written as 255.255.252.0.

#### Basic Subnetting Practice: Exercise 2

Using a separate sheet of paper, solve the following scenario:

Your company has been assigned the 172.20.0.0/16 network for use at one of its sites. You need to calculate a subnet mask that will accommodate 100 hosts per subnet while maximizing the number of available subnets. What subnet mask will you use?

#### Basic Subnetting Practice: Exercise 2 Solution

To determine how many host bits are required to accommodate 100 hosts, you can write out a table that shows the number of hosts supported by a specific number of hosts bits, as shown in [Table 7-25](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab25). As with the previous example, you might want to sketch out a similar table on the dry-erase card (or electronic notepad) you are given when taking the Network+ exam.

![](../images/key_topic_icon_158.jpg)


**Table 7-25** Number of Supported Hosts, Given a Specified Number of Host Bits

| Host Bits | Number of Supported Hosts (2*h* – 2, Where *h* Is the Number of Host Bits) |
| --- | --- |
| 2 | 2 |
| 3 | 6 |
| 4 | 14 |
| 5 | 30 |
| 6 | 62 |
| 7 | 126 |
| 8 | 254 |
| 9 | 510 |
| 10 | 1022 |
| 11 | 2046 |
| 12 | 4094 |

In this example, where you want to support 100 hosts, 6 host bits are not enough, and 7 host bits are more than enough. Because 6 host bits are not enough, you round up and use 7 host bits.

Because an IPv4 address has 32 bits and you need 7 host bits, you can calculate the number of subnet bits by subtracting the 7 host bits from 32 (that is, the total number of bits in an IPv4 address). This results in a 25-bit subnet mask (that is, 32 total bits – 7 host bits = 25 subnet mask bits). Therefore, you can conclude that to meet the scenario’s requirements, you should use a subnet mask of /25, which could also be written as 255.255.255.128.

#### Calculating New IP Address Ranges

Now that you can calculate the number of subnets created based on a given number of borrowed bits, the next logical step is to calculate the IP address ranges making up those subnets. For example, if you subnetted 172.25.0.0/16 with a 24-bit subnet mask, the resulting subnets would be as follows:

172.25.0.0/24

172.25.1.0/24

172.25.2.0/24

…

172.25.255.0/24

Let’s consider how such a calculation is performed. Notice in the previous example that you count by 1 in the third octet to calculate the new networks. To decide in what octet you start counting and by what increment you count, a new term needs to be defined. The *interesting octet* is the octet that contains the last 1 in the subnet mask.

In this example, the subnet mask is a 24-bit subnet mask, which has the dotted-decimal equivalent 255.255.255.0 and the binary equivalent 11111111.11111111.11111111.00000000. From any of these subnet mask representations, you can determine that the third octet is the octet to contain the last 1 in the subnet mask. Therefore, you will be changing the value of the third octet to calculate the new networks.

Now that you know the third octet is the interesting octet, you need to know by what increment you will be counting in that octet. This increment is known as the *block size*, and you can calculate it by subtracting the subnet mask value in the interesting octet from 256. In this example, the subnet mask has the value 255 in the interesting octet (that is, the third octet). If you subtract 255 from 256, you get the result 1 (that is, 256 – 255 = 1). The first subnet is the original network address, with all of the borrowed bits set to 0. After this first subnet, you start counting by the block size (1 in this example) in the interesting octet to calculate the remainder of the subnets.

The process just described for calculating subnets can be summarized as follows:

![](../images/key_topic_icon_158.jpg)

**Step 1.** Determine the interesting octet by determining the last octet in the subnet mask to contain a 1.

**Step 2.** Determine the block size by subtracting the decimal value in the subnet’s interesting octet from 256.

**Step 3.** Determine the first subnet by setting all the borrowed bits (which are bits in the subnet mask beyond the bits in the classful subnet mask) to 0.

**Step 4.** Determine additional subnets by taking the first subnet and counting by the block size increment in the interesting octet.

To reinforce this procedure, consider another example. Say that a 27-bit subnet mask is applied to the network address 192.168.10.0/24. To calculate the created subnets, you can perform the following steps:

**Step 1.** The subnet mask /27 (in binary) is 11111111.11111111.11111111.11100000. The interesting octet is the fourth octet because the fourth octet contains the last 1 in the subnet mask.

**Step 2.** The decimal value of the fourth octet in the subnet mask is 224 (11100000 in decimal). Therefore, the block size is 32 (256 – 224 = 32).

**Step 3.** The first subnet is 192.168.10.0/27—the value of the original 192.168.10.0 network with the borrowed bits (the first 3 bits in the fourth octet) set to 0.

**Step 4.** Counting by 32 (the block size) in the interesting octet (the fourth octet) allows you to calculate the remaining subnets:

192.168.10.0

192.168.10.32

192.168.10.64

192.168.10.96

192.168.10.128

192.168.10.160

192.168.10.192

192.168.10.224

Now that you know the subnets created from a classful network given a subnet mask, the next logical step is to determine the usable addresses within those subnets. Recall that you cannot assign an IP address to a device if all the host bits in the IP address are set to 0 because an IP address with all host bits set to 0 is the address of the subnet itself. Similarly, you cannot assign an IP address to a device if all the host bits in the IP address are set to 1 because an IP address with all host bits set to 1 is the directed broadcast address of a subnet.

By excluding the network and directed broadcast addresses from the 192.168.10.0/27 subnets (as previously calculated), you can determine the usable addresses shown in [Table 7-26](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab26).

![](../images/key_topic_icon_158.jpg)


**Table 7-26** Usable IP Address Ranges for the 192.168.10.0/27 Subnets

| Subnet Address | Directed Broadcast Address | Usable IP Addresses |
| --- | --- | --- |
| 192.168.10.0 | 192.168.10.31 | 192.168.10.1–192.168.10.30 |
| 192.168.10.32 | 192.168.10.63 | 192.168.10.33–192.168.10.62 |
| 192.168.10.64 | 192.168.10.95 | 192.168.10.65–192.168.10.94 |
| 192.168.10.96 | 192.168.10.127 | 192.168.10.97–192.168.10.126 |
| 192.168.10.128 | 192.168.10.159 | 192.168.10.129–192.168.10.158 |
| 192.168.10.160 | 192.168.10.191 | 192.168.10.161–192.168.10.190 |
| 192.168.10.192 | 192.168.10.223 | 192.168.10.193–192.168.10.222 |
| 192.168.10.224 | 192.168.10.255 | 192.168.10.225–192.168.10.254 |

To help develop your subnet-calculation skills, you are now challenged with a few practice subnetting exercises.

#### Advanced Subnetting Practice: Exercise 1

Using a separate sheet of paper, solve the following scenario:

Based on your network design requirements, you determine that you should use a 26-bit subnet mask applied to your 192.168.0.0/24 network. You now need to calculate each of the created subnets. In addition, you want to know the broadcast address and the range of usable addresses for each of the created subnets.

#### Advanced Subnetting Practice: Exercise 1 Solution

As described earlier, you can go through the following four-step process to determine the subnet address:

**Step 1.** The subnet mask /26 (in binary) is 11111111.11111111.11111111.11000000. The interesting octet is the fourth octet because the fourth octet contains the last 1 in the subnet mask.

**Step 2.** The decimal value of the fourth octet in the subnet mask is 192 (11000000 in decimal). Therefore, the block size is 64 (256 – 192 = 64).

**Step 3.** The first subnet is 192.168.0.0/26—the value of the original 192.168.0.0 network with the borrowed bits (the first 2 bits in the last octet) set to 0.

**Step 4.** Counting by 64 (the block size) in the interesting octet (the fourth octet) allows you to calculate the remaining subnets, resulting in the following subnets:

192.168.0.0

192.168.0.64

192.168.0.128

192.168.0.192

The directed broadcast addresses for each of these preceding subnets can be calculated by adding 63 (that is, one less than the block size) to the interesting octet for each subnet address. Excluding the subnet addresses and directed broadcast addresses, you can calculate a range of usable addresses, the results of which are shown in [Table 7-27](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab27).


**Table 7-27** Usable IP Address Ranges for the 192.168.0.0/26 Subnets

| Subnet Address | Directed Broadcast Address | Usable IP Addresses |
| --- | --- | --- |
| 192.168.0.0 | 192.168.0.63 | 192.168.0.1–192.168.0.62 |
| 192.168.0.64 | 192.168.0.127 | 192.168.0.65–192.168.0.126 |
| 192.168.0.128 | 192.168.0.191 | 192.168.0.129–192.168.0.190 |
| 192.168.0.192 | 192.168.0.255 | 192.168.0.193–192.168.0.254 |

#### Advanced Subnetting Practice: Exercise 2

Using a separate sheet of paper, solve the following scenario:

In the network shown in [Figure 7-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig13), the 172.16.0.0/16 network is subnetted using a 20-bit subnet mask. Notice that two VLANs (two subnets) are configured; however, one of the client PCs is assigned an IP address that is not in that PC’s VLAN. Which client PC is assigned an incorrect IP address?

![](../images/07fig13.jpg)


**Figure 7-13** Topology for Advanced Subnetting Practice: Exercise 2

#### Advanced Subnetting Practice: Exercise 2 Solution

To determine which client PC is assigned an IP address outside its local VLAN, you need to determine the subnets created by the 20-bit subnet mask applied to the 172.16.0.0/16 network:

**Step 1.** The interesting octet for a 20-bit subnet mask is the third octet because the third octet is the last octet to contain a 1 in the 20-bit subnet mask (11111111.11111111.11110000.00000000, which could also be written as 255.255.240.0).

**Step 2.** The decimal value of the third octet in the subnet mask is 240. Therefore, the block size is 16 (256 – 240 = 16).

**Step 3.** The first 172.16.0.0/20 subnet is 172.16.0.0 (172.16.0.0/20 with the 4 borrowed bits in the third octet set to 0).

**Step 4.** Beginning with the first subnet, 172.16.0.0/20, and counting by the block size 16 in the interesting octet yields the following subnets:

172.16.0.0/20

172.16.16.0/20

172.16.32.0/20

172.16.48.0/20

172.16.64.0/20

172.16.80.0/20

172.16.96.0/20

172.16.112.0/20

172.16.128.0/20

172.16.144.0/20

172.16.160.0/20

172.16.176.0/20

172.16.192.0/20

172.16.208.0/20

172.16.224.0/20

172.16.240.0/20

Based on the IP addresses of the router interfaces, you can figure out the subnets for VLAN A and VLAN B. Specifically, the router interface in VLAN A has the IP address 172.16.90.255/20. Based on the previous listing of subnets, you can determine that this interface resides in the 172.16.80.0/20 network, whose range of usable addresses is 172.16.80.1–172.16.95.254. Then you can examine the IP addresses of Client 1 and Client 2 to determine whether their IP addresses reside in that range of usable addresses.

Similarly, for VLAN B, the router’s interface has an IP address of 172.16.208.255/20. Based on the previous subnet listing, you notice that this interface has an IP address that is part of the 172.16.208.0/20 subnet. As you did for VLAN A, you can check the IP address of Client 3 and Client 4 to decide whether their IP addresses live in VLAN B’s range of usable IP addresses (that is, 172.16.208.1–172.16.223.254). [Table 7-28](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab28) shows these comparisons.

**Table 7-28** IP Address Comparison for Advanced Subnetting Practice: Exercise 2

| Client | VLAN | Range of Usable Addresses | Client IP Address | Is Client in Range of Usable Addresses? |
| --- | --- | --- | --- | --- |
| Client 1 | A | 172.16.80.1–172.16.95.254 | 172.16.80.2 | Yes |
| Client 2 | A | 172.16.80.1–172.16.95.254 | 172.16.95.7 | Yes |
| Client 3 | B | 172.16.208.1–172.16.223.254 | 172.16.206.5 | No |
| Client 4 | B | 172.16.208.1–172.16.223.254 | 172.16.223.1 | Yes |

The comparison in [Table 7-28](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab28) reveals that Client 3 (with IP address 172.16.206.5) does not have an IP address in VLAN B’s subnet (with the usable address range 172.16.208.1–172.16.223.254).

#### Additional Practice

If you want to continue practicing these concepts, make up your own subnet mask and apply it to a classful network of your choosing. Then you can calculate the created subnets, the directed broadcast IP address for each subnet, and the range of usable IP addresses for each subnet.

To check your work, you can use a subnet calculator. An example of such a calculator is the free Advanced Subnet Calculator, available for download from <https://www.solarwinds.com/free-tools/advanced-subnet-calculator>, as shown in [Figure 7-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig14).

![](../images/07fig14.jpg)


**Figure 7-14** Free Advanced Subnet Calculator

Note

As you read through different networking literature, you might come across other approaches to performing subnetting. Various shortcuts exist (including the one presented in this chapter), and some approaches involve much more binary math. The purpose of this section is not to provide an exhaustive treatment of all available subnetting methods but to show a quick and easy approach to performing subnet calculations in the real world and for the Network+ certification exam.

#### Classless Inter-domain Routing

Whereas subnetting is the process of extending a classful subnet mask (that is, adding 1s to a classful mask), [***classless inter-domain routing (CIDR)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_143) does just the opposite. Specifically, CIDR shortens a classful subnet mask by removing 1s from the classful mask. As a result, CIDR allows contiguous classful networks to be aggregated. This process is sometimes called *route aggregation*.

A typical use of CIDR is by a service provider summarizing multiple Class C networks that are assigned to the provider’s various customers. For example, imagine that a service provider is responsible for advertising the following Class C networks:

192.168.32.0/24

192.168.33.0/24

192.168.34.0/24

192.168.35.0/24

The service provider could advertise all four networks with the single route advertisement 192.168.32.0/22. To calculate this advertisement, convert the values in the third octet (that is, the octet where the values start to differ) to binary, as shown in [Figure 7-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig15). Then determine how many bits the networks have in common. The number of common bits then becomes the number of bits in the CIDR mask.

![](../images/key_topic_icon_158.jpg)

![](../images/07fig15.jpg)


**Figure 7-15** CIDR Calculation Example

Because all four of the network addresses have the first 22 bits in common, and because setting the remaining bits to 0 (11000000.10101000.00100000.00000000) creates the network address 192.168.32.0, these networks can be summarized as 192.168.32.0/22.

### Real-World Case Study

Acme, Inc. has decided to use private IP addresses for its internal LAN and for the WAN. The company will use the private block 10.0.0.0/8 and create enough subnets to cover the number of virtual local area networks (VLANs) it will be using at the headquarters site and at each of the remote offices. The association between the Layer 2 VLANs and the Layer 3 IP subnets will be one-to-one, with each VLAN having its own associated subnet.

The company will have nine VLANs and will use a couple subnets for the WAN connections. For the VLANs, the company plans to use the network mask /12, which will offer enough subnets to meet its needs based on the starting mask /8 for the Class A private address 10.0.0.0/8.

For the WAN connectivity Acme is purchasing from a service provider for connectivity between the remote branch offices and the headquarters site, the company will use /30 masks, which will allow for two hosts on each of the WAN connections. This is enough for each device at the end of the point-to-point WAN connections.

To connect its LANs to the Internet, Acme plans to use NAT, which is going to be performed by its service provider so that traffic going to the Internet will appear to be coming from a globally routable IP address and not from a private address. (You’ll learn more about NAT in [Chapter 9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09).)

### Summary

Here are the main topics covered in this chapter:

- A binary math tutorial was provided in this chapter to give you a basic understanding of why binary math is necessary for working with subnet masks.
- The characteristics of IPv4 were presented in this chapter, including IPv4’s address format.
- This chapter examined various approaches for assigning IP address information to network devices, including static assignment, dynamic assignment, and APIPA.
- Finally, this chapter provided multiple examples and practice exercises for various subnet calculations.

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 7-29](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab29) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 7-29** Key Topics for [Chapter 7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| [Table 7-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab01) | Binary Conversion Table | 164 |
| Section | Converting a Binary Number to a Decimal Number | 165 |
| Section | Converting a Decimal Number to a Binary Number | 165 |
| [Figure 7-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig02) | Dividing an IP Address into a Network Portion and a Host Portion | 172 |
| [Table 7-19](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab19) | IP Address Classes | 173 |
| [Table 7-20](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab20) | Private IP Networks | 174 |
| [Table 7-21](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab21) | Assignable IP Addresses | 182 |
| [Table 7-22](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab22) | Dotted-Decimal and Prefix-Notation Representations for IPv4 Subnets | 182 |
| [Table 7-23](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab23) | Subnet Octet Values | 183 |
| Formula | Number of created subnets | 185 |
| Formula | Number of borrowed bits | 186 |
| Formula | Number of host bits | 186 |
| Formula | Number of assignable IP addresses in a subnet | 186 |
| [Table 7-24](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab24) | Number of Subnets Created by a Specified Number of Borrowed Bits | 187 |
| [Table 7-25](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab25) | Number of Supported Hosts, Given a Specified Number of Host Bits | 188 |
| Step list | Steps for calculating subnets | 190 |
| [Table 7-26](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07tab26) | Usable IP Address Ranges for the 192.168.10.0/27 Subnets | 191 |
| [Figure 7-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07fig15) | CIDR Calculation Example | 197 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” or at least the section for this chapter and complete as many of the tables as possible from memory. [Appendix D](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appd.xhtml#appd), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appd.xhtml#appd),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[Automatic Private IP Addressing (APIPA)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_01)

[Class A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_02)

[Class B](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_03)

[Class C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_04)

[Class D](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_05)

[Class E](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_06)

[classless inter-domain routing (CIDR)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_07)

[IPv4 address classes](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_08)

[localhost](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_09)

[loopback](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_010)

[private IP addressing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_011)

[RFC1918](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_012)

[subnetting](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_013)

[Variable-Length Subnet Masking (VLSM)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#key_014)

### Additional Resources

**Subnetting—Hosts per Subnet:** <https://www.ajsnetworking.com/subnetting>

**Subnetting—What Mask to Use:** <https://www.ajsnetworking.com/subnetting2>

**Subnetting—“I Feel the Need, the Need for Speed”:** <https://www.ajsnetworking.com/subnetting3>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_1) What is the binary representation of the decimal number 117?

1. 10110101
2. 01110101
3. 10110110
4. 01101001

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_2) What is the decimal equivalent of the binary number 10110100?

1. 114
2. 190
3. 172
4. 180

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_3) What is the class of IP address 10.1.2.3/24?

1. Class A
2. Class B
3. Class C
4. Class D

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_4) What is the classful subnet mask for a Class B network?

1. 255.255.0.0
2. 255.255.255.255
3. 255.255.255.0
4. 255.0.0.0

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_5) Which of the following is a dynamic approach to assigning routable IP addresses to networked devices?

1. CIDR
2. APIPA
3. RFC1918
4. DHCP

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_6) How many assignable IP addresses exist in the 172.16.1.10/27 network?

1. 30
2. 32
3. 14
4. 64

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_7) What is the prefix notation for the subnet mask 255.255.255.240?

1. /20
2. /24
3. /28
4. /29

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_8) Your company has been assigned the 192.168.30.0/24 network for use at one of its sites. You need to use a subnet mask that will accommodate seven subnets while simultaneously accommodating the maximum number of hosts per subnet. What subnet mask should you use?

1. /24
2. /26
3. /27
4. /28

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_9) A client with IP address 172.16.18.5/18 belongs to what network?

1. 172.16.0.0/18
2. 172.16.64.0/18
3. 172.16.96.0/18
4. 172.16.128.0/18

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_10) What effect does classless inter-domain routing have on the subnet mask in IP addressing?

1. The mask is not changed
2. The mask is lengthened
3. The mask is shortened
4. The mask is eliminated

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz7_11) Which of the following is not a private address range as defined in RFC1918?

1. 127.x.x.x
2. 10.x.x.x
3. 172.16.x.x to 172.31.x.x
4. 192.168.x.x