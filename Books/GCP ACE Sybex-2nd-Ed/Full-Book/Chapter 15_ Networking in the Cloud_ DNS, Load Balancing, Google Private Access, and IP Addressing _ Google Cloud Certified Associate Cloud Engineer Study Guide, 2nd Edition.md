---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **2.4 Planning and configuring network resources**
- **3.5 Deploying and implementing networking resources**
- **4.5 Managing networking resources**

---

This chapter continues the focus on networking, specifically configuring the Domain Name System (DNS), load balancing, Google Private Access, and managing IP addresses. Cloud DNS is a managed service providing authoritative domain naming services. It is designed for high availability, low latency, and scalability. Load balancing services in Google Cloud offer several types of load balancers to address a range of needs. In this chapter, you will see how HTTP(S), SSL Proxy, TCP Proxy, Network TCP/UDP, and Internal TCP/UDP Network differ and when to use each. Cloud engineers should also be familiar with managing IP addresses, in particular managing classless interdomain routing (CIDR) blocks and understanding how to reserve IP addresses. This chapter, in combination with [Chapter 14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml), “Networking in the Cloud: Virtual Private Clouds and Virtual Private Networks,” provides an overview of the networking topics covered on the Associate Cloud Engineer exam.

## Configuring Cloud DNS

Cloud DNS is a Google service that provides domain name resolution. At the most basic level, DNS services map domain names, such as `example.com`, to IP addresses, such as 35.20.24.107. A managed zone contains DNS records associated with a DNS name suffix, such as `aceexamdns1.com`. DNS records contain specific details about a zone. For example, an A record maps a hostname to IP addresses in IPv4. AAAA records are used in IPv6 to map names to IPv6 addresses. CNAME records map an alias to the canonical name of the domain. In this section, you will learn how to configure DNS services in Google Cloud, which consists of creating zones and adding records.

### Creating DNS Managed Zones Using Cloud Console

To create a managed zone using Cloud Console, navigate to the Network Services section of the console. Click Cloud DNS to access the page shown in [Figure 15.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0001).

Click Create Zone to the page shown in [Figure 15.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0002).

First, select a zone type, which can be Public or Private. Then specify a zone name, which must be unique within the project.

![Snapshot of network Services Cloud DNS page](../images/c15f001.png)


[**FIGURE 15.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0001) Network Services Cloud DNS page

Public zones are accessible from the Internet. These zones provide name servers that respond to queries from any source. Private zones provide name services to your Google Cloud resources, such as virtual machines (VMs) and load balancers. Private zones respond only to queries that originate from resources in the same project as the zone.

In the form, provide a zone name and description. Specify the DNS name, which should be the suffix of a DNS name, such as `aceexamdns1.com`.

You can enable DNSSEC, which is DNS security. It provides strong authentication of clients communicating with DNS services. DNSSEC is designed to prevent spoofing (a client appearing to be some other client) and cache poisoning (a client sending incorrect information to update the DNS server).

If you choose to create a private zone, you will have the option of choosing settings that provide additional configurations for a private zone, as shown in [Figure 15.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0003).

In addition to the parameters set for a public zone, you will need to specify the networks that will have access to the private zone.

After you've created some zones, the Cloud DNS page will list the zones, as shown in [Figure 15.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0004).

![Snapshot of creating a public DNS zone](../images/c15f002.png)


[**FIGURE 15.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0002) Creating a public DNS zone

![Snapshot of additional configuration options for private DNS zones](../images/c15f003.png)


[**FIGURE 15.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0003) Additional configuration options for private DNS zones

![Snapshot of list of DNS zones](../images/c15f004.png)


[**FIGURE 15.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0004) List of DNS zones

Click the name of a zone to see its details. As shown in [Figure 15.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0005), the zone details include a list of records associated with the zone. When a zone is created, NS and SOA records are added. NS is a *name server* record that has the address of an authoritative server that manages the zone information. SOA is a *start of authority* record, which has authoritative information about the zone. You can add other records, such as A and CNAME records.

![Snapshot of list of records in a DNS zone](../images/c15f005.png)


[**FIGURE 15.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0005) List of records in a DNS zone

To add an A record, click Add Record Set to display the page shown in [Figure 15.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0006).

![Snapshot of creating an A record set](../images/c15f006.png)


[**FIGURE 15.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0006) Creating an A record set

Select A as a resource record type and specify an IPv4 address of the server that maps domain names to IP addresses for this zone.

The TTL (time to live) and TTL Unit parameters specify how long the record can live in a cache—in other words, the period of time DNS resolvers should cache the data before querying for the value again. DNS resolvers perform lookup operations mapping domain names to IP addresses. If you want to specify multiple IP addresses in the record, click Add Item to add other IP addresses.

You can also add canonical name records using the Create Record Set page. In this case, select CNAME as the Resource Record Type, as shown in [Figure 15.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0007).

The CNAME record takes a name, or alias, of a server. The DNS name and TTL parameters are the same as in the A record example.

Also, DNS Forwarding is now available, which allows your DNS queries to be passed to an on-premises DNS server if you are using Cloud VPN or Interconnect.

![Snapshot of creating a CNAME record](../images/c15f007.png)


[**FIGURE 15.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0007) Creating a CNAME record

### Creating DNS Managed Zones Using *gcloud*

To create DNS zones and add records, you will use `gcloud dns managed-zones` and `gcloud dns record-sets transaction`.

To create a managed public zone called `ace-exam-zone1` with the DNS suffix `aceexamzone.com`, use this:

```
gcloud dns managed-zones create ace-exam-zone1 --description= "A sample zone" --dns-name=aceexamzone.com.
```

To make this a private zone, you add the `--visibility` parameter set to `private`:

```
gcloud dns managed-zones create ace-exam-zone1 --description= "A sample zone" --dns-name=aceexamzone.com. --visibility=private --
networks=default
```

To add an A record, you start a transaction, add the A record information, and then execute the transaction.

Transactions are started with `gcloud dns record-sets transaction start`. Record sets are added using `gcloud dns record-sets transaction add`, and transactions are completed using `gcloud dns record-sets-transaction execute`. Together, the steps are as follows:

```
gcloud dns record-sets transaction start --zone=ace-exam-zone1 gcloud dns record-sets transaction add 192.0.2.91 --name=aceexamzone.com.
 --ttl=300 --type=A --zone=ace-exam-zone1 gcloud dns record-sets transaction execute --zone=ace-exam-zone1.
```

To create a CNAME record, you would use similar commands:

```
gcloud dns record-sets transaction start --zone=ace-exam-zone1 gcloud dns record-sets transaction add server1.aceexamezone.com. \--name=www2.aceexamzone.com. --ttl=300 --type=CNAME --zone=ace-exam-zone1
gcloud dns record-sets transaction execute --zone=ace-exam-zone1
```

## Configuring Load Balancers

Load balancers distribute workload to servers running an application. In this section, we will discuss the different types of load balancers and how to configure them.

### Types of Load Balancers

Load balancers can distribute load within a single region or across multiple regions. The several load balancers offered by Google Cloud are characterized by three features:

- Global versus regional load balancing
- External versus internal load balancing
- Traffic type, such as HTTP and TCP

Global load balancers are used when an application is globally distributed. There are four global load balancers:

- Global External HTTP(S) Load Balancing, which balances HTTP and HTTPS loads across a set of back-end instances globally on a Premium network service tier.
- Global External HTTP(S) Load Balancing (classic), which balances HTTP and HTTPS loads across a set of back-end instances globally on Premium tier networking and regionally on Standard tier networking.
- SSL Proxy, which terminates SSL/TLS connections, which are Secure Socket Layer connections. This type is used for non-HTTPS traffic.
- TCP Proxy, which terminates TCP sessions at the load balancer and then forwards traffic to back-end servers.

Regional load balancers are used when resources providing an application are in a single region. The regional load balancers are as follows:

- Regional External HTTP(S) Load Balancing, which balances HTTP(S) regionally on Standard tier networking
- Internal HTTP(S) Load Balancing, which balances HTTP(S) regionally on Premium tier networking only
- Internal TCP/UDP Load Balancing, which balances TCP/UDP regionally on Premium tier networking only
- External TCP/UDP Network Load Balancing, which enables balancing of TCP, UDP, and other protocols regionally on Standard or Premium tier networking

---

### Real World Scenario

### Load Balancing and High Availability

Applications that need to be highly available should use load balancers to distribute traffic and to monitor the health of VMs in the back end. A company offering API access to customer data will need to consider how to scale up and down in response to changes in load and how to ensure high availability.

The combination of instance groups ([Chapter 6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml), “Managing Virtual Machines”) and load balancers solves both problems. Instance groups can manage autoscaling, and load balancers can perform health checks. If a VM is not functioning, the health checks will fail and take the failed VM out of rotation for traffic. Users of the API are less likely to get failed response codes when instance groups keep an appropriate number of VMs active and load balancers prevent any traffic from being routed to failed servers.

---

### Configuring Load Balancers Using Cloud Console

To create a load balancer in Cloud Console, navigate to the Network Services section and select Load Balancing, as shown in [Figure 15.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0008).

The first step to creating a load balancer is deciding on the type. In this example, you will create a TCP load balancer (see [Figure 15.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0009)).

After you select the TCP Load Balancing option, the page shown in [Figure 15.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0010) appears. Select Only Between My VMs for private load balancing. This load balancer will be used in a single region, and you will not offload TCP or SSL processing.

![Snapshot of network Services, Load Balancing section](../images/c15f008.png)


[**FIGURE 15.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0008) Network Services, Load Balancing section

![Snapshot of create A Load Balancer options](../images/c15f009.png)


[**FIGURE 15.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0009) Create A Load Balancer options

You will need to specify if you want the load balancer to handle traffic from the Internet to your VMs or only between VMs on your network. Next, specify if you want to support a single region or multiple regions. You will also specify a back-end type, which can be Backend Service, Target Pool, or Target Instance. Backend Service allows you to specify how to distribute traffic as well as support for connection draining, TCP health checks, managed instance groups, and failover groups. Target Pools are instances within a region that are identified by a list or URLs that specify what VMs can receive traffic.

![Snapshot of creating a TCP balancer](../images/c15f010.png)


[**FIGURE 15.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0010) Creating a TCP balancer

[Figure 15.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0011) shows the parameters for configuring a back end, including IP Stack Type, Health Check, and Session Affinity.

You can configure a health check for the back end. This will bring up a separate page, as shown in [Figure 15.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0012).

In the health check, you specify a name, a protocol and a port, and a set of health criteria. In this case, you check back ends every 5 seconds and will wait for a response for up to 5 seconds. If you have two consecutive periods where the health check fails, then the server will be considered unhealthy and taken out of the load balancing rotation.

Next, you configure the front end using the page in [Figure 15.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0013). You specify a name, subnetwork, and an internal IP configuration, which in this case is ephemeral (see “Managing IP Addresses” later in this chapter for more on types of IP addresses). You also specify the port that will have its traffic forwarded to the back end. In this example, you are forwarding traffic on port 80.

The last step prior to creating the front end is to review the configuration and then create the load balancer.

![Snapshot of configuring the back end](../images/c15f011.png)


[**FIGURE 15.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0011) Configuring the back end

### Configuring Load Balancers Using *gcloud*

In this section, we will review the steps needed to create a network load balancer. These are good options when you need to load balance protocols in addition to HTTP(S).

![Snapshot of creating a health check](../images/c15f012.png)


[**FIGURE 15.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0012) Creating a health check

![Snapshot of configuring the front end](../images/c15f013.png)


[**FIGURE 15.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0013) Configuring the front end

The `gcloud compute forward-rules` command is used to forward traffic that matches an IP address to the load balancer:

```
gcloud compute forwarding-rules create ace-exam-lb --port=80 \--target-pool ace-exam-pool
```

This command routes traffic to any VM in the `ace-exam-pool` to the load balancer called `ace-exam-lb`.

Target pools are created using the `gcloud compute target-pools create` command. Instances are added to the target pool using the `gcloud compute target-pools add-instances` command. For example, to add VMs ig1 and ig2 to the target pool called `ace-exam-pool`, use the following command:

```
gcloud compute target-pools add-instances ace-exam-pool --instances ig1,ig2
```

## Google Private Access

VMs running in a VPC can use external IP addresses to connect to Google APIs and other services. However, if you do not want to assign external IP addresses to VMs, you can use one of the Private Google Access options.

Private Google Access is used to reach Google Cloud resources without using an external IP address. This allows you to connect to Google APIs through the VPC's default network gateway. This option supports most Google Cloud services and APIs. Traffic to Google APIs from on-premises systems needs to be sent to either `private.googleapis.com` or `restricted.googleapis.com`. Also, routes must be in place for traffic to flow from on-premises systems to `private.googleapis.com` or `restricted.googleapis.com`.

Private Service Access is used to access a Google or third-party managed VPC network through a VPC Peering connection. This supports some Google Cloud services and third-party services.

Private Service Connect is used with Google Cloud resources that may or may not have external IP addresses as well as on-premises systems. With this option, you connect to a Private Service Connect endpoint in your VPC network and that endpoint will forward requests to Google APIs and services.

If you are using Cloud Run, App Engine Standard, and Cloud Functions, then you can use Serverless VPC Access to reach private IP addresses from those services.

## Managing IP Addresses

The exam topics for the Associate Cloud Engineer certification specifically identifies two IP address–related topics: expanding CIDR blocks and reserving IP addresses.

---

![](../images/note_16.png) It is also important to understand the difference between ephemeral and static IP addresses. Static IP addresses are assigned to a project until they are released. They are used if you need a fixed IP address for a service, such as a website. Ephemeral IP addresses exist only as long as the resource is using the IP address, such as on a VM running an application only accessed by other VMs in the same project. If you delete or stop a VM, ephemeral addresses are released.

---

### Expanding CIDR Blocks

CIDR blocks define a range of IP addresses that are available for use in a subnet. If you need to increase the number of addresses available—for example, if you need to expand the size of clusters running in a subnet—you can use the `gcloud compute networks subnets expand-ip-range` command. It takes the name of the subnet and a new prefix length. The prefix length determines the size of the network mask.

For example, to increase the number of addresses in `ace-exam-subnet1` to 65,536, you set the prefix length to 16:

```
gcloud compute networks subnets expand-ip-range ace-exam-subnet1 \--prefix-length 16
```

This assumes the prefix length was larger than 16 prior to issuing this command. The `expand-ip-range` command is used only to increase the number of addresses. You cannot decrease them, though. You would have to re-create the subnet with a smaller number of addresses.

### Reserving IP Addresses

Static external IP addresses can be reserved using Cloud Console or the command line. To reserve a static IP address using Cloud Console, navigate to the Virtual Private Cloud (VPC) section of the console and select IP Addresses. This will display a page like the one shown in [Figure 15.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0014).

![Snapshot of vPC Network IP Address page](../images/c15f014.png)


[**FIGURE 15.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0014) VPC Network IP Address page

Click Reserve External Static Address to display the page shown in [Figure 15.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#c15-fig-0015), where you can reserve an IP address.

When reserving an IP address, you will need to specify a name and optional description. You may have the option of using the lower-cost Standard service tier for networking, which uses the Internet for some transfer of data. The Premium tier routes all traffic over Google's global network. You will also need to determine whether the address is in IPv4 or IPv6 and whether it's regional or global. You can attach the static IP address to a resource as part of the reservation process, or you can keep it unattached.

![Snapshot of reserving a static IP address](../images/c15f015.png)


[**FIGURE 15.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml#R_c15-fig-0015) Reserving a static IP address

Reserved addresses stay attached to a VM when it is not in use and stay attached until released. This is different from ephemeral addresses, which are released automatically when a VM shuts down.

To reserve an IP address using the command line, use the `gcloud` command `gcloud compute addresses create`. For example, to create a static IP address in the us-west2 region, which uses the Premium tier, use this command:

```
gcloud compute addresses create ace-exam-reserved-static1 \--region=us-west2 --network-tier=PREMIUM
```

## Summary

The Associate Cloud Engineer exam may test your knowledge of Cloud DNS, load balancing, and managing IP addresses. Cloud DNS is an authoritative name service for mapping domain names to IP addresses. You can set up public or private DNS zones. You will also need to be familiar with load balancing and the different types of load balancers. Some load balancers are regional, and some are global. Some are for internal use only, and others support external sources of traffic. The chapter also reviewed how to expand the number of addresses available in a subnet and discussed how to reserve IP addresses.

## Exam Essentials

- **Understand that Cloud DNS is used to map domain names to IP addresses.**   If you want to support queries from the Internet, use a public DNS zone. Use a private DNS zone only if you want to accept queries from resources in your project.
- **Know that DNS entries, like `example.com`, can have multiple records associated with them.**   The A record specifies the address of a DNS resolver that maps domain names to IP addresses. CNAME records store the canonical name of the domain.
- **Know how load balancers are distinguished.**   Load balancers are distinguished based on global versus regional load balancing, external versus internal load balancing, and the protocols supported. Global balancers distribute load across regions, whereas regional load balancers work within a region. Internal load balancers balance traffic only from within Google Cloud, not external sources. Some load balancers are protocol-specific, such as HTTP and SSL load balancers.
- **Know the types of load balancers and when they should be used.**   HTTP(S), SSL Proxy, TCP Proxy, and TCP/UDP. Load balancers distribute load regionally or globally. Internal load balancers distribute load from internal traffic. External load balancers distribute load from external traffic.
  - HTTP(S) balances HTTP and HTTPS load.
  - SSL Proxy terminates SSL/TLS connections.
  - TCP Proxy terminates TCP sessions.
  - TCP/UDP balances TCP/UDP traffic on private networks hosting internal VMs.
- **Understand that configuring a load balancer can require configuring both the front end and back end.**  The network load balancer can be configured by specifying a forwarding rule that routes traffic to the load balancer to VMs in the target pool.
- **Know Google Private Access options.**  Private Google Access is used for private access to most Google Cloud services, while Private Service Access is used with third-party services and some Google Cloud service. Private Service Connect uses a VPC endpoint for forwarding traffic to Google Cloud services. Serverless VPC Access allows Cloud Run, Cloud Functions, and App Engine Standard to reach VMs with private addresses.
- **Know how to increase the number of IP addresses in a subnet.**  Use the `gcloud compute network subnets expand-ip-range` command to increase IP addresses in a subnet. The number of addresses can only increase. The `expand-ip-range` command cannot be used to decrease the number of addresses.
- **Know how to reserve an IP address using the console and the `gcloud compute address create` command.**  Reserved IP addresses continue to be available to your project even if they are not attached to a resource. Know the difference between Premium and Standard tier network services.

## Review Questions

You can find the answers in the Appendix.

1. What record type is used to specify the IPv4 address of a domain?
   1. AAAA
   2. A
   3. NS
   4. SOA
2. The CEO of your startup just read a news report about a company that was attacked by something called cache poisoning. The CEO wants to implement additional security measures to reduce the risk of DNS spoofing and cache poisoning. What would you recommend?
   1. Using DNSSEC
   2. Adding SOA records
   3. Adding CNAME records
   4. Deleting CNAME records
3. What do the TTL parameters specify in a DNS record?
   1. Time a record can exist in a cache before it should be queried again
   2. Time a client has to respond to a request for DNS information
   3. Time allowed to create a CNAME record
   4. Time before a human has to manually verify the information in the DNS record
4. What command is used to create a DNS zone in the command line?
   1. `gsutil dns managed-zones create`
   2. `gcloud dns managed-zones create`
   3. `gcloud managed-zones create`
   4. `gcloud create dns managed zones`
5. What parameter is used to make a DNS zone private?
   1. `--private`
   2. `--visibility=private`
   3. `--private=true`
   4. `--status=private`
6. Which load balancers provide global load balancing?
   1. Global External HTTP(S) Load Balancing and Global External HTTP(S) Load Balancing (classic) only
   2. SSL Proxy and TCP Proxy only
   3. Global External HTTP(S) Load Balancing, Global External HTTP(S) Load Balancing (classic), SSL Proxy, and TCP Proxy
   4. Internal TCP/UDP, HTTP(S), SSL Proxy, and TCP Proxy
7. Which regional load balancer balances HTTP(S) regionally on Premium tier networking only?
   1. Global External HTTP(S) Load Balancing
   2. SSL Proxy
   3. TCP Proxy
   4. Internal HTTP(S) Load Balancing
8. You are configuring a load balancer and want to implement private load balancing. Which option would you select?
   1. Only Between My VMs
   2. Enable Private
   3. Disable Public
   4. Local Only
9. What two components need to be configured when creating a TCP Proxy load balancer?
   1. Front end and forwarding rule
   2. Front end and back end
   3. Forwarding rule and back end only
   4. Back end and forwarding rule only
10. A health check is used to check what resources?
    1. Organization policies
    2. VMs
    3. Storage buckets
    4. Persistent disks
11. Where do you specify the ports on a TCP Proxy load balancer that should have their traffic forwarded?
    1. Back end
    2. Front end
    3. Network Services section
    4. VPC
12. What command is used to create a network load balancer at the command line?
    1. `gcloud compute forwarding-rules create`
    2. `gcloud network forwarding-rules create`
    3. `gcloud compute create forwarding-rules`
    4. `gcloud network create forwarding-rules`
13. A team is setting up a web service for internal use. They want to use the same IP address for the foreseeable future. What type of IP address would you assign?
    1. Internal
    2. External
    3. Static
    4. Ephemeral
14. You are starting up a VM to experiment with a new Python data science library. You'll use SSH to connect to the VM, use the Python interpreter interactively for a while, and then shut down the machine. What type of IP address would you assign to this VM?
    1. Ephemeral
    2. Static
    3. Permanent
    4. IPv8
15. You have created a subnet called sn1 using 192.168.0.0 with 65,534 addresses. You realize that you will not need that many addresses, and you'd like to reduce that number to 254. Which of the following commands would you use?
    1. `gcloud compute networks subnets expand-ip-range sn1 \--prefix-length=24`
    2. `gcloud compute networks subnets expand-ip-range sn1 \--prefix-length=-8`
    3. `gcloud compute networks subnets expand-ip-range sn1 --size=256`
    4. There is no command to reduce the number of IP addresses available.
16. You have created a subnet called sn1 using 192.168.0.0. You want it to have 14 addresses. What prefix length would you use?
    1. 32
    2. 28
    3. 20
    4. 16
17. You want all your network traffic to route over the Google network and not traverse the public Internet. What level of network service should you choose?
    1. Standard
    2. Google-only
    3. Premium
    4. Non-Internet
18. You have a website hosted on a Compute Engine VM. Users can access the website using the domain name you provided. You do some maintenance work on the VM and stop the server and restart it. Now users cannot access the website. No other changes have occurred on the subnet. What might be the cause of the problem?
    1. The restart caused a change in the DNS record.
    2. You used an ephemeral instead of a static IP address.
    3. You do not have enough addresses available on your subnet.
    4. Your subnet has changed.
19. You are deploying a distributed system. Messages will be passed between Compute Engine VMs using a reliable UDP protocol. All VMs are in the same region. You want to use the load balancer that best fits these requirements. Which kind of load balancer would you use?
    1. Internal TCP/UDP
    2. TCP Proxy
    3. SSL Proxy
    4. Global External HTTP(S) Load Balancing
20. You want to use Cloud Console to review the records in a DNS entry. What section of Cloud Console would you navigate to?
    1. Compute Engine
    2. Network Services
    3. Kubernetes Engine
    4. Hybrid Connectivity