# Session 23: EFS (Elastic File System)

## Overview

This session focuses on AWS Elastic File System (EFS), a managed NFS-based file storage service that provides scalable, shared file storage for EC2 instances. EFS enables creating a centralized storage system where multiple instances can access the same data simultaneously, solving the challenge of data consistency across distributed systems.

> [!IMPORTANT]
> EFS uses NFS (Network File System) protocol behind the scenes and provides a file-level storage system that scales automatically without requiring capacity planning.

## Key Concepts

### EFS Fundamentals

#### Centralized Storage Concept
**Problem Statement**: Multiple EC2 instances running web servers that need identical data and content, but currently using separate EBS volumes leading to data drift and inconsistency.

**Solution**: EFS provides a shared, centralized storage pool accessible by multiple instances simultaneously.

```diff
! Client Request → Load Balancer → Web Server 1 or Web Server 2
  Both servers access identical data from shared EFS storage
```

#### EFS Architecture
- **Regional Service**: Available within an AWS region
- **Multi-AZ Deployment**: Automatic replication across multiple Availability Zones within a region
- **Mount Targets**: NFS endpoints in each AZ for connectivity
- **NFS Protocol**: Uses NFSv4.1 for file system access

### VPC Integration

#### Why VPC Matters for EFS
```diff
+ Network Boundary: VPC defines the network perimeter for EFS accessibility
- Without proper VPC: Complex networking configurations required
- With same VPC: Automatic network connectivity via private subnets
```

**Key Points**:
- EFS mount targets are created in subnets within your VPC
- Each Availability Zone gets its own mount target
- Security Groups control access to mount targets

#### Multi-AZ Setup Benefits
- **High Availability**: Storage survives AZ failures
- **Standard Storage Class**: Automatic multi-AZ replication
- **Performance**: Parallel access across AZs

### EFS Provisioning

#### Creation Process
1. Navigate to EFS service in AWS Console
2. Choose VPC (region-specific)
3. Configure mount targets across desired AZs
4. Set security groups for access control

#### Storage Classes
- **Standard**: Multi-AZ, general-purpose storage
- **One Zone**: Single AZ, cost-optimized for development

### Security Configuration

#### Security Groups for EFS
**Default Behavior**: EFS security groups deny all inbound traffic by default

**Required Action**: Modify security group to allow NFS traffic (port 2049)

```diff
- Default: All inbound traffic blocked
+ Required: Allow NFS (TCP 2049) from authorized sources
```

### Manual Mounting Process

#### Prerequisites
1. **Network Connectivity**: Instances and EFS in same VPC
2. **NFS Client**: Install NFS utilities (`nfs-utils` on Linux)
3. **Permissions**: Proper security group configuration

#### Step-by-Step Mounting

1. **Get EFS Endpoint**:
   ```
   # From EFS Console → Network section
   Mount target DNS name: fs-12345678.efs.region.amazonaws.com
   ```

2. **Install NFS Client**:
   ```bash
   sudo yum install -y nfs-utils  # Amazon Linux/CentOS
   sudo apt-get install -y nfs-common  # Ubuntu/Debian
   ```

3. **Create Mount Directory**:
   ```bash
   sudo mkdir -p /mnt/efs-data
   ```

4. **Mount EFS**:
   ```bash
   sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-12345678.efs.region.amazonaws.com:/ /mnt/efs-data
   ```

5. **Verify Mount**:
   ```bash
   df -h  # Shows mounted filesystem
   mount   # Lists all mounts
   ```

#### Mount Options Explained
- `nfsvers=4.1`: NFS version 4.1
- `rsize=1048576`: Read buffer size (1MB)
- `wsize=1048576`: Write buffer size (1MB)
- `hard`: Persistent retry on failures
- `timeo=600`: Timeout in deciseconds
- `retrans=2`: Retransmission count

### Automated Mounting (EC2 Launch Wizard)

#### New AWS Console Feature
- Attach EFS during EC2 instance launch
- Automatic security group creation
- Script-based mounting with user-data

#### Benefits
- **Simplified Setup**: No manual mount commands
- **Automatic Security**: Proper security groups created
- **User-Data Scripts**: Automated mounting on boot

### Demo: Multiple Web Servers with Shared EFS

#### Scenario Setup
**Objective**: Two web servers serving identical content from centralized EFS storage

**Configuration**:
```
Web Server 1 (EC2-1) ──┐
                     ├── NFS/EFS Mount ── Centralized Content
Web Server 2 (EC2-2) ──┘
```

#### Implementation Steps

1. **Create EFS Filesystem**
2. **Launch Web Servers** (with or without automated EFS attachment)
3. **Manual Mount** (if not using automated method)
4. **Create Content** on one server
5. **Verify** identical content from both servers

#### Data Consistency Demonstration
```bash
# On Web Server 1
echo "First line" > /var/www/html/index.html

# On Web Server 2
echo "Second line" >> /var/www/html/index.html

# Check from either server - both show same content
cat /var/www/html/index.html
# Output: First line
#         Second line
```

### Performance Concepts: IOPS vs Throughput

#### Understanding IOPS (Input/Output Operations Per Second)

**Definition**: Number of read/write operations a storage system can perform per second

**Key Factors**:
- **Random Access**: Frequent jumping between different data locations
- **Small Data Transfers**: Reading/writing small chunks of data

#### Understanding Throughput

**Definition**: Amount of data transferred per second (MB/s, GB/s)

**Key Factors**:
- **Sequential Access**: Continuous data reading/writing
- **Large Data Transfers**: Reading/writing large data blocks

```diff
+ IOPS: "How many times can I jump here and there per second?"
- Sequential Speed: "How fast can I read continuous data?"
```

#### Storage Hardware Types

##### SSD (Solid State Drive) Hard Disks
- **Characteristics**: Electronic chip-based storage
- **Strength**: Excellent for random I/O operations
- **Performance**: High IOPS capability
- **Use Cases**: Databases, web applications, random access patterns

##### HDD (Hard Disk Drive) Hard Disks
- **Characteristics**: Mechanical platters with spinning disks
- **Strength**: Excellent for sequential/continuous data access
- **Performance**: High throughput capability
- **Use Cases**: Log files, big data, sequential processing

#### AWS EBS Storage Classes

| Storage Class | IOPS | Throughput | Use Case | Cost |
|---------------|------|------------|----------|------|
| GP2 | Up to 16K | Variable | General purpose, databases | Medium |
| GP3 | Configurable | 1,000 MB/s | High IOPS + Throughput | Medium |
| IO1 (Provisioned IOPS) | Up to 64K | Variable | Mission-critical databases | High |
| IO2 | Up to 256K | Variable | High-performance databases | Very High |
| ST1 (Throughput Optimized HDD) | Limited | High | Big data, logs | Low |
| SC1 (Cold HDD) | Limited | Low | Infrequent access | Very Low |

## Lab Demos

### Demo 1: Manual EFS Mounting on Running Instance

**Prerequisites**:
- EC2 instance running Amazon Linux
- EFS filesystem created
- Both in same VPC

**Steps**:
1. Update EFS security group to allow NFS traffic
2. Install NFS client utilities
3. Get EFS mount target DNS name
4. Mount EFS using mount command
5. Verify successful mounting with `df -h`

### Demo 2: Shared Web Server Content

**Objective**: Demonstrate data consistency across multiple web servers

**Setup**:
```bash
# On Web Server 1
sudo yum install -y httpd
sudo systemctl start httpd
sudo mount -t nfs4 fs-xxxxxxxx.efs.region.amazonaws.com:/ /var/www/html

# Create content
echo "Shared Content" > /var/www/html/index.html

# On Web Server 2
sudo yum install -y httpd
sudo systemctl start httpd
sudo mount -t nfs4 fs-xxxxxxxx.efs.region.amazonaws.com:/ /var/www/html

# Verify content is identical
curl http://webserver1
curl http://webserver2
```

## Summary

### Key Takeaways
```diff
+ EFS enables shared file storage across multiple EC2 instances
+ Uses NFS protocol for file system access
+ Automatic scaling and multi-AZ replication
+ Manual mounting requires network connectivity and proper security
+ Performance metrics: IOPS for random access, Throughput for sequential
+ SSD excels at random I/O, HDD excels at sequential throughput
+ Choose storage class based on application requirements and cost
```

### Quick Reference

#### Common Commands
```bash
# Mount EFS
mount -t nfs4 fs-xxxxxxxx.efs.region.amazonaws.com:/ /mnt/efs

# Unmount EFS
umount /mnt/efs

# Check mounted filesystems
df -h

# Install NFS client
yum install -y nfs-utils
apt-get install -y nfs-common
```

#### EFS Limits
- Maximum throughput: Varies by storage class
- Minimum storage: No minimum charge beyond storage used
- Performance modes: General Purpose vs Max I/O

#### Security Group Configuration
- **Protocol**: NFS (TCP)
- **Port**: 2049
- **Source**: Security group of EC2 instances or specific CIDR

### Expert Insight

#### Real-World Application
EFS is commonly used for:
- **Content Management Systems**: Shared media and file storage
- **Web Applications**: Shared configuration and user uploads
- **Development Environments**: Shared code repositories
- **Machine Learning**: Shared datasets and model files
- **Container Persistent Storage**: Kubernetes persistent volumes

#### Expert Path
Master EFS by understanding:
1. Network architecture and VPC design
2. Security group best practices
3. Performance monitoring and optimization
4. Backup and disaster recovery strategies
5. Integration with other AWS services (ECS/EKS, Lambda)

#### Common Pitfalls
```diff
- ❌ Forgetting VPC compatibility requirements
- ❌ Using restrictive security groups without NFS access
- ❌ Not installing NFS client utilities
- ❌ Choosing wrong storage class for workload patterns
- ❌ Ignoring performance differences between SSD/HDD
- ❌ Forgetting EFS regional nature (not global)
- ❌ Using EFS for high-frequency random access without Max I/O mode
```

#### Lesser-Known Facts
- **Cross-Account Access**: EFS supports cross-account mounting via VPC peering
- **Encryption**: Data can be encrypted at rest using KMS
- **Lifecycle Policies**: Automatic movement to cheaper storage classes
- **Backup Integration**: Native integration with AWS Backup service
- **File Locking**: Supports NFS file locking for consistency
- **Performance Scaling**: Throughput scales with storage size automatically

---

*🤖 Generated with [Claude Code](https://claude.com/claude-code)*

*Co-Authored-By: Claude <noreply@anthropic.com>*

*Model ID: CL-KK-Terminal*
