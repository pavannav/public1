# Chapter 6: Designing Networks

**Exam Objective Covered:**
- **2.2 Configuring network topologies**

---

This chapter covers networking in Google Cloud from an architecture perspective, focusing on virtual private clouds, hybrid-cloud connectivity, load balancing, and service-centric networking. Architects should be familiar with the seven-layer Open Systems Interconnection (OSI) Network model when designing and troubleshooting networks.

**OSI Model Layers:**

| Layer | Name         | Description |
|-------|--------------|-------------|
| 1 | Physical | Physical base: cables, RF, voltages |
| 2 | Data Link | Data transfer between two nodes; error correction; includes MAC and LLC sublayers |
| 3 | Network | Packet forwarding using routers; IP protocol |
| 4 | Transport | Controls data transfer between systems; TCP and UDP |
| 5 | Session | Manages sessions between applications; TLS handshake |
| 6 | Presentation | Maps application to network representations; encryption/decryption |
| 7 | Application | Top layer; provides functionality for apps (e.g., web browsers) |

Architects most often reason about layers 3, 4, and 7 — for subnets, firewall rules, and web application firewalls.

---

## IP Addressing, Firewall Rules, and Routers

### IP Address Structure

An IP network is a set of devices that can communicate directly using internet protocols. Networks can be partitioned into **subnets** for more efficient traffic flow.

An **Internet Protocol (IP) address** identifies a device, virtual device, or service on a network. IP supports two versions:
- **IPv4:** Four octets (e.g., `192.168.20.10`) — 32-bit address
- **IPv6:** Eight 16-bit blocks (e.g., `FE80:0000:0000:0000:0202:B3FF:FE1E:8329`) — 128-bit address

For exam purposes, understanding IPv4 is sufficient.

**CIDR Notation:** IP ranges are specified using Classless Inter-Domain Routing (CIDR) notation — an IPv4 address followed by `/` and an integer (1–32). The integer specifies the number of bits used to identify the network (the **subnet mask**); remaining bits identify host addresses.

> Example: `172.16.0.0/12` — the first 12 bits specify the network; 20 bits remain for host addresses, allowing up to 1,048,574 IP addresses.

---

![note](../images/note_24.png) CIDR addressing was adopted in 1993 under RFCs 1518 and 1519, replacing classful networking (Classes A, B, C for unicast; D for multicast; E for experimental). CIDR was adopted to help avoid IPv4 address exhaustion and control routing table growth. RFCs are technical specifications for the internet defined by the Internet Engineering Task Force.

---

### Public vs. Private Addressing

- **Private IP addresses:** Non-internet-routable; reserved for internal use.
- **Public IP addresses:** Used for internet communication.
- **NAT (Network Address Translation):** Allows a public IP to be used with private IP addresses, reducing the number of public IPs needed.

IETF-defined private address ranges:

| Range | From | To |
|-------|------|----|
| 10.0.0.0/8 | 10.0.0.0 | 10.255.255.255 |
| 172.16.0.0/12 | 172.16.0.0 | 172.31.255.255 |
| 192.168.0.0/16 | 192.168.0.0 | 192.168.255.255 |

Address counts: 10.0.0.0/8 = 16,777,216; 172.16.0.0/12 = 1,048,576; 192.168.0.0/16 = 65,536.

### Firewall Rules

**Firewall rules** control network traffic by blocking or allowing ingress or egress traffic to a network, subnet, or device.

Two **implied rules** are defined with VPCs (cannot be deleted):
- Block all incoming traffic (priority 65535)
- Allow all outgoing traffic (priority 65535)

Priority is an integer from **0 (highest)** to **65535 (lowest)**. Override implied rules by specifying rules with a lower priority number.

**Four default rules** on the default VPC network (all at priority 65534):

| Rule Name | Description |
|-----------|-------------|
| `default-allow-internal` | Allows ingress for all protocols/ports among instances in the network |
| `default-allow-ssh` | Allows TCP port 22 ingress from any source (SSH access to Linux servers) |
| `default-allow-rdp` | Allows TCP port 3389 ingress from any source (RDP for Windows servers) |
| `default-allow-icmp` | Allows ingress ICMP traffic from any source |

**Firewall rule attributes:**
- **Direction:** Ingress or egress
- **Action:** Allow or deny
- **Target:** Instances to which the rule applies
- **Source/Destination:** Source for ingress; destination for egress
- **Protocol:** TCP, UDP, ICMP, etc.
- **Port number:** Communication endpoint
- **Enforcement status:** Enable or disable without deleting

Firewall rules are **global resources** assigned to VPCs, applying to all VPC subnets in all regions.

### Cloud Router

A **router** connects multiple networks and enables communication between them. **Cloud Router** is a software-defined network service that uses the **Border Gateway Protocol (BGP)** to advertise IP address ranges and build dynamic routes.

Cloud Router provides routing services for:
- Dedicated Interconnect
- Partner Interconnect
- HA VPN
- Supported router appliances

By default, Cloud Router only advertises subnet routes. Custom route advertisements can be configured.

### Cloud Armor

**Cloud Armor** is a layer 7 **web application firewall (WAF)** designed to:
- Mitigate distributed denial-of-service (DDoS) attacks
- Prevent cross-site scripting and SQL injection attacks
- Protect against the OWASP Top 10 threats (via preconfigured rules)

Cloud Armor is configured using **security policies** that scrub incoming requests. Policies can be preconfigured or manually configured. Named IP lists can allow traffic only from trusted third parties.

---

## Virtual Private Clouds

VPCs are like a network in a data center — network-based organizational structures for controlling access to GCP resources. VPCs organize:
- Compute Engine instances
- App Engine Flexible instances
- GKE clusters

VPCs are **global resources** and can span multiple regions.

---

![note](../images/note_24.png) The resource hierarchy (organizations, folders, projects) controls billing and identity-based access. VPCs control network access to resources.

---

A VPC is associated with a project or organization. Projects can have multiple VPCs. Resources within a VPC can communicate with each other (subject to firewall rules) and with Google APIs and services.

### VPC Subnets

- **Subnets** are **regional resources** with defined IP address ranges.
- VPCs themselves do **not** have IP address ranges — subnets do.
- Each subnet in a VPC must have distinct, non-overlapping IP ranges.

**VPC Modes:**

| Mode | Description |
|------|-------------|
| Default | Automatically created when a project is enabled (can be disabled via org constraints) |
| Auto-mode | Creates a subnet in every region; all use the `10.128.0.0/9` range |
| Custom | Full control of subnetting; recommended for production environments |

- VPC reserves **4 IP addresses** from each subnet.
- Smallest allowed subnet is **/29**.
- Auto-mode subnets are assigned IP addresses in the `10.nnn.0.0/20` range per region.

VPCs use routes to determine traffic routing within the VPC and across subnets, and can learn regional-only or multiregional/global routes depending on configuration.

### Shared VPC

A **Shared VPC** connects resources from multiple projects to a common VPC network using private IP addresses.

- Has **one host project** and **one or more service projects**.
- Host and service projects must be in the **same organization** (with one exception for service project migrations).
- The VPC network is defined in the host project and centrally shared.

**Subnet sharing options:**
1. Share all subnets in the host (including future ones).
2. Specify individual subnets to share.

**Advantages of Shared VPCs:**
- Resources across projects can communicate using private IP addresses.
- Allows separation of network management (e.g., firewall rules) from project management (e.g., instances).
- Organization policy constraints can prevent accidental deletion of host projects and restrict service project attachments.

> Shared VPCs work only within the **same organization**. For cross-organization communication, use VPC Network Peering.

### VPC Network Peering

**VPC Network Peering** enables different VPC networks to communicate using private IP address space (RFC 1918). It is used as an alternative to external IP addresses or VPNs.

- Can connect VPCs **between organizations** (unlike Shared VPC).
- Commonly used by SaaS providers to make services available to customers in different GCP organizations.

**Three primary advantages:**

| Advantage | Description |
|-----------|-------------|
| Lower latency | Traffic stays on the Google network, not the public internet |
| Reduced attack surface | Services remain inaccessible from the public internet |
| No egress charges | No egress charges for traffic using VPC network peering |

**Key constraints:**
- Peered networks manage their own firewall rules and routes.
- Maximum of **25 peering connections** from a single VPC.
- Both sides must set up a peering relationship; if one side deletes it, the other enters inactive mode.
- Latency and throughput are the same as private traffic within the network.

Works with: **Compute Engine, App Engine Flexible Environment, Google Kubernetes Engine.**

---

## Hybrid-Cloud Networking

**Hybrid-cloud networking** provides network services between an on-premises data center and a cloud. **Multicloud networking** links two or more public clouds (and may include private data centers).

**Use case examples:**
- Batch jobs using legacy mainframe applications → best run on-premises.
- Ad hoc batch processing (e.g., image format conversion) → good candidate for cloud (preemptible VMs).
- Enterprise data warehouse at petabyte scale → well suited for BigQuery.

### Hybrid-Cloud Design Considerations

| Consideration | Details |
|---------------|---------|
| Throughput | Sufficient bandwidth for data transfers between environments |
| Latency | Critical for real-time applications calling on-premises APIs from the cloud |
| Reliability | Single interconnect = single point of failure; use multiple interconnects or VPN backup |

**Common network topologies:**

| Topology | Description |
|----------|-------------|
| Mirrored | Public cloud and private on-premises mirror each other (e.g., DR or test environments) |
| Meshed | All systems across all clouds and private networks can communicate with each other |
| Gated egress | On-premises service APIs available to cloud apps without public internet exposure |
| Gated ingress | Cloud service APIs available to on-premises apps without public internet exposure |
| Gated egress and ingress | Combines gated egress and gated ingress |
| Handover | On-premises apps upload data to shared storage (e.g., Cloud Storage); cloud services consume it (common for data warehousing) |

### Hybrid-Cloud Implementation Options

Three types of network links support hybrid-cloud computing:

1. Cloud VPN
2. Cloud Interconnect
3. Direct peering

#### Cloud VPN

**Cloud VPN** provides virtual private networks between GCP and on-premises networks using **IPSec VPNs**. Available in two types:

| Type | Details |
|------|---------|
| HA VPN | IPSec VPN; 99.99% availability; uses two connections, each with its own external IP; supports multiple tunnels; requires both gateways active for SLA |
| Classic VPN | One network interface; one external IP; 99.9% availability |

- Each Cloud VPN tunnel supports up to **3 Gbps**.
- Data traverses the public internet but is **encrypted** using the **Internet Key Exchange (IKE)** protocol.

#### Cloud Interconnect

**Cloud Interconnect** provides high throughput and highly available networking between GCP and on-premises networks.

| Type | Details |
|------|---------|
| Dedicated Interconnect | Direct connection between Google Cloud access point and customer data center; 10 Gbps or 100 Gbps configurations |
| Partner Interconnect | Uses a third-party network provider; 50 Mbps to 50 Gbps connections |

**Advantages:**
- Data transmitted on **private connections** (not public internet).
- Private IP addresses in GCP VPCs are **directly addressable** from on-premises (no NAT or VPN needed).
- Dedicated Interconnect scalable to **80 Gbps** (eight 10 Gbps) or **200 Gbps** (two 100 Gbps).
- Partner Interconnect scalable to **80 Gbps** (eight 10 Gbps).

**Disadvantage:** Additional cost and complexity. If low latency and high availability are not required, Cloud VPN is less expensive.

#### Direct Peering

**Direct peering** allows customers to connect their networks to a Google network point of access by exchanging **BGP routes**. It is:
- Not a GCP service — a lower-level network connection outside of GCP.
- Does not use any GCP resources (VPC firewall rules, GCP access controls).

> Use direct peering when you need access to **Google Workspace services** in addition to Google Cloud services. In all other cases, Google recommends Dedicated or Partner Interconnect.

**Summary comparison:**

| Option | Throughput | Latency | Cost | Best For |
|--------|-----------|---------|------|----------|
| Cloud VPN | Up to 3 Gbps/tunnel | Higher (public internet) | Lower | Cost-effective hybrid connectivity |
| Dedicated Interconnect | 10–200 Gbps | Low | Higher | High-throughput, low-latency needs |
| Partner Interconnect | 50 Mbps–80 Gbps | Low | Moderate | When direct interconnect isn't feasible |
| Direct Peering | Varies | Low | Lower | BGP-level connectivity; Google Workspace access |

---

## Service-Centric Networking

Traditional networking is device-centric (IP addresses assigned to devices). In the cloud, managed services abstract away implementation details, so IP-based network controls may not apply.

Google Cloud provides several **private access options** for VPC resources to access APIs and services without an external IP address.

### Private Service Connect for Google APIs

Allows connection to Google APIs and services through an **endpoint within the VPC network** — no external IP address required. Clients can be GCP resources or on-premises systems.

**Two endpoint bundles:**
| Bundle | Equivalent Domain |
|--------|-------------------|
| All APIs (`all-apis`) | `private.googleapis.com` |
| VPC-SC (`vpc-sc`) | `restricted.googleapis.com` |

### Private Service Connect for Google APIs with Consumer HTTP(S)

Connects Google APIs and services using **internal HTTP(S) load balancers**. Clients can be in GCP or on-premises.

### Private Google Access

Connects external IP addresses and Private Google Access domains to GCP APIs and services through the VPC's **default internet gateway**.

- Used when GCP resources **do not have external IP addresses**.
- Enabled at the **VPC subnet level**.
- Does not enable APIs automatically — must be enabled separately.
- Requires routes for destination IP ranges used by Google APIs and services.
- Requires DNS records if using `private.googleapis.com` or `restricted.googleapis.com`.

### Private Google Access for On-Premises Hosts

Connects on-premises hosts to Google APIs and services through a VPC network. Compatible with:
- Cloud VPN
- Cloud Interconnect

Allows on-premises hosts to use **internal IP addresses** to reach Google services.

### Private Service Connect for Published Services

Connects to services in another VPC **without an external IP address**. The accessed service must be published using the Private Service Connect for Service Producers service.

### Private Service Access

Connects from a **serverless environment on GCP** to resources within a VPC using IP addresses. Implemented using a **VPC Network Peering connection**. GCP VM instances may or may not have external IP addresses.

### Serverless VPC Access

Connects from a **serverless environment in GCP** to resources in a VPC using an **internal address**. Supports:
- Cloud Run
- App Engine Standard
- Cloud Functions

---

## Load Balancing

**Load balancing** distributes work across a set of resources. GCP provides **five load balancer types**.

**Three factors for choosing a load balancer:**
1. Is workload distributed within a region or across multiple regions?
2. Is traffic from internal GCP resources only or external sources?
3. What protocols must the load balancer support?

**GCP Load Balancer Types:**

| Type | Scope | Traffic | Protocol |
|------|-------|---------|----------|
| Network TCP/UDP | Regional | External | TCP, UDP |
| Internal TCP/UDP | Regional | Internal | TCP or UDP |
| HTTP(S) | Global | External | HTTP, HTTPS |
| SSL Proxy | Global | External | SSL/TLS (non-HTTPS) |
| TCP Proxy | Global | External | TCP (non-HTTPS, non-SSL) |

### Regional Load Balancing

#### Network TCP/UDP

- Distributes workload based on **IP protocol, address, and port**.
- Uses **forwarding rules** and **target pools** to direct traffic.
- **Nonproxied** — passes data through without modification.
- Distributes traffic only **within the region** where configured.
- All traffic from the same connection is routed to the same instance (can cause imbalance with long-lived connections).
- External-facing, region-specific resource.

#### Internal TCP/UDP

- The only **internal** load balancer.
- Distributes traffic from **GCP resources** using **private IP addresses**.
- Regional load balancer.
- Supports TCP **or** UDP — not both simultaneously.
- Traffic passes through without being proxied.
- Good choice for distributing workload across Compute Engine instance groups with private IP addresses.
- Routes traffic **within a VPC** (vs. Network TCP/UDP which operates outside VPCs).

### Global Load Balancing

All global load balancers require the **Premium Tier** of network services.

#### HTTP(S) Load Balancing

- Used to distribute **HTTP and HTTPS traffic** globally (across two or more regions).
- Uses **forwarding rules** → **target HTTP proxy** → **URL map** → backend service → instance.
- URL map routes traffic based on URL (e.g., `/documents` vs. `/images` → different backend groups).
- Backend service routes requests based on **capacity, health status, and zone**.
- HTTPS traffic requires **SSL certificates** installed on backend instances.
- Backend resource can also be a **Cloud Storage bucket**.

#### SSL Proxy Load Balancing

- **Terminates SSL/TLS** at the load balancer; distributes traffic to backends via TCP or SSL (SSL recommended).
- Recommended for **non-HTTPS SSL traffic** (use HTTP(S) load balancer for HTTPS).
- Distributes traffic to the **closest region with capacity**.
- **Offloads SSL encryption/decryption** from backend instances.

#### TCP Proxy Load Balancing

- Uses a **single IP address** for all users globally; routes to the **closest instance**.
- Used for **non-HTTPS and non-SSL** TCP traffic.

---

## Additional Network Services

### Service Directory

**Service Directory** is a managed service for centralizing information about services — an **endpoint registry** for publishing, discovering, and connecting to services.

- Supports workloads in **Compute Engine** and **Kubernetes Engine**.
- Also supports **on-premises** data center services and **third-party cloud** services.

### Cloud CDN

**Cloud CDN** is a content delivery network managed by Google Cloud for distributing content globally to minimize latency.

- Works with **external HTTP(S) Load Balancing**.
- The load balancer provides a public IP address; the CDN backend provides content.
- Content sources: Compute Engine instance groups, zonal network endpoint groups, App Engine, Cloud Run, Cloud Functions, and Cloud Storage.

### Cloud DNS

**Cloud DNS** is a managed global domain name service for publishing domain names. DNS is a hierarchical, distributed database using:
- **Authoritative servers** to hold DNS name records.
- **Nonauthoritative servers** to cache DNS data for improved performance.

**Common DNS record types:**

| Record Type | Description |
|-------------|-------------|
| A | Address record — maps domain names to IP addresses |
| CNAME | Canonical name — stores aliases |
| MX | Mail exchange record |
| NS | Name server record — assigns a DNS zone to an authoritative server |

**Zone types:**
- **Public zones:** Visible to the internet.
- **Private zones:** Visible only from specified VPCs.

---

## Summary

- **VPCs** are virtual private clouds that define a network associated with a project. VPCs have subnets; subnets are assigned IP ranges and all instances receive IP addresses from their subnet's range.
- **Shared VPCs** have one host project and one or more service projects, enabling cross-project communication via private IP addresses.
- **VPC Network Peering** enables cross-VPC communication using RFC 1918 private IP space; can operate across organizations.
- **Firewall rules** control traffic; two implied rules (allow all egress, deny most ingress) cannot be deleted but can be overridden by higher-priority rules.
- **Hybrid-cloud networking** connects on-premises data centers to cloud. Key considerations: latency, throughput, reliability, and topology. Options: Cloud VPN, Cloud Interconnect, direct peering.
- **Service-centric networking** provides private access options for VMs in a VPC to reach APIs and services without external IP addresses.
- **Load balancing** distributes work across resources. GCP provides five load balancers: Network TCP/UDP, Internal TCP/UDP, HTTP(S), SSL Proxy, and TCP Proxy. Select based on regional/global distribution, protocol, and internal/external traffic.

---

## Exam Essentials

- **Understand virtual private clouds.** VPCs are global resources that organize GCP resources in a network. Subnets are regional resources with assigned IP ranges.
- **Know VPCs may be shared.** Shared VPCs include a host VPC and one or more service VPCs. They enable cross-project resource access and separation of network vs. project management duties.
- **Know what firewall rules are and how to use them.** Rules are global, defined at the network level, enforced per instance. Implied rules (allow all egress, deny most ingress) cannot be deleted. Default rules: `default-allow-internal`, `default-allow-ssh`, `default-allow-rdp`, `default-allow-icmp`.
- **Know CIDR block notation.** CIDR = IPv4 address + `/` + integer specifying bits for the subnet mask; remaining bits identify the host address.
- **Understand why hybrid-cloud networking is needed.** Workloads across environments require reliable networking. Key considerations: latency, throughput, reliability, and topology.
- **Understand hybrid-cloud connectivity options.** Cloud VPN (IPSec, public internet, lower cost), Cloud Interconnect (private connections, high throughput/availability), direct peering (BGP-level, for Google Workspace access).
- **Know service-centric networking options for private access.** Private access options allow VMs in a VPC to reach APIs without an external IP. Serverless VPC Access supports Cloud Run, App Engine Standard, and Cloud Functions.
- **Know the five types of load balancers.** Network TCP/UDP, Internal TCP/UDP, HTTP(S), SSL Proxy, TCP Proxy. Choose based on: single region vs. multiregion, protocol, and internal vs. external traffic.

---

## Review Questions

1. Your team has deployed a VPC with default subnets in all regions. The lead network architect at your company is concerned about possible overlap in the use of private addresses. How would you explain how you are dealing with the potential problem?
   - A. You inform the network architect that you are not using private addresses at all.
   - **B. When default subnets are created for a VPC, each region is assigned a different IP address range.**
   - C. You have increased the size of the subnet mask in the CIDR block specification of the set of IP addresses.
   - D. You agree to assign new IP address ranges on all subnets.

2. A data warehouse service running in GCP has all of its resources in a single project. The e-commerce application has resources in another project, including a database with transaction data that will be loaded into the data warehouse. The data warehousing team would like to read data directly from the database using extraction, transformation, and load processes that run on Compute Engine instances in the data warehouse project. Which of the following network constructs could help with this?
   - **A. Shared VPC**
   - B. Regional load balancing
   - C. Direct peering
   - D. Cloud VPN

3. An intern working with your team has changed some firewall rules. Prior to the change, all Compute Engine instances on the network could connect to all other instances on the network. After the change, some nodes cannot reach other nodes. What might have been the change that causes this behavior?
   - A. One or more implied rules were deleted.
   - **B. The `default-allow-internal` rule was deleted.**
   - C. The `default-all-icmp` rule was deleted.
   - D. The priority of a rule was set higher than 65535.

4. The network administrator at your company has asked that you configure a firewall rule that will always take precedence over any other firewall rule. What priority would you assign?
   - **A. 0**
   - B. 1
   - C. 65534
   - D. 65535

5. During a review of a GCP network configuration, a developer asks you to explain CIDR notation. Specifically, what does the 8 mean in the CIDR block 172.16.10.2/8?
   - A. 8 is the number of bits used to specify a host address.
   - **B. 8 is the number of bits used to specify the subnet mask.**
   - C. 8 is the number of octets used to specify a host address.
   - D. 8 is the number of octets used to specify the subnet mask.

6. Several new firewall rules have been added to a VPC. Several users are reporting unusual problems with applications that did not occur before the firewall rule changes. You'd like to debug the firewall rules while causing the least impact on the network and doing so as quickly as possible. Which of the following options is best?
   - A. Set all new firewall priorities to 0 so that they all take precedence over other rules.
   - B. Set all new firewall priorities to 65535 so that all other rules take precedence over these rules.
   - **C. Disable one rule at a time to see whether that eliminates the problems. If needed, disable combinations of rules until the problems are eliminated.**
   - D. Remove all firewall rules and add them back one at a time until the problems occur and then remove the latest rule added back.

7. An executive wants to understand what changes in the current cloud architecture are required to run compute-intensive machine learning workloads in the cloud and have the models run in production using on-premises servers. The models are updated daily. There is no network connectivity between the cloud and on-premises networks. What would you tell the executive?
   - A. Implement additional firewall rules.
   - B. Use global load balancing.
   - **C. Use hybrid-cloud networking.**
   - D. Use regional load balancing.

8. To comply with regulations, you need to deploy a disaster recovery site that has the same design and configuration as your production environment. You want to implement the disaster recovery site in the cloud. Which topology would you use?
   - A. Gated ingress topology
   - B. Gated egress topology
   - C. Handover topology
   - **D. Mirrored topology**

9. Network engineers have determined that the best option for linking the on-premises network to GCP resources is by using an IPSec VPN. Which GCP service would you use in the cloud?
   - A. Cloud IPSec
   - **B. Cloud VPN**
   - C. Cloud Interconnect IPSec
   - D. Cloud VPN IKE

10. Network engineers have determined that a link between the on-premises network and GCP will require an 8 Gbps connection. Which option would you recommend?
    - A. Cloud VPN
    - **B. Partner Interconnect**
    - C. Direct Interconnect
    - D. Hybrid Interconnect

11. Network engineers have determined that a link between the on-premises network and GCP will require a connection between 60 Gbps and 80 Gbps. Which hybrid-cloud networking services would best meet this requirement?
    - A. Cloud VPN
    - B. Cloud VPN and Direct Interconnect
    - **C. Direct Interconnect and Partner Interconnect**
    - D. Cloud VPN, Direct Interconnect, and Partner Interconnect

12. The director of network engineering has determined that any links to networks outside of the company data center will be implemented at the level of BGP routing exchanges. What hybrid-cloud networking option should you use?
    - **A. Direct peering**
    - B. Indirect peering
    - C. Global load balancing
    - D. Cloud IKE

13. A startup is designing a social site dedicated to discussing global political, social, and environmental issues. The site will include news and opinion pieces in text and video. The startup expects that some stories will be exceedingly popular, and others won't be, but they want to ensure that all users have a similar experience with regard to latency, so they plan to replicate content across regions. What load balancer should they use?
    - **A. HTTP(S)**
    - B. SSL Proxy
    - C. Internal TCP/UDP
    - D. TCP Proxy

14. As a developer, you foresee the need to have a load balancer that can distribute load using only private RFC 1918 addresses. Which load balancer would you use?
    - **A. Internal TCP/UDP**
    - B. HTTP(S)
    - C. SSL Proxy
    - D. TCP Proxy

15. After a thorough review of the options, a team of developers and network engineers have determined that the SSL Proxy load balancer is the best option for their needs. What other GCP service must they have to use the SSL Proxy load balancer?
    - A. Cloud Storage
    - B. Cloud VPN
    - **C. Premium Tier networking**
    - D. TCP Proxy Load Balancing

16. You want to connect to access Cloud Storage APIs from a Compute Engine VM that has only an internal IP address. What GCP service would you use to enable that access?
    - **A. Private Service Connect for Google APIs**
    - B. Dedicated Interconnect
    - C. Partner Interconnect
    - D. HA VPN
