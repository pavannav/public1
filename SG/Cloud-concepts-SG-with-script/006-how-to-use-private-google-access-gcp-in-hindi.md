# Session 6: Private Google Access in GCP

## Table of Contents
- [Introduction to Private Google Access](#introduction-to-private-google-access)
- [Enabling Private Google Access on a VM](#enabling-private-google-access-on-a-vm)
- [Creating a VM Without External IP](#creating-a-vm-without-external-ip)
- [Testing Private Access to GCP Services](#testing-private-access-to-gcp-services)
- [Handling Permissions with Service Accounts](#handling-permissions-with-service-accounts)
- [Summary](#summary)

## Introduction to Private Google Access

### Overview
Private Google Access in Google Cloud Platform (GCP) allows resources within a VPC network, such as Virtual Machines (VMs), to access Google Cloud services and APIs without using an external IP address. This feature enables secure, private communication over Google's internal network, which is useful for maintaining security by avoiding exposure to the public internet while still allowing access to services like Cloud Storage, BigQuery, and other Google APIs.

Private Google Access is typically enabled at the subnet level and is required for VMs that don't have external IP addresses to reach Google's services privately.

### Key Concepts/Deep Dive
- **What is Private Google Access?**: It's a Google Cloud feature that routes traffic from your VPC to Google Cloud services through Google's private network, bypassing the public internet. This ensures that your resources can access services like Cloud Storage (GS) without needing external IPs, improving security and potentially reducing costs associated with data egress.
  
- **When to Use It**:
  - When deploying VMs behind a VPN or in a private subnet.
  - For applications that need to access Google services without exposing public IPs.
  - To comply with security policies that prohibit external internet access.

- **Requirements**:
  - The VM must be in a custom VPC network.
  - Private Google Access must be enabled on the subnet.
  - The VPC network must support internal DNS for googleapis.com and similar domains.

- **Limitations**:
  - Only works for Google Cloud APIs and services; not for arbitrary internet access.
  - Requires proper routing and DNS configuration within the GCP network.

> [!NOTE]
> Private Google Access is off by default on new subnets. You must explicitly enable it.

> [!IMPORTANT]
> Enabling this feature ensures that your workloads can access Google Cloud services securely. Without it, VMs without external IPs cannot reach services like GS utilities or BigQuery.

## Enabling Private Google Access on a VM

### Overview
To enable Private Google Access, you need to configure the subnet where your VM resides. This allows the VM to use Google Cloud's private network for service access.

### Key Concepts/Deep Dive
- **Subnet Configuration**: Private Google Access is enabled per subnet. Once enabled, all VMs in that subnet can access Google services privately.
  
- **Steps to Enable**:
  1. Navigate to the GCP Console > VPC Network > VPC Networks > Your Network > Subnets.
  2. Select the subnet for your VM.
  3. Edit the subnet settings and toggle "Private Google Access" to ON.
  4. Save the changes.

- **Default Behavior**: By default, private Google access is set to OFF in new subnets. Check your subnet settings if access fails.

- **Verification**: After enabling, test by accessing a Google Cloud service from a VM in that subnet.

## Creating a VM Without External IP

### Overview
For testing Private Google Access, create a VM without an external IP to simulate a fully private environment.

### Key Concepts/Deep Dive
- **Why No External IP?**: This ensures the VM can only access resources via private networks, forcing reliance on Private Google Access for Google services.
  
- **Configuration Steps**:
  1. Go to GCP Console > Compute Engine > VM Instances > Create Instance.
  2. Choose your region and zone.
  3. Under "Machine configuration", set the network to a custom VPC with Private Google Access enabled.
  4. In the "Network interfaces" section:
     - Remove any external IP by deselecting "External IP" (leave as "None").
  5. Keep other settings default (e.g., machine type, boot disk).
  6. Click "Create".

- **Additional Options**: Ensure the subnet supports Private Google Access. Note the internal IP for later access or testing.

- **Post-Creation**: The VM will have only an internal IP and a container IP (if applicable). Copy the internal IP for SSH access if needed via VPN.

## Testing Private Access to GCP Services

### Overview
Once Private Google Access is enabled and a VM is created, test by accessing GCP services like Cloud Storage using gsutil commands.

### Lab Demo
1. **Create the VM**:
   - Follow the steps above to create a VM without external IP.
   - VM created successfully with no public IP assigned.

2. **Attempt to Access Cloud Storage**:
   - From the VM, run the gsutil command to interact with a bucket:
     ```
     gsutil cp gs://your-bucket-name/object-name local-path
     ```
   - If Private Google Access is not enabled, the command will fail with a communication error (e.g., "Cannot communicate").

3. **Enable Private Google Access**:
   - Exit the VM, go to GCP Console > VPC Network.
   - Edit the VM's subnet to enable "Private Google Access".

4. **Retest Access**:
   - SSH back into the VM (using internal IP via VPN if direct access is blocked).
   - Run:
     ```
     gsutil ls gs://your-bucket-name
     ```
   - The command should now succeed, listing contents of the bucket (e.g., images like PNG files).

It's important to note that the operation may take a few moments to take effect, as propagation occurs across Google's network.

## Handling Permissions with Service Accounts

### Overview
Even with Private Google Access enabled, service accounts attached to the VM may lack permissions to access specific GCP services, leading to access denied errors.

### Key Concepts/Deep Dive
- **Service Accounts**: VMs use service accounts for authentication to GCP services. Ensure the account has appropriate IAM roles.

- **Common Issues**:
  - **Error**: Access denied for list operations.
  - **Cause**: Service account lacks storage.objectViewer or similar permissions.
  
  - **Resolution**:
    1. Go to GCP Console > IAM & Admin > IAM.
    2. Find the VM's service account.
    3. Add roles like "Storage Object Viewer" for Cloud Storage access.
    4. Verify permissions and retest the command.

- **Avoiding Pitfalls**: Always configure IAM roles before deploying. Use the Compute Engine default service account sparingly; prefer custom service accounts for fine-grained control.

> [!WARNING]
> Without proper permissions, even enabled Private Google Access won't function, as authentication fails.

## Summary

### Key Takeaways
```diff
+ Private Google Access allows VMs to reach Google Cloud services over private networks without external IPs.
+ Enable it at the subnet level for secure, cost-effective access.
+ Create test VMs without external IPs to validate configurations.
+ Test access using gsutil commands; expect initial failures before enabling the feature.
- Service account permissions are critical; access denied errors indicate IAM role issues.
- Always verify subnet settings, as Private Google Access is disabled by default.
```

### Expert Insight
- **Real-world Application**: In production, enable Private Google Access for workloads in private subnets (e.g., behind Cloud NAT or VPNs) to access Google APIs securely. This is ideal for analytics pipelines using BigQuery or storage solutions like Cloud Storage, ensuring no data traverses the public internet.
  
- **Expert Path**: Master IAM policies by experimenting with custom roles and conditional access. Integrate with Cloud Build or Kubernetes for private deployments. Study Google's VPC best practices to combine this with features like Private Service Connect.

- **Common Pitfalls**:
  - Forgetting to enable Private Google Access on the subnet, leading to connectivity failures.
  - Assuming VMs have implicit permissions; always audit service account roles.
  - Misconfigured DNS or routing in custom VPCs, preventing googleapis.com resolution.
  
- **Resolutions and Avoidance**:
  - After enabling the feature, wait 5-10 minutes for propagation before testing.
  - Use Cloud Logging to monitor access patterns and identify permission denials early.
  - Implement least-privilege IAM from the start to avoid overuse of default service accounts.

- **Lesser-Known Facts**: Private Google Access supports DNS-based routing, allowing seamless access to regional endpoints without explicit IP whitelisting. It's compatible with Shared VPCs for cross-project private connectivity.
