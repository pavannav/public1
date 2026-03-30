# Session 57: Shared VPC Deep Dive - Resources Without VPC, GKE on Shared VPC, GCE on Shared VPC

## Table of Contents
- [Introduction to Shared VPC](#introduction-to-shared-vpc)
- [Host Project and Service Projects](#host-project-and-service-projects)
- [Enabling Shared VPC](#enabling-shared-vpc)
- [Creating Resources in Service Projects](#creating-resources-in-service-projects)
- [Firewall Rules in Shared VPC](#firewall-rules-in-shared-vpc)
- [NAT for Outbound Access](#nat-for-outbound-access)
- [GKE on Shared VPC](#gke-on-shared-vpc)
- [Load Balancing with Internal IPs](#load-balancing-with-internal-ips)
- [Limitations and Drawbacks](#limitations-and-drawbacks)

## Introduction to Shared VPC

### Overview
Shared VPC in Google Cloud Platform (GCP) enables centralized networking management across multiple projects within the same organization. This concept mimics on-premise IT ticket-based networking by allowing dedicated network engineering teams to control all networking infrastructure, while application teams consume shared subnets to deploy resources. It addresses the challenge of maintaining consistent networking practices across large organizations where not all team members are networking experts.

### Key Concepts/Deep Dive
Shared VPC allows subnet sharing across projects, enabling:
- **Centralized networking control**: Network engineers manage VPCs, subnets, firewall rules, and routes in a "host project"
- **Decentralized resource deployment**: Application teams deploy VMs, Kubernetes clusters, and other resources in "service projects" without managing networks
- **Improved security and compliance**: Networking policies can be enforced organization-wide
- **Cost efficiency**: Avoids VPN tunnels (costing $30-40 each) between multiple service projects

The key insight is that only certain resources (VMs, GKE clusters, Cloud SQL with private IPs, Memory Store, Filestore) require networking, while many GCP services (Cloud Storage, BigQuery, Cloud Functions, etc.) operate without VPC requirements.

### Demo: Identifying VPC-Requiring Resources
The following table shows which GCP products require networking and which can operate without VPC:

| Resource | Requires VPC? | Notes |
|----------|---------------|--------|
| Virtual Machines | Yes | Must be deployed in a subnet |
| Kubernetes Engine | Yes | Requires network for nodes and services |
| Cloud SQL with Private IP | Yes | Uses Private Services Access |
| Memory Store (Redis) | Yes | Requires network for access |
| Filestore (NFS) | Yes | Mounts require network connectivity |
| Cloud SQL with Public IP | No | Can be accessed via external endpoints |
| Cloud Storage buckets | No | Global service, region-independent |
| BigQuery datasets | No | Serverless analytics service |
| Cloud Run services | No | Fully managed, no network required |
| Cloud Functions | No | Event-driven, serverless |
| Global Load Balancers | No | GCP-managed IP pools |

### Common Pitfalls
- Assuming all GCP services require networking (many don't)
- Mixing host and service project responsibilities
- Forgetting that service projects cannot create their own VPCs when attached to shared VPC

## Host Project and Service Projects

### Overview
In the Shared VPC model, projects are classified into "host projects" (containing all networking infrastructure) and "service projects" (containing application resources). This separation ensures that networking remains under centralized control while allowing application teams to operate independently.

### Key Concepts/Deep Dive
**Host Project Characteristics:**
- Contains all VPCs, subnets, firewall rules, routes, and NAT configurations
- Dedicated to networking management only
- No VMs, GKE clusters, or application resources should be deployed here
- Managed by network engineering teams with specialized certifications

**Service Project Characteristics:**
- Cannot contain VPC infrastructure after attaching to shared VPC
- Can deploy VMs, GKE clusters, and other resources using shared subnets
- Can contain serverless resources (Cloud Run, Cloud Functions, etc.) without any networking
- Managed by application development teams

### Lab Demo: Setting Up Host and Service Projects

1. Create a host project with required APIs enabled:
```bash
gcloud projects create shared-vpc-host --name="Shared VPC Host"
gcloud services enable compute.googleapis.com --project=shared-vpc-host
gcloud services enable container.googleapis.com --project=shared-vpc-host
```

2. Create service projects:
```bash
gcloud projects create service-project-a --name="Service Project A"
gcloud projects create service-project-b --name="Service Project B"
```

3. Enable compute engine APIs in service projects:
```bash
gcloud services enable compute.googleapis.com --project=service-project-a
gcloud services enable compute.googleapis.com --project=service-project-b
```

4. Create custom VPC in host project:
```bash
gcloud compute networks create shared-vpc-host-network \
  --subnet-mode=custom \
  --project=shared-vpc-host
```

5. Create subnets in host project:
```bash
gcloud compute networks subnets create us-central1-subnet \
  --network=shared-vpc-host-network \
  --region=us-central1 \
  --range=10.0.1.0/24 \
  --project=shared-vpc-host

gcloud compute networks subnets create europe-west1-subnet \
  --network=shared-vpc-host-network \
  --region=europe-west1 \
  --range=10.0.2.0/24 \
  --project=shared-vpc-host
```

### Expert Insight: Project Separation Best Practices
- Host projects should remain network-only; use org policies to prevent VM creation
- Service projects should not create VPCs; automation should detect and flag such attempts
- Use service accounts carefully - compute network user role allows subnet access but not creation

## Enabling Shared VPC

### Overview
To enable Shared VPC, the host project must have the appropriate IAM permissions and be configured for shared networking. This is a one-time setup that allows subnet sharing across projects.

### Key Concepts/Deep Dive
**IAM Requirements for Host Project:**
- `compute.organizationAdmin` role at org level for initial setup
- `compute.sharedVpcHost` role for ongoing management
- `compute.networkAdmin` role for network configuration

The process involves:
1. Ensuring projects are within the same organization node
2. Granting necessary IAM roles at appropriate levels
3. Enabling Shared VPC functionality in the host project
4. Attaching service projects to the host

### Lab Demo: Enabling Shared VPC

```bash
# Grant shared VPC admin role at org level (if not already granted)
gcloud organizations add-iam-policy-binding [ORG_ID] \
  --member=user:[ADMIN_EMAIL] \
  --role=roles/compute.sharedVpcAdmin

# Enable Shared VPC in host project (requires host project context)
gcloud services enable compute.googleapis.com --project=shared-vpc-host
# In GCP Console: Navigation → VPC → Shared VPC → Enable

# Attach service projects (requires host project context)
gcloud compute shared-vpc enable [HOST_PROJECT_ID] --project=[HOST_PROJECT_ID]
gcloud compute shared-vpc associated-projects add service-project-a --host-project=shared-vpc-host
gcloud compute shared-vpc associated-projects add service-project-b --host-project=shared-vpc-host
```

### Common Pitfalls
- Attempting to enable Shared VPC in projects not under an org node (results in error)
- Insufficient IAM permissions (leads to permission errors)
- Trying to use standalone projects instead of organization-managed projects

## Creating Resources in Service Projects

### Overview
Once Shared VPC is configured, service projects can create VMs and other network-dependent resources using shared subnets, while maintaining full isolation for serverless resources.

### Key Concepts/Deep Dive
**Available Subnets in Service Projects:**
- Only explicitly shared subnets appear in the interface
- Subnets maintain the same properties (regions, IP ranges, etc.)
- Resources inherit host project's networking policies
- Firewall rules must still be managed in the host project

### Lab Demo: Creating VMs in Service Projects

```bash
# Grant compute network user role to users in service project
gcloud projects add-iam-policy-binding service-project-a \
  --member=user:[USER_EMAIL] \
  --role=roles/compute.networkUser

# Switch to service project and create VM using shared subnet
gcloud config set project service-project-a
gcloud compute instances create shared-vm \
  --zone=us-central1-a \
  --subnet=projects/shared-vpc-host/regions/us-central1/subnetworks/us-central1-subnet \
  --network-tier=PREMIUM \
  --no-address \
  --service-account=[SERVICE_ACCOUNT] \
  --scopes=cloud-platform
```

### Demo: Cloud SQL Without Networking
```bash
# Create Cloud SQL instance with public IP (no VPC required)
gcloud sql instances create cloudsql-public \
  --database-version=MYSQL_8_0 \
  --tier=db-f1-micro \
  --region=us-central1 \
  --project=service-project-a \
  --authorized-networks=0.0.0.0/0  # For demo only - restrict in production
```

### Expert Insight: Resource Allocation in Shared Environments
- Use consistent naming conventions across service projects
- Implement tagging strategies for cost allocation and monitoring
- Monitor shared subnet IP utilization to prevent exhaustion
- Use org policies to enforce service account usage

## Firewall Rules in Shared VPC

### Overview
Firewall rules in Shared VPC must be created in the host project since service projects don't contain VPC infrastructure. This ensures centralized security policy management.

### Key Concepts/Deep Dive
**Firewall Rule Scope:**
- Rules apply to all resources using the shared network
- Target by service account for granular control
- Source IPs can be restricted to GCP services (e.g., health checks)
- EGRESS and INGRESS rules follow standard GCP practices

**Best Practices:**
- Use service accounts instead of tags for targeting
- Restrict sources explicitly (avoid 0.0.0.0/0)
- Apply principle of least privilege

### Lab Demo: Firewall Rules for SSH and Health Checks

```bash
# Create SSH firewall rule for specific service account
gcloud compute firewall-rules create allow-ssh-from-service-account \
  --network=shared-vpc-host-network \
  --allow=tcp:22 \
  --source-ranges=35.235.240.0/20 \
  --target-service-accounts=[VM_SERVICE_ACCOUNT] \
  --project=shared-vpc-host

# Create health check firewall rule for load balancers
gcloud compute firewall-rules create allow-health-checks \
  --network=shared-vpc-host-network \
  --allow=tcp:80 \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-service-accounts=[VM_SERVICE_ACCOUNT] \
  --project=shared-vpc-host
```

### Demo: Testing Firewall Connectivity
```bash
# Test connectivity between VMs in different projects using ping
gcloud compute ssh shared-vm --zone=us-central1-a --project=service-project-a
ping [IP_OF_VM_IN_OTHER_PROJECT]
```

### Common Pitfalls
- Creating firewall rules in service projects (not possible)
- Using overly permissive source ranges
- Forgetting to update firewall rules when changing architectures

## NAT for Outbound Access

### Overview
Cloud NAT enables VMs with internal-only IP addresses to access the internet for updates, package installations, and other outbound connectivity needs without requiring external IPs.

### Key Concepts/Deep Dive
**NAT Components:**
- **Router**: Contains NAT configuration and BGP routing
- **NAT Gateway**: Performs address translation
- **Cloud Router**: Manages BGP sessions with external networks

**Requirements for Internet Access:**
- Default internet gateway (always active)
- EGRESS firewall rules (default: allow all)
- NAT configuration for outbound translation

### Lab Demo: Creating NAT Gateway

```yaml
# NAT configuration using Terraform (recommended approach)
resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = google_compute_network.shared_vpc.self_link
  region  = "us-central1"
  project = "shared-vpc-host"
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "nat-gateway"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
```

### Demo: VM Startup Script with NAT
```yaml
# VM with startup script for nginx installation
resource "google_compute_instance" "web_server" {
  name         = "nginx-server"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = "projects/shared-vpc-host/regions/us-central1/subnetworks/us-central1-subnet"
  }

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF
}
```

### Expert Insight: NAT vs External IPs
- NAT provides secure outbound access without inbound attack surface
- Use external IPs only when absolutely necessary
- Monitor NAT usage for security and cost analysis
- Combine NAT with VPC Service Controls for additional isolation

## GKE on Shared VPC

### Overview
Kubernetes Engine clusters can be deployed in service projects using shared VPC subnets, enabling containerized applications to run in centralized networking environments.

### Key Concepts/Deep Dive
**GKE-Specific Requirements:**
- Secondary IP ranges for Pods and Services
- Private clusters for security (internal-only node IPs)
- Managed service networking or custom secondary ranges
- Host project manages all networking; service project manages clusters

### Lab Demo: GKE Cluster in Shared VPC

```bash
# Add secondary ranges to shared subnet (in host project)
gcloud compute networks subnets update us-central1-subnet \
  --region=us-central1 \
  --add-secondary-ranges=pods=10.0.32.0/24,services=10.0.33.0/24 \
  --project=shared-vpc-host

# Create private GKE cluster in service project
gcloud container clusters create private-cluster \
  --project=service-project-a \
  --zone=us-central1-a \
  --network=projects/shared-vpc-host/global/networks/shared-vpc-host-network \
  --subnetwork=projects/shared-vpc-host/regions/us-central1/subnetworks/us-central1-subnet \
  --enable-private-nodes \
  --private-cluster \
  --master-ipv4-cidr=172.16.0.0/28 \
  --enable-ip-alias \
  --cluster-secondary-range-name=pods \
  --services-secondary-range-name=services \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=3 \
  --num-nodes=1
```

### Demo: GKE Autogenerated Firewall Rules
GKE automatically creates firewall rules in the host project prefixed with "gke-":
```yaml
# Example autogenerated rules (read-only)
gke-private-cluster-12345678-all: ALLOW all from 10.0.32.0/24 to 10.0.32.0/24
gke-private-cluster-12345678-node-hc: ALLOW TCP:10256 from 130.211.0.0/22 to 10.0.1.0/24 (health checks)
```

> [!WARNING]
> Never modify or delete GKE autogenerated firewall rules. Any changes may be reverted by GKE or cause cluster instability.

### Common Pitfalls
- Forgetting to configure secondary IP ranges
- Using public clusters in shared VPC (defeats security benefits)
- Insufficient permissions for GKE service agents

## Load Balancing with Internal IPs

### Overview
Load balancers can expose applications running on VMs with internal IPs by routing traffic through external or internal load balancers, with all networking controlled from the host project.

### Key Concepts/Deep Dive
**Components:**
- Internal-only VMs deployed in service projects
- Load balancers managed in service projects but dependent on host project networking
- Health checks requiring firewall rules in host project
- NAT for outbound internet access during setup

### Lab Demo: Load Balancer with Internal VM Backend

```yaml
# Create instance group (service project)
resource "google_compute_instance_group" "web_servers" {
  name      = "web-server-group"
  zone      = "us-central1-a"
  instances = [google_compute_instance.web_server.self_link]
  named_port {
    name = "http"
    port = 80
  }
  project = "service-project-a"
}

# Create HTTP load balancer (service project)
resource "google_compute_global_address" "lb_ip" {
  name    = "web-lb-ip"
  project = "service-project-a"
}

resource "google_compute_global_forwarding_rule" "lb_frontend" {
  name       = "web-lb-frontend"
  target     = google_compute_target_http_proxy.lb_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.lb_ip.address
  project    = "service-project-a"
}

# Backend service with health checks
resource "google_compute_backend_service" "web_backend" {
  name      = "web-backend"
  port_name = "http"
  protocol  = "HTTP"
  
  backend {
    group = google_compute_instance_group.web_servers.self_link
  }

  health_checks = [google_compute_http_health_check.web_hc.self_link]
  project       = "service-project-a"
}

resource "google_compute_http_health_check" "web_hc" {
  name               = "web-health-check"
  request_path       = "/"
  port               = 80
  check_interval_sec = 10
  timeout_sec        = 5
  unhealthy_threshold = 3
  project            = "service-project-a"
}

# Firewall rule for health checks (host project) - critical step
resource "google_compute_firewall" "health_check_firewall" {
  name    = "allow-health-checks"
  network = google_compute_network.shared_vpc.self_link
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]  # GCP health check ranges
  target_service_accounts = [google_service_account.vm_service_account.email]
  project = "shared-vpc-host"
}
```

### Expert Insight: Load Balancing Best Practices
- Use internal load balancers for service-to-service communication
- Implement proper health checks to prevent routing to unhealthy instances
- Monitor load balancer metrics for performance optimization
- Use Cloud Armor for DDOS protection at the load balancer level

## Limitations and Drawbacks

### Overview
While Shared VPC provides excellent centralized control, it introduces dependencies on network engineering teams and has certain limitations that organizations must consider.

### Key Concepts/Deep Dive
**Key Limitations:**
- **Service Project Limit**: Up to 100 service projects per host project
- **Host Project Limit**: Up to 100 host projects per organization
- **Single Host Connection**: Service projects can attach to only one host project
- **Dependency Issues**: All networking changes require host project access

**Drawbacks:**
- Single point of failure for networking team availability
- Latency in implementing networking changes
- Complex approval processes for firewall rule modifications
- Reduced agility for application teams

### Comparison: Shared VPC vs Decentralized Networking

| Aspect | Shared VPC | Decentralized (VPC Peering) |
|--------|------------|-----------------------------|
| Control | Centralized | Distributed |
| Setup Complexity | High initial setup | Per-project setup |
| Firewall Management | Centralized | Distributed |
| Team Dependencies | High | Low |
| Scalability | High (100 projects) | Very high |
| Flexibility | Moderate | High |
| Cost | Lower VPN costs | Higher peering costs |

> [!NOTE]
> Shared VPC is ideal for enterprises requiring strict network governance, while decentralized approaches suit environments needing maximum team autonomy.

### Lesser Known Things About Shared VPC
- Subnet sharing is all-or-nothing; you cannot share individual IP ranges
- Load balancer IPs are allocated from GCP pools, not from shared subnets
- Kubernetes cluster upgrades may require temporary additional firewall rules
- Cross-project service account delegation enables automated resource creation
- Org policies can force internal-only VMs across shared VPCs

## Summary

### Key Takeaways
```diff
+ Shared VPC enables centralized network management with decentralized resource deployment
+ Host projects manage all networking infrastructure while service projects consume shared subnets
+ Many GCP services operate without VPC requirements, reducing networking complexity
+ NAT provides secure outbound internet access for VMs with internal IPs
+ GKE clusters in shared VPC automatically generate required firewall rules in host projects
+ Load balancers can expose applications on internal-only VMs through proper health check configuration
- All firewall rules must be created in host projects, creating dependencies on network teams
- Service projects can attach to only one host project
- Shared VPC setup requires organization-level IAM permissions
```

### Expert Insight

**Real-world Application**: Shared VPC is commonly used in regulated industries (finance, healthcare) where network engineering teams maintain strict security controls while application teams rapidly deploy services. For example, a bank's network team manages firewall rules and connectivity, while development teams deploy microservices across shared subnets without touching networking.

**Expert Path**: 
- Master IAM roles and org policies for Shared VPC governance
- Learn Terraform/Terraform for automated Shared VPC setup
- Understand cross-project service account delegation patterns
- Study VPC peering for hybrid decentralized-centralized models
- Gain expertise in Cloud NAT and load balancer configurations
- Explore VPC Service Controls integration with Shared VPC

**Common Pitfalls**:
- Insufficient IAM planning leading to permission errors during setup
- Forgetting health check firewall rules when configuring load balancers
- Mixing local VPCs in service projects with shared VPC (causes routing conflicts)
- Network team bottlenecks causing delays in firewall rule approvals
- Underestimating secondary IP range requirements for GKE pod networking
- Assuming all resources can be created without networking verification
- Resolution: Implement automated IAM management and document approval processes

**Common Issues and Resolution**:
- VM creation failures: Check subnet sharing and IAM compute.networkUser role assignment
- Firewall rule ineffectiveness: Ensure rules target correct service accounts or tags
- Health check failures: Verify GCP health check IP ranges in firewall rules
- GKE pod networking issues: Confirm secondary IP ranges are properly configured
- NAT access problems: Check default internet gateway and EGRESS rules are enabled

**Lesser Known Things About This Topic**:
- Load balancer external IPs don't consume shared subnet IP ranges
- Shared VPC enables seamless multi-project Kubernetes networking without complex peering
- Service project owners can create resources in any shared subnet if they have proper IAM access
- NAT gateways can be restricted to specific subnets for cost control
- GKE service accounts automatically receive network permissions in shared VPC setups
- Organization policies cascade to shared VPC resources
- Cross-regional shared VPC is possible but requires careful planning for global applications
- Audit logs capture all shared VPC access across projects
- Service project deletion doesn't automatically clean up host project resources
- Private Google Access works differently in shared VPC environments
- F5 BIG-IP and other network appliances can leverage multiple NICs in shared VPC

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
