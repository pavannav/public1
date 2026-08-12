# Chapter 5: Computing with Compute Engine Virtual Machines

> **Exam Objectives Covered:**
> - 1.3 Installing and configuring the command line interface (CLI), specifically Cloud SDK (e.g., setting the default project)
> - 2.2 Planning and configuring compute resources — selecting appropriate compute choices, using preemptible VMs and custom machine types as appropriate

---

This chapter covers Google Cloud Console (GUI), Google Cloud SDK (CLI), and Cloud Shell for creating and managing Compute Engine VMs. It also covers basic VM management tasks and cost considerations.

---

## Creating and Configuring Virtual Machines with the Console

Three ways to create a VM:
1. **Google Cloud Console** (web-based GUI)
2. **Google Cloud SDK** (local CLI)
3. **Google Cloud Shell** (browser-based CLI)

**Console URL:** `https://console.cloud.google.com`

### Main Virtual Machine Configuration Details

**Console path:** Compute Engine → VM Instances → Create Instance

![The main starting form of Google Cloud Console](../images/c05f001.png)

**Figure 5.1** — Google Cloud Console main starting form

![The Project form lets you choose the project you want to work with when creating VMs.](../images/c05f002.png)

**Figure 5.2** — Project selection form

![The starting panel for creating a VM](../images/c05f003.png)

**Figure 5.3** — Compute Engine VM Instances starting panel

![Part of the main configuration form for creating VMs in Compute Engine](../images/c05f004.png)

**Figure 5.4** — Create Instance main configuration form

**Required parameters when creating a VM:**

| Parameter | Description |
|---|---|
| **Name** | VM name (for your use; Google uses internal identifiers) |
| **Region** | Major geographical area |
| **Zone** | Data center–like facility within a region |
| **Machine type** | Number of vCPUs and amount of memory |
| **Boot disk** | Operating system image |

> **Note:** A billing account must be enabled before creating a VM for the first time.

![A partial list of regions providing Compute Engine services](../images/c05f005.png)

**Figure 5.5** — Partial list of Compute Engine regions

![A list of zones within the us-east1 region](../images/c05f006.png)

**Figure 5.6** — Zones within us-east1

**Machine family hierarchy:**

```
Machine Family (e.g., General Purpose, Compute Optimized, Memory Optimized)
  └── Series (e.g., E2, N2, C2, M2)
        └── Generation
              └── Machine Type (varies by vCPU count and memory)
```

![A partial list of machine types available in the us-east1-b zone](../images/c05f007.png)

**Figure 5.7** — Partial list of machine types in us-east1-b (E2 series)

![Virtual machines within a machine family are further organized into series and generations based on the type of processor.](../images/c05f008.png)

**Figure 5.8** — Machine family → series → generation hierarchy

> **Confidential VM Service** — keeps data in memory encrypted using keys Google does not have access to. Useful for high-security applications.

> **Running containers in a VM** — you can specify a container from a public repository or Google Container Registry to run inside the VM.

**Boot disk types:**

| Disk Type | Storage | Characteristics |
|---|---|---|
| **Balanced Persistent Disk** | SSD | Balances cost and performance |
| **Extreme Persistent Disk** | SSD | High performance; provision desired IOPS level |
| **SSD Persistent Disk** | SSD | Solid-state drives |
| **Standard Persistent Disk** | HDD | Standard hard disk drives; lower cost |

![Form for configuring the boot disk of the VM](../images/c05f009.png)

**Figure 5.9** — Boot disk configuration form

**Identity and API Access:**

- Specify a **service account** for the VM.
- Set the **scope of API access** — limit which APIs the VM's processes can call.

![Identity And API Access and Firewall configurations](../images/c05f010.png)

**Figure 5.10** — Identity and API Access and Firewall configuration

---

### Advanced Configuration Details

Accessed via: **Management, Security, Disks, Networking, and Sole Tenancy** tabs.

#### Management Tab

![The first part of the Management tab of the VM creation form](../images/c05f011.png)

**Figure 5.11** — Management tab

| Option | Description |
|---|---|
| **Description** | Free-text description of the VM and its use |
| **Labels** | Key-value pairs for VM management and cost tracking; best practice to always include |
| **Deletion Protection** | Forces confirmation before deleting; operation fails if enabled |
| **Reservations** | Compute Engine instance reservation settings |
| **Startup Script** | Bash or Python script pasted into Automation text box; runs on every startup |
| **Metadata** | Key-value pairs stored in a metadata server; queryable via Compute Engine API; useful for parameterizing startup/shutdown scripts |

**Availability Policy drop-down options:**

| Option | Values | Description |
|---|---|---|
| **VM Provisioning Model** | Standard / Spot | Spot allows Google to shut down with 30-second notice; ~80% cheaper |
| **On Host Maintenance** | Migrate / Terminate | Whether to migrate VM to another physical server during maintenance |
| **Automatic Restart** | On / Off | Restart VM on hardware failure or non-user-initiated shutdown |

#### Security Tab

**Shielded VM security features:**

| Feature | Purpose |
|---|---|
| **Secure Boot** | Checks digital signatures of OS software; halts boot if check fails; protects against rootkits |
| **vTPM** (Virtual Trusted Platform Module) | Virtualizes a hardware TPM chip; protects security resources (keys, certificates) |
| **Integrity Monitoring** | Compares current boot measurements to a known-good baseline; detects tampering |

- **Project-wide SSH keys** — by default, give all project users access to VMs. Can be **blocked at the VM level**.

![You can place additional security controls on VMs.](../images/c05f012.png)

**Figure 5.12** — Security tab with Shielded VM options

#### Boot Disks and Additional Disks

**Boot disk advanced settings:**
- **Deletion Rule** — whether boot disk is deleted when instance is deleted.
- **Encryption key management** — Google-managed (default), CMEK, or CSEK.

![Boot disk advanced configuration](../images/c05f013.png)

**Figure 5.13** — Boot disk advanced configuration

**Adding a new disk:**

| Field | Description |
|---|---|
| Name and description | Identifier for the disk |
| Source | Blank disk, snapshot, or image |
| Disk size and type | Storage capacity and performance tier |
| Snapshot schedule | Automated backup schedule |
| Encryption | Google-managed (default), CMEK, or CSEK |

![Adding a new disk to a Compute Engine instance](../images/c05f014.png)

**Figure 5.14** — Adding a new disk

**Attaching an existing disk:**
- Choose disk from list of existing disks.
- Attach as **Read/Write** or **Read-Only**.
- Specify whether disk is deleted when VM is deleted (default: **keep the disk**).
- Optionally provide a custom disk name.

![Form for adding an existing disk to a VM](../images/c05f015.png)

**Figure 5.15** — Attaching an existing disk

#### Networking Tab

- View and configure **network interface** (IP address).
- Add a **second network interface** (useful for proxies or servers bridging two networks).
- Add **network tags**.

![Options for network configuration of a VM](../images/c05f016.png)

**Figure 5.16** — Networking tab options

#### Sole-Tenancy Tab

- Ensures your VMs run on a physical server **with only your project's VMs**.
- Uses **node affinity labels** to control placement.
- CPU overcommit is permitted only on machines with **4 or more CPUs**.

![Sole tenancy configuration options](../images/c05f017.png)

**Figure 5.17** — Sole tenancy configuration

---

## Creating and Configuring Virtual Machines with Cloud SDK

### Installing Cloud SDK

Three options for interacting with Google Cloud:

| Method | Description |
|---|---|
| **CLI (Cloud SDK)** | Install locally; use `gcloud` commands |
| **RESTful interface** | Programmatic API access |
| **Cloud Shell** | Browser-based; Cloud SDK pre-installed |

Cloud SDK supports: **Linux, Windows, macOS**

#### Installing Cloud SDK on Linux

**For Ubuntu/Debian (using `apt-get`):**

```bash
# Step 1: Add gcloud CLI URI as package source
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a \
/etc/apt/sources.list.d/google-cloud-sdk.list

# Step 2: Import Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key \
--keyring /usr/share/keyrings/cloud.google.gpg add -

# Step 3: Update package list and install Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-cli
```

- For Red Hat Enterprise / CentOS: use `yum` (see `https://cloud.google.com/sdk/docs/install-sdk#rpm`)

#### Cloud SDK on macOS

- Requires **Python 3**.
- Three versions: 32-bit macOS, 64-bit x86, 64-bit arm64 (Apple M1).
- Instructions: `https://cloud.google.com/sdk/docs/install-sdk#mac`

#### Installing Cloud SDK on Windows

- Download installer from: `https://cloud.google.com/sdk/docs/install-sdk#windows`

---

### Initializing Cloud SDK

After installation, initialize with:

```bash
gcloud init
```

- Provides an **authentication link** — open in browser, authenticate with Google, copy response code back to terminal.
- Prompts to **select or create a project** — selected project becomes the **default project** for subsequent commands.

---

### Creating a Virtual Machine with Cloud SDK

The `gcloud` command is the top-level command. It manages:

| Service | Command Group |
|---|---|
| Compute Engine | `gcloud compute` |
| Cloud SQL | `gcloud sql` |
| Kubernetes Engine | `gcloud container` |
| Cloud Dataproc | `gcloud dataproc` |
| Cloud DNS | `gcloud dns` |
| Cloud Deployment Manager | `gcloud deployment-manager` |

**`gcloud` command structure:**

```
gcloud  <service>  <resource-type>  <command/verb>  [OPTIONS]
```

**Example commands:**

```bash
# Create two VM instances (uses default project and zone)
gcloud compute instances create ace-instance-1 ace-instance-2

# View default project information
gcloud compute project-info describe

# Create VMs in a specific zone
gcloud compute instances create ace-instance-1 ace-instance-2 --zone=us-central1-a

# List all VMs in the current project
gcloud compute instances list

# Create a VM with a specific machine type
gcloud compute instances create ace-instance-n1s8 --machine-type=e2-standard-2

# Create a preemptible VM
gcloud compute instances create --machine-type=n1-standard-8 --preemptible ace-instance-1
```

**Common `gcloud compute instances create` parameters:**

| Parameter | Description |
|---|---|
| `--boot-disk-size` | Boot disk size (10 GB to 2 TB) |
| `--boot-disk-type` | Disk type (see `gcloud compute disk-types list`) |
| `--labels` | Key-value pairs in format `KEY=VALUE` |
| `--machine-type` | Machine type (default: `n1-standard-1`; see `gcloud compute machine-types list`) |
| `--preemptible` | Makes the VM preemptible |
| `--zone` | Zone for the VM |

> Full parameter reference: `https://cloud.google.com/sdk/gcloud/reference/compute/instances/create`

---

### Creating a Virtual Machine with Cloud Shell

- **Cloud Shell** — browser-based terminal with Cloud SDK pre-installed.
- Activated from Cloud Console via the **shell icon** in the upper-right corner.
- All `gcloud` commands available locally are also available in Cloud Shell.

![Cloud Shell is activated through Cloud Console.](../images/c05f018.png)

**Figure 5.18** — Activating Cloud Shell from Cloud Console

![Cloud Shell opens a command-line window in the browser.](../images/c05f019.png)

**Figure 5.19** — Cloud Shell browser terminal

---

## Basic Virtual Machine Management

### Starting and Stopping Instances

**Via Console:** Compute Engine → VM Instances → select VM → click ellipsis (⋮) for options (Start, Stop, etc.)

![Basic operations on VMs can be performed using a pop-up menu in the console.](../images/c05f020.png)

**Figure 5.20** — VM operations pop-up menu in Console

**Via `gcloud`:**

```bash
# Stop an instance
gcloud compute instances stop INSTANCE-NAME

# Start an instance
gcloud compute instances start INSTANCE-NAME
```

---

### Network Access to Virtual Machines

| OS | Protocol | Access Method |
|---|---|---|
| **Linux** | **SSH** | Console SSH button or `gcloud compute ssh` |
| **Windows** | **RDP** (Remote Desktop Protocol) | RDP client |

**SSH options from Console** (click SSH button next to VM):

![From the console, you can start an SSH session to log into a Linux server.](../images/c05f021.png)

**Figure 5.21** — SSH options from Cloud Console

- **Open In Browser Window** — opens a terminal in a new browser window.

![A terminal window opens in a new browser window when using SSH-in-browser.](../images/c05f022.png)

**Figure 5.22** — Browser-based SSH terminal

---

### Monitoring a Virtual Machine

**Console path:** VM Instances → click VM name → select **Monitoring** tab

- View CPU utilization, network utilization, and disk operations in real time.

![The Observability tab of the VM Instance Details page](../images/c05f023.png)

**Figure 5.23** — VM Observability/Monitoring tab

---

### Cost of Virtual Machines

Key VM cost facts:

| Factor | Detail |
|---|---|
| **Billing increment** | 1-second increments |
| **Minimum charge** | 1 minute of use |
| **Cost basis** | Machine type: number of vCPUs and amount of memory |
| **Sustained use discounts** | Available for some instance types (not all) |
| **Spot VM savings** | Up to **80% less** than standard VMs |

> Pricing reference: `https://cloud.google.com/compute/vm-instance-pricing`

To track costs automatically: enable **Cloud Billing** and set up **Billing Export** → generates daily usage and cost reports.

---

## Guidelines for Planning, Deploying, and Managing Virtual Machines

| Guideline | Reason |
|---|---|
| Choose the fewest CPUs and smallest memory that meets requirements including peak load | Minimizes VM cost |
| Use the console for ad hoc administration | Quick, interactive |
| Use `gcloud` scripts for repeated tasks | Repeatable, version-controllable |
| Use startup scripts for software updates and repeated setup steps | Consistent initialization |
| Save a modified machine image when you've made several changes | Avoid re-running the same modifications on every new instance |
| Use spot VMs if unplanned disruptions are tolerable | Up to 80% cost savings |
| Use SSH or RDP for OS-level tasks | Direct OS access |
| Use Cloud Console, Cloud Shell, or Cloud SDK for VM-level tasks | Appropriate abstraction level |

---

## Summary

| Tool | Type | Use |
|---|---|---|
| **Google Cloud Console** | Web-based GUI | Ad hoc resource creation and management |
| **Cloud SDK (`gcloud`)** | Local CLI | Scripted and repeatable management tasks |
| **Cloud Shell** | Browser-based CLI | `gcloud` commands without local installation |

**VM creation required parameters:** name, region, zone, machine type, boot disk.

**`gcloud` command structure:**
```
gcloud  compute  instances  <verb>  [OPTIONS]
```

**Common management tasks:** start/stop instances, SSH/RDP access, monitoring (CPU, disk, network), cost tracking.

---

## Exam Essentials

- **Console and Cloud SDK for VM management:** Know how to create, start, and stop VMs using both interfaces. Required parameters: name, machine type, region, zone, boot disk. VMs must be created in a project.

- **Spot VMs:** Know when to use (fault-tolerant, interruptible workloads) and when not to (databases, stateful services requiring availability). Cost up to 80% less than standard VMs.

- **Advanced options (Shielded VMs, boot disk):** Shielded VMs add Secure Boot, vTPM, and Integrity Monitoring. Boot disk options include balanced, extreme, SSD, and standard persistent disks.

- **`gcloud compute instance` commands:**
  - Structure: `gcloud` → service (`compute`) → resource type (`instances`) → verb (`create`, `list`, `stop`, `start`, `describe`)
  - Know `create`, `list`, `stop`, `start`, `describe`

- **Monitoring:** CPU utilization, network monitoring, and disk monitoring found on the VM Instance Details → Monitoring/Observability tab.

- **VM cost factors:** Billed by the second (1-minute minimum). Cost based on vCPUs and memory. Prices vary by location. Custom machine types available. Sustained use discounts available on some types.

---

## Review Questions

1. After opening Google Cloud Console, what is one of the first things you should do before working on VMs?
   - A. Open Cloud Shell
   - B. Verify you can log in via SSH
   - C. **Verify that the selected project is the one you want to work with**
   - D. Review the list of running VMs

2. What is a one-time task you will need to complete before using the console?
   - A. **Set up billing**
   - B. Create a project
   - C. Create a storage bucket
   - D. Specify a default zone

3. What is the minimal set of information needed to create a single VM in Google Cloud?
   - A. A name for the VM and a machine type
   - B. **A name for the VM, a machine type, a region, and a zone**
   - C. A name for the VM, a machine type, a region, a zone, and a CIDR block
   - D. A name for the VM, a machine type, a region, a zone, and an IP address

4. You don't see the machine type suggested by an architect in the console. What could be the reason?
   - A. You have selected the incorrect subnet
   - B. **That machine type is not available in the zone you specified**
   - C. You have chosen an incompatible operating system
   - D. You have not specified a correct memory configuration

5. Your manager wants to bill each department for the VMs used for their applications. What would you suggest?
   - A. Access controls
   - B. Persistent disks
   - C. **Labels and descriptions**
   - D. Descriptions only

6. Where in the Create An Instance page would you find the preemptible property?
   - A. **Availability Policy**
   - B. Identity And API Access
   - C. Sole Tenancy
   - D. Networking

7. You need a server protected against rootkit attacks at the boot level. Which option should you select?
   - A. Firewall
   - B. **Shielded VM**
   - C. Project-wide SSH keys
   - D. Boot disk integrity control service

8. Which of the following parameters CANNOT be set when adding an additional disk through Cloud Console?
   - A. Disk type
   - B. Encryption key management
   - C. **Block size**
   - D. Source image for the disk

9. Your team has configuration drift problems — changes are made but not tracked. What practice would you implement?
   - A. Have all engineers use only Cloud Shell
   - B. **Write scripts using `gcloud` commands to change configuration and store those scripts in a version control system**
   - C. Take notes and store in Google Drive
   - D. Limit privileges so only you can make changes

10. Which of the following is part of commands for administering resources in Compute Engine?
    - A. **`gcloud compute instances`**
    - B. `gcloud instances`
    - C. `gcloud instances compute`
    - D. None of the above

11. How could a new engineer get summary information on each VM running in a project?
    - A. `gcloud compute list`
    - B. **`gcloud compute instances list`**
    - C. `gcloud instances list`
    - D. `gcloud list instances`

12. When creating a VM using the command line, how should you specify labels?
    - A. Use `--labels` with format `KEYS:VALUES`
    - B. **Use `--labels` with format `KEY=VALUE`**
    - C. Use `--labels` with format `KEYS,VALUES`
    - D. This is not possible in the command line

13. In the boot disk advanced configuration, which operations can you specify when creating a new VM?
    - A. Add a new disk, reformat an existing disk, attach an existing disk
    - B. Add a new disk and reformat an existing disk
    - C. **Add a new disk and attach an existing disk**
    - D. Reformat an existing disk and attach an existing disk

14. You have a 10 GB dataset that data scientists need accessible in each of their VMs' filesystems with minimal steps. What is the best approach?
    - A. Store the data in Cloud Storage
    - B. **Create VMs using a source image created from a disk with the data on it**
    - C. Store the data in Google Drive
    - D. Load the data into BigQuery

15. The Networking tab of the Create VM form is where you would perform which operation?
    - A. Set the IP address of the VM
    - B. **Add a network interface to the VM**
    - C. Specify a default router
    - D. Change firewall configuration rules

16. What parameter would you include with `gcloud` to specify the type of boot disk?
    - A. **`boot-disk-type`**
    - B. `boot-disk`
    - C. `disk-type`
    - D. `type-boot-disk`

17. Which command creates a VM with four CPUs named `web-server-1`?
    - A. **`gcloud compute instances create --machine-type=n1-standard-4 web-server-1`**
    - B. `gcloud compute instances create --cpus=4 web-server-1`
    - C. `gcloud compute instances create --machine-type=n1-standard-4 --instance-name=web-server-1`
    - D. `gcloud compute instances create --machine-type=n1-4-cpu web-server-1`

18. Which command stops a VM named `web-server-1`?
    - A. `gcloud compute instances halt web-server-1`
    - B. `gcloud compute instances --terminate web-server1`
    - C. **`gcloud compute instances stop web-server-1`**
    - D. `gcloud compute stop web-server-1`

19. You created an Ubuntu VM and want to log in to install software packages. Which protocol would you use?
    - A. FTP
    - B. **SSH**
    - C. RDP
    - D. ipconfig

20. Which of the following accurately summarizes Google Cloud VM billing for a management comparison?
    - A. **VMs are billed in 1-second increments, cost varies with vCPUs and memory, custom machine types are available, preemptible VMs cost up to 80% less, and Google offers sustained use discounts**
    - B. VMs are billed in 1-second increments and can run up to 24 hours before being shut down
    - C. Google offers sustained use discounts in only some regions, cost varies with vCPUs and memory, custom machine types available, preemptible VMs cost up to 80% less
    - D. VMs are charged a minimum of 1 hour of use, and cost varies with vCPUs and memory
