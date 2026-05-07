# Session 24: Storage - EFS and NFS

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Importance of Storage](#importance-of-storage)
  - [Types of Storage](#types-of-storage)
  - [EFS - Elastic File System](#efs---elastic-file-system)
    - [Creating EFS](#creating-efs)
    - [Mounting EFS to EC2 Instances](#mounting-efs-to-ec2-instances)
    - [Demo: Running a Web Server with EFS](#demo-running-a-web-server-with-efs)
  - [Setting Up Your Own NFS Server](#setting-up-your-own-nfs-server)
    - [Configuring NFS Server](#configuring-nfs-server)
    - [Mounting as NFS Client](#mounting-as-nfs-client)
    - [Permissions and Security](#permissions-and-security)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
This session focuses on storage services in AWS, emphasizing why storage is critical for applications and data management. It begins by reviewing AWS's origin from S3 and expands to file storage using Elastic File System (EFS) and custom Network File System (NFS) setups on Linux. The goal is to understand block, file, and object storage types, with hands-on demos for EFS creation, mounting, and basic NFS server configuration.

## Key Concepts and Deep Dive

### Importance of Storage
Storage underpins every IT operation, from initial data gathering to production deployments. AWS began with S3 (Simple Storage Service) as its flagship object storage, enabling URL-based file sharing. Over time, it added compute, networking, and other storage types. Understanding storage is essential for:
- Deploying web applications or containers that require data persistence.
- Avoiding hardware purchases by renting cloud resources.
- Selecting the right storage based on use cases (high availability, cost, scalability).

> [!NOTE]  
> Storage is a core AWS certification topic, critical for roles like Cloud Engineer.

### Types of Storage
AWS offers three primary storage types:

| Type          | AWS Service | Use Case | Details |
|---------------|-------------|----------|---------|
| Block Storage | EBS (Elastic Block Store) | Databases, OS root volumes | Provides persistent, low-latency block-level access; attached to instances like virtual hard drives. |
| File Storage  | EFS (Elastic File System) | Shared file systems, web servers | Serverless, scalable file storage with NFS compatibility; multi-AZ for high availability or single AZ for cost savings. |
| Object Storage| S3 (Simple Storage Service) | Static websites, backups, media | URL-accessible storage; highly durable, accessible via APIs; supports static websites and content delivery. |

- **Object Storage** (e.g., S3): Ideal for unstructured data; user-friendly, no hardware management.
- **Block Storage** (e.g., EBS): Tightly coupled to instances; fixed size.
- **File Storage** (e.g., EFS or NFS): NAS (Network Attached Storage); scalable, shared across instances.

### EFS - Elastic File System
EFS is AWS's serverless file storage, built on NFS. It provides scalable, shared storage without managing servers. Key features:
- **Elastic**: Grows/diminishes automatically; pay only for used space.
- **High Availability**: Standard mode replicates across multiple AZs; One Zone mode saves costs for non-critical data.
- **Serverless**: No server management required.
- **Use Cases**: Web serving, content management, big data applications.

#### Creating EFS
1. Navigate to AWS Console > EFS > Create file system.
2. Name it (e.g., "EFS-Test-1").
3. Select VPC (default is recommended for initial setups).
4. Choose storage class:
   - **Standard**: Multi-AZ for availability.
   - **One Zone**: Single AZ for cost-efficiency.
5. Review and create; EFS handles security groups automatically.

💡 **Expert Insight**: Standard EFS suits critical apps (e.g., Instagram uploads); One Zone for archival data (e.g., old photos).

#### Mounting EFS to EC2 Instances
EFS mounts via DNS name, integrating with security groups.

**Prerequisites**: EC2 instances in the same VPC/subnet with HTTPD (Apache) installed via `yum install httpd`.

**Steps**:
1. Launch EC2 instances (use Amazon Linux for easy console access).
2. From EFS > Network: Note DNS name (e.g., `fs-12345678.efs.us-east-1.amazonaws.com`).
3. On EC2: Update security groups if needed (allow inbound traffic; EFS auto-creates groups).
4. Mount example:
   ```
   sudo yum install -y nfs-utils  # If not installed
   sudo mkdir /mnt/efs
   sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-12345678.efs.us-east-1.amazonaws.com:/ /mnt/efs
   ```
5. Verify with `df -h`; mount persists per session or add to `/etc/fstab` for permanence.

⚠️ **Warning**: Security group mismatches cause mount failures; always verify inbound rules.

#### Demo: Running a Web Server with EFS
**Objective**: Share web content across multiple EC2 instances using EFS.

**Steps**:
1. Launch two EC2 instances; install httpd.
2. Create EFS as above.
3. Mount EFS to `/var/www/html` on both instances.
4. On first instance: Create `index.html` with content (e.g., "Website is working").
5. Access second instance via public IP; verify shared content.
6. Update content on second instance; observe sync across instances.

This demonstrates shared persistence: File changes propagate instantly via network.

### Setting Up Your Own NFS Server
For custom control, configure NFS on Linux (EC2). NFS uses protocols like NFS4 for secure, performant sharing.

**Architecture**: NFS Server shares folders; clients mount them (e.g., IP-based制限s for security).

**Steps**:
1. **Install NFS-utils**:
   ```
   sudo yum install -y nfs-utils
   ```
   This includes server/client tools.

2. **Start NFS Server**:
   ```
   sudo systemctl start nfs-server
   sudo systemctl enable nfs-server
   ```

3. **Configure Exports** (/etc/exports):
   - Define shared folders and permissions.
   - Example: Share `/share` folder to client IP `172.31.x.x` with read-write, no root squash:
     ```
     /share 172.31.x.x(rw,no_root_squash)
     ```
   - Reload: `sudo exportfs -a && sudo systemctl restart nfs-server`
   - Verify: `showmount -e localhost`

#### Mounting as NFS Client
1. On client: Install nfs-utils, ensure network connectivity (same VPC).
2. Mount example:
   ```
   sudo mkdir /mnt/share
   sudo mount -t nfs server_ip:/share /mnt/share
   ```
3. Verify with `df -h`; test file operations.

#### Permissions and Security
- **Read-Only vs. Read-Write**: Use `ro` or `rw` in /etc/exports.
- **Root Squash**: Prevents client root from owning server files (default: `root_squash`); disable with `no_root_squash` for full access.
- **Port Configuration**: NFS uses ports (e.g., 2049); customize via /etc/sysconfig/nfs for firewalls.
- **Security**: Restrict by IP/range; avoid wildcard (*) in production.

**Differences from EFS**:
- EFS: Serverless, unlimited scalability, automated security.
- Custom NFS: Fixed to host's storage (e.g., 8GB EBS), manual config, cost-effective for simple setups.

With good network (e.g., 5G-enabled), perform remote mounts for hybrid storage.

## Lab Demos
### Demo 1: EFS Creation and Multi-Instance Sync
- Create EFS via console.
- Launch two EC2 instances.
- Mount EFS; install/start httpd.
- Create/edit files (e.g., index.html); verify across instances.
- Command reference:
  - Mount: `mount -t nfs fs-dns:/ /var/www/html`
  - Verify: `df -h && ls /var/www/html`

### Demo 2: Custom NFS Server Setup
- On one EC2: Install nfs-utils, start server, configure /etc/exports.
- On another EC2: Mount shared folder.
- Test r/w permissions; observe root squash effects.
- Commands:
  - Server: `vim /etc/exports`, `systemctl restart nfs-server`, `exportfs -a`
  - Client: `mount -t nfs server_ip:/share /mnt/share`

## Summary

### Key Takeaways
```diff
+ Storage is foundational: Block (EBS) for fixed needs, File (EFS/NFS) for shared/scalable, Object (S3) for distributed.
+ EFS advantages: Serverless, elastic, multi-AZ high availability; ideal for dynamic web apps.
+ NFS flexibility: Custom control on Linux; suitable for controlled environments with fixed storage.
- Avoid misconfigurations: Security groups can block mounts; always test network connectivity.
! Follow instructor flow: Emphasize practicals—launch instances, mount, test access.
```

### Quick Reference
- **Create EFS**: Console > EFS > Name/VPC > Choose Standard/One Zone.
- **Mount EFS**: `mount -t nfs fs-dns:/ /mount-point`
- **Start NFS Server**: `systemctl start nfs-server && exportfs -a`
- **/etc/exports Example**: `/share client_ip(rw,no_root_squash)`
- **Mount NFS**: `mount -t nfs server_ip:/share /local-dir`
- **Verify Mounts**: `df -h`

### Expert Insight
#### Real-World Application
In production, use EFS for Kubernetes pods or multi-server web farms needing shared config/files. Custom NFS suits on-prem/private clouds for cost control. For high-speed needs (e.g., IoT/5G), prioritize low-latency mounts.

#### Expert Path
- Master AWS VPCs/subnets: EFS/NFS require network-awareness.
- Learn advanced EFS: Lifecycle policies, encryption, performance modes.
- Practice partitioning/formatting: Essential for block storage beyond this session.

#### Common Pitfalls
- Security group issues: Add inbound rules (NFS port 2049) manually if auto-groups fail.
- Space limits: Custom NFS bound by host EBS—monitor with `df`.
- Permissions errors: Enable `no_root_squash` cautiously; it's a security risk.

#### Lesser-Known Facts
- EFS originated from NFSv4; AWS abstracts server management.
- Root squash protects against privilege escalation in NFS.
- EFS scales to petabytes without user intervention, unlike physical NAS.
