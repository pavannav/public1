# Session 10: Day 10 Questions - Windows Licensing, Terminate VM if Idle, Spot VM Query

## Table of Contents
- [Idle VM Termination](#idle-vm-termination)
- [Host Maintenance](#host-maintenance)
- [Committed Use Discounts](#committed-use-discounts)
- [Windows Licensing](#windows-licensing)
- [Application Licensing](#application-licensing)
- [Labels vs Tags](#labels-vs-tags)
- [Automatic Restart](#automatic-restart)
- [Outages and High Availability](#outages-and-high-availability)
- [IAM for VM Access](#iam-for-vm-access)
- [Ops Agent](#ops-agent)
- [Summary](#summary)

## Idle VM Termination

### Overview
This question addresses whether there's a built-in option in Google Cloud Compute Engine to terminate a regular virtual machine (VM) automatically if it's idle for a specific period, such as 20 minutes. It explores alternative approaches beyond out-of-the-box features.

### Key Concepts
Google Cloud does not provide a direct, built-in feature to terminate VMs based on idle time, unlike some managed services that allow idle timeout configurations. However, you can build a custom solution using monitoring and automation tools.

#### Using Metrics and Monitoring
- **Metrics Collection**: Google Cloud Monitoring captures metrics like CPU usage. You can set thresholds, e.g., if CPU utilization is less than 1% for the last 20 minutes, trigger an action.
- **Automation**: Integrate with Cloud Functions or Cloud Run for serverless automation. When the metric condition is met, trigger the termination of the VM using the Compute Engine API.
- **Tools Involved**:
  - Google Cloud Monitoring (formerly Stackdriver): For defining alerts and metrics.
  - Cloud Logging and Pub/Sub: For event-driven triggers.
  - Cloud Scheduler: Optional for scheduled checks.

```bash
# Example: Use gcloud to check VM usage (manual check; automate via scripts)
gcloud compute instances describe my-vm --zone=us-central1-a --format="value(cpuPlatform)"
```

⚠️ This is not an out-of-the-box feature; it requires custom development, testing, and monitoring to avoid unintended terminations.

#### Limitations
- Requires scripting and IaC tools like Terraform or gcloud commands.
- Potential risk of terminating active workloads due to misconfigured thresholds.
- Contrast with services like Cloud Run or App Engine, which have built-in idle timeout (e.g., 15 minutes).

### Lab Demos
No explicit demos in the transcript, but to implement:
1. Enable Google Cloud Monitoring on the project.
2. Create a metric filter for low CPU usage.
3. Set up a Cloud Function to receive alerts and call `gcloud compute instances stop` or terminate the VM.
4. Test the automation with a test VM.

## Host Maintenance

### Overview
Host maintenance in Google Cloud Compute Engine involves migrating VMs to new hosts for updates or repairs. The question clarifies whether software installed on the original VM will be automatically reinstalled on the new host.

### Key Concepts
During host maintenance, Google Cloud migrates your VM intact to a new host without changing its configuration or software. This ensures continuity but has specific implications for certain hardware.

#### VM Migration Process
- **Intact Migration**: The entire VM, including installed software, OS configurations, and data, is moved to a new host. No software reinstallation occurs.
- **Duration**: Typically takes 1-2 minutes for regular VMs; schedule downtime accordingly.
- **Interaction**: Notify via email or console; you can reschedule or migrate manually.

> [!IMPORTANT]
> Host maintenance differs from recreating VMs—it's a live migration, not a rebuild.

#### Special Cases for GPUs
- VMs with GPUs (e.g., NVIDIA GPUs) always terminate during maintenance events.
- **Reason**: GPUs cannot be migrated live due to hardware constraints.
- **Process**: You'll receive advance notification; manually shut down and restart the VM on a new host with available GPUs.
- Cloud Monitoring alerts can help automate responses, but manual intervention is required.

```yaml
# Example Terraform snippet for VM with GPU scheduling
resource "google_compute_instance" "gpu_vm" {
  name         = "gpu-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  guest_accelerator {
    type  = "nvidia-tesla-k80"
    count = 1
  }

  # Maintenance behavior: GPUs terminate
}
```

#### Key Criteria
- **Regular VMs**: Automatic live migration.
- **GPU VMs**: Termination with notification; requires manual restart.

## Committed Use Discounts

### Overview
Committed Use Discounts (CUDs) in Google Cloud offer cost savings for long-term VM usage commitments, addressing expense and flexibility in decommissions.

### Key Concepts
Google Cloud provides 1-year and 3-year CUD commitments for Compute Engine VMs, granting up to 57-70% discounts compared to on-demand pricing. This is not a spot or preemptible model but a reservation model.

#### Commitment Details
- **Discount Range**: 57% for 1-year, up to 70% for 3-year commitments.
- **Billing**: Charged monthly for the committed period (e.g., 36 months), not upfront.
- **Flexibility**: Tied to specific machine types; apply automatically to eligible usage.

#### Cancellation and Early Termination
- **Policy**: Commitments are fixed for the term; Google states you cannot cancel midway.
- **Options Discussed**: 
  - Some flexibility through account representatives or adjustments (e.g., transfer commitments).
  - No upfront payment reduces risk, unlike some providers.
- **Real-World**: Contact Google sales for partial cancellations or repurpose; internal options exist if negotiated.

```diff
+ Benefit: Significant savings (e.g., 70% off) for predictable workloads.
- Limitation: Less flexible than on-demand; plan for full term usage.
```

#### Example Cost Comparison
| Commitment | On-Demand Discount | Max Discount |
|------------|---------------------|--------------|
| 1 Year    | Up to 57%          | 57%         |
| 3 Years   | Up to 70%          | 70%         |

👉 Use for stable workloads; avoid if usage may drop mid-term.

## Windows Licensing

### Overview
Windows licensing in Google Cloud covers Server editions, exploring Bring Your Own License (BYOL) options versus pay-as-you-go versions, including Key Management Service (KMS) integration.

### Key Concepts
Google Cloud supports both Google-provided Windows licensing (pay-as-you-go) and BYOL for existing Microsoft licenses. BYOL requires paperless activation and specific setup.

#### Pay-as-You-Go vs. BYOL
- **Pay-as-You-Go**: Google charges an hourly rate; automatic licensing via Google.
- **BYOL**: Use your own perpetual licenses; involves bureaucracy with Microsoft for cloud compatibility.

#### KMS Server Support
- **Deployment**: Azure integrates KMS; Google Cloud supports custom KMS deployments within Sole Tenant Nodes (STNs).
- **Process**:
  - Use STNs for isolated VMs.
  - Deploy your KMS server in a separate VM within STNs.
  - Connect Windows VMs to your KMS for activation.

```bash
# Example: Activate Windows via KMS (after setup)
slmgr /skms <kms-server-ip>
slmgr /ato
```

#### Sole Tenant Nodes (STNs)
- **Required for BYOL**: Ensures hardware isolation.
- **Procedure**: Submit forms to Microsoft and Google; get approval; deploy in STNs.
- **Collaboration**: Involves Microsoft for license transfer to cloud host IDs.

💡 For Windows admins migrating legacy servers, STNs enable KMS integration—test activation post-migration.

## Application Licensing

### Overview
Application licensing tied to network identifiers (e.g., MAC or IP addresses) complicates VM migrations in Google Cloud due to host changes.

### Key Concepts
Many enterprise software licenses bind to MAC/IP addresses. During migrations, addresses change, potentially invalidating licenses. Solutions focus on flexibility and updates.

#### Migration Challenges
- **Host Changes**: Google Cloud doesn't preserve original MAC/IP; licenses may fail.
- **Common Binding**: Enterprise software (e.g., search engines) often MAC-bound or both.

#### Resolution Approaches
1. **Vendor Coordination**: Request new licenses post-migration.
   - Step 1: Provision VM, extract new MAC/IP.
   - Step 2: Share with software vendor for re-issuance.
   - Step 3: Apply new license; invalidate old one.
2. **MAC Address Modification**: Technically possible but not supported or legal in some contexts—avoid if possible.
   - Not natively supported in Google Cloud (unlike Azure).
   - Historical workaround, but compliance risks.

#### Legacy Considerations
- **Subscription Shift**: Modern software favors subscriptions over perpetual licenses, reducing these issues.
- **Vendor Policy**: Unique per software; some allow rehosting explicitly.
- **Best Practice**: Plan migrations; document bindings; engage vendors early.

⚠️ Common Pitfall: Assuming MAC/IP preservation—document vendors' rehosting policies.

```diff
+ Dashboard: This is a critical concept for enterprise migrations
- Pitfall: Ignoring MAC/IP dependencies leads to outages
! Alert: Google Cloud lacks native MAC customization
```

## Labels vs Tags

### Overview
Labels and Tags in Google Cloud serve different purposes for metadata: one for organization/search, the other for network/access control.

### Key Concepts
Both are key-value pairs but function separately, unlike AWS where "tags" cover both roles.

#### Differences
- **Labels**:
  - Purpose: Organizational (e.g., environment: prod, team: devops).
  - Use: Filtering, searching, and grouping in Google Cloud Console/API.
  - Cost: Free; improves discoverability.
- **Tags**:
  - Purpose: Network/firewall rules (e.g., allow traffic from specific tagged VMs).
  - Use: IAM and Firewall policies; route traffic based on tags.
  - Limitation: Network-scoped; not global like labels.

#### Practical Examples
- Labels: Label VMs as `owner: finance` for billing queries.
- Tags: Tag VMs as `network: secure` for firewall rules allowing access.

```diff
+ Labels: Enable searchable metadata for ops
- Tags: Distinct from labels; tied to networking
! Note: Confusion arises from AWS; in GCP, separate functionally
```

## Automatic Restart

### Overview
Automatic Restart in Compute Engine reboots VMs after unplanned failures (e.g., hardware issues host outages), protecting uptime.

### Key Concepts
Enabled by default for regular VMs; ensures recovery without manual intervention.

#### When to Use
- **Recommended for**: Software requiring patching/restarts or production systems.
- **Free Feature**: No additional cost.
- **Scenarios**:
  - Data center issues (e.g., floods, power outages)—as in Google Cloud Paris incident 2023.
  - Hardware failures.
- **Not Applicable**: Preemptible/Spot VMs, as they may not restart.

#### Real-World Example: Paris Google Cloud Outage 2023
- **Incident**: Flooding caused systematic shutdown; VMs restarted automatically, minimizing downtime.
- **Comparison**: AWS faced fewer impacts due to dispersed zones.
- **Implication**: Critical for disaster recovery.

> [!WARNING]
> Disable only if VM state must remain untouched (rare).

## Outages and High Availability

### Overview
Outages in Google Cloud raise concerns about high availability (HA). Responses emphasize cloud provider responsibility and multi-regional strategies.

### Key Concepts
Outages occur due to infrastructure failures (e.g., floods); Google handles zonal/VM-level recoveries, but regional blackouts require proactive measures.

#### Handling Zonal/Regional Failures
- **Provider Role**: Google manages host maintenance, VM migration, and zonal recoveries automatically.
- **Extreme Cases**: Full zone outages (e.g., Paris flooding) yield compensations but no user guarantees.
- **Multi-Regional HA**:
  - Strategy: Deploy workloads across regions/zones (e.g., Mumbai and Singapore via multi-zone).
  - Benefits: Tolerance to regional disasters.
  - Cost Tradeoff: Higher expenses; potential latency issues.
- **Limitations**: Not suitable for latency-sensitive apps; data residency constraints in regulated regions.

#### Advice for Customers
- **Transparency**: Explain cloud limitations; highlight managed recoveries.
- **Alternative**: Multi-cloud for FAANG avoidance if HA is paramount.
- **Examples**: Banking in Tokyo + Osaka for earthquake resilience.

```diff
+ Multi-Zonal: Boosts HA with failover
- Limitation: No prevention for rare events
! Note: Costs rise 2-3x for multi-region
```

## IAM for VM Access

### Overview
IAM integration in Compute Engine controls VM access via roles, enabling secure logins without direct SSH keys.

### Key Concepts
IAM ties VM access to Google Account roles, supporting external users and two-factor authentication (2FA).

#### Key Features
- **Control VM Access Through IAM**: Link access to IAM roles (e.g., Compute Engine roles for login).
- **Roles**: E.g., `roles/compute.osLogin`; grants login permissions.
- **Organization Integration**: Domains can enforce that only @domain.com users access VMs.
- **OS Login**: Part of IAM; manages SSH without keys.
- **External Users**: Allowed if invited.

#### Advanced Security
- **Domain Join**: VMs can join Active Directory for group-based permissions (as in on-prem).
- **Compliance**: IAM ensures users inherit group policies for software installs.

```yaml
# Example IAM policy for VM access
resource "google_compute_instance_iam_binding" "vm_access" {
  instance_name = "my-instance"
  role          = "roles/compute.osLogin"

  members = [
    "user:example@domain.com",
  ]
}
```

💡 For enterprise: Combine with Active Directory for full compliance.

## Ops Agent

### Overview
Ops Agent installs on VMs for enhanced metrics collection in Google Cloud Monitoring, beyond default CPU/disk info.

### Key Concepts
Default metrics cover basic counters; Ops Agent provides memory, application logs, and deeper telemetry.

#### Installation Timing
- **Recommended in DevOps Module**: Covered in later sessions (e.g., Module 8 on monitoring/observability).
- **Purpose**: Captures metrics like memory utilization not available by default.

#### Current Capabilities (Without Agent)
- Visible: CPU, Disk, Network in Monitoring.
- Missing: Full memory stats; requires Agent for comprehensive observability.

#### Demo Reference
In future sessions: Install via gcloud/ssh, configure receivers, validate in Monitoring dashboard.

```bash
# Example: Install Ops Agent library (install actual agent)
sudo apt-get update
sudo apt-get install -y google-cloud-ops-agent
```

⚠️ Without Ops Agent, observability is limited—plan for installation in production.

## Summary

```diff
+ Idle VM Termination: Custom solutions using Monitoring + Automation for cost savings
- Host Maintenance Confusion: GPUs require manual restarts; regular VMs migrate intact
! Committed Discounts: 57-70% savings but fixed terms; negotiate flexibility
+ Licensing: BYOL via STNs; KMS possible; handle MAC/IP bindings with vendors
- Automatic Restart: Essential for HA; defaults on files for failure recovery
+ IAM Access: Integrates with domains; secure logins without keys
! Outages: Mitigate with multi-regional; provider handles most recoveries
+ Ops Agent: Extends monitoring; install for full telemetry
- Labels vs Tags: Overlooked difference; labels for search, tags for networking
```

### Quick Reference
- **Terminate Idle VM**: Use Monitoring (CPU <1%), Cloud Functions for automation.
- **GPU Maintenance**: Always terminates; manual restart required.
- **CUD Commitment**: 1/3-year terms; monthly billing; up to 70% discount.
- **Windows BYOL**: Sole Tenant Nodes + KMS server for custom licensing.
- **Application Licensing**: Coordinate with vendors for MAC/IP re-issuance.
- **Labels/Tags**: Labels for filtering; Tags for firewalls.
- **Automatic Restart**: On for regular VMs; off for Spot.
- **Ops Agent**: Install for memory metrics; defaults cover CPU/disk.
- **IAM VM Access**: Roles like `roles/compute.osLogin`; integrates with domains.

### Expert Insight

**Real-world Application**: Use idle termination for dev environments to cap costs; multi-regional HA for critical apps like e-commerce. IAM access prevents credential sprawl in enterprise migrations.

**Expert Path**: Master Monitoring alerts for automation; negotiate CUD extensions via Google reps. Explore BYOL for legacy apps undergoing cloud migrations—test KMS in STNs first.

**Common Pitfalls**: Assuming built-in idle timeouts or MAC preservation—leads to outages. Misusing labels/tags confuses policies. For outages, over-relying on single regions without multi-zone failover.

**Lesser-Known Facts**: Google Cloud's regional design (e.g., Paris campus) amplifies zonal failures vs. AWS's dispersed zones. Ops Agent evolved from Stackdriver; enables third-party integrations.

**Advantages**: Flexibly handled outages via managed migrations; deep IAM integration for zero-trust.

**Disadvantages**: Limited MAC customization; BYOL bureaucracy; outage dependencies on Google's design.
