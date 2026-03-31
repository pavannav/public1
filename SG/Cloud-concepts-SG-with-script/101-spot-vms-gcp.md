# Session 101: Spot VMs on GCP

**Note on Transcript Corrections:** While processing the transcript, the following corrections were made for accuracy and clarity:
- "Kota" corrected to "Quota"
- "preeable" corrected to "preemptible"
- "primitable" corrected to "preemptible"
- "preeutable" corrected to "preemptible"
- "court" corrected to "code" (contextual: quota)
- "primatable" corrected to "preemptible"
- Minor grammatical fixes for readability (e.g., "school from comput engine SLA" to "not covered under Compute Engine SLA")
- "htp" not present, but similar typos avoided
- Other slight misspellings corrected (e.g., "flown" to "flow")

This guide follows the instructor's sequence from the transcript, covering all sub-topics without skipping.

## Table of Contents

- [Introduction to Spot VMs](#introduction-to-spot-vms)
- [Spot Provisioning Model](#spot-provisioning-model)
- [Discount and Pricing](#discount-and-pricing)
- [Preemption](#preemption)
- [Termination Actions](#termination-actions)
- [SLA Coverage](#sla-coverage)
- [Preemption Process](#preemption-process)
- [Host Maintenance](#host-maintenance)
- [Limitations of Spot VMs](#limitations-of-spot-vms)
- [Best Practices](#best-practices)
- [Quotas for Spot VMs](#quotas-for-spot-vms)
- [Lab Demo: Creating Spot VMs](#lab-demo-creating-spot-vms)
- [Summary](#summary)

## Introduction to Spot VMs

### Overview
Spot VMs on Google Cloud Platform (GCP) are a cost-effective way to run workloads using underutilized Compute Engine resources. They provide significant discounts compared to standard VMs but come with the risk of preemption, making them ideal for fault-tolerant applications that can handle interruptions. This section introduces the basic concept and use cases.

### Key Concepts/Deep Dive
- **Definition**: Spot VMs leverage GCP's spot provisioning model, allowing users to access spare compute resources at discounted rates.
- **Why Use Spot VMs?**: Organizations with flexible workloads, such as batch jobs or non-critical processing tasks, can benefit from up to 95% cost savings. This is especially useful for scenarios like data processing, testing, or development environments where interruptions are acceptable.
- **Risk Factor**: VMs can be preempted at any time when GCP needs resources back, similar to how other cloud providers handle spot instances.
- **Target Workloads**: Best suited for fault-tolerant workloads—applications that can resume after interruption without significant downtime or data loss.

> [!IMPORTANT]
> Spot VMs are not suitable for production workloads requiring guaranteed uptime, such as web servers or databases with strict SLA requirements.

## Spot Provisioning Model

### Overview
The spot provisioning model allows GCP to offer excess capacity at lower prices. This model enables users to run VMs on闲置 resources that would otherwise go unused, promoting efficient resource utilization.

### Key Concepts/Deep Dive
- **How It Works**: Google maintains large data centers with unused capacity. When demand is low, this capacity is offered as Spot VMs to users at discounted rates.
- **Availability**: Based on real-time supply and demand. Capacity fluctuates by region, zone, and time.
- **Comparison to Standard VMs**: Standard VMs are billed at full price and offer reliability guarantees; Spot VMs trade reliability for cost savings.
- **Supported Resources**: Includes CPUs, GPUs, TPUs, and Local SSD, all at reduced pricing.

📝 **Tip**: Monitor capacity availability in your preferred regions before deploying large-scale workloads.

## Discount and Pricing

### Overview
Spot VMs offer substantial discounts, making them an attractive option for cost-conscious users. Pricing varies based on demand and resource type.

### Key Concepts/Deep Dive
- **Discount Range**: Up to 91-95% off standard VM pricing, including for GPUs, TPUs, and Local SSD.
- **Pricing Example**: From the transcript video, standard VM pricing might be ~$25/month, while Spot VMs can drop to ~$10/month—a 60% savings in this case.
- **Dynamic Pricing**: Prices are market-driven but always lower than standard rates. Actual discounts depend on machine type and region.
- **Billing Impact**: Only pay for actual usage time before preemption; no partial charges for interrupted instances.

> [!NOTE]
> Pricing details can be viewed in the GCP console during VM creation for real-time estimates.

## Preemption

### Overview
Preemption is the core trade-off with Spot VMs, where GCP can reclaim resources suddenly when needed. Understanding preemption helps users design resilient applications.

### Key Concepts/Deep Dive
- **Definition**: GCP can stop or delete Spot VMs anytime to allocate resources to higher-priority demands, such as standard VM requests in regions experiencing high usage.
- **Triggers**: Occurs when:
  - Capacity is needed elsewhere (e.g., sudden demand spike).
  - Host maintenance is required.
  - Infrastructure events happen (e.g., regional failures).
- **No SLA Coverage**: Preemption does not qualify for credits or uptime guarantees from Compute Engine SLA.
- **Frequency**: Can happen within minutes or days—unpredictable timing.

Preemption mimics GCP's resource balancing strategy, ensuring critical user requests are fulfilled.

## Termination Actions

### Overview
When creating Spot VMs, users must specify how to handle preemption via termination actions. These settings control the final state of the VM and disks.

### Key Concepts/Deep Dive
- **Options**: Choose between "Stop" or "Delete" upon termination.
- **Stop Behavior**:
  - VM is terminated (powered off), but disks remain.
  - No compute charges incurred after stoppage.
  - VM can restart if capacity becomes available again.
- **Delete Behavior**:
  - VM and auto-delete disks are permanently removed.
  - All resources are gone; disks without auto-delete are preserved but must be paid for.
- **Disk Handling**: Independent of termination action—manually specify auto-delete for disks to control persistence.
- **Prioritization**: For Spot VMs, termination action settings always override other configurations.

> [!WARNING]
> Without proper disk management, stopped Spot VMs can accumulate storage costs while unavailable.

## SLA Coverage

### Overview
Spot VMs are explicitly excluded from GCP's Compute Engine Service Level Agreement (SLA), meaning no uptime commitments or compensation for interruptions.

### Key Concepts/Deep Dive
- **Exclusion Reason**: Due to the preemptible nature, GCP does not provide SLAs for Spot VMs.
- **User Responsibility**: Users must assume full risk—no credits or refunds for preemption-induced downtime.
- **Comparison to Standard VMs**: Standard VMs offer SLA-backed availability (e.g., 99.9% uptime guarantees).
- **Legal Note**: Do not rely on Spot VMs for mission-critical services.

⚠️ **Caution**: Assume preemption will occur and design applications accordingly.

## Preemption Process

### Overview
GCP follows a structured process for preemption to minimize data loss, starting with soft signals and escalating if necessary.

### Key Concepts/Deep Dive
- **Sequence**:
  1. **Soft Signal**: Google sends a best-effort shutdown signal with up to 30 seconds for graceful shutdown.
  2. **Shutdown Scripts**: Users can run scripts during this window to save data (e.g., upload to Cloud Storage).
  3. **Hard Shutdown**: If not stopped in 30 seconds, GCP sends ACPI G3 signal for forced power-off.
- **Final State**: Determined by termination action (stop or delete).
- **Time Frame**: Preemption can happen immediately after notification; scripts must be fast-acting.
- **Data Preservation**: Use the soft signal window to back up critical data.

```
graph TD
    A[Preemption Triggered] --> B[GCP Sends Soft Signal (30s)]
    B --> C[Run Shutdown Scripts to Save Data]
    C --> D[VM Attempts Graceful Shutdown]
    D --> E{Stopped in 30s?}
    E -->|Yes| F[VM Stopped/Delete per Settings]
    E -->|No| G[GCP Sends ACPI G3 Hard Shutdown]
    G --> F
```

This process ensures efficient resource reclamation while giving users a chance to mitigate losses.

## Host Maintenance

### Overview
Host maintenance for Spot VMs involves planned or emergency updates to physical hosts, resulting in VM preemption.

### Key Concepts/Deep Dive
- **Behavior**: Unlike standard VMs (which may migrate live), Spot VMs are always terminated during host maintenance.
- **Reason**: Prevents conflicts with preemption policies.
- **Sequence**: Mirrors the preemption process—soft signal, then hard shutdown based on termination settings.
- **Impact**: Treated as a system-initiated termination, just like demand-based preemption.
- **Event Types**: Can occur due to hardware upgrades, security patches, or other infrastructure needs.

💡 **Insight**: Test host maintenance simulation (as shown in lab demo) to understand behavior before production use.

## Limitations of Spot VMs

### Overview
Spot VMs have several restrictions compared to standard VMs, primarily due to their preemptible design.

### Key Concepts/Deep Dive
- **Migration Restrictions**:
  - Cannot convert running Spot VMs to standard VMs.
  - No live migration during host events.
- **Restart Policies**:
  - Automatic restart on host failure is not supported.
  - Manual restart only if capacity allows.
- **Unsupported Hardware**:
  - No support for bare metal X4 instances.
- **Other Constraints**:
  - Variable availability based on capacity.
  - Preemption at any time (minutes to weeks).
  - Excluded from SLA, bare metal options, or managed instance group live migration.

These limitations emphasize Spot VMs' design for short-term, interruptible tasks.

## Best Practices

### Overview
To maximize benefits and minimize risks, follow proven strategies for deploying Spot VMs effectively.

### Key Concepts/Deep Dive
- **Use Instance Templates**: For creating multiple identical VMs, streamlines management.
- **Managed Instance Groups (MIGs)**: Distribute VMs regionally or across zones for redundancy; automatically replace preempted instances.
- **Machine Type Selection**: Prefer smaller, more available types over large ones.
- **Operational Timing**: Run during off-peak hours (e.g., evenings, weekends) when capacity is higher.
- **Fault Tolerance Design**:
  - Build applications to handle interruptions (e.g., stateless or resumable).
  - Implement retry logic for creation attempts.
- **Shutdown and Startup Scripts**:
  - Save checkpoints to Cloud Storage on shutdown.
  - Pull data back on restart to resume workflows.
- **Testing**: Regularly simulate preemption (via GCP console tools) to validate resilience.

Adopting these practices ensures smoother operations at scale.

## Quotas for Spot VMs

### Overview
Spot VMs consume quotas, and proper management prevents interference with standard VM resources.

### Key Concepts/Deep Dive
- **Quota Types**:
  - Spot VMs use CPU, GPU, and Local SSD quotas.
  - Without preemptible quotas, Spot VMs consume standard quotas.
- **Risk Mitigation**: Request preemptible quotas to isolate Spot VM usage and avoid depleting standard quotas.
- **Free Trial Limitation**: Preemptible quotas unavailable in free trials; use paid accounts for full functionality.
- **Regional Quotas**:
  - Once granted preemptible quotas in a region, all Spot VMs there use them.
  - Cannot fall back to standard quotas in regions with preemptible quotas.
  - In regions without preemptible quotas, standard quotas are used.
- **Management Tips**:
  - Request preemptible quotas early to avoid scaling issues.
  - Monitor usage to prevent over-allocation affecting standard workloads.

> [!TIP]
> Proactive quota planning prevents production disruptions when standard VM needs arise.

## Lab Demo: Creating Spot VMs

### Overview
This demo walks through creating Spot VMs in the GCP console, setting termination options, and simulating preemption to understand behavior.

### Key Concepts/Deep Dive
- **Step-by-Step Creation**:
  1. Navigate to Compute Engine > VM instances > Create instance.
  2. Name the VM (e.g., spot-vm1).
  3. Set Provisioning Model to "Spot".
  4. Compare pricing: Standard (~$25/month) vs. Spot (~$10/month).
  5. Configure termination action: "Stop" (VM powers off, disks persist) or "Delete" (full removal).
  6. On Host Maintenance: Always "Terminate VM" for Spot VMs (no migration option).
  7. Additional options: Set limits, graceful shutdown (covered in other videos).
- **Testing Preemption**:
  - Use GCP's "Simulate Maintain Event" command in console for each VM.
  - Command example (for spot-vm1 in asia-south1-a): `gcloud compute instances simulate-maintenance-event spot-vm1 --zone=asia-south1-a`.
  - Observe operations logs: Check status (done) and monitor VM state changes.
  - Stop action: VM powers off; can restart if capacity returns.
  - Delete action: VM disappears permanently.
- **Shutdown Scripts** (optional):
  - Add scripts to save data to Cloud Storage before termination.
  - Startup scripts to restore data on restart.
- **Duration**: VMs create quickly; simulations take 1-3 minutes to reflect changes.

```
sequenceDiagram
    participant U[User] as User
    participant GC[GCP Console] as Console
    participant VM[Spot VM] as VM

    U->>GC: Create Spot VM with Stop/Delete termination
    GC->>VM: VM Created
    U->>GC: Simulate Maintenance Event
    GC->>VM: Send Preemption Signal
    VM->>GC: Shutdown Script Runs (if configured)
    VM->>GC: VM Stopped/Deleted
    U->>GC: Check Operations Log & VM State
```

This hands-on approach demonstrates real-world preemption handling.

## Summary

### Key Takeaways
```
! Spot VMs provide up to 95% cost savings but are preemptible, making them ideal for fault-tolerant workloads
! Termination actions (Stop vs. Delete) control resource fate during preemption—Stop preserves disks, Delete removes everything
+ Preemption process starts with a 30-second soft signal for graceful data saving, followed by hard shutdown if needed
- Spot VMs lack SLA coverage, migration options, and auto-restart, unlike standard VMs
+ Best practices include using MIGs, smaller machine types, off-peak timing, and retry logic
- Manage preemptible quotas to avoid consuming standard quotas and ensure resource isolation
```

### Expert Insight

#### Real-world Application
In production, Spot VMs excel for scalable, cost-efficient tasks like big data processing (e.g., via BigQuery or custom ML training), CI/CD pipelines, or rendering farms. Companies like startups or research labs use them to lower cloud costs while handling batch workloads that checkpoint progress, ensuring continuity post-preemption.

#### Expert Path
To master Spot VMs, start with small-scale experimentation in free trials, focusing on fault-tolerance design (e.g., Kubernetes Jobs for containerized workloads). Progress to paid accounts for quota management and MIGs. Dive deeper into automation with Terraform for infrastructure as code, and monitor via GCP's Monitoring tools to predict preemption patterns. Combine with committed use discounts for hybrid strategies, and enroll in GCP certifications like Associate Cloud Engineer for formalized knowledge.

#### Common Pitfalls
- **Underestimating Preemption Frequency**: Avoid treating Spot VMs as reliable; test frequently to build resilience. Issue: Production downtime without checkpoints. Resolution: Implement watchdog scripts that auto-recover workloads.
- **Quota Exhaustion**: Running Spot VMs on standard quotas depletes limits for critical standard VMs. Resolution: Proactively request preemptible quotas and set alerts in GCP Billing/Monitoring.
- **Configuration Mistakes**: Setting wrong termination actions (e.g., Delete without backup) leads to permanent data loss. Resolution: Always test termination via simulations and document settings.
- **Poor Application Design**: Non-stateless apps fail spectacularly on preemption. Resolution: Refactor to use distributed systems (e.g., queues, databases for state), and conduct chaos engineering drills.

#### Common Issues with Resolution and How to Avoid Them
- **VMCreation Failure Due to Capacity**: Error: "Not enough resources." Resolution: Retry with exponential backoff scripts or switch zones. Avoidance: Use MIGs for auto-distribution and smaller machine types.
- **Startup Delays After Restart**: After Stop action, scripts may fail to pull data. Resolution: Verify Cloud Storage permissions and error logging in scripts. Avoidance: Test full restart cycles and use ARM-based VMs for faster initialization.
- **Storage Cost Overruns**: Deleted VMs leave orphan disks if auto-delete unchecked. Resolution: Audit disks post-preemption with `gcloud compute disks list`. Avoidance: Enable auto-delete by default and monitor costs with GCP billing reports.
- **Host Maintenance Misjoins**: Simulating maintenance without correct project/zones causes "Permission Denied." Resolution: Double-check instance names and zones in CLI commands. Avoidance: Use console over CLI for beginners and save commands in scripts.

#### Lesser Known Things About This Topic
- **Preemption Timing Patterns**: GCP often preempts during off-hours to minimize user impact; monitor historical data via BigQuery audit logs for predictive scheduling.
- **Spot GPU/TPU Availability**: These resources preempt less in low-demand regions (e.g., Asia-Pacific during US daytime), making them goldmines for ML workloads.
- **Integration with Vertex AI**: Spot VMs can power managed notebooks or training jobs, combining with Auto ML for hyper-efficient model experiments.
- **Preemption Marketplace**: Internal GCP algorithms prioritize based on bid-like factors (though not user-configurable), favoring long-running or strategic instances.
- **Historical Discounts**: Discounts hover at 60-91% but spike to 95-99% during major events (e.g., holidays) or capacity overhangs.
