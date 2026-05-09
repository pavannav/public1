# Session 55: Storage, Database Exam Questions, Networking Basics, Avoiding Default VPC

**Table of Contents**
- [Exam Questions on Storage and Database](#exam-questions-on-storage-and-database)
- [Basics of Networking](#basics-of-networking)
- [Virtual Private Cloud (VPC) and Avoiding Default VPC](#virtual-private-cloud-vpc-and-avoiding-default-vpc)
- [Summary](#summary)

## Exam Questions on Storage and Database

### Overview
This session covers Google Cloud certification exam questions focused on storage and database scenarios, emphasizing data management strategies like lifecycle policies for cost optimization and compliance. It highlights common pitfalls in choosing storage classes based on access patterns and data retention needs.

### Key Concepts / Deep Dive
- **Cost Optimization with Lifecycle Policies**: For infrequently accessed data with monthly refresh cycles and no need for data older than 5 years, select coldline storage initially and use lifecycle rules to delete old data. Avoid standard or nearline upfront if access is minimal.
- **Security Camera Footage Storage**: Footages involve regular access for analysis (threat detection, object counting). Use multi-regional standard storage for 30 days, then transition to coldline for compliance (90-180 days retention). Ensure retrieval considerations for occasional investigations; coldline provides cost-effective storage with acceptable retrieval costs.
- **Edge Cases with Compliance**: Even with low access, prioritize compliance over cost. Archive storage may incur high early deletion fees if removed before 365 days.
- **Multipart, Stateful VMs, and Enterprise Databases**: Stateless VMs use GCS directly due to no local storage persistence. Enterprise databases (e.g., multi-terabyte) require efficient migration using Transfer Appliance for large volumes, avoiding online transfers due to time/cost. Use Transfer Service for smaller incremental transfers from AWS/other clouds.
- **Client Data Uploads and Sharing**: User uploads to GCS via stateless VMs. Avoid persistent disks for storage unless necessary; they're block storage and may violate compliance if resized (e.g., deletes data beyond capacity). Prefer GCS for global, durable storage with transfer services for replication.

### Code/Config Blocks
```bash
# Sample GSUTIL for transferring data
gsutil mv gs://source-bucket/data gs://dest-bucket/

# Lifecycle Rule Example (YAML for Terraform or gcloud)
lifecycle:
  rule:
  - condition:
      age: 30
    action:
      type: SetStorageClass
      storage_class: COLDLINE
```

### Tables
| Scenario | Recommended Storage Class | Lifecycle Action | Rationale |
|----------|---------------------------|------------------|-----------|
| Monthly access, delete after 5 years | Coldline with lifecycle delete | Delete after 5 years | Optimizes cost for infrequent access |
| Security footage (regular 30 days, retain 90-180 days) | Standard → Coldline | Move to Coldline at 30 days, delete at 180 days | Balances access needs and cost |
| Large enterprise data migration | Transfer Appliance/Service | Autonomous transfer | Handles large volumes efficiently |

### Lab Demos
- **VM Creation Across Regions**: Create VMs in geographically separated regions (e.g., Singapore and US Central). Verify internal IP connectivity via ping. Demo shows global VPC allows routing without external IPs.
- **Disable Firewall Rules**: Illustrate impact of disabling broad rules (e.g., ICMP deny blocks pings). Re-enable for experimentation.

## Basics of Networking

### Overview
Networking fundamentals build on RFC 1918 standards for private IPs, OSI model layers, and Google Workspace integration. These enable secure, scalable cloud architectures by defining TCP/IP protocols, IP ranges, and communication layers.

### Key Concepts / Deep Dive
- **RFC 1918 Standard**: Defines private IP ranges (Class A: 10.0.0.0/8 for 16M IPs; Class B: 172.16.0.0/12 for 1M IPs; Class C: 192.168.0.0/16 for 65K IPs). Used for non-routable internal IPs, essential for secure networking.
- **OSI Model Overview**:
  - Layer 7 (Application): Protocols like HTTP/HTTPS, DNS, SSH.
  - Layer 4 (Transport): TCP/UDP, port numbers (e.g., 22 for SSH, 443 for HTTPS).
  - Layer 3 (Network): IP addressing, routing, VPNs, ping/traceroute.
  - Layers 1-2: Physical/Data Link (MAC addresses, cabling).
- **Google Workspace**: Collaborative suite (Gmail, Drive, Docs) using SAAS model. Integrates with GCP via Service Accounts for secure access to GCS (e.g., uploading data directly).
- **Global Network Advantage**: Google Cloud's private network spans regions globally, enabling free internal communication via RFC 1918 IPs without external IPs. Contrasts with AWS/Azure's regional restrictions requiring VPC peering or VPNs.

### Code/Config Blocks
```bash
# Diagnose IP and test connectivity
ip addr show  # View internal/external IPs
ping <internal-ip>  # Test connectivity (e.g., across regions)

# Google Workspace GCS Integration (pseudo-code)
from google.oauth2 import service_account
credentials = service_account.Credentials.from_service_account_file('key.json')
from google.cloud import storage
client = storage.Client(credentials=credentials)
bucket = client.get_bucket('<bucket-name>')
blob = bucket.blob('<file>')
blob.upload_from_string('<content>')
```

### Tables
| OSI Layer | Purpose | Examples |
|-----------|---------|----------|
| 7 (Application) | User interfaces, protocols | HTTP, FTP, SSH |
| 4 (Transport) | Data transfer with error checking | TCP (reliable), UDP (fast) |
| 3 (Network) | Routing and addressing | IP, Ping, VPN |

### Lab Demos
- **RFC Calculator Demo**: Use online tools (e.g., ipaddressguide.com) to calculate IP ranges and masks.
- **Ping Across Regions**: In default VPC, ping VMs in different regions to demonstrate global routing.

## Virtual Private Cloud (VPC) and Avoiding Default VPC

### Overview
VPCs enable secure, isolated networking in Google Cloud. Default VPCs offer quick starts but suffer from broad subnets, open firewalls, and inflexibility. Custom VPCs with manual subnet creation and restricted firewalls provide control, compliance, and cost optimization.

### Key Concepts / Deep Dive
- **VPC Basics**: Global construct in Google Cloud; enables internal communication without external IPs. Subnets are regional and use RFC 1918 ranges. Firewalls control traffic (implicit deny Ingress, allow Egress).
- **Why Avoid Default VPC***:
  - Broad subnets across all regions (41-42, subject to change).
  - Overly permissive firewalls (allow ICMP/SSH from anywhere, internal open).
  - Fixed Class A ranges (10.x.x.x/20), limiting expansion.
  - Auto-mode adds subnets for new regions automatically.
  - Shared naming (e.g., "default") causes confusion.
  - Quota waste (one of five global VPCs).
  - No IP overlap prevention; hard to delete regions/subnets.
  - Production risks (e.g., SOC compliance violations for unused regions).
- **Best Practices**: Use custom mode; create subnets only in operational regions with unique names/ranges. Enable Org Policy "Skip Default VPC" to prevent creation. Leverage implied firewalls for security.

### Code/Config Blocks
```bash
# Create Custom VPC with Subnets
gcloud compute networks create custom-vpc --subnet-mode=custom
gcloud compute networks subnets create subnet-sg --network=custom-vpc --region=asia-southeast1 --ip-cidr-range=10.5.4.0/29

# Firewall Rules
gcloud compute firewall-rules create allow-internal --network=custom-vpc --allow=tcp,udp,icmp --source-ranges=10.0.0.0/8,172.16.0.0/12,192.168.0.0/16

# Org Policy to Skip Default VPC
gcloud alpha org-policies set-policy --org=gcp-organization-resource-name policies/compute.skip_default_network

# Connect to VM
gcloud compute ssh instance-1 --zone=asia-southeast1-b --network=custom-vpc
```

### Tables
| Aspect | Default VPC | Custom VPC |
|--------|-------------|------------|
| Subnet Mode | Auto (all regions) | Custom (selective regions) |
| IP Ranges | Class A (fixed /20) | Any RFC 1918 (/16 to /29) |
| Firewalls | Broad open rules | Minimal implied + custom |
| Expansion | Auto-adds new regions | Manual, controlled |
| Security | High risk (open rules) | Low risk (restricted) |

Mermaid Flowchart for VPC Creation
```mermaid
flowchart TD
A[Create Custom VPC] --> B[Select Subnet Mode: Custom]
B --> C[Add Subnets to Operational Regions]
C --> D[Define CIDR Ranges (RFC 1918)]
D --> E[Create Minimal Firewall Rules]
E --> F[Test VM Connectivity]
F --> G[Apply Org Policies to Prevent Defaults]
```

### Lab Demos
- **Global Ping Demo**: Create VMs in Singapore/US; ping via internal IPs in custom VPC.
- **Firewall Modification**: Disable default rule; observe ping failure. Re-enable for access.
- **VPC Deletion**: Attempt delete (fails with resources); delete VMs/subnets first.
- **Implied Firewall Impact**: Override defaults; test SSH attempts (fails due to implicit deny).

## Summary

### Key Takeaways
```diff
+ Global VPC enables seamless internal communication without external IPs or VPNs
- Avoid default VPCs due to broad security, compliance, and cost risks
! Firewall rules gate traffic; understand implied denies for security
! RFC 1918 and OSI model are foundational for GCP networking
```

### Quick Reference
- **RFC 1918 Private Ranges**: 10.0.0.0/8 (16M), 172.16.0.0/12 (1M), 192.168.0.0/16 (65K)
- **OSI Key Layers**: 7 (HTTP), 4 (TCP/UDP), 3 (IP/Ping)
- **Custom VPC Commands**:
  - Create: `gcloud compute networks create <name> --subnet-mode=custom`
  - Add Subnet: `gcloud compute networks subnets create <subnet> --network=<vpc> --region=<region> --ip-cidr-range=<cidr>`
  - Firewall: `gcloud compute firewall-rules create allow-internal --network=<vpc> --allow=tcp,udp,icmp --source-ranges=10.0.0.0/8`
- **Org Policy**: Enable `compute.skip_default_network` to prevent defaults

### Expert Insight
#### Real-world Application
In production, custom VPCs isolate environments (e.g., dev/prod via shared VPC). For media companies handling footage, enforce lifecycle rules for compliance/costs. Global networking supports streaming distributions without data transit fees.

#### Expert Path
Master subnetting with CIDR calculators for efficient IP allocation. Dive into VPC Flow Logs for troubleshooting; experiment with IAP for secure admin access. Pursue Professional Cloud Network Engineer cert for advanced topics like interconnects.

#### Common Pitfalls
- Ignoring quota limits; exceeding 5 VPCs wastes resources.
- Over-relying on implied rules; explicit rules prevent misconfigurations.
- Forgetting subnet deletion order; resources block VPC cleanup.
- External IP exposure; use IAP to avoid opening ports globally.
- IP overlaps with on-prem; always use RFC 1918 and test connectivity.

#### Lesser-Known Facts
- Google's network spans 100+ suburbs in 200+ cities; it's the planet's largest SDN.
- Early deletion penalties in archives can exceed storage savings if retention <1 year.
- Workspace Drive storage isn't region-specific; proxy via IAP for secure access.
