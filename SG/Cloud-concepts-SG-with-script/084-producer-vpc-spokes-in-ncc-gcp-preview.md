# Session 84: Producer VPC Spokes in NCC GCP Preview

## Table of Contents

- [Introduction and Overview](#introduction-and-overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [What is a Producer VPC Spoke?](#what-is-a-producer-vpc-spoke)
  - [Private Service Access Setup](#private-service-access-setup)
  - [Creating Producer VPC Spokes](#creating-producer-vpc-spokes)
  - [Dependencies and Prerequisites](#dependencies-and-prerequisites)
  - [Unique Properties](#unique-properties)
  - [Connectivity Exceptions](#connectivity-exceptions)
  - [IP Range Overlaps and Management](#ip-range-overlaps-and-management)
  - [Supported Services](#supported-services)
- [Lab Demo: Setting Up and Testing Producer VPC Spokes](#lab-demo-setting-up-and-testing-producer-vpc-spokes)
  - [Step 1: Allocate IP Ranges for Private Service Access](#step-1-allocate-ip-ranges-for-private-service-access)
  - [Step 2: Create Private Service Connection](#step-2-create-private-service-connection)
  - [Step 3: Create SQL Instance with Private IP](#step-3-create-sql-instance-with-private-ip)
  - [Step 4: Create NCC Hub](#step-4-create-ncc-hub)
  - [Step 5: Add Consumer VPC as VPC Spoke](#step-5-add-consumer-vpc-as-vpc-spoke)
  - [Step 6: Add Producer VPC Spoke](#step-6-add-producer-vpc-spoke)
  - [Step 7: Add Additional VPC Spokes](#step-7-add-additional-vpc-spokes)
  - [Step 8: Test Connectivity](#step-8-test-connectivity)
- [Common Issues and Mitigation](#common-issues-and-mitigation)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Expert Insights](#expert-insights)

## Introduction and Overview

Welcome to the third part of our Network Connectivity Center (NCC) series, focusing on Producer VPC Spokes in a preview state within Google Cloud Platform (GCP). This session explores a specialized feature of NCC that enables secure sharing of Google-managed services (such as Cloud SQL and Filestore) across multiple VPC networks via private IP addresses.

In traditional cloud networking, connecting services across VPC networks or projects requires complex peering configurations or public IP exposure, which can introduce security risks. Producer VPC Spokes provide a managed solution within NCC to extend connectivity from producer-managed VPCs—where Google services reside—to consumer VPCs through a centralized hub, ensuring secure, private, and routable access.

This feature is particularly valuable for enterprise architectures requiring multi-cloud consistency, cross-project service sharing, or hybrid deployments. By integrating Producer VPC Spokes into your NCC topology, you can eliminate the need for VPNs or interconnects while maintaining control over route propagation and security policies.

As this feature is in preview, certain constraints apply, including topology limitations and supported service integrations. This guide assumes familiarity with basic VPC concepts, NCC fundamentals (covered in previous sessions), and GCP console navigation. We'll follow the instructor's sequence: starting with conceptual foundations, moving through dependencies, and concluding with a hands-on demonstration.

**Key Objectives:**
- Understand the role of Producer VPC Spokes in NCC architectures
- Identify prerequisites and dependency chains
- Configure private service access for supported Google services
- Implement NCC hubs and spokes for cross-network connectivity
- Validate connectivity and troubleshoot common issues

**Transcript Corrections and Notes:**
During transcript review, several spelling and terminology errors were identified and corrected:
- "ping connection" → "peering connection" (throughout)
- "spook" → "spoke" (multiple instances)
- "vbc" → "VPC" (typographical error)
- "NCG" → "NCC" (acronym consistency)
- "peed" → "paired/peered" (contextual correction)
- "VB spoke" → "VPC spoke" (typo)
- Various minor grammatical fixes for clarity (e.g., "bi" → "by", "htp" not present but noted for completeness)
These corrections ensure technical accuracy without altering the original instructional content.

## Key Concepts and Deep Dive

### What is a Producer VPC Spoke?

A Producer VPC Spoke is a specialized NCC resource that makes Google-managed services accessible across NCC networks via private IP addresses. Unlike traditional VPC spokes that connect custom VPCs, producer spokes expose the behind-the-scenes producer VPCs where Google's services (like Cloud SQL or Filestore) operate.

#### How It Works: Conceptual Flow

When you configure Private Service Access, GCP automatically creates a VPC peering connection between your consumer VPC (in your control) and a producer VPC (Google-owned, inaccessible). This peering allows services in the producer VPC to advertise routes to your consumer VPC.

A Producer VPC Spoke extends this by:
- Adding the producer VPC as a "spoke" in your NCC hub
- Exposing the producer VPC's subnet routes to all hub-attached VPCs
- Enabling cross-network access without additional peering configurations

**Diagram: Producer VPC Spoke Architecture**

```mermaid
graph TD
    A[Consumer VPC (Your Project)] -->|VPC Peering| B[Producer VPC (Google Project)]
    B --> C[Cloud SQL Instance<br>(Private IP Assigned)]
    D[NCC Hub] -->|Spoke 1| A
    D -->|Spoke 2| E[Producer VPC Spoke<br>(Routes Producer Subnets)]
    E -->|Exports Routes| D
    F[Other Connected VPCs] --> D
    
    style B fill:#e1f5fe
    style C fill:#b3e5fc
    style E fill:#ffcc80,sroke:#ff8a65
```

> [!IMPORTANT]
> The producer VPC is in a Google-managed project (e.g., servicenetworking), and you cannot access or modify it directly. All interactions occur through NCC and the peering connection.

Key points:
- Single producer VPC spoke creates connectivity to **all** services reachable via the Private Service Access peering
- Routes are subnet-based (not dynamic) for the producer VPC
- Overlaps with consumer VPC allocation ranges must be avoided manually

### Private Service Access Setup

Private Service Access (PSA) is the foundational component enabling Producer VPC Spokes. PSA allocates internal IP ranges within your VPC to allow Google services to assign private IPs for resources like Cloud SQL or Filestore.

- **Configuration Steps:**
  - Go to VPC Networks → Private Service Access → Allocate IP ranges
  - Choose automatic or custom ranges (recommend custom to avoid overlaps)
  - Enable Service Networking API (if not already active)

- **Relationship to NCC:**
  - PSA creates the peering (often named automatically, e.g., "pvpc-networking-<hash>")
  - Without this peering, Producer VPC Spoke creation fails

### Creating Producer VPC Spokes

Producer VPC Spokes require specific inputs:
- **Existing VPC Spoke:** The consumer VPC (where PSA is configured) must already be added as an NCC VPC spoke
- **Peering Connection Name:** Reference to the PSA-created peering (e.g., via API or console inspection)
- **Hub Integration:** The spoke joins the hub, exporting producer subnet routes

**Console Steps:**
1. Navigate to Network Connectivity → Network Connectivity Center
2. Select hub → Add spokes → Choose Producer VPC network
3. Provide spoke name, select consumer VPC spoke, and specify peering connection

### Dependencies and Prerequisites

Creating a Producer VPC Spoke has strict dependencies:
- **Must-Have Resources:**
  - VPC Network with Private Service Access configured
  - Active VPC peering connection from PSA
  - Consumer VPC added as NCC VPC Spoke
  - Hub configured (mesh or star topology with appropriate groups)

**Topology Considerations:**
- In star topology: Producer and consumer spokes must be in the same group (Edge or Center)
- In mesh: Single default group

> [!NOTE]
> The consumer VPC and Producer VPC spoke must coexist as spokes; removing the consumer spoke breaks producer connectivity.

### Unique Properties

- **Resource Ownership:**
  - Producer VPC: Always in Google-owned project; you cannot view or modify it
  - Spokes and Hub: Created in your project
  - Peering and PSA: Initiated in consumer VPC project

- **Connectivity Scope:**
  - Enables multi-project/multi-organization access via shared hub routes
  - No direct connectivity between multiple producer VPC spokes; they remain isolated except through NCC

**Connectivity Rules:**

```diff
+ Producer VPC → Consumer VPCs: Via NCC routes
+ Consumer VPC → Producer VPC: Via NCC routes  
+ Producer VPC → Consumer VPC: Always via peering (not NCC for direct service traffic)
- Producer VPC → Producer VPC: No direct connectivity
! NCC exports only static subnet routes; dynamic routes (e.g., via Cloud Routers) are unsupported
```

### Connectivity Exceptions

Producer VPC Spokes have specific connectivity limitations:
- **No Peer-to-Peer Producer Communication:** Producer spokes cannot connect directly; use NCC routes or additional configurations
- **Peering Persists:** Producer and consumer VPCs retain peering connectivity alongside NCC
- **Isolation Principle:** Forces all cross-producer traffic through NCC hub for policy enforcement

### IP Range Overlaps and Management

NCC does **not** automatically check for IP range overlaps when creating spokes. Manual validation is critical.

**Overlaps to Avoid:**
- Producer allocated ranges (PSA) conflicting with any NCC-attached VPC subnets
- If overlaps occur: PSA cannot allocate new service IPs, causing deployment failures

**Resolution Strategies:**
- **Expand PSA Ranges:** Modify or add new ranges in Private Service Access settings
- **Reallocate Resources:** Recreate SQL/Filestore instances in non-overlapping ranges
- **Audit Regularly:** Check routes in NCC console for conflicts before adding spokes

**Common Overlap Scenarios:**
| Scenario | Detection Method | Mitigation |
|----------|-------------------|------------|
| New VPC spoke conflicts with PSA range | NCC console route inspection | Expand PSA allocation |
| Existing service IPs overlap consumer subnets | GCP console IP range viewer | Relocate PSA ranges |
| Multi-project hub with shared ranges | Cross-project audit tools | Centralize IP management |

> [!WARNING]
> Overlaps may prevent resource creation (e.g., new SQL instances) with opaque errors. Always verify ranges before proceeding.

### Supported Services

- **Primary Services:** Cloud SQL (all flavors), Filestore
- **Access Pattern:** Services assign IPs from PSA-allotted ranges; accessible via private IPs from any NCC-attached VPC
- **Routing:** Static subnet (e.g., 10.0.0.0/24 → Producer VPC)

## Lab Demo: Setting Up and Testing Producer VPC Spokes

This demo creates a complete setup: PSA in Project 1, SQL instance, NCC hub with spokes, and cross-VPC connectivity testing. Assumes you have active GCP projects with billing enabled.

### Step 1: Allocate IP Ranges for Private Service Access

1. In GCP Console, go to VPC Networks → Private Service Access
2. Click "Allocate IP ranges"
3. Configure:
   - Name: sql1
   - Purpose: Custom allocated range
   - Prefix length: /24 (minimum required)
4. Click "Allocate"
5. Repeat for additional range:
   - Name: sql2
   - Purpose: Custom allocated range
   - Prefix length: /24
6. Click "Allocate"

> [!NOTE]
> Skip automatic allocation to prevent uncontrolled overlaps with existing subnets.

### Step 2: Create Private Service Connection

1. In Private Service Access, click "Create Connection"
2. Select "Google Cloud Platform"
3. Go to "Google APIs & services" subsection
4. Choose allocated ranges (e.g., sql1, sql2)
5. Click "Connect"

This creates VPC peering with the Google producer VPC (visible in VPC Peerings as pvpc-networking-<hash>).

### Step 3: Create SQL Instance with Private IP

1. Navigate to SQL → Create instance
2. Choose Cloud SQL for MySQL (or Enterprise)
3. Configure:
   - Instance name: testing-one
   - Password: [set securely]
   - Zone: Single zone for cost-efficiency
   - Machine: db-f1-micro (2 vCPUs, 8GB RAM)
4. Under Connections:
   - Uncheck "Public IP"
   - Check "Private IP"
   - Select the consumer VPC (e.g., first-project-vpc1)
   - Choose PSA range (automatically detects sql1/sql2)
5. Click "Create Instance"

Wait ~5 minutes for provisioning. Notes:
- Instance gets IP from PSA range (e.g., 192.168.0.1)
- No public access; only internal/private connectivity

### Step 4: Create NCC Hub

1. Go to Network Connectivity → Network Connectivity Center
2. Click "Create Hub"
3. Configure:
   - Name: mhub
   - Topology: Mesh (or Star if preferred)
4. Click "Create"

### Step 5: Add Consumer VPC as VPC Spoke

1. In NCC → Spokes → Add spokes
2. Select "VPC network"
3. Configure:
   - Spoke name: first-project-vpc1-spoke
   - VPC network: first-project-vpc1 (consumer network)
   - Hub: mhub
   - No filters (covered in prior sessions)
4. Click "Create"

### Step 6: Add Producer VPC Spoke

1. In NCC → Spokes → Add spokes
2. Select "Producer VPC network"
3. Configure:
   - Spoke name: my-sql-producer
   - Hub: mhub
   - Consumer VPC spoke: Select from dropdown (first-project-vpc1-spoke)
   - Peering connection: Auto-detected (pvpc-networking-<hash>)
   - Optional: Add filters (same as VPC spokes)
4. Click "Create"

Routes now appear: PSA ranges (e.g., 192.168.1.0/24) and SQL subnets.

### Step 7: Add Additional VPC Spokes

Repeat Step 5 for other VPCs (e.g., first-project-vpc3, second-project-vpc1):
1. Add spoke for first-project-vpc3
2. For second-project-vpc1 (different project): Specify Project ID and Hub name in NCC console
3. Accept pending spokes if using restricted acceptance

### Step 8: Test Connectivity

From VMs in consumer VPCs:

1. SSH into VM (in consumer VPC, e.g., first-project-vpc3-vm)
2. Run MySQL client:

```bash
mysql -h <SQL-Private-IP> -u root -p <password>
```

   - Example: `mysql -h 192.168.1.3 -u root -p`

**Expected Results:**
- Pre-NCC: Connection timeout/error
- Post-NCC: Successful MySQL access from any attached consumer VPC (same project, cross-project, multi-org)

Verify routes in NCC console: Producer ranges (e.g., 192.168.1.0/24) propagate to all spokes.

## Common Issues and Mitigation

| Issue | Symptoms | Resolution | Prevention |
|-------|----------|------------|------------|
| No Consumer Spoke Dropdown | Producer spoke creation blocked | Add consumer VPC as spoke first | Follow dependency order |
| Missing Peering | Error: No pairing connection | Verify PSA configuration; recreate if needed | Enable Service Networking API pre-setup |
| Route Not Propagating | Connectivity fails after spoke addition | Check meshed topology groups; ensure same group membership | Use mesh topology for simplicity |
| IP Overlap | PSA range conflicts | Expand/modify PSA ranges; recreate services | Audit all VPC subnets before allocating |
| Cross-Project Failure | Spoke remains inactive | Enable hub in target project; accept spokes | Use auto-acceptance for trusted projects |

## Summary

### Key Takeaways

```diff
+ Producer VPC Spokes enable secure, private sharing of Google services (e.g., Cloud SQL) across NCC-connected VPCs via hub routes
+ Requires Private Service Access setup and consumer VPC spoke as prerequisite
+ Exports static subnet routes; supports mesh/star topologies with group alignment
+ Manual IP overlap checking is essential (NCC doesn't automate this)
+ Connectivity flows: Consumer VPCs ↔ NCC Hub ↔ Producer VPC Spoke (via peering fallback)
- Avoids public IPs and complex peering; isolates producer traffic through NCC
! Preview feature: Limited to specific Google services; dynamic routes unsupported
+ Demo validates end-to-end flow: Create PSA → Peering → SQL → NCC Hub/Spokes → Cross-VPC Access
```

### Expert Insights

**Real-world Application:**
In production enterprises, Producer VPC Spokes streamline multi-project/multi-cloud architectures. For example, centralize Cloud SQL analytics in a secure producer VPC, then grant read-only access to data science teams across regional VPCs via NCC without exposing public endpoints. This supports compliance-heavy environments (e.g., HIPAA) by keeping all traffic private and routable through centralized security inspection points in the NCC hub.

**Expert Path:**
To master this feature, focus on NCC topology design:
1. Diagram hub/spoke hierarchies for your org's VPC landscape
2. Practice PSA range planning with Terraform (automate overlap checks)
3. Integrate with Cloud Routing for hybrid scenarios (once dynamic routes are supported)
4. Monitor via Cloud Logging/Operations Suite for route propagation anomalies
5. Study related NCC features like appliance spokes for on-prem extensions

**Common Pitfalls:**
- Forgetting dependency chain: Creation fails silently if consumer spoke isn't added first
- Overlapping IP ranges: Leads to baffling deployment errors; always document and audit allocations
- Topology mismatches: Star group misalignments break connectivity; default to mesh if unsure
- Route propagation delays: Newly created services don't immediately appear in NCC routes
- Preview limitations: Expect instability; avoid in critical prod without extensive testing

**Lesser Known Things:**
1. Producer VPC spokes don't support BGP/dynamic routing—routes are static and tied to PSA allocations; updates require spoke recreation.
2. The peering connection remains active even after NCC spoke removal, allowing fallback connectivity if NCC fails.
3. NCC routes for producer spokes appear only after service usage begins (e.g., after SQL instance starts), not before.
4. Producer VPCs are organization-agnostic: You can share services across different GCP organizations via shared NCC hubs.
5. Cost impact: Producer spokes don't add compute charges but amplify data transfer costs across spokes due to centralized routing.

**Model ID Reference:** CL-KK-Terminal

<summary>
Instructions complied with for Session 84 processing: Transcript fully integrated into structured Markdown study guide, including live demo steps, corrections logged, and preview status emphasized.
</summary>
