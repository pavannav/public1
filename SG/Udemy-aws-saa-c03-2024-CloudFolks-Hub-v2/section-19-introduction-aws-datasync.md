# Section 19: AWS DataSync and Storage Gateway

<details open>
<summary><b>Section 19: AWS DataSync and Storage Gateway (CL-KK-Terminal)</b></summary>

## Table of Contents
- [19.1 Introduction AWS Datasync](#191-introduction-aws-datasync)
- [19.2 AWS Datasync Hands-On-1](#192-aws-datasync-hands-on-1)
- [19.3 AWS Datasync Hands-On-2](#193-aws-datasync-hands-on-2)
- [19.4 AWS Datasync Hands-On-3](#194-aws-datasync-hands-on-3)
- [19.5 AWS Datasync Hands-On-4](#195-aws-datasync-hands-on-4)
- [19.6 Introduction Of Storage Gateway](#196-introduction-of-storage-gateway)
- [19.7 Storage Gateway File Gateway (On Premise Lab) Hands-On](#197-storage-gateway-file-gateway-on-premise-lab-hands-on)
- [19.8 Storage Gateway File Gateway (Cloud Lab) Hands-On](#198-storage-gateway-file-gateway-cloud-lab-hands-on)
- [19.9 Storage Gateway Volume Gateway](#199-storage-gateway-volume-gateway)
- [19.10 Storage Gateway TLV (Tape Gateway)](#1910-storage-gateway-tlv-tape-gateway)
- [19.11 AWS DataSync Vs Storage Gateway](#1911-aws-datasync-vs-storage-gateway)

## 19.1 Introduction AWS Datasync

### Overview
This introductory video explains AWS DataSync as a key service for moving data between on-premises storage and AWS services. It focuses on two main use cases: copying data between AWS storage systems and transferring data from on-premises storage to AWS.

### Key Concepts/Deep Dive
AWS DataSync is an online data transfer service that simplifies, automates, and accelerates moving data between on-premises storage systems (such as NFS or SMB file servers) and AWS storage services like S3, EFS, and FSX.

#### Two Primary Use Cases:
1. **Copying Data Between AWS Storage Systems**:
   - Transfer data between S3 and EFS
   - Transfer data between EFS and FSX
   - Any AWS storage service combination using DataSync

2. **Transferring Data from On-Premises to AWS**:
   - Move data from on-premises NFS or SMB shared storage to AWS S3, EFS, or FSX
   - Enables backup, data migration, and archive cold data in the cloud

### Lab Planning
- Lab demonstrations will be covered in subsequent videos
- Practical implementation will show step-by-step setup and data transfer processes

## 19.2 AWS Datasync Hands-On-1

### Overview
This hands-on video demonstrates the first use case of AWS DataSync: transferring data between different AWS storage services, specifically from S3 to EFS within the same AWS environment.

### Key Concepts/Deep Dive
DataSync handles moving data between AWS storage systems without requiring on-premises infrastructure, unlike on-premises to AWS transfers which need the DataSync agent.

#### Lab Setup and Configuration
**Prerequisites:**
- S3 bucket with test data (pictures in this example)
- Amazon EFS filesystem
- EC2 instance for testing EFS access

**Step-by-Step DataSync Setup:**

1. **Create Source S3 Bucket**:
   ```bash
   # Create bucket named 'data-sync-test02'
   # Upload test files (images)
   ```

2. **Create Target EFS Filesystem**:
   ```bash
   # In EFS console: Create file system
   # Configure mount targets for specific availability zones
   # Test mount on Linux EC2 instance
   ```

3. **Configure DataSync Task**:
   ```bash
   # Navigate to DataSync service
   # Choose "Between AWS storage services"
   # Source: Amazon S3, select bucket
   # Auto-generate IAM role for S3 access
   # Destination: EFS, select filesystem, root path "/"
   ```

4. **Task Execution**:
   ```bash
   # Start task immediately
   # Monitor execution details
   # Verify transferred files: Transfer summary shows file count and data size
   # Validate in EFS by checking mounted filesystem
   ```

### Lab Lab Results
- Successfully transferred test files from S3 to EFS
- Task shows 9 files transferred within minutes
- Files visible in EFS mount point on EC2 instance

### Clean-Up
- Delete EFS filesystem and DataSync task when done

## 19.3 AWS Datasync Hands-On-2

### Overview
This hands-on video covers transferring data from on-premises storage to AWS cloud using DataSync, demonstrating a real-world hybrid cloud scenario.

### Key Concepts/Deep Dive
This lab requires virtualization software (VMware Workstation, Fusion) and Windows Server 2012 ISO. Sets up a Windows SMB server as on-premises storage and transfers files to S3 bucket.

#### Lab Requirements
- VMware Workstation or supported hypervisor
- Windows Server 2012 ISO (evaluation version available)
- Sufficient RAM (8GB+) and CPU resources
- Network connectivity for AWS access

#### Lab Setup Components
1. **Virtual Windows SMB Server (On-Premises Storage)**:
   - Install Windows Server 2012 in VMware
   - Configure IP address in same network range as host
   - Enable SMB sharing with test files
   - Set administrator credentials

2. **DataSync Agent (Virtual Appliance)**:
   - Download VMware-compatible OVA from AWS console
   - Import and configure in VMware
   - Assign static IP and configure network settings
   - Test AWS connectivity using public service endpoint

3. **AWS Preparation**:
   - Create S3 bucket (e.g., 'on-prem-data01')
   - IAM role auto-generation for DataSync

#### Step-by-Step Configuration
1. **Setup Windows SMB Server**:
   ```bash
   # Assign static IP (example: 192.168.1.100)
   # Default gateway same as host network
   # Create shared folder: \\server\\data with full permissions
   # Add test files (documents, images)
   ```

2. **Install and Configure DataSync Agent**:
   ```bash
   # Import OVA in VMware
   # Allocate minimum 4GB RAM, 2 vCPUs
   # Configure static IP (192.168.1.101)
   # Test connectivity and synchronize time with AWS
   # Activate agent via AWS console using private IP
   ```

3. **Create DataSync Task**:
   ```bash
   # Source: SMB, server IP, share name ('data'), credentials
   # Destination: S3 bucket
   # Task settings: Transfer all data, verify data integrity
   # Schedule: Manual execution
   ```

4. **Execute Task**:
   ```bash
   # Start execution manually
   # Monitor transfer: ~23 seconds for test transfer
   # Verify in S3: Files present matching on-premises data
   ```

### Common Issues and Solutions
- **SMB Connection Issues**: Ensure correct credentials and network connectivity
- **Agent Connectivity**: Use appropriate IP (private for same network, public if needed)
- **File Permissions**: Configure proper SMB share and user permissions

### Alternative Lab Approach
For users without virtualization resources, the next video demonstrates cloud-only implementation.

## 19.4 AWS Datasync Hands-On-3

### Overview
This hands-on video demonstrates a cloud-only alternative to the previous lab, avoiding virtualization requirements by deploying everything in AWS EC2.

### Key Concepts/Deep Dive
Simulates on-premises environment using AWS services: Windows Server EC2 as "on-premises" storage, DataSync agent as another EC2 instance, and S3 as cloud destination.

#### Lab Architecture (Cloud Simulation)
```
On-Premises Server (EC2 Windows) → DataSync Agent (EC2) → S3 Bucket
```

#### AMI ID Retrieval for DataSync Agent
To launch DataSync agent in EC2, get region-specific AMI ID:
```bash
aws ssm get-parameters-by-path --path /aws/service/datasync/ --region ap-south-1 --query "Parameters[].Name"
# Returns AMI ID for Mumbai region (ap-south-1)
```

#### Setup Steps
1. **Launch Windows Server EC2 (Source)**:
   ```bash
   # Launch Windows Server 2012
   # Enable RDP access
   # Configure shared folder with test files
   ```

2. **Deploy DataSync Agent EC2**:
   ```bash
   # Launch EC2 using retrieved AMI ID
   # Instance type: t2.xlarge (minimum 4GB RAM)
   # Enable internet access for activation
   ```

3. **Configure and Activate Agent**:
   - Connect via console or SSH as admin/admin
   - Configure static network or use DHCP
   - Test AWS connectivity
   - Activate via AWS console using public IP
   - Create SMB DataSync task

4. **Execute Data Transfer**:
   ```bash
   # Start manual execution
   # Monitor transfer progress and completion
   ```

### Lab Benefits
- No virtualization software required
- All resources in AWS (cost-effective for short labs)
- Demonstrates DataSync in cloud infrastructure

### Cost Considerations
- ~₹10-15 per hour for EC2 instances
- Recommended termination immediately after lab

## 19.5 AWS Datasync Hands-On-4

### Overview
This video covers AWS DataSync benefits, use cases, and theoretical aspects without additional hands-on labs.

### Key Concepts/Deep Dive
DataSync is positioned as AWS's primary online data transfer service, emphasizing advantages over alternatives like Snowball for certain scenarios.

#### Core Use Cases
1. **Data Migration**: Move large datasets from on-premises to AWS
2. **Cold Data Archiving**: Archive infrequently accessed data to cloud storage
3. **Data Protection**: Implement cloud backup strategies
4. **Timely Data Processing**: Transfer data for cloud computing workloads

#### Key Benefits
1. **Simplified and Automated Data Movement**
   - Pre-configured virtual machine agent
   - Web-based management console
   - Automated transfer processes

2. **TLS-Encrypted Transfers**
   - Secure data transmission with TLS encryption
   - Supports industry standards for data protection

3. **Reduced Operational Costs**
   - More cost-effective than physical data transfer methods for ongoing transfers
   - Automated operations reduce manual intervention

4. **Fast and Reliable Transfers**
   - Resume-capable transfers handle network interruptions
   - Parallel processing capabilities for improved speed

5. **Operational Efficiency**
   - Scheduled or on-demand data transfers
   - Minimal system failures due to automation
   - Human error reduction in data movement processes

### Why DataSync Over Snowball
- Suitable for incremental data transfers vs. one-time bulk migrations
- Better for scenarios requiring frequent updates
- Cost-effective for smaller, ongoing data movements

### Exam Focus
> [!IMPORTANT]
> Theoretical concepts and use cases are crucial for AWS certification exams. Focus on benefits, use cases, and differentiation from other AWS data transfer services.

## 19.6 Introduction Of Storage Gateway

### Overview
This introduction video covers AWS Storage Gateway as a hybrid cloud storage service providing seamless integration between on-premises IT environments and AWS cloud storage.

### Key Concepts/Deep Dive
Storage Gateway bridges on-premises applications and cloud storage by deploying a virtual appliance that creates local storage interfaces while automatically syncing data to AWS.

#### Core Definition
A hybrid cloud storage service enabling on-premises access to virtually unlimited cloud storage by linking applications to Amazon S3, EFS, EBS, or Glacier.

#### Key Components
1. **Virtual Appliance Deployment**
   - VM image downloaded and installed on VMware ESXi, Microsoft Hyper-V, or Linux KVM
   - Locally-hosted in on-premises data centers

2. **Storage Interfaces**
   - Provides familiar storage protocols to existing applications
   - Three main gateway types available

#### Storage Gateway Types
1. **File Gateway**: NFS/SMB interface for file-based storage
2. **Volume Gateway**: iSCSI block storage interface
3. **Tape Gateway**: Virtual tape library (VTL) interface

> [!NOTE]
> File Gateway acts as a bridge between on-premises file protocols and S3, while Volume Gateway provides block-level iSCSI storage with cloud-backed volumes.

#### Use Case Scenario
When companies need additional storage capacity but don't want to purchase expensive hardware, Storage Gateway provides a software-defined storage solution that scales to cloud storage limits.

### Deployment Process
1. Download VM image
2. Install on supported hypervisor
3. Configure network and AWS connectivity
4. Activate through AWS Management Console
5. Choose gateway type and configure storage options

> [!TIP]
> Storage Gateway complements DataSync for hybrid cloud storage strategies, providing both data movement and storage abstraction services.

## 19.7 Storage Gateway File Gateway (On Premise Lab) Hands-On

### Overview
This hands-on video demonstrates setting up AWS Storage Gateway File Gateway in a virtualized on-premises environment using VMware Workstation.

### Key Concepts/Deep Dive
File Gateway creates a centralized, S3-backed file storage system for on-premises servers. Unlike DataSync which transfers existing data, File Gateway provides new storage capacity.

#### Prerequisites
- VMware Workstation with sufficient resources (8-16GB RAM, i5 equivalent CPU, 200GB+ SSD space)
- Windows Server 2012 virtual machines for application and database servers
- SSD storage recommended for optimal performance

#### Lab Scenario
Simulates centralized file storage for multiple on-premises servers:
- Application server requiring shared storage
- Database server requiring shared storage
- File Gateway providing unified, cloud-backed storage

#### Step-by-Step Setup
1. **Create Virtual Machines**:
   ```bash
   # VMware Workstation: Custom VM creation
   # Windows Server 2012 for Application and Database servers
   # Allocate 2 vCPUs, 2GB RAM, 60GB storage each
   ```

2. **Configure Server Networking**:
   ```bash
   # Listen to INNER CIRCLE assembly videos for VMware networking
   # Configure bridge mode for AWS connectivity
   # Assign static IPs in same network range
   ```

3. **Deploy Storage Gateway Appliance**:
   ```bash
   # Download VMware OVA file
   # Import to VMware Workstation
   # Allocate 8GB RAM, create network adapters
   # Add cache disk (150GB recommended, 20GB minimum for testing)
   ```

4. **Configure Gateway Network**:
   - Boot gateway VM (username: admin, password: password)
   - Configure static IP via console interface
   - Test AWS connectivity and synchronize time
   - Activate gateway via AWS console using IP address

5. **SMB Configuration**:
   ```bash
   # Enable SMB guest access with password
   # Configure guest user authentication
   ```

6. **Create File Share**:
   ```bash
   # Select S3 bucket as storage destination
   # Configure NFS/SMB protocols
   # Enable data encryption
   # Create IAM role for S3 access
   ```

7. **Mount File Share on Servers**:
   ```bash
   net use Z: \\[GATEWAY_IP]\[SHARE_NAME] /user:[CREDENTIALS]
   ```
   - Map network drive on Windows servers
   - Test file creation and access

#### Lab Results
- Centralized Z: drive available on all servers
- Files stored locally in cache, automatically uploaded to S3
- Cross-server file access through shared storage

### Performance Considerations
- Use SSD storage for optimal gateway performance
- Monitor cache utilization for capacity planning

## 19.8 Storage Gateway File Gateway (Cloud Lab) Hands-On

### Overview
This hands-on video replicates the previous File Gateway lab entirely in AWS using EC2 instances, eliminating virtualization requirements.

### Key Concepts/Deep Dive
Cloud-based File Gateway simulation maintains the same architecture while using EC2 instances to replace on-premises virtualization.

#### Cloud Architecture
```
Application Server (EC2) → Database Server (EC2) → File Gateway (EC2) → S3 Bucket
192.168.1.50        192.168.1.51        Gateway IP       sg-storage-file
```

#### EC2-Based Deployment
1. **Launch Windows Servers EC2**:
   ```bash
   # Two Windows Server 2012 instances
   # Enable RDP access
   # Launch and connect via RDP
   ```

2. **Deploy File Gateway EC2**:
   ```bash
   # Get AMI ID via AWS CLI
   aws ssm get-parameters-by-path --path /aws/service/storage-gateway/ --region ap-south-1
   # Launch EC2 with AMI ID, t2.xlarge type
   ```

3. **Attach EBS Volumes**:
   - Gateway requires additional EBS volume for cache
   - Attach 25GB EBS volume for demonstration

4. **Gateway Configuration**:
   ```bash
   # Activate via AWS console
   # Create file share with SMB protocol
   # Configure guest access credentials
   ```

5. **Mount on Application Servers**:
   ```bash
   # Use public IPs for cloud connectivity
   # Map network drives with SMB credentials
   ```

#### Cost Management
- Terminate instances immediately after lab completion
- Charge approximately ₹50-100 for brief EC2 usage
- Monitor AWS billing for real-time cost tracking

### Comparisons
- **On-Premises vs Cloud**: Same functionality, cloud eliminates virtualization complexity
- **Resource Requirements**: Cloud reduces local hardware needs
- **Cost**: Pay-per-use vs. capital expense for on-premises hardware

## 19.9 Storage Gateway Volume Gateway

### Overview
This video introduces AWS Storage Gateway's Volume Gateway, the second gateway type that provides block-level iSCSI storage services.

### Key Concepts/Deep Dive
Volume Gateway delivers block storage volumes via iSCSI protocol, presenting drive letters to on-premises servers while storing data in the cloud.

#### Gateway Types
1. **Cached Volume**: Primary working data cached locally, changed data uploaded to cloud
2. **Stored Volume**: All data stored locally with scheduled snapshots to cloud

#### Demonstration Architecture
```
On-Premises Server (EC2) → Volume Gateway (EC2) → EBS Volume → S3/AWS Backup
iSCSI Connection         20GB Volume         
```

#### Step-by-Step Setup (Cloud Simulation)
1. **Deploy Volume Gateway EC2**:
   ```bash
   # Use AMI ID for Volume Gateway
   # Launch t2.xlarge instance
   # Attach 25GB+ EBS volume for cache/upload buffer
   ```

2. **Gateway Activation**:
   - Configure network settings
   - Activate via AWS console
   - Allocate local storage for cache (20GB EBS volume)

3. **Create Storage Volume**:
   ```bash
   # Provision 20GB iSCSI volume
   # Configure iSCSI target settings
   ```

4. **iSCSI Connection**:
   ```bash
   # Connect Windows server to iSCSI target
   # Initialize and format new volume
   # Mount as drive letter (e.g., D:)
   ```

5. **Volume Operations**:
   ```bash
   # Install software to verify block storage functionality
   # Demonstrate cloud backup capabilities
   ```

#### Volume Gateway Features
- **Block Storage Interface**: Provides raw disk partitions via iSCSI
- **Cloud Integration**: 
  - EBS snapshots for point-in-time backups
  - AWS Backup service integration
  - Automatic backup scheduling
- **Software Installation**: Unlike File Gateway, supports application installation on mounted volumes

### Use Case Comparison
| Feature | File Gateway | Volume Gateway |
|---------|-------------|----------------|
| Protocol | NFS/SMB | iSCSI |
| Use Case | File sharing | Application storage |
| Cloud Storage | S3 | EBS/AWS Backup |
| Software Support | No | Yes |

### Benefits
- Secure, reliable volume backups in cloud
- Fast volume recovery from EBS snapshots
- Integration with AWS backup ecosystem

## 19.10 Storage Gateway TLV (Tape Gateway)

### Overview
This video covers the third Storage Gateway type: Tape Gateway (Virtual Tape Library or VTL), though no hands-on lab is performed due to complex requirements.

### Key Concepts/Deep Dive
Tape Gateway modernizes legacy tape backup systems by virtualizing tape libraries while storing data in S3 and Glacier.

#### Physical Tape Backup Characteristics
- Small tapes store large amounts of data (GBs to TBs)
- Higher durability than optical media (CD/DVD)
- Used for long-term archival and compliance data

#### Tape Gateway Solution
- Virtual Tape Library (VTL) replaces physical tape infrastructure
- Compatible with leading backup applications (Veeam, etc.)
- Data stored in S3 Standard (active) or Glacier/Deep Archive (archived)

#### Key Features
1. **iSCSI VTL Interface**: 
   - Drop-in replacement for physical tape libraries
   - Compatible with existing backup software (Veeam, Commvault, etc.)

2. **Automated Data Management**:
   - Active tapes: S3 Standard storage
   - Ejected/archived tapes: Glacier or Deep Archive
   - Automatic verification and lifecycle management

3. **Security and Compression**:
   - Data compression and encryption in transit/at rest
   - Automatic integrity checks

### Benefits
- **Seamless Migration**: Maintain existing backup workflows without changes
- **Cost Efficiency**: Store archival data in Deep Archive (< $1/TB/month)
- **Reliability**: Eliminate physical tape management hassles (loss, degradation, storage space)

## 19.11 AWS DataSync Vs Storage Gateway

### Overview
This video clarifies the key differences between AWS DataSync and Storage Gateway, addressing common confusion in hybrid cloud scenarios.

### Key Concepts/Deep Dive
While both services handle data movement between on-premises and AWS, they serve different purposes and architectures.

#### Core Differences
| Aspect | AWS DataSync | AWS Storage Gateway |
|--------|-------------|-------------------|
| **Purpose** | Data transfer service | Virtual storage appliance |
| **Infrastructure** | Requires existing storage | Provides new storage capacity |
| **Gateway Types** | Single service | File, Volume, Tape gateways |
| **Use Cases** | Migrate existing data | Add cloud-backed storage |

#### DataSync Characteristics
- **Agent-Based**: Virtual machine connects to existing storage systems
- **Transfer Protocols**: NFS, SMB, object storage APIs
- **Destinations**: S3, EFS, FSX, Snowcone
- **When to Use**: You have existing storage and need to copy data to AWS

#### Storage Gateway Characteristics
- **Storage Provisioning**: Creates virtual storage systems (NAS, SAN, VTL)
- **Interface Protocols**: NFS, SMB, iSCSI, tape
- **Cloud Integration**: Seamlessly connects to S3, EBS, Glacier
- **When to Use**: You need additional storage capacity without physical hardware

#### Hybrid Usage
DataSync and Storage Gateway can be used together:
- Storage Gateway for primary storage in hybrid environments
- DataSync for automated data movement and backup scheduling

### Decision Framework
> [!IMPORTANT]
> **Choose DataSync when**: You have existing on-premises storage and need to migrate data to AWS.
> 
> **Choose Storage Gateway when**: You need to expand storage capacity and want cloud-backed storage without purchasing hardware.

### Conclusion
- DataSync: Data migration and synchronization tool
- Storage Gateway: Virtual storage infrastructure for hybrid cloud architectures

## Summary

### Key Takeaways
```diff
+ AWS DataSync enables efficient online data transfers between on-premises storage and AWS services, focusing on migration and synchronization scenarios.
+ Storage Gateway provides virtual storage appliances that extend AWS cloud storage to on-premises environments through File, Volume, and Tape gateway types.
+ DataSync requires existing storage systems, while Storage Gateway creates new cloud-backed storage capacity.
+ File Gateway serves NAS file sharing needs with S3 backend, Volume Gateway provides iSCSI block storage, and Tape Gateway modernizes legacy backup systems.
+ Real-world hybrid cloud strategies often combine both services: Storage Gateway for storage abstraction and DataSync for data movement orchestration.
```

### Quick Reference
**DataSync Common Commands:**
```bash
# List agent command capabilities
# (No CLI tools - management through AWS console)

# Task scheduling options
- Hourly: Regular incremental transfers
- Manual: On-demand synchronization
```

**Storage Gateway Mount Commands:**
```bash
# NFS mount (Linux)
mount -t nfs [GATEWAY_IP]:/[SHARE_NAME] /mnt/storage

# SMB mount (Windows)
net use Z: \\[GATEWAY_IP]\[SHARE_NAME] /user:guest [PASSWORD]

# iSCSI connection (Windows)
# Use iSCSI Initiator to connect targets
```

### Expert Insight

#### Real-world Application
DataSync and Storage Gateway form the backbone of enterprise hybrid cloud storage strategies. Organizations use Storage Gateway to migrate workload storage to cloud-backed services, then leverage DataSync for automated data protection, disaster recovery, and multi-site data synchronization across global operations.

#### Expert Path
Master hybrid cloud data management by understanding storage protocols (NFS, SMB, iSCSI), cloud storage services (S3, EBS, Glacier), and integration with backup solutions (AWS Backup, third-party tools). Focus on performance optimization, cost management, and security configurations for complex enterprise environments.

#### Common Pitfalls
- Overlooking cache size requirements for Storage Gateway performance
- Misconfiguring authentication for SMB/iSCSI connections
- Not planning for data transfer costs and bandwidth limitations
- Ignoring compatibility between backup software and Gateway types
- Failing to implement proper monitoring and alerting for transfer failures

#### Lesser-Known Facts
DataSync can automatically detect and transfer only changed data blocks, significantly reducing transfer times and costs for incremental backups. Storage Gateway's File Gateway supports Microsoft DFS Namespaces for seamless integration with existing Windows file server environments.

</details>
