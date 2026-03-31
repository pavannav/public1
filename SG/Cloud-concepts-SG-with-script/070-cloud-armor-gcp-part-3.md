# Session 3: Cloud Armor GCP - Preview Mode and Advanced Options

## Table of Contents
- [Preview Mode](#preview-mode)
- [Advanced Match Conditions](#advanced-match-conditions)
- [Lab Demo: Implementing Preview Mode](#lab-demo-implementing-preview-mode)
- [Lab Demo: Advanced Rules for Regional Blocking](#lab-demo-advanced-rules-for-regional-blocking)
- [Lab Demo: Combining Conditions (Region and IP)](#lab-demo-combining-conditions-region-and-ip)
- [Lab Demo: Blocking Specific ASN](#lab-demo-blocking-specific-asn)
- [Lab Demo: Blocking Specific Request Paths](#lab-demo-blocking-specific-request-paths)
- [Additional Advanced Options](#additional-advanced-options)
- [Summary](#summary)

## Preview Mode

### Overview
Preview mode allows testing Cloud Armor security rules without enforcing them, enabling administrators to observe potential impacts on traffic before making changes live. This feature provides visibility into rule effects through logs while maintaining normal traffic flow.

### Key Concepts/Deep Dive
- **How Preview Mode Works**: 
  - Requests still evaluate against security policies normally
  - Logs record both the actual enforced action and the preview action
  - Individual rules can be set to preview mode independently
  - Entire policies can have all rules in preview mode

- **Logging Requirements**:
  - Logging must be enabled on the load balancer for preview logs to appear
  - Preview logs appear as "preview security policy" alongside enforced policy logs
  - Both matched and preview rule actions are logged

- **Practical Use Case**:
  - Test deny rules without impacting legitimate users
  - Verify rule matching before going live
  - Analyze rule effectiveness in a safe environment

> [!IMPORTANT]
> Preview mode requires enabled logging. Without logging, no preview data will be available.

### Lab Demo: Implementing Preview Mode

#### Steps:
1. Navigate to Cloud Armor in GCP Console
2. Select the default security policy (or create a new one)
3. Add a new rule:
   - Match condition: Specific IP address (e.g., 35.200.248.25)
   - Action: Deny
   - Enable Preview mode: ✅ Checked
   - Priority: 10000
4. Ensure logging is enabled on the load balancer
5. Test the rule by making requests from the specified IP

#### Verification:
- Traffic continues to work normally (HTTP 200 responses)
- Check logs in Cloud Logging:
  - Look for both "enforced security policy" and "preview security policy" entries
  - Preview logs show "outcome denied" while enforced policy allows traffic

#### Log Structure:
```json
{
  "enforced_security_policy": {
    "configured_action": "ACCEPT",
    "outcome": "ACCEPT",
    "priority": 2147483647
  },
  "preview_security_policy": {
    "configured_action": "DENY", 
    "outcome": "DENY",
    "priority": 10000
  }
}
```

## Advanced Match Conditions

### Overview
Advanced match conditions use Common Expression Language (CEL) to create sophisticated rules based on multiple HTTP request attributes. These expressions allow fine-grained control over traffic filtering using logical operators and attribute matching.

### Key Concepts/Deep Dive

#### CEL Structure:
- **Attributes**: Data to inspect (originip, originregioncode, requestpath, etc.)
- **Operations**: How to evaluate the data (inIpRange, equals, contains, etc.)
- **Operators**: Logical combinations (&& for AND, || for OR)
- **Limits**: Up to 5 expressions per rule

#### Available Attributes:
| Attribute | Description | Example |
|-----------|-------------|---------|
| originip | Source IP address | 203.0.113.1 |
| originregioncode | Geographic region | US, IN, JP |
| origin.asn | Autonomous System Number | 146915 |
| request.path | HTTP request path | /admin, /wp-admin |
| request.headers | HTTP headers | User-Agent, Cookie |
| request.method | HTTP method | GET, POST, PUT |

#### Expression Examples:
```cel
// Block US traffic
origin.region_code == "US"

// Block specific IP range
origin.ip in ipRange("192.168.1.0/24")

// Block specific request path  
request.path == "/forbidden"

// Block traffic with specific cookie
request.headers['cookie'].contains('wordpress')

// Complex condition: US region AND specific IP
origin.region_code == "US" && origin.ip in ipRange("203.0.113.0/24")
```

#### Response Codes:
- **403 Forbidden**: Default for blocked requests
- **404 Not Found**: Alternative for path-based blocks
- **502 Bad Gateway**: Custom configurable response

### Lab Demo: Advanced Rules for Regional Blocking

#### Steps:
1. In Security Policy, create new rule
2. Select Advanced Mode
3. Use visual editor or text expression:
   - Attribute: origin.region_code
   - Operator: ==
   - Value: "US"
4. Action: Deny
5. Response Code: 502 (Bad Gateway)
6. Preview: Enabled
7. Priority: 100000
8. Add Rule

#### Testing:
- From US-based VM: Expect 502 Bad Gateway response
- From non-US VM: Normal access (HTTP 200)

```bash
# Test from US VM (blocked)
curl http://your-load-balancer-ip/

# Expected response: 502 Bad Gateway

# Test from Asia VM (allowed)  
curl http://your-load-balancer-ip/

# Expected response: 200 OK with content
```

### Lab Demo: Combining Conditions (Region and IP)

#### Steps:
1. Edit existing regional block rule
2. Add additional expression:
   ```cel
   origin.region_code == "US" && origin.ip in ipRange("35.200.248.0/24")
   ```
3. Action: Deny
4. Update rule

#### Testing:
- Requests from US-region IPs outside the specified range: Still allowed
- Requests from the specified US IP range: Blocked
- Non-US traffic: Always allowed

### Lab Demo: Blocking Specific ASN

#### Steps:
1. Create new rule in Advanced Mode
2. Expression:
   ```cel
   origin.asn == 146915
   ```
3. Action: Deny
4. Response Code: 404 Not Found
5. Priority: 9999
6. Add Rule

#### Verification:
- Find your ASN using tools like "show complete IP details" in logs
- Test from network with that ASN: Expect 404 response
- Alternative: Allow-only rule
  ```cel
  origin.asn != 146915
  ```

### Lab Demo: Blocking Specific Request Paths

#### Steps:
1. Create new rule in Advanced Mode  
2. Expression:
   ```cel
   request.path == "/bad-path"
   ```
3. Action: Deny
4. Response Code: 403 Forbidden
5. Priority: 777
6. Add Rule

#### Testing:
```bash
# Allowed path
curl http://your-load-balancer-ip/city.png

# Blocked path  
curl http://your-load-balancer-ip/bad-path

# Expected: 403 Forbidden (from policy)
# Application may return 404 for unknown paths
```

### Additional Advanced Options

#### More Expression Examples:
```cel
// Block IPv6 traffic
origin.ip.isIpv6()

// Cookie-based filtering
request.headers['cookie'].contains('italics=true')

// Referer header check
request.headers['referer'].contains('malicious-site.com')

// User-Agent blocking
request.headers['user-agent'].contains('Chrome')
```

#### Resource Links:
- [Cloud Armor Custom Rules Language](https://cloud.google.com/armor/docs/rules-language)
- CEL Documentation for Cloud Armor expressions

## Summary

### Key Takeaways
```diff
+ Preview mode enables safe testing of security rules before enforcement
+ Logs are critical for monitoring preview rule effectiveness
+ Advanced match conditions use CEL expressions for sophisticated filtering
+ Combine multiple conditions with && operators for complex rules
+ Regional (US, EU), ASN, path, and header-based filtering are common use cases
+ Response codes (403, 404, 502) can be customized for blocked traffic
+ Up to 5 expressions allowed per rule for granular control
+ Default security policies are created automatically with load balancers
+ Preview rules show both current and preview outcomes in logs
```

### Expert Insight

#### Real-world Application
In production environments, use preview mode to gradually roll out security policies:
- Deploy new WAF rules in preview first
- Monitor logs for false positives over 1-2 weeks
- Tune expressions based on observed traffic patterns
- Implement rate limiting at the load balancer level using Cloud Armor

#### Expert Path
- Master CEL syntax by studying Google's documentation regularly
- Practice building complex expressions combining geography, user behavior, and request attributes
- Learn to use preview mode systematically for policy deployment pipelines
- Integrate Cloud Armor logs with SIEM tools for threat hunting
- Create reusable rule templates for common use cases across projects

#### Common Pitfalls
- Forgetting to enable logging prevents preview mode visibility
- Overly broad regional blocks (e.g., denying US entirely) can block legitimate users from CDN providers
- Misconfigured IP ranges in expressions (wrong CIDR notation)
- Not waiting for policy propagation (takes 5-15 minutes)
- Mixing preview and enforced rules in complex policies without careful testing
- Ignoring case sensitivity in string matches (use contains() instead of == for partial matches)

#### Lesser Known Things About This Topic
- ASN filtering can block entire service providers rather than specific malicious actors
- IPv6 traffic can be filtered separately using `origin.ip.isIpv6()` method
- Preview mode doesn't consume rule enforcement quota, allowing broader testing
- Multiple expressions are evaluated as AND conditions - any false expression blocks the entire rule
- Policy names and rule priorities appear in log fields for detailed auditing
- Cookie headers are case-insensitive but array-based - use `.contains()` for safe matching
- Cross-scripting defenses can be implemented by blocking suspicious headers/messages patterns
