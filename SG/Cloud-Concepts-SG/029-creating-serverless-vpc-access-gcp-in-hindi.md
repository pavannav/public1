# Session 29: Creating Serverless VPC Access in GCP (in Hindi)

<details open>
<summary><b>Session 29: Creating Serverless VPC Access in GCP (in Hindi) (KK-CS45-script-v2)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Key Concepts & Deep Dive](#key-concepts--deep-dive)
- [Creating Serverless VPC Access Connector](#creating-serverless-vpc-access-connector)
- [Demo Setup](#demo-setup)
- [Lab Demo: Testing VPC Access](#lab-demo-testing-vpc-access)
- [Summary](#summary)

## Overview

This session covers Serverless VPC Access in Google Cloud Platform (GCP), which enables secure communication between serverless environments (Cloud Run, App Engine, Cloud Functions) and resources within a Virtual Private Cloud (VPC). The session demonstrates how serverless applications can access VPC resources through private IP addresses and internal DNS, ensuring secure and compliant architectures.

## Key Concepts & Deep Dive

### Serverless VPC Access Fundamentals

Serverless VPC Access serves as a bridge between serverless environments and VPC networks, enabling secure private communication. This service is essential when your serverless applications need to connect to:

- Compute Engine VMs
- Memorystore (Redis)
- Private Service Connect endpoints
- Other VPC resources

### Key Features and Architecture

**Private Communication Channel:**
- All traffic between serverless environments and VPC resources flows through private IP addresses
- Supports internal DNS resolution within the VPC
- Eliminates need for public IP exposure for VPC resources

**VPC Connector:**
- Acts as a managed proxy between serverless services and VPC network
- Creates Virtual Machines (VMs) in the background to handle traffic
- Available machine types: f1-micro, e2-micro, e2-standard-4
- Supports scaling from minimum 2 instances to maximum 10 instances

> [!IMPORTANT]
> Key requirement: Connector subnet must be unused /28 CIDR range or custom IP range

### Network Tags and Security

When you create a Serverless VPC Access connector, two network tags are automatically created:

1. **vpc-connector** - Universal network tag that blocks communication from specific VMs
2. **vpc-connector-[region]-[connector-name]** - Region-specific tag for finer control

**Automatic Firewall Rule:**
- Priority: 1000
- Allows traffic from connector's IP range to all destinations in the VPC
- Invisible in VPC Network > Firewall section (implicit rule)

### Scaling Behavior and Limitations

> [!NOTE]
> **Current Limitation:** Connectors scale OUT but don't scale IN automatically. Once scaled to maximum instances, they maintain that count even if traffic decreases.

**Scaling Configuration:**
- Minimum instances: Always 2 (cannot be reduced)
- Maximum instances: Up to 10
- Machine types affect throughput capacity
- Cost increases with instance count

### Machine Type Selection

| Machine Type | Throughput | Cost |
|-------------|------------|------|
| f1-micro | Lowest | Lowest |
| e2-micro | Low | Low |
| e2-standard-4 | High | Higher |

## Creating Serverless VPC Access Connector

### Step-by-Step Creation Process

**Prerequisites:**
- Active GCP project with VPC network
- Choose region carefully (cannot change later)
- Identify available /28 subnet or create new CIDR range

**Console Navigation:**
```
VPC Network > Serverless VPC Access > Create Connector
```

**Configuration Options:**

1. **Name:** Assign meaningful connector name
2. **Region:** Select deployment region
3. **Network:** Choose target VPC network
4. **Subnet:** Select or create /28 subnetwork range
5. **Instance Settings:**
   - Minimum instances: 2 (fixed)
   - Maximum instances: 2-10
   - Machine type: f1-micro, e2-micro, or e2-standard-4

**Example Configuration:**
```yaml
name: "vpc-access-connector"
region: "us-central1"
network: "my-vpc"
subnet: "192.168.9.0/28"
min_instances: 2
max_instances: 3
machine_type: "f1-micro"
```

## Demo Setup

The session demonstrates VPC Access implementation with:

- Pre-configured VM serving basic HTTP responses
- Docker image for Cloud Run testing
- Python Cloud Function for automated testing

### VM Configuration

Created a VM instance with private IP `192.168.1.3` that responds with:
```
Testing of serverless connector is going on.
```

## Lab Demo: Testing VPC Access

### Cloud Run Integration

**Service Creation Steps:**

1. Navigate to Cloud Run in GCP Console
2. Create new service
3. Select pre-built Docker image
4. Configure network settings:
   ```
   Network: [Target VPC]
   Serverless VPC Access: [Select Connector]
   ```

**Key Configuration:**
- Service URL generated after deployment
- Connector selection enables private IP access
- Without connector: Connection fails with network errors

**Testing Results:**

✅ **With Connector:** Successfully connects to VM private IP
```
Testing of serverless connector is going on.
```

❌ **Without Connector:** Connection timeout
```
curl: Connection refused/No route to host
```

### Cloud Functions Integration

**Function Setup:**

1. Create new HTTP-triggered function
2. Runtime: Python 3.x
3. Configure VPC Access in Advanced Settings
4. Select connector in "Egress settings"

**Sample Code Structure:**
```python
import requests

def hello_world(request):
    # Connect to VPC resource via private IP
    response = requests.get('http://192.168.1.3')  # VM private IP

    # Store result in Cloud Storage
    bucket = storage_client.bucket('my-bucket')
    blob = bucket.blob('curl_output.txt')
    blob.upload_from_string(response.text)

    return 'Function executed successfully'
```

**Testing Process:**
- Function successfully executes
- Output stored in Cloud Storage bucket
- Confirms successful private network communication

### App Engine Integration

**Configuration Approach:**
For App Engine applications, configure VPC access via `app.yaml`:

```yaml
vpc_access_connector:
  name: "projects/{project}/locations/{region}/connectors/{connector-name}"
```

Required parameters:
- Project name
- Region
- Connector name

## Summary

### Key Takeaways

```diff
+ Serverless VPC Access bridges serverless environments with VPC resources through secure private channels
+ Enables Cloud Run, App Engine, and Cloud Functions to communicate with VMs, Memorystore, and other VPC services
+ Uses connectors (VMs) deployed in /28 subnets to proxy traffic between serverless and VPC networks
+ Supports automatic scaling (out only) and provides network tags for security control
+ Requires explicit connector selection in service configurations for each serverless service
+ Eliminates need for public IP exposure while maintaining secure communication
- Connectors don't scale in automatically once maximum instances are reached
- Region selection is permanent after creation
- Requires available /28 subnet range in target VPC
```

### Quick Reference

**Connector Creation Commands:**
```bash
# Console: VPC Network > Serverless VPC Access > Create Connector
# Required: Name, Region, VPC, Subnet (/28), Instance Settings
```

**Configuration Examples:**

**Cloud Run:**
```
Networking > VPC Network: my-vpc
Serverless VPC Access: vpc-access-connector
```

**Cloud Functions:**
```
Configuration > Advanced Settings > Egress Settings > VPC Connector: vpc-access-connector
```

**App Engine (app.yaml):**
```yaml
vpc_access_connector:
  name: "projects/my-project/locations/us-central1/connectors/vpc-access-connector"
```

**Network Tags:**
- `vpc-connector`: Universal blocking tag
- `vpc-connector-us-central1-vpc-access`: Region-specific tag

### Expert Insight

**Real-world Application:**
Implement Serverless VPC Access in enterprise environments requiring secure microservices communication, where Cloud Functions need database access or Cloud Run services must reach on-premises resources through hybrid cloud setups.

**Expert Path:**
Master network tag usage for granular security control and VPC Service Controls integration. Learn to monitor connector performance through Cloud Monitoring metrics and implement automated scaling strategies using Cloud Operations.

**Common Pitfalls:**
- Forgetting connector selection in serverless service configuration
- Choosing inappropriate region, requiring connector recreation
- Not accounting for lack of automatic scale-in behavior
- Insufficient /28 subnet planning in large organizations
- Misconfiguration of firewall rules blocking connector traffic

</details>