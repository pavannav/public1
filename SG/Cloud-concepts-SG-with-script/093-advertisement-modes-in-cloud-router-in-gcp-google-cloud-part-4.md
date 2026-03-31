# Session 4: Advertisement Modes in Cloud Router in GCP

## Table of Contents
- [Advertisement Routes](#advertisement-routes)
  - [Overview](#overview)
  - [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Code/Config Blocks](#codeconfig-blocks)
  - [Lab Demos](#lab-demos)
- [Summary](#summary)

## Advertisement Routes

### Overview
Advertisement routes are BGP prefixes that a Cloud Router advertises to its BGP peers. When you advertise specific subnet ranges, it enables systems in on-premises networks or other cloud environments (including other cloud providers like AWS) to reach resources within your Google Cloud Platform (GCP) Virtual Private Cloud (VPC) network. The advertisement process involves BGP (Border Gateway Protocol) and uses metrics like MED (Multi Exit Discriminator) to influence path selection.

For instance, if you have a subnet in your VPC and want to make it accessible to a peer router, you advertise that subnet. This allows packet routing from on-premises systems or VMs to your GCP resources through established VPN tunnels or interconnects.

### Key Concepts and Deep Dive

- **BGP Advertisement Basics**:
  - Routes are advertised from Cloud Router to BGP peers
  - Allows bidirectional communication between GCP VPC and peer networks
  - Each advertised prefix uses an MED value for path preference

- **MED (Multi Exit Discriminator)**:
  - Also known as metric "M" in GCP documentation
  - Determines primary vs. secondary paths between multiple tunnels
  - Lower MED values indicate preferred paths
  - Example: Two tunnels with different bandwidths - higher bandwidth tunnel gets lower MED for primary traffic

- **Advertisement Mode Configuration**:
  - Configurable at two levels:
    - **Cloud Router level**: Affects all BGP sessions associated with that router
    - **BGP Session level**: Allows per-session customization, overriding router-level settings
  
- **Default Advertisement Mode**:
  - Advertises all local subnet ranges based on VPC type:
    - **Regional VPC**: Only subnets in the same region as the Cloud Router are advertised
    - **Global VPC**: All subnets across all regions are advertised
  - No manual configuration required for basic use cases

- **Custom Advertisement Mode**:
  - Provides granular control over advertised IP prefixes
  - Two main approaches:
    - **Local subnets + custom ranges**: Advertise all local subnets plus additional custom IP ranges
    - **Custom ranges only**: Advertise only specified custom ranges, excluding local subnets by default
  - Supports IP summarization to reduce route table size and avoid quota limits
  - Useful for organizations with complex networking requirements

- **VPC Peering Integration**:
  - Custom advertisement modes are essential when advertising VPC peering routes
  - Cloud Router doesn't automatically advertise peering routes
  - Requires explicit custom route configuration
  - Enables traffic flow between peered VPCs through VPN tunnels

- **Traffic Segregation**:
  - Different BGP sessions can advertise different subnet ranges
  - Enables network engineering decisions like:
    - Routing critical traffic through high-bandwidth connections
    - Using cost-effective paths for non-critical traffic (e.g., VPN tunnels for secondary traffic)
    - Load balancing across multiple links

### Code/Config Blocks

```yaml
# Example custom IP range advertisement
advertised-routes:
  - description: "Custom subnet range"
    range: "10.160.0.0/20"
    med: 100  # MED value for path preference
```

### Lab Demos

#### **Demo 1: VPC Peering and Custom Route Advertisement at Cloud Router Level**

1. **Setup VPC Peering**:
   - Create VPC peering between two VPC networks in the same project
   - Configure export/import custom routes on both sides
   - Create VMs in different VPCs to test connectivity

2. **Configure Cloud Router**:
   - Navigate to Cloud Router in Google Cloud Console
   - Edit advertisement settings
   - Change from "Default" to custom mode
   - Add custom IP ranges (e.g., peered VPC subnets)
   - Save configuration

3. **Test Connectivity**:
   - Attempt to ping VMs across peered networks
   - Verify route table entries are created via VPC peering and advertised routes
   - Check Cloud Router's "Advertise and learn routes" section to confirm custom ranges are displayed

4. **Validation**:
   - Initial ping may fail without custom advertisement (one-way traffic)
   - After adding custom routes, ping succeeds due to return path advertisement
   - Traffic flows bidirectionally through the configured routes

#### **Demo 2: Per-BGP Session Advertisement Configuration**

1. **Configure First BGP Session**:
   - Navigate to individual BGP session within Cloud Router
   - Edit session settings and select "Use custom advertisement"
   - Add specific custom IP ranges (e.g., "10.10.1.0/24" and "10.10.2.0/24")
   - Set MED values if needed for path preference

2. **Configure Second BGP Session**:
   - Edit the second BGP session
   - Override with custom advertisement
   - Add different custom IP ranges (e.g., "10.10.11.0/24")
   - Ensure different subnet ranges per session

3. **Verify Advertisement Differences**:
   - Check Cloud Router's session-specific advertisement views
   - First session shows two custom ranges
   - Second session shows one specific range

4. **Traffic Testing and Logging**:
   - Create VMs in subnets matching advertised ranges
   - Test connectivity using ping from source VMs
   - Examine Cloud Logging to verify correct tunnel usage:
     - Traffic to first session's subnets uses "Second Project First Tunnel"
     - Traffic to second session's subnets uses "Second Project Second Tunnel"
   - Confirm network traffic segregation based on advertisement configuration

## Summary

### Key Takeaways

```diff
+ Cloud Router advertisement modes control which subnet ranges are shared with BGP peers

+ Default mode automatically advertises local subnets based on VPC type (regional vs global)

+ Custom mode provides granular control, allowing summarization and selective route sharing

+ BGP session-level advertisement can override router-level settings for per-session customization

+ VPC peering routes require explicit custom advertisement configuration

+ MED values influence traffic path selection across multiple available connections

+ Proper advertisement configuration enables traffic segregation for network engineering requirements

! Without return path advertisement, one-way traffic may fail even with established tunnels

! Custom modes don't inherit local subnet advertisements unless explicitly configured to do so
```

### Expert Insight

**Real-world Application**: Use advertisement modes for multi-cloud connectivity and hybrid cloud architectures. For example, advertise specific subnets to on-premises data centers via Cloud Interconnect while using VPN tunnels for backup connectivity with cost optimization.

**Expert Path**: Master MED configuration for traffic engineering across multiple cloud interconnects and VPN tunnels. Understand BGP route reflectors and communities for advanced route filtering and policy implementation.

**Common Pitfalls**:
- Forgetting to configure return path advertisement in peered VPC scenarios, causing one-way traffic issues
- Exceeding BGP quota limits by advertising too many granular subnets instead of using summarization in custom modes
- Misconfiguring session-level advertisement modes, expecting inheritance from router-level settings when custom session modes break this relationship
- Not setting appropriate MED values, leading to suboptimal routing across expensive or low-bandwidth connections
- Assuming global VPC advertisement works automatically without verifying regional constraints
- Ignoring that custom advertisement modes at session level don't automatically include local subnet ranges unless explicitly added

**Lesser Known Things**: Advertisement modes can be combined with BGP route policies for dynamic route filtering based on tags, regions, or priority levels. Custom advertisement supports both IPv4 and IPv6 ranges, and you can use Cloud Router's API for programmatic advertisement management in automation scenarios.

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
