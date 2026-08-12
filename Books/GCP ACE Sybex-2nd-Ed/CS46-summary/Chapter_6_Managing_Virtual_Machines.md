# Chapter 6: Managing Virtual Machines

> **Exam Objective Covered:**
> - 4.1 Managing Compute Engine resources

---

This chapter covers managing single VM instances and instance groups using Cloud Console and the `gcloud` CLI. Topics include starting, stopping, deleting, filtering VMs, attaching GPUs, working with snapshots and images, and configuring instance groups with load balancing and autoscaling.

---

## Managing Single Virtual Machine Instances

Three methods for managing VMs — all equivalent in capability:
1. **Cloud Console** (GUI)
2. **Cloud Shell** (browser terminal with Cloud SDK pre-installed)
3. **Cloud SDK** (local `gcloud` CLI)

---

### Managing Single Virtual Machine Instances in the Console

**Console path:** Compute Engine → VM Instances

![The VM Instance panel in the Compute Engine section of Cloud Console](../images/c06f001.png)

**Figure 6.1** — VM Instance panel showing running instances

---

#### Starting, Stopping, and Deleting Instances

Actions accessed via the **three-dot (⋮) icon** on the right side of each VM listing.

![The list of commands available from the console for changing the state of a VM](../images/c06f002.png)

**Figure 6.2** — Command menu for a running VM

**VM state operations:**

| Operation | Effect | Billed? |
|---|---|---|
| **Stop** | Halts the VM; releases compute resources; VM still exists | No (while stopped) |
| **Start** | Starts a stopped VM | Yes |
| **Reset** | Restarts VM; properties unchanged; **memory contents lost** | Yes |
| **Delete** | Removes VM from console; releases all resources including stored image | No (after deletion) |

> **Note:** When a VM is restarted (Reset), the contents of memory are lost. Save data to a **persistent disk** or **Cloud Storage** to preserve it across reboots.

![A warning message that may appear about stopping a VM](../images/c06f003.png)

**Figure 6.3** — Stop warning message (can be suppressed)

![When VMs are stopped, the icon on the left changes and SSH is no longer available.](../images/c06f004.png)

**Figure 6.4** — Stopped VM: green check → gray circle; SSH disabled

![When VMs are stopped, Stop and Reset are no longer available, but Start / Resume is available.](../images/c06f005.png)

**Figure 6.5** — Stopped VM command menu: only Start/Resume available

![Deleting an instance from the console will display a warning message.](../images/c06f006.png)

**Figure 6.6** — Delete warning message

---

#### Viewing Virtual Machine Inventory

- Use the **Filter VM Instances** box above the VM list to narrow results.

![List of instances filtered by search criteria](../images/c06f007.png)

**Figure 6.7** — Filtered VM list (example: filtering by name `instance-2`)

**Available filter fields:**

| Filter Field |
|---|
| Labels |
| Internal IP |
| External IP |
| Status |
| Zone |
| Network |
| Deletion protection |

> Multiple filter conditions are combined with **AND** by default. Use `OR` explicitly to change this.

---

#### Attaching GPUs to an Instance

- GPUs accelerate **math-intensive** workloads: machine learning, visualizations, high-performance computing.
- Compute Engine has a dedicated **GPU machine family**.
- Requires **GPU driver libraries** installed — use a pre-built image (e.g., **Deep Learning images**) or install manually.
- GPU-enabled instance must run in a **zone where GPUs are available**.

![GPU machine family supports a variety of GPU types and a number of GPUs and CPU platforms.](../images/c06f008.png)

**Figure 6.8** — GPU machine family and Deep Learning image options

**GPU configuration parameters:**

| Parameter | Options / Notes |
|---|---|
| **GPU Type** | e.g., NVIDIA Tesla A100, NVIDIA Tesla T4 |
| **Number of GPUs** | Varies by GPU type |
| **CPU Platform** | e.g., Intel Skylake or later, Intel Ivy Bridge or later (Compute Engine selects automatically by default) |

**GPU count options by type (examples):**

| GPU Model | Available Counts |
|---|---|
| NVIDIA Tesla A100 | 1, 2, 4, 8, or 16 |
| NVIDIA Tesla T4 | 1, 2, or 4 |

![Some GPU options available in Compute Engine](../images/c06f009.png)

**Figure 6.9** — GPU type and count options

**GPU restrictions:**
- GPUs **cannot** be attached to **shared memory machines**.
- CPU must be **compatible** with the selected GPU.
- Full restriction list and zones with GPU availability: `https://cloud.google.com/compute/docs/gpus`

---

#### Working with Snapshots

- **Snapshots** are copies of data on a persistent disk.
- Used for: **backups**, **point-in-time recovery**, **copying disk data to other instances**.

**Snapshot behavior:**

| Snapshot | Type | Storage |
|---|---|---|
| First snapshot | **Full copy** of all data on the disk | Full disk size |
| Subsequent snapshots | **Incremental** — only data changed since last snapshot | Delta only |

> **Important:** If running a database or application that buffers data in memory before writing to disk (e.g., MySQL), **flush disk buffers** before taking a snapshot to prevent data loss. MySQL uses `FLUSH` statement.

**Required IAM role:** `Compute Storage Admin`

**Console path:** Compute Engine → Snapshots → Create Snapshot

![Creating a snapshot using Cloud Console](../images/c06f010.png)

**Figure 6.10** — Snapshot creation page

![Form for creating a snapshot](../images/c06f011.png)

**Figure 6.11** — Snapshot creation form (name, description, labels, regional/multiregional storage)

**Snapshot storage options:** Regional or **Multiregional**

---

#### Working with Images

**Snapshots vs. Images:**

| Feature | Snapshots | Images |
|---|---|---|
| **Primary use** | Data backup and disk copying | Creating new VMs |
| **Backup type** | Incremental | Single complete backup |
| **Can create VM from it?** | Yes (if from a boot disk) | Yes |

**Image sources:**

| Source | Description |
|---|---|
| **Disk** | Create from an existing persistent disk |
| **Snapshot** | Create from a snapshot |
| **Image** | Create from another image (same or different project) |
| **Cloud Storage file** | Browse a Cloud Storage bucket to select a file |
| **Virtual disk** | Import a virtual disk file |

**Console path:** Compute Engine → Images → Create Image

![Images available. From here, you can create additional images.](../images/c06f012.png)

**Figure 6.12** — Image listing page

![Cloud Console form for creating an image](../images/c06f013.png)

**Figure 6.13** — Create Image form (name, description, labels, source, Family attribute)

> **Image Family** — optional attribute to group related images (e.g., different versions). When a family is specified, the **latest non-deprecated image** in the family is used automatically.

![Options for the source of an image](../images/c06f014.png)

**Figure 6.14** — Image source options

![When using an image as a source, you can choose a source image from another project.](../images/c06f015.png)

**Figure 6.15** — Selecting source image from another project

![When using a Cloud Storage file as a source, you browse your storage buckets for a file.](../images/c06f016.png)

**Figure 6.16** — Browsing Cloud Storage for image source

**Image lifecycle operations:**

| Operation | Effect | Applies To |
|---|---|---|
| **Delete** | Permanently removes the image | Custom images only |
| **Deprecate** | Marks image as no longer supported; allows specifying replacement image | Custom images only |

> **Deprecated images** are still available for use but may not receive security patches or updates. Users are informed they should migrate to the newer supported version. Eventually deprecated images will be removed entirely.

---

### Managing a Single Virtual Machine Instance with Cloud Shell and the Command Line

#### `gcloud`-wide (Global) Flags

These flags can be appended to any `gcloud` command:

| Flag | Description |
|---|---|
| `--account` | Override the default Google Cloud account |
| `--configuration` | Use a named configuration file (key-value pairs) |
| `--flatten` | Generate separate key-value records when a key has multiple values |
| `--format` | Output format: `default`, `csv`, `json`, `yaml`, `text`, etc. |
| `--help` | Display detailed help message |
| `--project` | Override the default project |
| `--quiet` | Disable interactive prompts; use defaults |
| `--verbosity` | Output detail level: `debug`, `info`, `warning`, `error` |

> Commands also accept an optional `--zone` parameter. If not specified and no default zone is set, the command will prompt for one.

---

#### Starting Instances

```bash
# Syntax
gcloud compute instances start INSTANCE_NAMES

# Start one or more instances
gcloud compute instances start instance-1 instance-2

# Start and return immediately without waiting
gcloud compute instances start instance-1 instance-2 --async

# Start in a specific zone
gcloud compute instances start ch06-instance-1 ch06-instance-2 --zone=us-central1-c

# List available zones
gcloud compute zones list
```

---

#### Stopping Instances

```bash
# Syntax
gcloud compute instances stop INSTANCE_NAMES

# Stop one or more instances
gcloud compute instances stop instance-3 instance-4

# Stop and return immediately without waiting
gcloud compute instances stop ch06-instance-1 ch06-instance-2 --async

# Stop in a specific zone
gcloud compute instances stop ch06-instance-1 ch06-instance-2 --zone=us-central1-c
```

---

#### Deleting Instances

```bash
# Delete a single instance
gcloud compute instances delete instance-1

# Delete in a specific zone
gcloud compute instances delete ch06-instance-1 --zone=us-central1-b

# Keep all disks when deleting
gcloud compute instances delete ch06-instance-1 --zone=us-central2-b --keep-disks=all

# Delete all non-boot (data) disks
gcloud compute instances delete ch06-instance-1 --zone=us-central2-b --delete-disks=data
```

**Disk retention options for `delete`:**

| Parameter | Value Options | Meaning |
|---|---|---|
| `--keep-disks` | `all` | Keep all disks |
| `--keep-disks` | `boot` | Keep root filesystem partition |
| `--keep-disks` | `data` | Keep non-boot disks |
| `--delete-disks` | `all` / `boot` / `data` | Delete specified disks |

---

#### Viewing VM Inventory

```bash
# List all VMs in current project
gcloud compute instances list

# Filter by zone
gcloud compute instances list --filter="zone:ZONE"

# Limit the number of results
gcloud compute instances list --limit=10

# Sort results by a resource field
gcloud compute instances list --sort-by=FIELD

# View all resource fields for a VM (useful for sort-by and filter)
gcloud compute instances describe INSTANCE_NAME

# Output in JSON format
gcloud compute instances list --format=json
```

---

#### Working with Snapshots

```bash
# Create a snapshot of a disk
gcloud compute disks snapshot DISK_NAME --snapshot-names=NAME

# List all snapshots
gcloud compute snapshots list

# Get details of a specific snapshot
gcloud compute snapshots describe SNAPSHOT_NAME

# Create a disk from a snapshot
gcloud compute disks create DISK_NAME --source-snapshot=SNAPSHOT_NAME

# Create a 100 GB standard persistent disk from a snapshot
gcloud compute disks create disk-1 --source-snapshot=ch06-snapshot \
  --size=100 --type=pd-standard
```

---

#### Working with Images

```bash
# Create an image from a disk
gcloud compute images create IMAGE_NAME --source-disk=DISK_NAME

# Create an image from a snapshot
gcloud compute images create IMAGE_NAME --source-snapshot=SNAPSHOT_NAME

# Image source parameters:
#   --source-disk          from a disk
#   --source-image         from another image
#   --source-image-family  latest non-deprecated image in a family
#   --source-snapshot      from a snapshot
#   --source-uri           from a web address

# Example: create image from disk
gcloud compute images create image-1 --source-disk=disk-1

# Delete an image
gcloud compute images delete IMAGE_NAME

# Export an image to Cloud Storage
gcloud compute images export --destination-uri=DESTINATION_URI --image=IMAGE_NAME
```

---

## Introduction to Instance Groups

**Instance groups** are sets of VMs managed as a single entity. Commands applied to the group apply to **all members**.

**Two types of instance groups:**

| Type | VMs | Use Case | Preferred? |
|---|---|---|---|
| **Managed** | Identical (created from instance template) | Scalable, highly available workloads; supports autoscaling and load balancing | Yes — preferred |
| **Unmanaged** | Can have different configurations | Legacy applications requiring mixed configurations | Only when needed |

**Managed instance group features:**
- Created from an **instance template** (defines machine type, boot disk image, zone, labels, etc.)
- **Autoscaling** — automatically add/remove instances based on load
- **Load balancing** — distribute traffic across the group
- **Auto-healing** — crashed instances are automatically re-created

---

### Creating and Removing Instance Groups and Templates

```bash
# Create an instance template
gcloud compute instance-templates create INSTANCE-TEMPLATE-NAME

# Create template from an existing VM
gcloud compute instance-templates create instance-template-1 \
  --source-instance=instance-1

# Delete an instance template
gcloud compute instance-templates delete INSTANCE-TEMPLATE-NAME

# List all instance templates
gcloud compute instance-templates list

# List managed instance groups
gcloud compute instance-groups managed list-instances

# List instances in a specific instance group
gcloud compute instance-groups managed list-instances INSTANCE-GROUP-NAME
```

**Console path:** Compute Engine → Instance Groups → Instance Group Templates

![Instance group templates can be created in the console using a form similar to the create instance form.](../images/c06f017.png)

**Figure 6.17** — Instance group template creation form

**Instance group scope:**

| Type | Scope | Recommendation |
|---|---|---|
| **Zonal managed instance group** | Single zone | Less resilient |
| **Regional managed instance group** | Across multiple zones in a region | **Recommended** — spreads workload, improves resiliency |

**Distribution policies:**

| Policy | Behavior |
|---|---|
| **Even** | Distribute evenly across all zones |
| **Balanced** | Distribute as evenly as possible based on available resources |
| **Any** | Deploy based on availability and reservations |

---

### Instance Groups Load Balancing and Autoscaling

- All Google Cloud load balancing types **require an instance group**.
- Managed instance groups can be configured to **autoscale** based on:
  - CPU utilization
  - Monitoring metric
  - Load-balancing capacity
  - Queue-based workloads

---

> ### Real World Scenario
> ### No More Peak Capacity Planning
>
> Before cloud computing, IT organizations had to purchase hardware for **peak capacity** — the maximum expected load. For businesses with highly variable workloads (e.g., US retailers with high holiday demand), this meant idle servers for most of the year.
>
> **Cloud computing and autoscaling eliminate peak capacity planning:**
> - Additional servers provisioned in **minutes**, not weeks or months.
> - Capacity dropped when not needed.
> - Instance groups **automate** the addition and removal of VMs based on configured policies.

---

> **Note:** When autoscaling, leave enough time for VMs to fully boot or shut down before triggering another scaling event. If the check interval is too short, a recently added VM may not be fully started before another is added — resulting in **over-provisioning**.

---

## Guidelines for Managing Virtual Machines

| Guideline | Rationale |
|---|---|
| **Use labels and descriptions** | Identify instance purpose; simplify filtering long lists |
| **Use managed instance groups** | Enable autoscaling and load balancing for scalable, highly available services |
| **Use GPUs for numeric-intensive processing** | ML and HPC workloads; can outperform adding more CPUs for certain tasks |
| **Use snapshots to save disk state** | Backups and data sharing between instances; stored in Cloud Storage |
| **Use preemptible/spot VMs for disruption-tolerant workloads** | Spot VMs cost 60%–91% less than standard VMs; no 24-hour runtime limit (unlike original preemptible VMs) |

---

## Summary

**Key `gcloud compute` command structure:**

```
gcloud  compute  <entity-type>  <operation>  [OPTIONS]
```

| Entity Type | Operations |
|---|---|
| `instances` | `create`, `delete`, `list`, `describe`, `start`, `stop` |
| `disks` | `snapshot`, `create` |
| `snapshots` | `list`, `describe` |
| `images` | `create`, `delete`, `export` |
| `instance-templates` | `create`, `delete`, `list` |
| `instance-groups managed` | `list-instances` |
| `zones` | `list` |

**Snapshots** = incremental disk copies; used for backup and data sharing.
**Images** = full disk copies; used to create VMs. Can be deprecated (not deleted) to signal users to migrate.
**Instance groups** = sets of VMs managed together; managed groups support autoscaling and load balancing.
**GPUs** = attached to VMs for compute-intensive tasks; requires GPU libraries in OS image.

---

## Exam Essentials

- **Cloud Console navigation:** Create, configure, delete, and list VM instances via Compute Engine area.

- **Cloud SDK installation:** Sets default environment variables (zone, project); if using Cloud Shell, SDK is already installed.

- **VM creation — console vs CLI:** Console for interactive configuration; `gcloud` commands for scripted/repeatable tasks. Know when to use custom images and how to deprecate them (marks as unsupported, allows specifying replacement).

- **GPUs:** Used for compute-intensive operations (ML, HPC). Use an image with GPU libraries pre-installed. Cannot attach to shared memory machines. CPU must be compatible. Availability varies by zone.

- **Snapshots vs. images:** Snapshots = incremental disk backups for data preservation and copying. Images = complete OS/disk copies used to create VMs.

- **Instance groups and templates:** Template defines configuration; managed instance groups use identical VMs; support autoscaling and load balancing. Unmanaged groups allow different VM configurations.

---

## Review Questions

1. Which page in Google Cloud Console would you use to create a single instance of a VM?
   - A. **Compute Engine**
   - B. App Engine
   - C. Kubernetes Engine
   - D. Cloud Functions

2. You notice the SSH option is disabled for one of the Linux VM instances in the console. Why?
   - A. The instance is preemptible and does not support SSH
   - B. **The instance is stopped**
   - C. The instance was configured with the No SSH option
   - D. The SSH option is never disabled

3. You need to reboot a slow-responding Linux server from the console. Which command would you use?
   - A. Reboot
   - B. **Reset**
   - C. Restart
   - D. Shutdown followed by Startup

4. In the console, you can filter the list of VM instances by which of the following?
   - A. Labels only
   - B. Member of managed instance group only
   - C. **Labels, status, or deletion prevention**
   - D. Labels and status only

5. You attached a GPU to a VM but machine learning models run unusually slowly. What could be the cause?
   - A. **GPU libraries are not installed**
   - B. The operating system is based on Ubuntu
   - C. You do not have at least eight CPUs
   - D. There isn't enough persistent disk space

6. When adding a GPU to an instance, you must ensure that:
   - A. **The GPU and CPU choices are compatible**
   - B. The instance is preemptible
   - C. The instance does not have non-boot disks attached
   - D. The instance is running Ubuntu 18.02 or later

7. You make a snapshot of a 100 GB disk, add 10 GB of data, then make a second snapshot. How much total storage is used (no compression)?
   - A. 210 GB (100 GB first, 110 GB second)
   - B. **110 GB (100 GB first, 10 GB second — incremental)**
   - C. 110 GB (second snapshot only; first deleted automatically)
   - D. 221 GB (100 + 110 + 11 GB metadata)

8. What role do you need to grant a team member to create snapshots?
   - A. Compute Image Admin
   - B. Storage Admin
   - C. Compute Snapshot Admin
   - D. **Compute Storage Admin**

9. The source of an image may be:
   - A. Only disks
   - B. Snapshots or disks only
   - C. **Disks, snapshots, or another image**
   - D. Disks, snapshots, or any database export file

10. You want users to know they should stop using Ubuntu 18.04 images and move to Ubuntu 20.04, without immediately deleting the old images. What feature would you use?
    - A. Redirection
    - B. **Deprecated**
    - C. Unsupported
    - D. Migration

11. You want to generate a list of VMs in JSON format. What command would you use?
    - A. `gcloud compute instances list`
    - B. `gcloud compute instances describe`
    - C. **`gcloud compute instances list --format=json`**
    - D. `gcloud compute instances list --output=json`

12. Which optional parameter would you use when starting an instance to display detailed information about how Google Cloud starts it?
    - A. `--verbose`
    - B. **`--async`**
    - C. `--describe`
    - D. `--details`

    > Note: `--async` returns immediately and shows the operation details without waiting. `--verbose` is a general Linux convention but not a standard `gcloud` parameter in this context.

13. Which command deletes an instance named `ch06-instance-3`?
    - A. `gcloud compute instances delete instance=ch06-instance-3`
    - B. `gcloud compute instance stop ch06-instance-3`
    - C. **`gcloud compute instances delete ch06-instance-3`**
    - D. `gcloud compute delete ch06-instance-3`

14. You want to delete `ch06-instance-1` but keep its boot disk and remove other disks. What command would you use?
    - A. **`gcloud compute instances delete ch06-instance-1 --keep-disks=boot`**
    - B. `gcloud compute instances delete ch06-instance-1 --save-disks=boot`
    - C. `gcloud compute instances delete ch06-instance-1 --keep-disks=filesystem`
    - D. `gcloud compute delete ch06-instance-1 --keep-disks=filesystem`

15. You want to view the resource fields you can use to sort a list of instances. What command would you use?
    - A. `gcloud compute instances list`
    - B. **`gcloud compute instances describe`**
    - C. `gcloud compute instances list --detailed`
    - D. `gcloud compute instances describe --detailed`

16. You are deploying an application that will need to scale and be highly available. Which Compute Engine component helps achieve this?
    - A. Preemptible instances
    - B. **Instance groups**
    - C. Cloud Storage
    - D. GPUs

17. Before creating an instance group, what do you need to create first?
    - A. Instances in the instance group
    - B. **Instance template**
    - C. Boot disk image
    - D. Source snapshot

18. How would you delete an instance template using the command line?
    - A. `gcloud compute instances instance-template delete`
    - B. **`gcloud compute instance-templates delete`**
    - C. `gcloud compute delete instance-template`
    - D. `gcloud compute delete instance-templates`

19. What can be the basis for scaling up an instance group?
    - A. CPU utilization and operating system updates
    - B. Disk usage and CPU utilization only
    - C. **Network latency, load balancing capacity, and CPU utilization**
    - D. Disk usage and operating system updates only

20. An architect is moving a legacy application with two different node configurations to Google Cloud. The load is consistent (no need to scale), and they want to manage the cluster as a single entity. What resource would you recommend?
    - A. Preemptible instances
    - B. **Unmanaged instance groups**
    - C. Managed instance groups
    - D. GPUs
