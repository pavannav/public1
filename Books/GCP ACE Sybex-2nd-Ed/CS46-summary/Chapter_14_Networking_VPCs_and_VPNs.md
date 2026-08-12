# Chapter 14: Networking in the Cloud: Virtual Private Clouds and Virtual Private Networks

## Exam Objectives Covered

- **2.4 Planning and configuring network resources**
- **4.5 Managing networking resources**

---

## Introduction

This chapter covers:

- Creating VPCs with default and custom subnets
- Shared VPCs and VPC network peering
- Deploying Compute Engine VMs with custom network configurations
- Creating and configuring firewall rules
- Creating Virtual Private Networks (VPNs)

---

## Creating a Virtual Private Cloud with Subnets

**VPCs** are software versions of physical networks that link resources in a project.

| VPC Property | Details |
|---|---|
| **Scope** | **Global** — not tied to a specific region or zone |
| **Auto-created** | Google Cloud automatically creates a default VPC for each new project |
| **Subnets** | **Regional** resources within a VPC; each has an IP address range |
| **Shared VPC** | Hosted in a common project; users in other projects can create resources in it |
| **VPC Peering** | Interproject connectivity without requiring an organization |

Resources (Compute Engine VMs, GKE clusters) communicate within a VPC unless blocked by a firewall rule.

---

### Creating a Virtual Private Cloud with Cloud Console

Navigate to **VPC Networks** in Cloud Console.

![The VPC Network page of Cloud Console](../images/c14f001.png)

**Figure 14.1** The VPC Network page of Cloud Console

Click **Create VPC Network**:

![Creating a VPC in Cloud Console, part 1](../images/c14f002.png)

**Figure 14.2** Creating a VPC in Cloud Console, part 1

**VPC modes:**

| Mode | Subnet Creation | IP Ranges |
|---|---|---|
| **Auto** | Automatically creates a subnet in each region | Google Cloud assigns IP ranges |
| **Custom** | You create subnets manually | You specify IP ranges (CIDR notation) |

**Custom subnet options** (Custom tab → Subnet section):

![Creating a custom subnet](../images/c14f003.png)

**Figure 14.3** Creating a custom subnet

| Option | Description |
|---|---|
| Region | Region for the subnet |
| IP range | CIDR notation (e.g., `10.10.0.0/16`) |
| **Private Google Access** | Allows VMs without external IPs to access Google APIs/services |
| **Flow Logs** | Logs network traffic for this subnet to Cloud Logging |

**VPC part 2 — Firewall rules and routing:**

![Creating a VPC in Cloud Console, part 2](../images/c14f004.png)

**Figure 14.4** Creating a VPC in Cloud Console, part 2

| Setting | Options |
|---|---|
| **Firewall Rules** | Pre-defined rules (e.g., allow SSH on port 22 from 0.0.0.0/0) |
| **Dynamic Routing** | **Regional** — Cloud Routers learn routes within the region only; **Global** — learn routes on all subnetworks in the VPC |
| **DNS Server Policy** | Optional; choose Google Cloud DNS or customize name resolution order |

After creation, VPC and subnets appear in the listing:

![Listing of VPCs and subnets](../images/c14f005.png)

**Figure 14.5** Listing of VPCs and subnets

---

### Creating a Virtual Private Cloud with gcloud

**Create an auto-mode VPC:**

```bash
gcloud compute networks create ace-exam-vpc1 --subnet-mode=auto
```

**Create a custom-mode VPC:**

```bash
gcloud compute networks create ace-exam-vpc1 --subnet-mode=custom
```

**Create a subnet in the custom VPC:**

```bash
gcloud compute networks subnets create ace-exam-vpc-subnet1 \
    --network=ace-exam-vpc1 \
    --region=us-west2 \
    --range=10.10.0.0/16 \
    --enable-private-ip-google-access \
    --enable-flow-logs
```

---

### Understanding CIDR Notation

**CIDR (Classless Interdomain Routing)** uses variable-length subnet masking (VLSM) to define flexible network sizes.

**Format:** `<IP address>/<subnet mask size>`

- The number after the `/` = how many bits are used for the **network** portion
- Remaining bits = **host** addresses

**RFC1918 private address ranges:**

| Range | CIDR | Host Addresses |
|---|---|---|
| 10.0.0.0 – 10.255.255.255 | /8 | ~16.7 million |
| 172.16.0.0 – 172.31.255.255 | /12 | ~1 million |
| 192.168.0.0 – 192.168.255.255 | /16 | 65,534 |

**Examples:**

| CIDR Block | Network Bits | Host Bits | Host Addresses |
|---|---|---|---|
| `192.168.0.0/16` | 16 | 16 | 65,534 |
| `172.16.0.0/12` | 12 | 20 | 1,048,574 |
| `10.0.0.0/8` | 8 | 24 | ~16.7 million |
| `0.0.0.0/0` | 0 | 32 | All addresses |

> **Rule:** Smaller number after `/` = more host addresses available.

---

### Creating a Shared Virtual Private Cloud Using gcloud

A **Shared VPC** is hosted in one project (host project) and shared with other projects (service projects).

**Step 1: Assign the Shared VPC Admin role**

At the **organization** level:

```bash
gcloud organizations add-iam-policy-binding [ORG_ID] \
    --member='user:[EMAIL_ADDRESS]' \
    --role="roles/compute.xpnAdmin"
```

Get the organization ID:

```bash
gcloud organizations list
```

At the **folder** level:

```bash
gcloud resource-manager folders add-iam-policy-binding [FOLDER_ID] \
    --member='user:[EMAIL_ADDRESS]' \
    --role="roles/compute.xpnAdmin"

# Get folder IDs:
gcloud resource-manager folders list --organization=[ORG_ID]
```

**Step 2: Enable the shared VPC on the host project:**

```bash
gcloud compute shared-vpc enable [HOST_PROJECT_ID]
```

**Step 3: Associate service projects:**

```bash
gcloud compute shared-vpc associated-projects add [SERVICE_PROJECT_ID] \
    --host-project [HOST_PROJECT_ID]
```

---

### VPC Network Peering (Interproject without an Organization)

VPC network peering enables private traffic between VPCs in different projects without requiring a shared organization. Both networks must create a peering entry pointing to the other:

```bash
# Peer from network A to network B
gcloud compute networks peerings create peer-ace-exam-1 \
    --network ace-exam-network-A \
    --peer-project ace-exam-project-B \
    --peer-network ace-exam-network-B \
    --auto-create-routes

# Peer from network B to network A
gcloud compute networks peerings create peer-ace-exam-1 \
    --network ace-exam-network-B \
    --peer-project ace-exam-project-A \
    --peer-network ace-exam-network-A \
    --auto-create-routes
```

---

## Deploying Compute Engine with a Custom Network

You can assign a VM to a specific subnet when creating an instance.

### Using Cloud Console

Navigate to **Compute Engine → Create Instance** → expand **Management ➢ Security ➢ Disks ➢ Networking ➢ Sole Tenancy** → click **Networking** tab.

![Preliminary options to create an instance in Cloud Console](../images/c14f006.png)

**Figure 14.6** Preliminary options to create an instance in Cloud Console

![Networking configuration options](../images/c14f007.png)

**Figure 14.7** Networking configuration options

- **Network tags** — used for defining firewall rules and routes
- Click **Add Network Interface** to assign a custom VPC and subnet

![Options to add a custom network interface](../images/c14f008.png)

**Figure 14.8** Options to add a custom network interface

**IP address options:**

| Setting | Options |
|---|---|
| Primary Internal IP | Ephemeral (auto) or Static |
| External IP | Ephemeral (auto), Static, or None |

### Using gcloud

```bash
gcloud compute instances create [INSTANCE_NAME] \
    --subnet [SUBNET_NAME] \
    --zone [ZONE_NAME]
```

---

## Creating Firewall Rules for a Virtual Private Cloud

Firewall rules are defined at the **network level** and control traffic flow to VMs.

**Key properties:**
- **Stateful** — if a connection is allowed in one direction, return traffic is automatically allowed
- An active connection = at least one packet exchanged every 10 minutes
- Applied at the **subnet (network)** level

### Structure of Firewall Rules

| Component | Description |
|---|---|
| **Direction** | Ingress (incoming) or Egress (outgoing) |
| **Priority** | Integer 0–65535; **0 = highest priority**, 65535 = lowest; highest-priority matching rule wins |
| **Action** | Allow or Deny (only one per rule) |
| **Target** | Instances the rule applies to: all instances in network, instances with specific network tags, or instances using a specific service account |
| **Source/Destination** | **Source** (ingress): IP ranges, network tags, service accounts, or combinations. **Destination** (egress): IP ranges only. `0.0.0.0/0` = any IP |
| **Protocol and Port** | TCP, UDP, ICMP, etc. + port or port range; if omitted, applies to all protocols |
| **Enforcement Status** | Enabled or Disabled (disabled rules not applied — useful for troubleshooting) |

**Implied rules (every VPC):**

| Rule | Direction | Action | Priority |
|---|---|---|---|
| Allow all egress | Egress | Allow | 65535 |
| Deny all ingress | Ingress | Deny | 65535 |

> Cannot delete implied rules. Override them by creating rules with higher priority (lower number).

**Default network rules (created automatically with auto-mode VPC):**

| Rule | Traffic | Priority |
|---|---|---|
| Allow ingress from any VM on same network | All protocols | 65534 |
| Allow ingress TCP port 22 (SSH) | TCP:22 | 65534 |
| Allow ingress TCP port 3389 (RDP) | TCP:3389 | 65534 |
| Allow ingress ICMP from any source | ICMP | 65534 |

---

### Creating Firewall Rules Using Cloud Console

Navigate to **VPC Networks → Firewall**.

![List of firewall rules in the VPC section of Cloud Console](../images/c14f009.png)

**Figure 14.9** List of firewall rules in the VPC section of Cloud Console

Click **Create Firewall Rule**:

![Creating a firewall rule](../images/c14f010.png)

**Figure 14.10** Creating a firewall rule

**Target type options:**

![List of target types](../images/c14f011.png)

**Figure 14.11** List of target types

- All instances in the network
- Instances with specific network tags
- Instances using a specific service account

**Source filter types:**

![List of source filter types](../images/c14f012.png)

**Figure 14.12** List of source filter types

- IP ranges
- Subnets
- Source tags
- Service accounts
- Combinations of the above (secondary source filter available)

After creation, the rule appears in the firewall rule listing:

![Listing of the firewall rule created using the earlier configuration](../images/c14f013.png)

**Figure 14.13** Listing of the firewall rule created using the earlier configuration

---

### Creating Firewall Rules Using gcloud

**Command:** `gcloud compute firewall-rules create`

**Key parameters:**

| Parameter | Description |
|---|---|
| `--action` | ALLOW or DENY |
| `--allow` | Protocol and port (e.g., `tcp:22`, `udp:20000-25000`) |
| `--description` | Rule description |
| `--destination-ranges` | Egress IP destination ranges |
| `--direction` | INGRESS or EGRESS |
| `--network` | VPC network to apply the rule to |
| `--priority` | 0–65535 (0 = highest priority) |
| `--source-ranges` | Ingress source IP ranges |
| `--source-service-accounts` | Ingress source service accounts |
| `--source-tags` | Ingress source network tags |
| `--target-service-accounts` | Target instances by service account |
| `--target-tags` | Target instances by network tag |

**Example — allow TCP traffic on ports 20000–25000:**

```bash
gcloud compute firewall-rules create ace-exam-fwr2 \
    --network ace-exam-vpc1 \
    --allow tcp:20000-25000
```

**Example — allow UDP traffic on ports 20000–30000 for ingress:**

```bash
gcloud compute firewall-rules create fwr1 \
    --allow=udp:20000-30000 \
    --direction=ingress
```

---

## Creating a Virtual Private Network

**VPNs** securely send network traffic between the Google Cloud network and an on-premises (or other) network by encrypting the connection.

**VPN types:**

| Type | Routing | IP Support | Availability SLA | Status |
|---|---|---|---|---|
| **HA VPN** | Dynamic (BGP) | IPv4 and IPv6 | **99.99%** within a region | Recommended |
| **Classic VPN** | Dynamic or static | IPv4 only | Less than HA | Partially deprecated |

> **Classic VPN** is partially deprecated. It can still be used for dynamic routing to Compute Engine VPN gateways but cannot be used for connections outside of Google Cloud.

> **HA VPN** uses **two tunnels** for high availability.

---

### Creating a Virtual Private Network Using Cloud Console

Navigate to **Hybrid Connectivity** in Cloud Console.

![Hybrid Connectivity section of Cloud Console](../images/c14f014.png)

**Figure 14.14** Hybrid Connectivity section of Cloud Console

Click **Create VPN Connection**:

![Creating a VPN connection, part 1](../images/c14f015.png)

**Figure 14.15** Creating a VPN connection, part 1

Choose **HA VPN** (recommended) or **Classic VPN**.

**HA VPN configuration:**

![Creating a high availability VPN](../images/c14f016.png)

**Figure 14.16** Creating a high availability VPN

Specify: VPN gateway name, VPC network, and region.

**Add VPN Tunnels:**

Tunnels connect the VPN gateway to a peer gateway (on-premises, another cloud, or Google Cloud).

![Configuring tunnels in an HA VPN](../images/c14f017.png)

**Figure 14.17** Configuring tunnels in an HA VPN

**Tunnel configuration options:**
- Name and description
- IP address of the VPN gateway on your network (peer gateway)
- Choose an existing peer VPN gateway or create a new one
- New peer gateway: name, 1/2/4 interfaces, external IP address

---

> ### Real World Scenario: Analytics in the Cloud
>
> Data scientists need access to both company transaction data (on-premises) and cloud-based analytics tools (Spark, ML services). Security policies prevent copying data over unsecured Internet connections.
>
> **Solution:** Create a **VPN** between the company data center and Google Cloud:
> - Network traffic between data center and cloud is **encrypted**
> - Analysts can securely access on-premises data using cloud tools
> - Information security teams maintain **confidentiality and integrity** of the data
>
> This is a common enterprise pattern for hybrid cloud architectures.

---

### Creating a Virtual Private Network Using gcloud

Three commands are used together to create a VPN from the command line:

| Command | Purpose |
|---|---|
| `gcloud compute target-vpn-gateways` | Create the VPN gateway |
| `gcloud compute forwarding-rules create` | Create forwarding rules |
| `gcloud compute vpn-tunnels create` | Create VPN tunnels |

**Create VPN tunnel (Classic VPN):**

```bash
gcloud compute vpn-tunnels create NAME \
    --peer-address=PEER_ADDRESS \
    --shared-secret=SHARED_SECRET \
    --target-vpn-gateway=TARGET_VPN_GATEWAY
```

| Parameter | Description |
|---|---|
| `NAME` | Name of the tunnel |
| `--peer-address` | IPv4 address of the remote tunnel endpoint |
| `--shared-secret` | Shared secret string for authentication |
| `--target-vpn-gateway` | Reference to the target VPN gateway |

> For **HA VPN**, also specify `--peer-gcp-gateway` (for Google Cloud peer) or `--peer-external-gateway` (for on-premises peer).

**Create forwarding rule:**

```bash
gcloud compute forwarding-rules create NAME \
    --TARGET_SPECIFICATION=VPN_GATEWAY
```

Where `TARGET_SPECIFICATION` can be `--target-instance`, `--target-http-proxy`, `--target-vpn-gateway`, etc.

---

## Summary

| Concept | Key Points |
|---|---|
| **VPC** | Global; contains regional subnets; auto or custom mode |
| **Subnet** | Regional; CIDR range; Private Google Access; Flow Logs |
| **Shared VPC** | Hosted in one project; shared via org/folder level IAM |
| **VPC Peering** | Interproject connectivity; no organization required; must peer both directions |
| **Firewall Rules** | Network level; stateful; direction, priority, action, target, source, protocol/port |
| **VPN** | Encrypted tunnel between VPC and on-premises; HA VPN (99.99%) recommended |
| **CIDR** | `IP/mask`; smaller mask number = more hosts; `0.0.0.0/0` = all addresses |

---

## Exam Essentials

- **VPCs are global; subnets are regional.** VPCs link resources in a project. Auto-mode VPCs create subnets in every region. Custom-mode VPCs require manual subnet creation with CIDR ranges.

- **Understand CIDR notation.** Format: `IP/mask-size`. Smaller mask number = more IP addresses. `0.0.0.0/0` = any address. Key private ranges: `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`.

- **VPCs created with gcloud:** `gcloud compute networks create`. Shared VPCs: `gcloud compute shared-vpc`. VPC peering: `gcloud compute networks peerings create`. Need Shared VPC Admin role (`roles/compute.xpnAdmin`) bound at org/folder level.

- **Add network interfaces to VMs.** Configure instances to use a particular subnet. Assign ephemeral or static (internal/external) IP addresses.

- **Firewall rules control traffic flow.** Components: direction, priority (0=highest, 65535=lowest), action (allow/deny), target, source/destination, protocol/port, enforcement status. Command: `gcloud compute firewall-rules create`. Parameter `--network` specifies the VPC.

- **VPN types: HA VPN and Classic VPN.** HA VPN: 99.99% SLA, BGP dynamic routing, dual tunnels, IPv4+IPv6. Classic VPN: partially deprecated. Create with `gcloud compute target-vpn-gateways`, `gcloud compute forwarding-rules`, and `gcloud compute vpn-tunnels`. Navigate via Hybrid Connectivity in Cloud Console.

---

## Review Questions

1. What kinds of resource are virtual private clouds in Google Cloud?
   - A. Zonal
   - B. Regional
   - C. Super-regional
   - **D. Global**

2. You have been tasked with defining CIDR ranges for a project with two VPCs and several subnets in each VPC. How many CIDR ranges will you need to define?
   - A. One for each VPC
   - **B. One for each subnet**
   - C. One for each region
   - D. One for each zone

3. A VPC network has not learned global routes. What parameter may have been missed when creating the VPC subnets?
   - A. DNS server policy
   - **B. Dynamic routing**
   - C. Static routing policy
   - D. Systemic routing policy

4. The command used to create a VPC from the command line is:
   - **A. `gcloud compute networks create`**
   - B. `gcloud networks vpc create`
   - C. `gsutil networks vpc create`
   - D. `gcloud compute create networks`

5. One subnet is not sending logs to Cloud Logging. What option may have been misconfigured when creating that subnet?
   - **A. Flow Logs**
   - B. Private IP Access
   - C. Cloud Logging
   - D. Variable-length subnet masking

6. At what levels of the resource hierarchy can a shared VPC be created?
   - A. Folders and resources
   - B. Organizations and project
   - **C. Organizations and folders**
   - D. Folders and subnets

7. You are using Cloud Console to create a VM in a custom subnet. What section of the Create Instance page would you use to specify the custom subnet?
   - **A. Networking tab of the Management, Security, Disks, Networking, Sole Tenancy section**
   - B. Management tab of the Management, Security, Disks, Networking, Sole Tenancy section
   - C. Sole Tenancy tab of Management, Security, Disks, Networking, Sole Tenancy
   - D. Sole Tenancy tab of Management, Security, Disks, Networking

8. You want to implement interproject communication between VPCs. Which feature would you use?
   - **A. VPC network peering**
   - B. Interproject peering
   - C. VPN
   - D. Interconnect

9. You want to limit traffic to a set of instances with a specific network tag. What part of a firewall rule references the network tag?
   - A. Action
   - **B. Target**
   - C. Priority
   - D. Direction

10. What part of a firewall rule determines whether a rule applies to incoming or outgoing traffic?
    - A. Action
    - B. Target
    - C. Priority
    - **D. Direction**

11. You want to define a CIDR range that applies to all destination addresses. What IP address would you specify?
    - **A. 0.0.0.0/0**
    - B. 10.0.0.0/8
    - C. 172.16.0.0/12
    - D. 192.168.0.0/16

12. You are using `gcloud` to create a firewall rule. Which command would you use?
    - A. `gcloud network firewall-rules create`
    - **B. `gcloud compute firewall-rules create`**
    - C. `gcloud network rules create`
    - D. `gcloud compute rules create`

13. You are using `gcloud` to create a firewall rule. Which parameter would you use to specify the subnet it should apply to?
    - A. `--subnet`
    - **B. `--network`**
    - C. `--destination`
    - D. `--source-ranges`

14. An application team wants to limit traffic to endpoints accepting any UDP traffic on ports 20000–30000. Which command would you use?
    - **A. `gcloud compute firewall-rules create fwr1 --allow=udp:20000-30000 --direction=ingress`**
    - B. `gcloud network firewall-rules create fwr1 --allow=udp:20000-30000 --direction=ingress`
    - C. `gcloud compute firewall-rules create fwr1 --allow=udp`
    - D. `gcloud compute firewall-rules create fwr1 --direction=ingress`

15. You have a rule to allow inbound traffic to a VM. You want it to apply only if there is not another rule that would deny that traffic. What priority should you give this rule?
    - A. 0
    - B. 1
    - C. 1000
    - **D. 65535**

16. You want to create a VPN using Cloud Console. What section of Cloud Console should you use?
    - A. Compute Engine
    - B. App Engine
    - **C. Hybrid Connectivity**
    - D. IAM & Admin

17. Your company needs at least a 99.99 percent availability SLA for networking between on-premises networks and a VPC. What should you use?
    - A. Classic VPN
    - **B. HA VPN**
    - C. Shared VPC
    - D. VPC network peering

18. You want the router on a tunnel to learn routes from all Google Cloud regions on the network. What feature would you enable?
    - **A. Global dynamic routing**
    - B. Regional routing
    - C. VPC
    - D. Firewall rules

19. What `gcloud` command would you use to create tunnels for a VPN?
    - A. `gcloud network vpn-tunnels create`
    - **B. `gcloud compute vpn-tunnels create`**
    - C. `gcloud network create vpn-tunnels`
    - D. `gcloud compute create vpn-tunnels`

20. You are using `gcloud` to create a VPN. Which command(s) would you use?
    - A. `gcloud compute target-vpn-gateways` only
    - B. `gcloud compute forwarding-rule` and `gcloud compute target-vpn-gateways` only
    - C. `gcloud compute vpn-tunnels` only
    - **D. `gcloud compute forwarding-rule`, `gcloud compute target-vpn-gateways`, and `gcloud compute vpn-tunnels`**
