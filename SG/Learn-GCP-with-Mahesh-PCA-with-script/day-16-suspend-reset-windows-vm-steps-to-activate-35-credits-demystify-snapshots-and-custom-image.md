### Mistake Corrections in Transcript:
- "equalent" corrected to "equivalent"
- "connectivities" corrected to "connectivity" 
- "Giving a picture so" corrected to "Giving a picture, so"
- "at any point of time" corrected to "at any point in time"
- "sca" corrected to "scan"
- "simle" corrected to "simple"
- "irani" corrected to "Irani" (proper name)
- "corrupted" corrected to "corrupted" (was consistent)
- "activitated" corrected to "activated"
- "ps" corrected to "PS" (PowerShell abbreviation)
- "sd" corrected to "SD" (Secure Digital)
- "r    " corrected to "r"
- "32  right" corrected to "32 right"
- "preemp" corrected to "preempt"
- "Multi regional" corrected to "Multi-regional"
- "SOAP" corrected to "SOA" (Service-Oriented Architecture? Actually kept as "SOAP" as it refers to the protocol in context)
- "helicop" corrected to "helicopter" 
- "helcop" corrected to "helicopter"
- Various punctuation and capitalization fixes for readability in technical terms

Session 16: Day 16 - Suspend, Reset Windows VM, Steps to activate 35 credits,Demystify Snapshots and Custom Image

## Table of Contents
- [VM Lifecycle States: Suspend and Reset](#vm-lifecycle-states-suspend-and-reset)
- [Activating 35 Google Cloud Skills Boost Credits](#activating-35-google-cloud-skills-boost-credits)
- [Windows VM Suspend Demo](#windows-vm-suspend-demo)
- [Reset vs Suspend Comparison](#reset-vs-suspend-comparison)
- [Custom Images vs Public Images](#custom-images-vs-public-images)
- [Snapshots vs Custom Images Deep Dive](#snapshots-vs-custom-images-deep-dive)
- [Creating Custom Images and Snapshots](#creating-custom-images-and-snapshots)
- [Backup and Recovery Scenarios](#backup-and-recovery-scenarios)
- [Auto-scaling Use Cases](#auto-scaling-use-cases)
- [Image Sharing and Permissions](#image-sharing-and-permissions)
- [Snapshot Scheduling](#snapshot-scheduling)
- [Restoration Procedures](#restoration-procedures)

## VM Lifecycle States: Suspend and Reset

### Overview
Virtual machine lifecycle states determine resource charging and operational behavior. Suspension saves computing resources while preserving memory state, whereas reset performs a hard reboot that clears memory content entirely.

### Key Concepts

#### Suspension Process
- **Memory Preservation**: Memory contents are written to storage when suspended
- **Cost Structure**: Only storage costs are incurred during suspension (not CPU/memory)
- **GUI Applications**: Windows VMs provide better visualization of hibernation/suspend
- **Cross-Platform**: Equals hibernation option in Windows/Linux

#### Reset Operation
- **Memory Wipe**: All memory contents are cleared permanently
- **Startup Scripts**: Triggers startup/shutdown scripts execution
- **Hard Reboot**: Equivalent to system reboot, loses all unsaved data

#### Cost Considerations
- **Windows VM Cost**: ~$13.44/month with Windows licensing
- **Suspension Cost**: ~$6.79 for storage during suspended state
- **Effective Cost**: ~$0.09/hour vs full instance cost

| Operation | Memory State | CPU/Memory Cost | Storage Cost | Triggers Scripts |
|-----------|-------------|-----------------|-------------|-----------------|
| Suspend | Preserved | Zero | Yes | No |
| Resume | Restored | Yes | No | No |
| Reset | Wiped | Yes | Yes (after reset) | Yes |
| Reboot | Wiped | Yes | No | Yes |

### Windows VM Suspend Demo

Setting up demonstration environment with Windows VM:

```bash
# Quick Lab activation (US West 3 region)
# Student ID required for authentication
# Use incognito mode for consistent access

# Required VM configuration:
- OS: Windows Server 2022 Datacenter
- Desktop experience: Enabled
- Machine type: E2-micro (or custom for cost optimization)
- Zone: US West 3
- External IP: Optional (for connectivity)
```

#### Demo Steps
1. **VM Creation**: Provision Windows VM with desktop experience enabled
2. **Activity Simulation**: Open applications to simulate real workload
   - Edge browser with multiple tabs
   - Cloud SDK terminal
   - Notepad with sample content
3. **Suspension**: VM → Disconnect → Suspend (vs Windows native hibernate)
4. **Resume Verification**: Check all applications return to exact state

### Reset vs Suspend Comparison

#### Suspension Characteristics
- **Visual Feedback**: Clear "Disconnected" state
- **Memory Persistence**: All RAM contents preserved on disk
- **Uptime Continuity**: System appears paused rather than restarted
- **Application State**: All programs resume exactly where left

#### Reset Characteristics
- **Immediate Disconnect**: No graceful shutdown
- **Clean State**: Memory completely wiped, uptime resets to zero
- **System Restart**: Triggers full boot sequence
- **Event Logging**: Records shutdown reason in Windows Event Viewer

#### Real-World Application
```diff
- Windows Server logs unexpected shutdown as "Unexpected restart"
! Use reset for troubleshooting connectivity issues
+ Implement reset as fallback when suspend fails
```

## Activating 35 Google Cloud Skills Boost Credits

### Overview
Google Cloud Skills Boost provides recurring credits for hands-on learning labs, with monthly 35-credit allocation across all enrolled members.

### Steps to Activate

#### 1. Account Setup
- **Requirements**: Gmail account (use fresh account if needed)
- **Registration Link**: https://cloud.google.com/training/community
- **Profile Creation**: Complete member registration process

#### 2. Credit Distribution
- **Monthly Reload**: 35 credits automatically added monthly
- **Expiration**: 30 days from activation
- **Usage Scope**: unrestricted learning credits

#### 3. Usage Guidelines
- **Resource Costs**: Map lab resource costs to credit requirements
- **Region Selection**: Choose US regions for consistent availability
- **Cost Optimization**: Monitor resource costs per credit

#### 4. Troubleshooting
- **Credit Balance**: Check in Skills Boost cloudprofile
- **Lab Availability**: Use incognito mode for consistent access
- **Block Prevention**: Follow lab instructions exactly to avoid email blocks

### Demo Environment
- **Cost Efficiency**: 34 hours ≈ 1 credit expenditure
- **VM Purpose**: Demonstrate Windows lifecycle states
- **Alternative Environment**: Free tier vs. paid labs

## Custom Images vs Public Images

### Overview
Images serve as golden templates containing operating systems and pre-configured software. Public images are managed by Google, while custom images are user-created for specific organizational needs.

### Image Types

#### Public Images
- **Provider**: Google Cloud managed
- **Licensing**: Includes license fees (Windows Server, Red Hat Enterprise Linux)
- **Availability**: Pre-built configurations ready to deploy
- **Cost**: License fees included in total cost

#### Custom Images
- **Provider**: User-created from compute disks or snapshots
- **Licensing**: License costs depend on base image and licensing model
- **Availability**: Custom configurations with pre-installed software
- **Cost**: Storage costs only (no licensing fees)

### Creating Custom Images

#### Source Options
- **Compute Disk**: Direct disk export (requires VM shutdown)
- **Snapshot**: Chain snapshots for image creation
- **Cloud Storage**: Import from GCS buckets (RAW format)
- **Archive**: Specify .tar.gz files in Cloud Storage

#### Process Steps
1. **VM State**: Ensure VM is shutdown/restarted
2. **Source Selection**: Disk, snapshot, or GCS object
3. **Image Creation**: Specify name, location, and encryption
4. **Validation**: Launch test instance to verify image integrity

## Snapshots vs Custom Images Deep Dive

### Overview
Both snapshots and images preserve VM state, but snapshots focus on incremental backups while images serve as golden copies for new VM deployments.

### Core Differences

| Feature | Snapshots | Custom Images |
|---------|-----------|---------------|
| **Purpose** | Backup & Recovery | New VM Deployment |
| **Incremental** | Yes | No (full disk copy) |
| **Source** | Compute disks only | Disks, Snapshots, GCS |
| **Cost** | Incremental storage | Full disk storage |
| **Boot Capability** | Cannot boot directly | Can create bootable VMs |
| **Sharing** | Requires special permissions | Use compute.imageUser role |
| **Scheduling** | Built-in automated scheduling | Manual process only |

### Technical Architecture

#### Snapshot Chain
```diff
+ Disk (Initial) → Snapshot 1 (Full Backup)
! DDL Change → Snapshot 2 (Incremental)
! File Changes → Snapshot 3 (Incremental)
+ VM Corruption → Restore from Snapshot N
```

#### Image Creation Flow
```diff
- VM Launch → Software Installation
! VM Shutdown → Custom Image Creation
! Template Ready → Rapid VM Deployment
```

### Cost Comparison

#### Snapshot Cost Structure
- **First Backup**: Full disk cost
- **Subsequent Backups**: Only delta storage cost
- **Compression**: Automatic size reduction
- **Global Storage**: Multi-regional replication

#### Image Cost Structure
- **Storage**: Full expanded disk size
- **No Compression**: Uncompressed disk footprint
- **Regional Storage**: Single regional location
- **Higher Long-term Cost**: Larger storage footprint

### Performance Comparison

#### Creation Time
- **Snapshots**: Fast (seconds to minutes)
- **Images**: Slower due to full disk copy (minutes)

#### VM Creation Time
- **From Snapshot**: Longer (requires disk expansion)
- **From Image**: Faster (ready-to-boot template)

## Creating Custom Images and Snapshots

### Custom Image Creation Methods

#### From Compute Disk
```bash
# Shut down VM first
gcloud compute instances stop INSTANCE_NAME

# Create image from disk
gcloud compute images create IMAGE_NAME \
  --source-disk=DISK_NAME \
  --source-disk-zone=SOURCE_ZONE \
  --storage-location=REGION
```

#### From Snapshot
```bash
# Create image from specific snapshot
gcloud compute images create IMAGE_NAME \
  --source-snapshot=SNAPSHOT_NAME \
  --storage-location=REGION
```

#### From Cloud Storage Archive
```bash
# All-in-one approach for pre-built archives
gcloud compute images create IMAGE_NAME \
  --source-uri=gs://BUCKET_NAME/IMAGE_ARCHIVE.tar.gz \
  --storage-location=REGION
```

### Snapshot Creation

#### Manual Snapshot
```bash
# Create snapshot from persistent disk (VM running)
gcloud compute disks snapshot DISK_NAME \
  --snapshot-names=SNAPSHOT_NAME \
  --zone=ZONE \
  --storage-location=REGION
```

#### Scheduled Snapshots
1. **Create Schedule**: Define snapshot policy
2. **Attach to Disk**: Associate schedule with compute disk
3. **Automatic Creation**: Daily/weekly snapshots based on policy

### Demonstrated Scenarios

#### Scenario 1: Progressive VM Changes
<img alt="VM State Progression Legend" src="https://via.placeholder.com/400x100/ffcccc/000000?text=Base+VM+-+Initial+State">

1. **Base VM**: Debian with core packages
2. **State Change**: Install Git → Snapshot 1
3. **State Change**: Install nginx → Snapshot 2
4. **State Change**: Install tree utility → Snapshot 3

#### Scenario 2: Restoration Testing
- **Corruption Simulation**: Remove critical software package
- **Point-in-Time Recovery**: Restore to pre-corruption snapshot
- **Verification**: Confirm software state and uptime reset

## Backup and Recovery Scenarios

### Snapshot-Based Recovery

#### Instant Snapshot Recovery
- **Live VM**: Snapshot creation without downtime
- **Attach to New VM**: Create new instance with snapshot as boot disk
- **Preserve Data**: Point-in-time recovery maintained

#### Persistent Disk Recovery
- **Detached Disk**: Data disks can be restored live
- **Clone Capability**: Create multiple copies simultaneously
- **Incremental Cost**: Only changed blocks stored

### Disaster Recovery Design

#### Geographic Distribution
- **Regional Storage**: Keep snapshots in separate regions from VMs
- **Data Sovereignty**: Consider GDPR/privacy compliance
- **RTO Optimization**: Minimize recovery time objectives

#### Compliance Considerations
```diff
- Banking Data: Keep snapshots within same data residency region
! Healthcare PHI: Implement strict geographic restrictions
+ Multi-regional: Acceptable for non-sensitive operational data
```

## Auto-scaling Use Cases

### Spot Instance Considerations
- **Cost Optimization**: Up to 90% discount possible
- **Preemption Risk**: Instance termination without notice
- **Restoration Strategy**: Maintain golden images for rapid recovery

### Image-Based Scaling

#### Auto-scaling Architecture
```diff
- Instance Group → Launch Template → Custom Image
! Scale-up Event → Instance Creation from Image
+ Load Distribution → Load Balancer → Instance Group
```

#### Performance Requirements
- **Boot Time**: Seconds rather than minutes
- **State Consistency**: Identical configurations across instances
- **Cost Efficiency**: Images provide faster scaling than snapshots

## Image Sharing and Permissions

### Cross-Project Sharing

#### Organizational Structure
```
Organization Node
├── DevOps Folder
│   └── DevOps Project
│       └── Central Custom Images
├── Development Folder
└── Production Folder
```

#### Required Roles
- **compute.imageUser**: Read access to create VMs from images
- **compute.imageAdmin**: Manage image lifecycle
- **Scope**: Organization-wide or project-specific

### Multi-Organization Sharing
- **Corporate Acquisitions**: Share images across different organization nodes
- **Partner Integrations**: Enable image access for third-party deployments
- **Global Catalog**: Centralized image repository

## Snapshot Scheduling

### Automated Backup Policy

#### Schedule Configuration
- **Frequency**: Hourly, daily, weekly options
- **Retention**: Define deletion rules (14-day retention typical)
- **Location**: Regional or multi-regional storage

#### Cost Optimization
```diff
+ Standard HDD: $0.04/GB/month
! SSD Persistent Disk: $0.08/GB/month
- Multi-regional: Additional replication costs
```

#### Policy Example
- **Schedule Name**: daily-backup-policy
- **Frequency**: Daily at 2 AM
- **Retention**: 14 days
- **Storage Class**: Regional HDD

### Automated Cleanup

#### Deletion Rules
- **Snapshot Deletion**: Remove snapshots older than retention period
- **Disk Deletion**: Options for snapshot cleanup after disk removal
- **Mixed Strategy**: Keep critical snapshots, delete routine backups

## Restoration Procedures

### Boot Disk Restoration

#### Required Steps
1. **VM Termination**: Stop affected VM
2. **Disk Detachment**: Remove corrupted boot disk
3. **Snapshot Selection**: Choose appropriate restoration point
4. **New Disk Creation**: Create disk from snapshot
5. **VM Reconfiguration**: Attach restored disk as boot disk

#### Verification Process
- **Service State**: Confirm all services restarted properly
- **Data Integrity**: Verify application data consistency
- **Uptime Reset**: Accept zero uptime after restoration

### Data Disk Restoration

#### Live Recovery
- **No Downtime**: Attach restored disks while VM running
- **Application Continuity**: Maintenance operations transparent to users
- **Incremental Recovery**: Only restore affected data partitions

---

## Summary

### Key Takeaways

```diff
+ Suspension saves costs by pausing compute resources while preserving memory
- Reset wipes all memory content and behaves exactly like a system reboot
! Custom Images are optimized for rapid VM creation and auto-scaling scenarios
+ Snapshots provide incremental backups with point-in-time recovery capabilities
- Images have higher storage costs than snapshots but enable faster VM deployments
+ Implement scheduled snapshots for automated backup and disaster recovery
! Choose multi-regional snapshot storage for enhanced disaster recovery resilience
```

### Expert Insight

#### Real-world Application
**Production Environment Strategy**: Implement hybrid approach combining both images and snapshots. Maintain golden images for standard deployments while using snapshots for critical data backups. For stateful applications running on spot instances, design architectures that separate application logic (images) from session data (snapshots).

**Cost Optimization**: Calculate TCO considering create-from-snapshot (slower but cheaper) vs. create-from-image (faster but more expensive storage). For frequently reused configurations, images pay for themselves through deployment speed improvements.

#### Expert Path
**Advanced Implementation**: Master Cloud Build integration for automated image creation pipelines. Implement Infrastructure as Code (IaC) approaches using Terraform to manage image lifecycles. Study instance templates for complex auto-scaling configurations combining custom images with startup scripts.

**Security Considerations**: Understand Shielded VM capabilities with custom images. Implement image sharing strategies for multi-organization deployments while maintaining least-privilege access controls.

#### Common Pitfalls
- **Not shutting down VMs before image creation**: Results in corrupted images with locked file systems
- **Single-region snapshot storage**: Exposes data to regional failures without recovery options
- **Over-provisioning image counts**: Maintains excessive storage costs for infrequently used configurations
- **Ignoring licensing implications**: Forgets that custom images may still require license tracking

**Lesser Known Facts**: Images support importing from on-premises environments through Cloud Storage archives. Snapshots can be exported to Cloud Storage for offline backup scenarios. Consider using instance-level snapshot permissions for fine-grained access control in complex organizational structures.
