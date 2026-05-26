<details open>
<summary><b>AWS interview Question.How to create vpc peering across region.  #aws #linux #abhrosh #shorts (KK-CS45-script-v2-Interview)</b></summary>

# AWS Cross-Region VPC Peering - Interview Study Guide

## Question

**Can you connect VPCs in different regions?**

## Expected Incorrect Answer

Most candidates will incorrectly answer **"No"** - this is why they get rejected in AWS interviews.

## Correct Answer

**Yes**, Cross-region VPC peering is **100% possible**.

### Key Points:
- Cross-region VPC peering allows you to connect VPCs across different AWS regions
- Traffic travels through AWS's private backbone network (not the public internet)
- Provides secure and private communication between VPCs in different geographic regions

## How to Create Cross-Region VPC Peering (Mumbai to Singapore)

### Step-by-Step Process:

#### 1. **Initiate from Source Region (Mumbai)**
- Navigate to VPC Peering in the AWS Console
- Click on **"Create Peering Connection"**
- Provide:
  - Peering connection name (e.g., PCX-prod)
  - Your current VPC ID with CIDR block
  - Select the target region (Singapore)
  - Enter the target VPC ID from Singapore region

#### 2. **Accept in Destination Region (Singapore)**
- Switch to the Singapore region
- Go to **Peering Connections**
- Locate the pending request from Mumbai
- Rename the connection (e.g., PCX-prod) and save
- Right-click on the connection and **Accept Request**

#### 3. **Verification**
- Connection status changes from "Pending Acceptance" to "Active"
- VPC peering is now established across regions

## Important Notes

- ✅ **Cost Consideration**: Cross-region VPC peering incurs data transfer charges
- ✅ **Limitations**: Some AWS resources (like certain load balancers) may not work across peered VPCs
- ✅ **Security**: Always ensure proper security groups and NACLs are configured

## Common Interview Follow-up Questions

1. **Q: Does cross-region VPC peering use the public internet?**
   - A: No, it uses AWS's private global network backbone

2. **Q: Can you peer VPCs across different AWS accounts in different regions?**
   - A: Yes, cross-account and cross-region peering is supported

3. **Q: Is VPC peering transitive?**
   - A: No, VPC peering is non-transitive - each VPC needs direct peering with others

---

**Note**: This transcript contains promotional content for abros.com training services at the end, which is not relevant to the technical content.

</details>