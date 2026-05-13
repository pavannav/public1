# Section 19: What is a DNS

<details open>
<summary><b>Section 19: What is a DNS (KK-CS45-script-v2)</b></summary>

## Table of Contents
1. [What is a DNS](#what-is-a-dns)
2. [Route 53 Overview](#route-53-overview)
3. [Route 53 - Registering a domain](#route-53---registering-a-domain)
4. [Route 53 - Creating our first records](#route-53---creating-our-first-records)
5. [Route 53 - EC2 Setup](#route-53---ec2-setup)
6. [Route 53 - TTL](#route-53---ttl)
7. [Route 53 CNAME vs Alias](#route-53-cname-vs-alias)
8. [Routing Policy - Simple](#routing-policy---simple)
9. [Routing Policy - Weighted](#routing-policy---weighted)
10. [Routing Policy - Weighted](#routing-policy---weighted-1)
11. [Route 53 - Health Checks](#route-53---health-checks)
12. [Route 53 - Health Checks Hands On](#route-53---health-checks-hands-on)
13. [Routing Policy - Failover](#routing-policy---failover)
14. [Routing Policy - Geolocation](#routing-policy---geolocation)
15. [Routing Policy - Geoproximity](#routing-policy---geoproximity)
16. [Routing Policy - Traffic Flow & Geoproximity Hands On](#routing-policy---traffic-flow--geoproximity-hands-on)
17. [Routing Policy - IP-based](#routing-policy---ip-based)
18. [Routing Policy - Multi Value](#routing-policy---multi-value)
19. [3rd Party Domains & Route 53](#3rd-party-domains--route-53)
20. [DNS Migration in Route 53](#dns-migration-in-route-53)
21. [Common Route 53 scenarios](#common-route-53-scenarios)
22. [Route 53 - Subdomain Zones](#route-53---subdomain-zones)
23. [Route 53 - DNSSEC](#route-53---dnssec)
24. [Route 53 Resolvers & Hybrid DNS](#route-53-resolvers--hybrid-dns)
25. [Hands On- Route53 Resolvers - Part 1 - Setting up VPN](#hands-on--route53-resolvers---part-1---setting-up-vpn)
26. [Hands On- Route53 Resolvers - Part 2 - DNS configuration](#hands-on--route53-resolvers---part-2---dns-configuration)
27. [Hands On- Route53 Resolvers - Part 3 - Resolver endpoints](#hands-on--route53-resolvers---part-3---resolver-endpoints)
28. [Route 53 Logging](#route-53-logging)
29. [Route 53 DNS Firewall](#route-53-dns-firewall)
30. [Solution Architectures for DNS](#solution-architectures-for-dns)
31. [Route 53 - Cleanup](#route-53---cleanup)

## What is a DNS

**Overview**: This lecture introduces the fundamental concepts of DNS (Domain Name System), explaining how it translates human-friendly hostnames into machine-readable IP addresses, and sets the foundation for understanding Route 53.

**Key Concepts and Deep Dive**:
- **DNS Fundamentals**: DNS translates human-friendly hostnames (e.g., www.google.com) into IP addresses that computers can use. It's the backbone of the internet, enabling hostname resolution.
- **Hierarchical Naming Structure**: Domain names follow a hierarchy with Top Level Domains (TLDs) like .com/.us/.gov, Second Level Domains (example.com), and subdomains (www.example.com).
- **FQDN (Fully Qualified Domain Name)**: A complete domain name that specifies an exact location in the DNS hierarchy. Examples include protocols, domains, and subdomains.
- **DNS Resolution Process**: Clients query local DNS servers, which recursively resolve through root servers, TLD servers, and authoritative name servers to find the IP address.
- **DNS Components**:
  - **Domain Registrar**: Where you register domain names (e.g., Amazon Route 53, GoDaddy).
  - **Zone Files**: Files containing DNS records for a domain.
  - **Name Servers**: Servers that resolve DNS queries.
  - **Record Types**: A (IPv4), AAAA (IPv6), CNAME, NS, etc.
- **DNS Query Flow**: Illustrates the step-by-step resolution process from client to authoritative name servers.

**Labs/Demos**:
- Demonstrates hostname-to-IP resolution for www.google.com
- Explains domain hierarchies with examples like api.www.example.com

## Route 53 Overview

**Overview**: Introduces Amazon Route 53 as AWS's managed DNS service, covering key features like record types, hosted zones, and DNS record management.

**Key Concepts and Deep Dive**:
- **Route 53 Features**:
  - Highly available, scalable, fully managed and authoritative DNS
  - Authoritative means full control over DNS records for registered domains
  - 100% availability SLA (only AWS service with this)
  - Supports domain registration
  - Integrates with AWS resources for health checks

- **DNS Record Types**:
  - **A Record**: Maps hostname to IPv4 address
  - **AAAA Record**: Maps hostname to IPv6 address
  - **CNAME Record**: Maps hostname to another hostname (cannot point to zone apex)
  - **NS Record**: Name servers for hosted zones

- **Hosted Zones**:
  - **Public Hosted Zones**: Resolve queries from internet clients for public domain names
  - **Private Hosted Zones**: Resolve queries only within associated VPCs for private domains
  - Cost: $0.50/month per hosted zone regardless of record count

- **Record Components**:
  - Domain/Subdomain name
  - Record type
  - Value
  - Routing policy
  - TTL (Time To Live)

- **Use Cases**: Mapping EC2 instances or other AWS/public resources to domain names for reliable access.

**Labs/Demos**:
- Example routing client requests through Route 53 to EC2 instances
- Public vs. private hosted zone comparisons

## Route 53 - Registering a domain

**Overview**: Walks through the process of registering a domain name through Route 53, including console navigation and cost implications.

**Key Concepts and Deep Dive**:
- **Domain Registration Steps**:
  1. Access Route 53 console and navigate to "Register domains"
  2. Select desired domain name (costs vary, typically $12-$15/year)
  3. Configure auto-renewal settings (recommended to enable)
  4. Enter registrant information and enable privacy protection
  5. Review and submit order

- **Post-Registration Setup**:
  - Default NS and SOA records are automatically created
  - Route 53 becomes the authoritative DNS for the domain
  - Hosting zone is created with domain as the zone name

- **Cost Considerations**:
  - Domain registration: Variable (e.g., $13/year)
  - Hosted zone: $0.50/month
  - Total free tier does not cover domain costs

**Labs/Demos**:
- Step-by-step domain registration for "stefanetheteacher.com"
- Verification of created NS and SOA records in hosted zone

## Route 53 - Creating our first records

**Overview**: Demonstrates creating basic DNS records (A records) in Route 53 and verifying resolution using dig and nslookup.

**Key Concepts and Deep Dive**:
- **Record Creation Process**:
  1. Navigate to hosted zone in Route 53 console
  2. Click "Create record"
  3. Specify record name, type (A), value (IP address), TTL
  4. Set routing policy and create

- **DNS Resolution Tools**:
  - **nslookup**: Simple DNS lookup tool
  - **dig**: Detailed DNS query tool showing TTL, query time, and more
  - Both can be run from AWS CloudShell or local terminal

- **Record Properties**:
  - Default TTL: 300 seconds (5 minutes)
  - Simple routing: Basic round-robin or single value

- **Verification**: Records become active immediately, allowing browser/terminal access to verify resolution.

**Labs/Demos**:
- Creating A record for "test.stephanetheteacher.com" pointing to dummy IP
- Using nslookup and dig to verify DNS resolution
- Explaining TTL behavior and record caching

## Route 53 - EC2 Setup

**Overview**: Prepares EC2 instances across multiple regions for Route 53 labs, including instance creation, user data scripts, and Application Load Balancer setup.

**Key Concepts and Deep Dive**:
- **Multi-Region EC2 Setup**:
  - Launch identical EC2 instances in Frankfurt (eu-central-1), N.Virginia (us-east-1), Singapore (ap-southeast-1)
  - Use Amazon Linux 2, t2.micro, HTTP security group (port 80)
  - Bootstrap script identifies AZ and region

- **User Data Script**:
  ```bash
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  echo "<h1>Hello World from $(hostname -f) in $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</h1>" > /var/www/html/index.html
  ```

- **Application Load Balancer**:
  - Internet-facing ALB in eu-central-1
  - Target group with EC2 instances (health checks enabled)
  - DNS name for load balanced access

**Labs/Demos**:
- Instance creation across regions with unique identifiers
- ALB setup with cross-AZ distribution
- Verification of HTTP responses showing different AZs/regions

## Route 53 - TTL

**Overview**: Explains Time To Live (TTL) and its impact on DNS caching and record update times, with hands-on demonstration of cache behavior.

**Key Concepts and Deep Dive**:
- **TTL Definition**: Amount of time (seconds) client DNS resolvers cache DNS records before re-querying
- **TTL Trade-offs**:
  - **Low TTL (e.g., 60s)**: Quick updates, high Route 53 query volume (higher cost)
  - **High TTL (e.g., 24h)**: Slow updates, low query volume (cost-effective)

- **Real-World Strategy**:
  1. Reduce TTL before planned changes (24 hours ahead)
  2. Update records after TTL reduction
  3. Allow global cache flush over old TTL period
  4. Restore original high TTL

- **Cache Behavior Demonstration**: Shows how records remain cached despite Route 53 changes until TTL expires.

**Labs/Demos**:
- Creating A record with 120-second TTL for EC2 instance
- Real-time cache verification using dig showing TTL countdown
- Updating record value and proving cache resistance

## Route 53 CNAME vs Alias

**Overview**: Compares CNAME and Alias records, demonstrating alias record advantages for AWS integration and zone apex usage.

**Key Concepts and Deep Dive**:
- **CNAME Records**:
  - Map hostname to another hostname
  - Cannot use for zone apex (root domain like example.com)
  - For non-root domains (e.g., www.example.com)

- **Alias Records**:
  - AWS-specific extension of DNS functionality
  - Can map to AWS resources directly (ELB, CloudFront, etc.)
  - Can use for zone apex
  - Free and include native health checks
  - TTL set automatically by Route 53

- **Use Cases**: ALB domain mapping to clean URLs without revealing AWS addresses
- **Restrictions**: Cannot create aliases for EC2 DNS names (only public IPs via A records)

**Labs/Demos**:
- CNAME record creation for "myapp.stephanetheteacher.com" pointing to ALB
- Alias record creation for "myalias.stephanetheteacher.com" pointing to ALB
- Browser verification of ALB routing through custom domains
- Zone apex alias demonstration for root domain access

## Routing Policy - Simple

**Overview**: Introduces basic simple routing policy, supporting single resource or multiple values with client-side load balancing.

**Key Concepts and Deep Dive**:
- **Simple Routing Characteristics**:
  - Routes traffic to single resource or multiple values
  - No health checks
  - Client randomly selects from multiple values (client-side LB)

- **Use Cases**: Basic domain-to-IP mapping, multiple IP failover
- **Limitations**: No policy-based routing or health monitoring

**Labs/Demos**:
- Single IP A record for "simple.stephanetheteacher.com"
- Multi-value A record demonstration with random selection
- Browser refresh showing different regions based on client choice

## Routing Policy - Weighted

**Overview**: Explains weighted routing policy using relative weights to control traffic distribution across multiple resources, ideal for gradual deployments.

**Key Concepts and Deep Dive**:
- **Weighted Routing Mechanics**:
  - Assign relative weights to DNS records
  - Traffic percentage = (record_weight / total_weights) × 100
  - Weights can sum to any number (e.g., 10, 20, 70)

- **Use Cases**:
  - Canary deployments (small percentage of new version)
  - Multi-region load distribution
  - Gradual traffic migration (set weights to 0 for zero traffic)

- **Configuration**:
  - Same name/type, different values and weights
  - Supports health checks
  - Set ID for record identification

**Labs/Demos**:
- Three-record weighted setup: 10% AP-Southeast-1 (weight 10), 20% EU-Central-1 (weight 20), 70% US-East-1 (weight 70)
- dig verification showing client-side distribution effects
- Excluding DNS caching with low TTL (3 seconds) for rapid switching

## Routing Policy - Weighted

**Overview**: (Note: This appears to be a duplicate transcript similar to the previous weighted policy section, covering the same concepts)

**Key Concepts and Deep Dive**:
Same content as previous weighted policy section.

## Route 53 - Health Checks

**Overview**: Introduces Route 53 health checks for endpoint monitoring, covering monitoring types, configurations, and integration with routing policies.

**Key Concepts and Deep Dive**:
- **Health Check Types**:
  - **Endpoint Health Checks**: Monitor public endpoints (HTTP/HTTPS/TCP)
  - **Calculated Health Checks**: Combine multiple health checks with AND/OR/NOT logic
  - **CloudWatch Alarm Health Checks**: Monitor private resources via CloudWatch alarms

- **Endpoint Health Check Configuration**:
  - Protocol: HTTP/HTTPS/TCP
  - IP/domain, port, path
  - Success criteria: 2xx/3xx status codes or string matching in response
  - Interval: 30s (standard) or 10s (fast, higher cost)
  - Threshold: Failure count before health state change (2-3 recommended)

- **Health Checkers**:
  - ~15 globally distributed health checkers
  - Success threshold: >18% healthy for overall health

- **Calculated Health Checks**:
  - Monitor up to 256 child health checks
  - Specify minimum healthy count

- **Private Resource Monitoring**: Use CloudWatch alarms on EC2 metrics (CPU, memory) for health-based routing of VPC-internal resources.

**Labs/Demos**:
- Health checker infrastructure explanations
- IP allowlisting requirements for health checkers (0.0.0.0/0 by default)
- CloudWatch integration for threshold-based alarms

## Route 53 - Health Checks Hands On

**Overview**: Practical implementation of health checks across multiple endpoints with security group manipulation to simulate failures.

**Key Concepts and Deep Dive**:
- **Health Check Creation**:
  - Endpoint monitoring for EC2 instances across regions
  - Monitor /health endpoint (added to user data script)
  - Default 30-second intervals

- **Health Checker IP Ranges**: Access health checkers' IP ranges at docs.aws.amazon.com/Route53/latest/APIReference/API_GetCheckerIpRanges.html

- **Calculated Health Checks**:
  - Combine monitoring rules
  - Child health check aggregation with logic

- **Troubleshooting**: Security group blocking causes timeout/connection failures, visible in CloudWatch logs.

**Labs/Demos**:
- Creating 3 health checks for EC2 instances in different regions
- Blocking port 80 on one instance, observing unhealthy status
- Health check status transitions and error logging

## Routing Policy - Failover

**Overview**: Demonstrates active-passive failover routing using primary/secondary records with health checks to route traffic to healthy resources.

**Key Concepts and Deep Dive**:
- **Failover Routing**:
  - Primary record: Used when healthy
  - Secondary record: Fallback when primary fails
  - Mandatory health check on primary (optional on secondary)

- **Automation**: Automatic routing changes based on health check status without manual intervention.

**Labs/Demos**:
- Primary EU-Central-1 record with EU health check, secondary US-East-1 record
- Simulated failure by removing HTTP from security group
- Automatic traffic switchover with browser verification

## Routing Policy - Geolocation

**Overview**: Enables location-based routing (continent/country/state) for content localization and load balancing by geographic regions.

**Key Concepts and Deep Dive**:
- **Geolocation Routing**:
  - Route based on user location (continent, country, US state)
  - Specify target resources per location
  - Include default record for unmatched locations
  - Supports health checks

- **Use Cases**: Content localization, regulatory compliance, performance optimization
- **Location Hierarchy**: Consecutive checks from most to least specific (US state → US → default)

**Labs/Demos**:
- AP-Southeast marker for Asia traffic
- United States marker for US traffic
- Default EU-Central-1 for remaining traffic
- VPN-based geographic testing for accurate verification

## Routing Policy - Geoproximity

**Overview**: Uses geographic proximity and bias weights to control traffic distribution, shifting traffic between geographic endpoints.

**Key Concepts and Deep Dive**:
- **Geoproximity Routing**:
  - Routes based on user and resource locations
  - Use bias to expand/shrink geographic coverage
  - Positive bias: Expand coverage (more traffic)
  - Negative bias: Shrink coverage (less traffic)
  - Requires latitude/longitude for non-AWS resources

- **Traffic Flow**: Visual geoproximity mapping for traffic distribution
- **Availability Zones**: Major city locations for latency calculations

**Labs/Demos**:
- Zone apex restrictions and API-based adjustments
- Bias value impacts on geographic boundaries and traffic effects

## Routing Policy - Traffic Flow & Geoproximity Hands On

**Overview**: Introduces Traffic Flow for visual, complex routing policy management and demonstrates geoproximity with bias visual mapping.

**Key Concepts and Deep Dive**:
- **Traffic Flow Visual Editor**:
  - Policy-based routing configuration
  - Visual decision trees and endpoint mapping
  - Geoproximity with interactive map
  - Policy versioning and application to hosted zones
  - Cost: $50/month per traffic policy record

- **Geoproximity Visual Mapping**:
  - Real-time bias effect visualization
  - Hemisphere division adjustments
  - AWS region integration and custom coordinates

- **Policy Management**:
  - Edit and deploy new versions
  - RAM sharing across accounts

**Labs/Demos**:
- Multi-endpoint geoproximity routing across Europe, Africa, and Americas
- Bias manipulation from -50 to 50 demonstrating traffic shifts
- Policy creation, deployment, and validation workflow

## Routing Policy - IP-based

**Overview**: Routes traffic based on client IP ranges (CIDRs) for controlled access and performance optimization.

**Key Concepts and Deep Dive**:
- **IP-based Routing**:
  - Define CIDR blocks mapping to specific resources
  - Route entire IP ranges to target endpoints
  - No client-side randomization

- **Use Cases**: ISP optimization, cost management, security controls
- **Configuration**: CIDR-to-resource mapping tables

**Labs/Demos**:
- Dual CIDR block mapping to different EC2 instances
- Client IP-range based endpoint selection

## Routing Policy - Multi Value

**Overview**: Returns multiple healthy resources for client-side load balancing, combining weighted routing with health check verification.

**Key Concepts and Deep Dive**:
- **Multi-Value Routing**:
  - Returns up to 8 healthy resources based on health checks
  - Client-side selection from healthy options
  - Superior to simple routing's lack of health awareness

- **Integration**: Mandatory health checks ensure only operational resources returned.

**Labs/Demos**:
- Three health-checked A records with client selection
- Unhealthy record exclusion demonstration
- String matching triggers in health check configuration

## 3rd Party Domains & Route 53

**Overview**: Explains domain registrar relationships with DNS hosting, enabling cross-provider domain registration and Route 53 DNS management.

**Key Concepts and Deep Dive**:
- **Domain vs DNS Separation**:
  - Register domains anywhere (GoDaddy, Google Domains, etc.)
  - Manage DNS records separately on Route 53

- **Cross-Provider Integration**:
  - Create public hosted zone in Route 53 for any domain
  - Update external registrar's NS records to Route 53 name servers
  - Route 53 becomes authoritative DNS resolver

- **Process**: Hosted zone → Get NS records → Update registrar NS settings → Enable delegation.

**Labs/Demos**:
- Migration scenarios without downtime
- NS record configuration at third-party providers

## DNS Migration in Route 53

**Overview**: Outlines zero-downtime DNS migration from external providers to Route 53, focusing on TTL reduction and phased transitions.

**Key Concepts and Deep Dive**:
- **Migration Steps**:
  1. Extract existing DNS records from current provider
  2. Create Route 53 hosted zone and import/recreate records
  3. Reduce NS TTL to 15 minutes on current provider
  4. Wait minimum 2 days for global cache flush
  5. Update NS records to Route 53 name servers
  6. Monitor query patterns and resolve issues
  7. Increase NS TTL back to default (optional domain transfer)

- **TTL Strategy**: Lower TTL for faster transitions, restore post-migration.
- **Backup Plan**: NS TTL allows quick rollback if issues arise.

**Labs/Demos**:
- Record export and import procedures
- Troubleshooting failed migrations

## Common Route 53 scenarios

**Overview**: Covers typical Route 53 implementations for EC2, ALB, CloudFront, API Gateway, S3, and VPC endpoints with appropriate record types.

**Key Concepts and Deep Dive**:
- **EC2 Integration**:
  - A records for public IPs or CNAMEs for internal DNS names
  - Solve internal/external DNS resolution differences

- **ALB/CloudFront**: Use alias records for direct AWS resource pointing without CNAME restrictions
- **API Gateway/VPC Endpoints**: Alias records for cross-account endpoint routing
- **S3 Static Websites**: Alias records with matching domain name bucket requirements
- **RDS**: CNAME records (aliases not supported for RDS endpoints)

**Labs/Demos**:
- EC2 private/public DNS name resolution differences
- Alias record creation examples for various AWS services
- CNAME vs alias strategic applications

## Route 53 - Subdomain Zones

**Overview**: Demonstrates subdomain delegation using NS records to enable teams-specific DNS management and hierarchical control improvements.

**Key Concepts and Deep Dive**:
- **Subdomain Delegation**:
  - Create separate hosted zones for subdomains (e.g., dev.example.com)
  - NS records delegate resolution to subdomain name servers
  - Most specific record wins in overlapping zones

- **Benefits**: IAM segregation, fine-grained permissions, individual team autonomy
- **Cross-Account Capability**: Delegate subdomains to other AWS accounts
- **Implementation**:
  1. Create subdomain hosted zone
  2. Copy NS records to parent NS record
  3. Enable resolution delegation

**Labs/Demos**:
- sub.stephanetheteacher.com hosted zone creation
- NS record population in parent zone
- DNS resolution verification with dig/nslookup

## Route 53 - DNSSEC

**Overview**: Explains DNS Security Extensions for cryptographic query validation, preventing poisoning and ensuring data integrity with key management.

**Key Concepts and Deep Dive**:
- **DNSSEC Components**:
  - **KSK (Key Signing Key)**: Customer-managed in KMS, highest authority
  - **ZSK (Zone Signing Key)**: Route 53-managed, used for signing
  - **Trust Chain**: Registrar → Parent Zone → Child Zone via DS records

- **DNS Poisoning Prevention**: Cryptographically verify responses through chain-of-trust
- **Limitations**: Public zones only, TTL capped at 1 week
- **Setup Process**: Zone preparation → DNSSEC enablement → KMS key creation → Trust establishment

**Labs/Demos**:
- Trust chain explanations for hierarchical validation
- Key management and signature verification workflows

## Route 53 Resolvers & Hybrid DNS

**Overview**: Covers resolver endpoints for hybrid cloud DNS, enabling cross-network name resolution between AWS VPCs and on-premises networks.

**Key Concepts and Deep Dive**:
- **Resolver Endpoints**:
  - **Inbound Endpoints**: Allow external DNS queries to resolve AWS-hosted domains
  - **Outbound Endpoints**: Forward AWS DNS queries to on-premises resolvers
  - High availability via multi-AZ ENIs with dedicated IPs

- **Hybrid DNS Architecture**:
  - Conditional forwarding rules (domains → target IPs)
  - Forwarding rule types: Domain-specific, NOT overrides, system rules
  - Database Rules: Most specific match wins, RAM-enabled sharing

- **Resolver Rules**:
  - System rules: Handle local AWS names (EC2.internal, etc.)
  - Configurable: Domain forwarding with target resolver IPs

**Labs/Demos**:
- Bidirectional DNS resolution architectures
- Forwarding rule precedence and matching logic
- Cross-account rule sharing with Resource Access Manager

## Hands On- Route53 Resolvers - Part 1 - Setting up VPN

**Overview**: Sets up site-to-site VPN between cloud VPC and simulated on-premises VPC using Libreswan on EC2, preparing hybrid DNS infrastructure.

**Key Concepts and Deep Dive**:
- **VPN Setup Prerequisites**:
  - Cloud VPC (20.0.0.0/16) and on-premises VPC (192.168.0.0/16)
  - Internet gateways and NAT gateways for external access
  - VPC endpoint integration with route tables

- **Libreswan Configuration**:
  - EC2 instance (Amazon Linux 2023) as VPN server
  - Sysctl parameters for IP forwarding and NAT
  - IPSec tunnel establishment with pre-shared keys
  - Static routing for cross-VPC traffic

- **Network Configuration**:
  - Virtual Private Gateway creation and VPC attachment
  - Customer Gateway for on-premises endpoint (VPN server IP)
  - Site-to-site VPN connection linking VGW and CGW

**Labs/Demos**:
- VPC and subnet creation with proper CIDR allocation
- VPN server user data and security group configuration
- Connectivity testing using ping across VPN tunnels

## Hands On- Route53 Resolvers - Part 2 - DNS configuration

**Overview**: Establishes DNS servers on both cloud and on-premises networks using Bind9, configuring domain resolution and service delegation.

**Key Concepts and Deep Dive**:
- **DNS Server Setup**:
  - **On-Premises**: EC2 with Bind9, internal zone (onprem.com), forwarding configuration
  - **Cloud**: Private hosted zone (cloud.com), A records for application servers

- **Bind9 Configuration**:
  - named.conf for zone definitions and forwarders
  - Zone files with SOA/NS records and resource definitions
  - Service startup and status verification

- **Resolution Testing**:
  - Client resolv.conf updates to use local DNS servers
  - nslookup verification for domain resolution
  - DNS service persistence through DHCP modifications

**Labs/Demos**:
- Bind installation and configuration on EC2
- Zone file creation with sample records
- DNS query testing from application servers

## Hands On- Route53 Resolvers - Part 3 - Resolver endpoints

**Overview**: Implements Route 53 resolver endpoints and forwarding rules to enable bidirectional DNS resolution between hybrid network environments.

**Key Concepts and Deep Dive**:
- **Resolver Endpoint Configuration**:
  - **Inbound Endpoints**: ENIs in cloud VPC for external query resolution
  - **Outbound Endpoints**: Forwarding interfaces to on-premises resolvers
  - Security groups allowing DNS traffic on port 53

- **DNS Forwarding Setup**:
  - Rule-based forwarding: onprem.com queries to VPN-based DNS server
  - On-premises DNS configuration updated with cloud resolver IPs
  - Conditional forwarding integration

- **Bidirectional Resolution**:
  - Cloud resources resolve on-premises domains
  - On-premises resources resolve cloud domains
  - End-to-end connectivity verification

**Labs/Demos**:
- Resolver endpoint security group creation
- Forwarding rule deployment and zone rule construction
- Cross-network DNS query testing and troubleshooting

## Route 53 Logging

**Overview**: Describes DNS query logging capabilities for Route 53, covering public record monitoring and private resolver query tracking.

**Key Concepts and Deep Dive**:
- **DNS Query Logging (Public)**:
  - Logs all Route 53 resolver queries for public hosted zones
  - Sent to CloudWatch Logs or S3 via Kinesis Firehose
  - Captures query details: name, type, response, client info

- **Resolver Query Logging (Private)**:
  - Monitors DNS queries from VPC resources and endpoints
  - Includes resolver rules, DNS Firewall, and endpoint queries
  - JSON format with comprehensive metadata
  - Exported to CloudWatch Logs, S3, or Kinesis Data Firehose
  - Shareable across accounts via RAM

**Labs/Demos**:
- CloudWatch metric dimensions and alarm configurations
- Log retention and analysis strategies

## Route 53 DNS Firewall

**Overview**: Introduces managed DNS filtering service for protecting against malicious domains and controlling outbound DNS traffic.

**Key Concepts and Deep Dive**:
- **DNS Firewall Operation**:
  - Filters DNS queries against rule groups
  - Intercept queries for protected domains
  - Actions: Allow, Block, Alert (with responses)

- **Implementation**:
  - VPC association with DNS Firewall rule groups
  - Query evaluation through configured domains
  - Integration with CloudWatch for logging and alerting

- **Configuration Modes**:
  - **Fail-Open**: Allow queries on firewall failure (availability priority)
  - **Fail-Close**: Block queries on firewall failure (security priority)

- **Rule Groups**: Reusable filtering policies for common malware/blocked domains

**Labs/Demos**:
- Rule group creation and domain blocking examples
- Fail-Close vs Fail-Open security model comparisons

## Solution Architectures for DNS

**Overview**: Presents advanced DNS architectures including split-view DNS for internal/external differentiation and multi-account resolver management.

**Key Concepts and Deep Dive**:
- **Split-View DNS**:
  - Identical domain names (e.g., example.com) with separate public/private zones
  - Contextual responses: External users get public resources, internal get private
  - Enables different authentication/content for user types

- **Multi-Account DNS Management**:
  - Centralized resolver rule management in dedicated account
  - RAM-sharing of forwarding rules to account-specific hosted zones
  - Hierarchical subdomain delegation (parent NS records point to child zones)

**Labs/Demos**:
- Split-view domain name resolution examples
- Cross-account resolver rule sharing workflows

## Route 53 - Cleanup

**Overview**: Provides cleanup instructions for Route 53 resources to prevent ongoing costs after lab completion.

**Key Concepts and Deep Dive**:
- **Domain Costs**: $12+/year registration, optional auto-renewal
- **Hosted Zone Costs**: $0.50/month, delete unused zones
- **EC2 Instance Costs**: Terminate unused instances across regions
- **ALB Costs**: Delete load balancers and target groups

**Labs/Demos**:
- Record deletion from hosted zones before zone removal
- Cross-region instance termination
- Cost tracking and resource decommission verification

## Summary

### Key Takeaways
```diff
! DNS backbone translates hostnames to IP addresses hierarchically
+ Route 53 is fully managed, authoritative DNS with 100% SLA
- Public hosted zones for internet, private for VPC-only resolution
+ Alias records enable AWS resource integration without restrictions
! Routing policies control traffic: Simple, Weighted, Failover, etc.
+ Health checks enable automated DNS failover and monitoring
- TTL controls cache duration; lower for quick changes, higher for cost efficiency
+ DNSSEC provides cryptographic verification against poisoning
! Resolver endpoints enable hybrid DNS between AWS and on-premises
- Route 53 logging supports both public and private DNS query tracking
+ DNS Firewall protects against malicious outbound queries
```

### Quick Reference
| Resource | Record Type | AWS Integration | TTL | Restrictions |
|----------|-------------|-----------------|-----|-------------|
| EC2 | A (public IP) | No alias support | Custom | Private IPs require A records |
| ALB/ELB | Alias A/AAAA | Native support | Automatically set | Preferred over CNAME |
| CloudFront | Alias | Required | Automatically set | Must use custom origin |
| S3 Static Sites | Alias | Required, bucket name must match domain | Automatically set | Website hosting required |
| API Gateway | Alias | Lambda integration | Automatically set | Edge/Regional optimization |
| VPC Endpoints | Alias | Private link routing | Automatically set | Local account resources |
| RDS | CNAME | No alias support | Custom | Public IPs not preferred |

### Expert Insight

**Real-world Application**: Route 53 enables global application distribution with intelligent routing. Use geolocation for content localization, weighted routing for canary deployments, and health checks for automated failover. Combine with resolver endpoints for seamless hybrid cloud DNS.

**Expert Path**: Master DNSSEC for security compliance, Traffic Flow visual editor for complex routing rules, and multi-account resolver sharing via RAM. Understand TTL optimization for performance vs. cost trade-offs.

**Common Pitfalls**:
- Using CNAMEs for zone apex instead of aliases
- High TTL blocking rapid DNS changes during incidents
- Forgetting security group rules for health checkers
- Ignoring DNSSEC trust chain requirements for migration

**Lesser-Known Facts**:
- DNS queries use UDP by default for speed; TCP for large responses
- Route 53 health checkers probe from 15+ global locations for accuracy
- Traffic Flow policies cost $50/month regardless of query volume
- Internal DNS resolution differs from external (EC2 DNS names resolve differently)

</details>