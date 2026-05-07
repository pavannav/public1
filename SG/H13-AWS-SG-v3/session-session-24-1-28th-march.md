# Session 24: EFS and NFS Revision

## Table of Contents
- [EFS Service](#efs-service)
  - [Overview](#overview)
  - [Key Concepts / Deep Dive](#key-concepts--deep-dive)
  - [Lab Demos](#lab-demos)
- [Creating Your Own NFS Server](#creating-your-own-nfs-server)
  - [Overview](#overview-1)
  - [Key Concepts / Deep Dive](#key-concepts--deep-dive-1)
  - [Lab Demos](#lab-demos-1)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## EFS Service

### Overview
Amazon Elastic File System (EFS) is a scalable, serverless file storage service designed for use with Amazon EC2 instances. It provides simple, scalable, elastic file storage that can be shared across multiple instances and Availability Zones. EFS is based on the Network File System (NFS) protocol and automatically scales storage capacity as files are added or removed. Key use cases include shared file storage for web servers, content repositories, and big data analytics.

### Key Concepts / Deep Dive

#### Storage Types in AWS
AWS offers three primary storage types: block storage (EBS), file storage (EFS), and object storage (S3).

| Storage Type | Service | Use Case | Scalability | Access Method |
|--------------|---------|----------|-------------|---------------|
| Block Storage | EBS | Persistent storage for EC2 instances | Moderate | Direct attach to instances |
| File Storage | EFS | Shared file systems across instances | High (elastic) | NFS protocol |
| Object Storage | S3 | Large-scale data lakes, backups | Extremely high | RESTful APIs |

#### EFS Creation Process
- **File System Name**: User-defined descriptive name (e.g., "EFS-test-one").
- **VPC Selection**: Deployed in a specific VPC (by default, the account's default VPC).
- **Storage Classes**:
  - **Standard**: Multi-AZ availability for high availability.
  - **One Zone**: Single Availability Zone, cost-effective for non-critical data.
- **Security Groups**: Automatically created and attached to allow NFS traffic (port 2049).
  - If issues arise, modify inbound rules to allow NFS from specific sources.

EFS is serverless, meaning no server management is required. It uses NFSv4 protocol for file sharing.

#### Mounting EFS
Mount EFS file systems using the `mount` command with the file system's DNS name. The system automatically handles protocol negotiation.

```bash
# Example mount command
mount -t nfs4 fs-abcdef1234567890.efs.region.amazonaws.com:/ /mount/point
```

Advantages include no upfront storage costs (pay for what you use) and automatic scaling.

> [!IMPORTANT]
> EFS relies on network connectivity within the VPC for data access.

### Lab Demos

#### Creating and Configuring EFS
1. Navigate to the EFS console in AWS.
2. Click "Create file system".
3. Enter a name (e.g., "EFS-test-one").
4. Select the VPC (default is fine).
5. Choose storage class (Standard for high availability).
6. Review and create - EFS provides a DNS name for mounting.

#### Mounting EFS on EC2 Instances
1. Launch EC2 instances in the same VPC.
2. Install NFS utilities (usually pre-installed).
3. Use the mount command with the EFS DNS name.
4. Test by creating files and verifying sharing across instances.

## Creating Your Own NFS Server

### Overview
Setting up your own NFS server involves configuring a Linux instance to share directories using the NFS protocol. This contrasts with AWS EFS, which is a managed service. NFS allows file sharing between Unix-like systems over a network, providing a way to centralize storage without relying on cloud-managed services.

### Key Concepts / Deep Dive

#### NFS Architecture
- **NFS Server**: Hosts the shared directories and manages access.
- **NFS Clients**: Mount the shared directories from the server.
- **Protocol**: Uses NFS (versions 3 or 4), with security features like root squashing to prevent privilege escalation.

#### Configuration File: `/etc/exports`
This file defines shared directories, permissible clients, and permissions.

```bash
# Example /etc/exports entry
/share 172.31.42.78(rw,no_root_squash)
```

- `rw`: Read-write permissions.
- `no_root_squash`: Disables root squashing for full access (use cautiously for security).

> [!NOTE]
> NFS requires network connectivity between server and clients. In AWS, ensure instances are in the same VPC or peered VPCs.

#### Handling Permissions
- Default behavior includes "root squashing" to limit root user privileges on clients.
- Disable with `no_root_squash` for applications requiring elevated permissions, but evaluate security risks.

### Lab Demos

#### Setting Up NFS Server
1. Launch an EC2 instance (Amazon Linux recommended).
2. Install NFS utilities (if not present):
   ```bash
   sudo yum install nfs-utils -y
   ```
3. Start the NFS service:
   ```bash
   sudo systemctl start nfs-server
   sudo systemctl enable nfs-server
   ```
4. Create a share directory:
   ```bash
   sudo mkdir /share
   ```
5. Edit `/etc/exports`:
   - Add entry for shared directory and client IPs.
   - Example: `/share 172.31.42.78(rw,no_root_squash)`
6. Restart NFS server:
   ```bash
   sudo exportfs -r
   sudo systemctl restart nfs-server
   ```
7. Verify exports:
   ```bash
   exportfs -v
   ```

#### Setting Up NFS Client
1. On the client instance, create a mount point:
   ```bash
   sudo mkdir /myfolder
   ```
2. Mount the NFS share:
   ```bash
   sudo mount -t nfs server_ip:/share /myfolder
   ```
   Replace `server_ip` with the NFS server's IP.
3. Test by creating files in `/myfolder` on the client and verifying on the server.
4. Check mounted file systems:
   ```bash
   df -hT
   ```

## Summary

### Key Takeaways
```diff
+ Storage is critical in AWS; understanding block (EBS), file (EFS/NFS), and object (S3) storage enables optimal architecture design
- Over-reliance on default security groups can expose NFS shares; always restrict access by IP
! EFS is serverless and elastic, while manual NFS setup requires server management but offers full control
+ Network connectivity is fundamental for all file sharing solutions
- Root squashing enhances security by default; disabling it requires careful evaluation
+ Practical labs reinforce concepts; practice EFS mounting and NFS configuration regularly
```

### Quick Reference
- **Start NFS Server**: `sudo systemctl start nfs-server`
- **Mount NFS**: `mount -t nfs server_ip:/share /mount/point`
- **Check Exports**: `exportfs -v`
- **Mount EFS**: `mount -t nfs4 efs-dns-name:/ /mount/point`
- **Configure Exports**: Edit `/etc/exports` with entries like `/share client_ip(rw)`

### Expert Insight

#### Real-world Application
In production environments, use EFS for managed, scalable file storage in web applications, data analytics, or containerized workloads (e.g., Kubernetes persistent volumes). For hybrid scenarios or on-premises control, set up custom NFS servers. Always implement backups, encryption, and monitoring for data integrity.

#### Expert Path
Deepen expertise by exploring NFS v4 features like ACLs, Kerberos authentication for secure NFS, and integrating with tools like Autofs for automated mounting. Experiment with NFS in clustered environments or over VPNs. Study AWS Storage Gateway for hybrid storage solutions bridging on-premises NFS with S3.

#### Common Pitfalls
- Insufficient network connectivity causing mount failures; verify VPC peering or security groups.
- Incorrect permissions leading to access denied; check `/etc/exports` syntax and NFS server logs.
- No monitoring of storage usage; implement CloudWatch alarms for EFS metrics.
- Over-configuring security; balance accessibility with compliance (e.g., HIPAA for health data).
- Assuming unlimited NFS server capacity; unlike EFS, manual NFS is limited by underlying disk size.

#### Lesser-Known Facts
- NFS can be used across different cloud providers or from on-premises to cloud via secure tunnels.
- EFS supports bursting throughput based on file system size, beneficial for variable workloads.
- Root squashing prevents NFS from being a security vulnerability, but advanced setups use RPCSEC_GSS for encryption.
- NFS v4 adds support for delegations, reducing network round trips for improved performance. 

<Model ID: KK-CS45-V3>
