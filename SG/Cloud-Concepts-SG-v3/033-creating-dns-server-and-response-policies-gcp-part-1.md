# Session 033: Creating DNS Server and Response Policies in GCP (Part 1)

- [Overview](#overview)
- [Key Concepts: Server Policies](#key-concepts-server-policies)
- [Key Concepts: Alternative Servers](#key-concepts-alternative-servers)
- [Key Concepts: Response Policies](#key-concepts-response-policies)
- [Lab Demo: Creating and Testing Server Policies](#lab-demo-creating-and-testing-server-policies)
- [Lab Demo: Creating and Testing Response Policies](#lab-demo-creating-and-testing-response-policies)
- [Summary](#summary)

## Overview

This session covers the creation and configuration of DNS Server Policies and Response Policies in Google Cloud Platform (GCP). Server Policies manage inbound and outbound DNS query routing, including forwarding and alternative server setups for hybrid cloud environments. Response Policies allow overriding or modifying DNS responses based on specific rules, enabling traffic redirection and domain management. The focus is on practical implementation, with hands-on demos demonstrating policy creation, testing with tools like `nslookup`, and troubleshooting common scenarios. By the end, you'll understand how to ensure secure, efficient DNS resolution across on-premises and cloud networks.

## Key Concepts: Server Policies

Server Policies in Cloud DNS provide granular control over DNS traffic flow. There are three main types of policies you can create:

### Inbound Policies
- **Purpose**: Forward DNS queries from on-premises networks to Google Cloud DNS for resolution.
- **Use Case**: If you have workloads in GCP that need to resolve domains hosted outside GCP, enable inbound forwarding.
- **Configuration**:
  - Specify the on-premises network ranges.
  - GCP reserves an internal IP address for the DNS server in the primary VPC's IP range.
  - This creates entry points for inbound DNS traffic.

### Outbound Policies
- **Purpose**: Allow GCP resources to resolve DNS queries via on-premises DNS servers.
- **Use Case**: Reverse forwarding; ensure on-premises workloads use GCP resources seamlessly.
- **Configuration**:
  - Provide the IP addresses of your on-premises DNS servers.
  - Can be applied to inbound, outbound, or both directions simultaneously.
  - Useful for integrating with existing DNS infrastructure in a VPC.

### Policy Attachement
- Policies can be attached to networks (VPCs).
- Multiple policies can coexist, but ensure no conflicts in configuration.

## Key Concepts: Alternative Servers

Alternative servers enhance DNS resolution by providing fallback options. Cloud DNS supports three types of alternative servers:

1. **Type 1: Internal Google Cloud Network**
   - Internal IP addresses within GCP VPC.
   - Automatically enabled; no manual configuration needed.
   - Resolves requests from Google Cloud resources.

2. **Type 2: On-Premises Networks via VPN**
   - Connects via Cloud VPN or interconnect.
   - Resolves requests from on-premises networks connected via VPN.
   - Must be explicitly enabled.

3. **Type 3: Public Internet**
   - Public DNS server IP addresses accessible over the internet.
   - Allows resolution for public domains from GCP.

When a policy includes alternative servers, DNS queries failover if the primary resolution fails. For example, if an internal server is unavailable, the system can query public DNS.

> [!NOTE]
> Corrections: In the transcript, "डीएनए" appears multiple times, likely meaning "DNS". "पॉलिसी" is "Policy". "रिस्पांस" is "Response". 'गे ' is 'GCP'. I corrected these for accuracy while preserving intent.

## Key Concepts: Response Policies

Response Policies override standard DNS responses to redirect traffic or handle specific domains.

### Core Features
- **Based on Query Scope**: Policies apply based on query content (e.g., domain names, Record Types like A, AAAA, CNAME).
- **Multiple Rules**: Each policy can contain multiple rules, allowing flexible routing.
  - **Record Change**: Modify the response (e.g., change an A record's IP address).
  - **Pass Through/Bypass**: Skip the rule for certain queries, allowing original responses.

- **Traffic Redirection Example**: Suppose an app queries `example.com` normally resolving to 1.1.1.1. A response policy can override this to point to 2.2.2.2 based on rules.

### Rule Structure
- **Query Matcher**: Defines which queries to apply the rule to (e.g., domain patterns with wildcards like `*.internal.domain.com`).
- **Response Override**: Specify new record data (e.g., new IPs, CNAMEs).
- **Actions**: Change record or pass through.

Response Policies enable advanced use cases like blue-green deployments, disaster recovery, or custom domain routing without altering upstream DNS.

## Lab Demo: Creating and Testing Server Policies

### Steps to Create an Inbound/Outbound Server Policy
1. Navigate to GCP Console > Cloud DNS > Policies > Create Policy.
2. Name the policy (e.g., "Inbound-Policy").
3. Enable inbound forwarding:
   - Select your project.
   - Choose the VPC network.
   - GCP will reserve an internal IP (e.g., for inbound queries).
4. Optionally add outbound configuration:
   - Provide alternative DNS server IPs (e.g., on-premises server at 192.168.1.1).
5. Attach to the target network.

### Testing the Policy
- From a GCP VM in the VPC, check DNS settings:
  ```
  nmtui
  # Configure network to use DHCP, then check IP.
  ip addr show
  ```
  Observe that the VM now has DNS forwarding entries (e.g., `dns-cloud-dns-forwarding`).
- Test resolution:
  ```
  nslookup google.com
  ```
  Should resolve via the configured forwarder. For private domains, add records if needed.
- For outbound: From on-premises, query a domain; it should route through GCP DNS.
- Add multiple policies or alternative servers as needed. Test failover by disconnecting servers and re-running `nslookup`.

Replace `google.com` with your test domains. Ensure the VPC has proper network settings.

## Lab Demo: Creating and Testing Response Policies

### Steps to Create a Response Policy
1. In Cloud DNS, create a Private Zone if not already done (for custom records).
2. Go to Policies > Create Response Policy.
3. Name it (e.g., "Response-Policy").
4. Add rules:
   - Rule name (e.g., "Redirect to Private").
   - Query Scope: Specify INTERNAL or EXTERNAL (based on private zone).
   - For record change: Create a new A record (e.g., change `example.com` to 192.68.1.2).
   - For pass through: Bypass specific queries (e.g., for unmatched domains).
5. Apply to the network.

### Testing the Policy
- Add a record in the Private Zone (e.g., A record for `test.private.domain.com` -> 192.168.1.100).
- From a VM, update the policy with a rule to change responses for `*.private.domain.com` to a different IP.
- Test with `dig` or `nslookup`:
  ```
  nslookup test.private.domain.com
  # Should show the overridden IP.
  ```
- Create new records and verify rules apply dynamically.
- Check bypass: Queries outside the rule should pass through unchanged.

Use tools like `dig` for detailed output:
```
dig test.private.domain.com @your-dns-server
```

Ensure rules are ordered correctly; earlier rules take precedence.

## Summary

### Key Takeaways
```diff
+ Server Policies enable hybrid DNS forwarding: Inbound for GCP-to-on-prem resolution, outbound for on-prem-to-GCP.
+ Alternative servers provide redundancy with three types: internal GCP, VPN-based, and public internet.
+ Response Policies allow DNS response overrides via rules for traffic redirection and domain management.
+ Testing with nslookup/dig validates configurations; attach policies to networks for application.
- Be cautious with overlapping rules in Response Policies to avoid unintended overrides.
- Ensure network connectivity (VPN/Interconnect) for cross-environment resolution.
```

### Quick Reference
- **Create Server Policy Command (gcloud)**:
  ```
  gcloud dns policies create inbound-policy \
    --project=my-project \
    --networks=my-vpc \
    --enable-inbound-forwarding \
    --alternative-name-servers=192.168.1.1
  ```
- **Create Response Policy Rule**:
  - Via Console: Add rules under Policies > Rules.
- **Test DNS**:
  ```
  nslookup domain.com
  dig domain.com @dns-server-ip
  ```
- **Key Ports**: DNS uses UDP/TCP port 53.

### Expert Insight

**Real-world Application**: In enterprise hybrid clouds, use outbound Server Policies for seamless on-prem apps resolving GCP services. Response Policies support canary deployments by routing subsets of users to new IPs. For global firms, combine with Cloud DNS for geo-distributed resolution.

**Expert Path**: Study Cloud DNS peering policies next. Dive into advanced BGP routing for complex networks. Practice with Terraform for policy IaC to automate at scale. Explore integrations with Cloud Router for full network orchestration.

**Common Pitfalls**: Misconfigured alternative servers can cause infinite loops in resolution. Forget to attach policies to networks—queries fail silently. Test for rule conflicts; validations help, but manual `dig` traces are essential. Ensure private zones exist before creating response rules.
</details>
