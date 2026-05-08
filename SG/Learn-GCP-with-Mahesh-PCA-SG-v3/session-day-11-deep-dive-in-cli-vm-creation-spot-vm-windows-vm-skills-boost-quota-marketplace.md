# Session 11: Deep Dive in CLI - VM Creation, Spot VM, Windows VM

## Table of Contents
- [Creating Preemptable and Spot VMs](#creating-preemptable-and-spot-vms)
- [VM Creation via UI and CLI](#vm-creation-via-ui-and-cli)
- [Adding Labels and Managing VM Configurations](#adding-labels-and-managing-vm-configurations)
- [Custom Machine Types with Spot Provisioning](#custom-machine-types-with-spot-provisioning)
- [Windows VMs](#windows-vms)
- [Quota Management and Limits](#quota-management-and-limits)
- [Marketplace Solutions](#marketplace-solutions)
- [Summary](#summary)

## Creating Preemptable and Spot VMs

### Overview
Preemptable and spot Virtual Machines (VMs) are cost-effective compute resources designed for workloads that can tolerate interruptions. Preemptable VMs run for a maximum of 24 hours with up to 80% discount, while spot VMs offer unlimited runtime potential with up to 91% discount but can be preempted at any time. These options help reduce infrastructure costs for non-critical, fault-tolerant applications by leveraging excess Google Cloud capacity.

### Key Concepts / Deep Dive

#### Preemptable vs Spot VMs Comparison
The primary difference lies in their availability and discount rates:

| Feature | Preemptable VMs | Spot VMs |
|---------|-----------------|----------|
| Maximum Runtime | 24 hours (fixed) | Unlimited (subject to availability) |
| Discount | Up to 80% off on-demand pricing | Up to 91% off on-demand pricing |
| Termination Policy | Terminated after 24 hours | Can be terminated anytime based on demand |
| Use Cases | Batch processing, data analysis within time limits | Test environments, development workloads |

#### VM Preemption Behavior
When a VM is preempted by Google Cloud:
- The compute resources (vCPUs and memory) are reclaimed
- Persistent disks and data remain intact
- The VM status changes to "TERMINATED"
- Disk snapshots and configurations are preserved for restart

This ensures data persistence while allowing Google to optimize resource utilization.

#### Cost Calculation Example
For a standard VM with an on-demand cost of $0.08/hour (2 vCPUs), the pricing would be:

- **Regular VM**: $0.08/hour
- **Preemptable VM**: Up to $0.016/hour (80% discount)
- **Spot VM**: Up to $0.0072/hour (91% discount)

### Lab Demos: Creating Spot VMs

#### Demo 1: Basic Spot VM Creation via CLI
```bash
gcloud compute instances create spot-vm-1 \
  --zone=us-central1-a \
  --provisioning-model=spot
```

This command creates a spot VM in the `us-central1-a` zone with default machine type (e2-small).

#### Demo 2: Spot VM with Custom Configuration
```bash
gcloud compute instances create spot-vm-2 \
  --zone=us-central1-a \
  --machine-type=e2-small \
  --provisioning-model=spot \
  --no-address \
  --service-account=default \
  --tags=my-component
```

Key parameters:
- `--provisioning-model=spot`: Specifies spot VM type
- `--no-address`: Removes external IP for security
- `--service-account`: Defines service account
- `--tags`: Adds network tags for firewall rules

## VM Creation via UI and CLI

### Overview
Google Cloud VMs can be created through the web-based Console UI or via Command Line Interface (CLI) tools. The CLI offers programmatic automation, filtering capabilities, and advanced configuration options not available in the UI, while the UI provides visual guidance and simplified workflows for beginners.

### Key Concepts / Deep Dive

#### UI-Based Creation
Navigate to **Compute Engine > VM instances > Create Instance** in Google Cloud Console. Select:
- Machine configuration (series, type)
- Boot disk (OS image)
- Networking (VPC, subnets)
- Security settings (firewalls, service accounts)

#### CLI-Based Creation with Filtering

Use `gcloud compute instances create` for CLI operations:

```bash
gcloud compute instances create vm-name \
  --machine-type=e2-small \
  --zone=us-central1-a \
  --provisioning-model=standard \
  --network=default
```

#### Advanced Listing and Filtering

```bash
# View all instances with vertical format
gcloud compute instances list

# Enable horizontal format for better readability
gcloud config set accessibility/screen_reader false
gcloud compute instances list

# Filter by preemptable VMs
gcloud compute instances list --filter="status=RUNNING AND scheduling.preemptible=True"

# Filter by service account
gcloud compute instances list --filter="serviceAccounts.email:compute@developer.gserviceaccount.com"

# Filter by network
gcloud compute instances list --filter="networkInterfaces.network:(projects/PROJECT/global/networks/default)"

# Export to CSV format (requires additional flags for large datasets)
gcloud compute instances list --format="csv(name,zone,machineType,preemptible,status)" > vms.csv
```

These filters enable operational visibility:

**Filter Examples:**
- List all spot VMs: `--filter="scheduling.provisioningModel:SPOT"`
- Find VMs by component label: `--filter="labels.component=my-sql-client"`
- Get running VMs: `--filter="status=RUNNING"`

#### JSON Output for Complex Filtering
For advanced queries:

```bash
gcloud compute instances list --format="json" | jq '.[] | select(.status == "RUNNING")'
```

This provides complete VM metadata for scripting and automation.

### Lab Demos: VM Filtering Techniques

#### Demo 1: Basic VM Listing
```bash
# List all VMs with readable format
gcloud compute instances list --format="table(name,zone,status,preemptible)"
```

Expected output shows VM name, zone, status, and preemptability status.

#### Demo 2: Advanced Filtering
```bash
# Find all spot VMs in a project
gcloud compute instances list --filter="scheduling.previsioningModel:SPOT"
```

This helps in auditing and resource management for cost optimization.

## Adding Labels and Managing VM Configurations

### Overview
Labels and configuration management enable better resource organization, billing tracking, and operational visibility in Google Cloud. Labels act as key-value pairs attached to resources, while configurations like delete protection prevent accidental resource removal.

### Key Concepts / Deep Dive

#### Labeling Strategy
Labels help in:
- Cost allocation and billing reports
- Resource organization and filtering
- Automation and policy enforcement

**Best Practices:**
- Use consistent naming conventions
- Include business context (environment, component, owner)
- Limit to 64 key-value pairs per resource

#### Delete Protection
```bash
# Enable delete protection
gcloud compute instances update vm-name \
  --zone=us-central1-a \
  --delete-protection=on

# Disable delete protection
gcloud compute instances update vm-name \
  --zone=us-central1-a \
  --delete-protection=off
```

Delete protection prevents accidental termination of critical VMs, especially spot instances.

### Lab Demos: Labeling and Protection

#### Demo 1: Adding Labels Post-Creation
```bash
# Add labels to existing VM
gcloud compute instances add-labels vm-name \
  --zone=us-central1-a \
  --labels=component=my-sql-client,environment=dev
```

This tags resources for better tracking and filtering.

#### Demo 2: Enabling Delete Protection
```bash
# Protect VM from deletion
gcloud compute instances update spot-vm-1 \
  --zone=us-central1-a \
  --delete-protection=on
```

Critical for spot VMs to preserve data when preempted.

## Custom Machine Types with Spot Provisioning

### Overview
Custom machine types allow precise CPU and memory allocation beyond predefined configurations, optimized for specific workload requirements. Combined with spot provisioning, this creates highly cost-effective compute resources for specialized applications requiring non-standard resource ratios.

### Key Concepts / Deep Dive

#### Custom Machine Type Specifications
- **vCPUs**: 1-128 (except shared-core types)
- **Memory**: 0.9-8192 GB, with specific ratios per CPU
- **Series Support**: E2, N2, N2D (varies by region)

**Cost Optimization Formula:**
Custom machine pricing = Standard machine pricing × (custom vCPUs × custom memory factor)

#### Spot with Custom Machines
Combines maximum discounts with tailored specifications:

```bash
gcloud compute instances create custom-spot-vm \
  --zone=us-central1-a \
  --custom-cpu=4 \
  --custom-memory=8 \
  --provisioning-model=spot
```

### Lab Demos: Custom Spot Configurations

#### Demo 1: Basic Custom Spot VM
```bash
gcloud compute instances create custom-spot-1 \
  --zone=us-central1-a \
  --custom-cpu=4 \
  --custom-memory=7.5 \
  --provisioning-model=spot \
  --no-address
```

This creates a 4 vCPU, 7.5 GB RAM spot VM without external IP.

#### Demo 2: Advanced Configuration
```bash
gcloud compute instances create production-custom-spot \
  --zone=us-central1-a \
  --custom-cpu=16 \
  --custom-memory=64 \
  --provisioning-model=spot \
  --service-account=my-service@project.iam.gserviceaccount.com \
  --tags=production,spot
```

Includes service account and network tags for production workloads.

## Windows VMs

### Overview
Windows Virtual Machines provide familiar desktop environments for enterprise applications requiring graphical user interfaces, development tools, or proprietary Windows software. In Google Cloud, Windows VMs offer seamless RDP connectivity, volume licensing integration, and pre-configured desktop experiences.

### Key Concepts / Deep Dive

#### Windows VM Characteristics
- **OS Options**: Server 2016, 2019, 2022 (Datacenter edition preferred)
- **Desktop Experience**: Enables full GUI and RDP capabilities
- **Client Access Licenses (CALs)**: Limits simultaneous RDP sessions (typically 2 per license)
- **Licensing**: Premium cost for Windows Server, additional CAL fees

#### RDP Configuration
Windows VMs use RDP for remote access:
- Username: `student` (lab environments)
- Password: Generated automatically
- Display device: Enable for screen recording/capture

#### Volume Licensing
Integration with Microsoft's volume licensing for enterprise deployments:
- Fill license details in VM creation wizard
- Enables installation of licensed software
- Reduces licensing costs for large deployments

### Lab Demos: Windows VM Setup

#### Demo 1: Creating Windows VM via UI
1. Navigate to **Compute Engine > VM instances > Create Instance**
2. Select **Windows Server 2022**
3. Enable **Desktop experience**
4. Configure machine type and networking
5. Create VM and wait for boot completion

#### Demo 2: RDP Access Verification
```bash
# Check VM startup status
gcloud compute instances get-serial-port-output windows-vm \
  --zone=us-central1-a \
  --start=0
```

Look for "Ready for RDP" or similar confirmation in serial output.

#### Demo 3: Volume Licensing Configuration
1. Go to VM creation screen
2. Scroll to "Licensing" section
3. Fill organization license details
4. Import required certificates if needed

## Quota Management and Limits

### Overview
Quotas serve as resource usage boundaries in Google Cloud, preventing unintended overconsumption while protecting platform stability. They enforce limits on computational resources, network components, and API calls, with automatic approval for basic increases in paid accounts.

### Key Concepts / Deep Dive

#### Regional vs Project-Wide Quotas
- **Regional Quotas**: vCPUs, GPUs, disk size per region
- **Project-Wide Quotas**: Global resources like networks, IP addresses
- **Per-Resource Limits**: Maximum instances per region (default varies)

#### Common Quota Limits
| Resource | Default Limit | Purpose |
|----------|---------------|---------|
| CPUs | 24-32/region | Computational capacity |
| In-use external IPs | 8/region | Network addressing |
| Persistent disks | 10TB/region | Storage allocation |
| API requests | Varies by service | Rate limiting |

#### Quota Modification Process
1. Navigate to **IAM & Admin > Quotas**
2. Filter for required resource
3. Request increase with justification
4. Automatic approval for paid accounts (immediate)
5. Manual review for complex requests (business days)

#### Handling Quota Exceeded Errors
- **IP Address Exceeded**: Use `--no-address` flag
- **CPU Limit Exceeded**: Request quota increase
- **Disk Quota**: Optimize storage or request increase

### Lab Demos: Quota Exploration and Management

#### Demo 1: Checking Current Quotas
Navigate to **IAM & Admin > Quotas** in Console
- Filter by service (Compute Engine)
- View current usage vs limits
- Identify nearing limits

#### Demo 2: Bulk VM Creation with Quota Awareness
```bash
# Create multiple VMs efficiently
gcloud compute instances create vm-{1..10} \
  --zone=us-central1-a \
  --machine-type=f1-micro \
  --no-address \
  --provisioning-model=spot
```

Monitors quota usage during creation.

## Marketplace Solutions

### Overview
Google Cloud Marketplace (formerly Cloud Launcher) provides pre-packaged software solutions deployable in single-click operations. It offers open-source tools, commercial software, and custom implementations with integrated billing and support, eliminating manual installation complexities.

### Key Concepts / Deep Dive

#### Marketplace Categories
- **Open Source**: WordPress, MySQL, Apache
- **Commercial**: Paid solutions with support
- **Custom Deployments**: Partner-provided configurations

#### Deployment Process
1. Browse Marketplace catalog
2. Select software solution
3. Configure deployment parameters
4. Deploy and access application
5. Integrated monitoring and management

#### Cost Model
- **Open Source**: Free software, paid infrastructure
- **Commercial**: Subscription-based with infrastructure costs
- **Enterprise**: Volume licensing integration

### Lab Demos: Marketplace Deployments

#### Demo 1: WordPress Installation
1. Navigate to **Marketplace > Search "WordPress"**
2. Select "WordPress on Ubuntu" (free)
3. Configure:
   - Zone: us-central1-a
   - Machine type: e2-small
   - Admin email
4. Deploy and access via provided URL

#### Demo 2: Matomo Analytics
1. Search "Matomo" in Marketplace
2. Select free solution
3. Deploy configuration
4. Access analytics dashboard at deployment URL

#### Demo 3: ElasticSearch Subscription
1. Search "Elastic" in Marketplace
2. Select paid offering
3. Configure subscription
4. Deploy and pay through Google Cloud billing

## Summary

### Key Takeaways
```diff
+ Spot VMs provide up to 91% cost savings for interruptible workloads
+ Custom machine types enable precise resource allocation
+ Windows VMs require premium licensing and CALs for RDP
+ Quotas are soft limits that can be increased in paid accounts
+ Marketplace offers quick software deployment with integrated billing
+ CLI filtering enables powerful operational automation
+ Delete protection preserves spot VM data during preemption
```

### Quick Reference
**Essential Commands:**
- Create spot VM: `gcloud compute instances create vm-name --provisioning-model=spot`
- Filter spot VMs: `gcloud compute instances list --filter="scheduling.provisioningModel:SPOT"`
- Enable delete protection: `gcloud compute instances update vm-name --delete-protection=on`
- Create without external IP: `gcloud compute instances create vm-name --no-address`
- Custom machine type: `gcloud compute instances create --custom-cpu=4 --custom-memory=8`

**Quota Limits:**
- Regional vCPUs: 24-32 (increases automatic)
- External IPs: 8/region
- Persistent disks: 10TB/region

### Expert Insight

#### Real-world Application
In production environments, spot VMs excel in CI/CD pipelines, batch data processing, and development/test environments. A fintech company reduced compute costs by 70% by migrating non-critical workloads to spot instances with custom machine types, maintaining 99.9% uptime through automated restart scripts triggered by preemption notifications.

#### Expert Path
Master advanced CLI filtering and automation scripts for fleet management. Learn Cloud Build for infrastructure-as-code deployments and Cloud Monitoring for proactive quota alerting. Focus on cost optimization patterns and automated resource scaling to achieve Google Cloud Professional Cloud Architect certification.

#### Common Pitfalls
Failing to implement graceful shutdown handlers in applications running on spot VMs leads to data corruption. Ignoring CAL limits on Windows VMs causes RDP disconnections. Over-provisioning custom machine types creates unnecessary costs, while under-estimating disk sizes causes I/O bottlenecks.

#### Lesser-Known Facts
Spot VM preemptions follow Google Cloud's capacity needs, typically occurring during peak traffic hours (9-5 PST). Marketplace deployments include auto-scaling configurations hidden in advanced settings. Windows VMs can integrate with Google Cloud Identity for seamless SSO, reducing CAL requirements for internal users.

#### Advantages and Disadvantages
**Advantages:**
- Spot VMs dramatically reduce costs for temporary workloads
- Custom machine types optimize resource usage
- Marketplace accelerates application deployment
- CLI automation enables massive fleet operations

**Disadvantages:**
- Spot VMs have unpredictable runtime durations
- Windows licensing increases total cost of ownership
- Quota increases may require manual engineering review
- Marketplace solutions might not match enterprise customization needs
