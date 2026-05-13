# Section 14: Design Scenario -1

<details open>
<summary><b>Design Scenario -1 (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [14.1 Design Scenario -1](#141-design-scenario--1)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
  - [Route Priority and BGP Path Selection](#route-priority-and-bgp-path-selection)
  - [Traffic Engineering Solution](#traffic-engineering-solution)

## 14.1 Design Scenario -1

### Overview
This design scenario demonstrates a real-world traffic engineering use case involving a company with two on-premises data centers (Sydney and Singapore) connected to an AWS VPC via Direct Connect. The scenario showcases how to manipulate BGP attributes to control traffic flow when simple AS path prepending fails due to AWS's route priority mechanisms.

### Key Concepts

#### Network Architecture
- **Company Infrastructure**: Two data centers in Sydney and Singapore
- **AWS Setup**: VPC located in Sydney region with multi-VPCs
- **Direct Connect Connections**:
  - 1G connection to Sydney Data Center
  - 10G connection to Singapore Data Center
- **Shared IP Prefix**: 192.168.10.0/24 between both on-premises data centers
- **On-premises BGP AS**: AS number 65001 used for Direct Connect peering

#### Data Center Interconnect
The on-premises data centers are connected via a seamless subnet integration, providing:
- Single shared subnet across both locations
- Layer 2 connectivity or overlay solutions
- Unified networking between Sydney and Singapore data centers

### Route Priority and BGP Path Selection

#### Initial Attempt: AS Path Prepending
The company wanted Singapore Data Center to be preferred for traffic from AWS VPC to the shared prefix (192.168.10.0/24).

**AS Path Prepending Configuration:**
- Singapore path: Default AS path (65001)
- Sydney path: Prepended AS path (65001 65001 65001)

```diff
- Expected behavior: Shorter AS path through Singapore should be preferred
+ Actual behavior: Traffic still preferred Sydney path
```

#### Why AS Path Prepending Failed
AWS Direct Connect Gateway applies route priority that considers:
1. **Network Path Cost**: DirectConnect gateway evaluates the distance from VPC to Direct Connect location
2. **Location Proximity**: VPC in Sydney has lower network cost to Sydney Direct Connect location

Even with BGP attributes, the network path cost takes precedence over AS path length in AWS's routing decision algorithm.

> [!IMPORTANT]
> Understanding AWS route priority is critical for traffic engineering. Network path cost (VPC to Direct Connect location proximity) is considered before BGP AS path attributes.

### Traffic Engineering Solution

#### Using BGP Local Preference
To meet the requirement of preferring Singapore path, use BGP local preference attribute instead of AS path prepending.

**BGP Local Preference**:
- Higher local preference value = More preferred path
- Considered **before** network path cost in route priority list
- Can be manipulated using specific BGP community values in AWS

#### BGP Community Implementation
Assign BGP community values to the prefix advertisement from customer router to Direct Connect router in Singapore:

- Apply community value to prefix 192.168.10.0/24 on Singapore advertisement
- This assigns higher local preference to the Singapore path
- Ensures traffic from Sydney VPC uses Singapore path despite proximity

#### Route Priority Order
Understanding AWS Direct Connect routing priorities:

1. **Longest Prefix Match** (always first)
2. **BGP Local Preference** (highest value preferred)
3. **Network Path Cost** (VPC to Direct Connect location proximity)
4. **AS Path Length** (shorter preferred)
5. Other BGP attributes...

```diff
+ BGP Local Preference gives control above Network Path Cost
+ Enables proper traffic engineering for required path selection
```

## Summary

### Key Takeaways
```diff
+ AS Path prepending may not work if Network Path Cost takes precedence
+ BGP Local Preference is evaluated before Network Path Cost in AWS routing
+ BGP Community values can assign local preference for Direct Connect routes
+ Understanding route priority hierarchy is essential for traffic engineering
```

### Quick Reference
- **Shared Prefix**: 192.168.10.0/24
- **On-prem BGP AS**: 65001
- **AWS Route Priority**: Longest Prefix → Local Preference → Path Cost → AS Path...
- **Solution**: Use BGP community values to set higher local preference for Singapore path

### Expert Insight

#### Real-world Application
This scenario demonstrates production-level traffic engineering where geographical proximity negatively impacts application performance. By leveraging BGP local preference, organizations can prioritize data routing based on business logic over physical network costs.

#### Expert Path
- Master AWS Direct Connect BGP community values for different preference levels
- Always verify route priority hierarchy in documentation
- Test BGP attribute changes in non-production first
- Monitor traffic patterns after BGP configuration changes

#### Common Pitfalls
- Assuming AS path prepending always controls traffic when advertised prefixes have same length
- Ignoring AWS-specific route priority mechanisms
- Not considering VPC location relative to Direct Connect gateways

#### Lesser-Known Facts
- Network path cost considers exact physical distance, not just regional proximity
- BGP community values can achieve granular control over route preferences
- Direct Connect Gateway routing differs from traditional BGP implementations

</details>