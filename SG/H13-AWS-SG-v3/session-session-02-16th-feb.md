# Session 02: OS Launching Concepts and EC2 Introduction

## Table of Contents
- [Overview](#overview)
- [Key Concepts / Deep Dive](#key-concepts--deep-dive)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
Session 2 marks day two of the AWS Cloud training, transitioning from foundational roadmap discussions to core technical concepts. The session introduces fundamental operating system launching methodologies (bare metal, virtualization, and containerization) and connects these concepts to AWS Cloud services, particularly EC2. It establishes the theoretical foundation for cloud computing while demonstrating practical AWS usage, emphasizing cost optimization and real-world application.

## Key Concepts / Deep Dive
### Greeting and Session Administration
The session begins with instructor greeting and attendance check, reinforcing the importance of live learning. Key administrative points include:
- Recordings from Session 1 uploaded to learning portal, not provided going forward to encourage live attendance
- Google Drive screenshots for each classroom session
- Task assignment: Write blogs/articles about Session 1 content, post on LinkedIn
- Learning portal access granted to all participants
- Emphasis on dedication and commitment for progression to advanced phases (OpenStack, private cloud, startup creation)
- Attendance via self-reflection posts on LinkedIn

### OS Launching Fundamentals
#### Purpose of Operating Systems
Any operating system (Windows, Linux, Mac) exists solely to run applications/software. The core requirement across all computing environments is to execute programs/apps.

#### Three Ways to Launch OS
There are only three technological approaches to launch (install) operating systems worldwide:

##### 1. Bare Metal Installation
- **Definition**: Direct installation on physical hardware (servers, laptops, desktops)
- **Characteristics**: 
  - Installs OS directly on real hardware (RAM, CPU, HDD)
  - Known as "bare metal OS" or simply OS
  - Constraint: Can only run one OS per physical hardware at any time
- **Process**: Boot/install power on the physical machine

##### 2. Virtualization
- **Definition**: Introduces "hypervisor" programs enabling multiple OS instances on single hardware
- **Key Technology**: Hypervisor (software/program creating virtual environments)
- **Benefits**: 
  - Enables multiple independent OS on shared physical resources
  - Solves bare metal limitation of single OS per hardware
  - Cost savings through resource sharing
- **Popular Hypervisors**:
  - VMware ESXi (commercial)
  - Oracle VirtualBox (free)
  - Xen (open-source)
  - KVM (open-source)
  - Microsoft Hyper-V
- **Terminology**:
  - Host machine: Physical hardware running Windows with hypervisor
  - Guest machines/VMs: Virtual OS instances (Linux, Ubuntu, Windows, etc.)
  - OS launch time: Typically 1-2 hours (depends on OS size/hypervisor)

##### 3. Containerization
- **Definition**: Modern technology for ultra-fast OS deployment using "container runtime" programs
- **Key Technology**: Containerization engine (programs like Docker, Podman, Rocket)
- **Benefits**:
  - OS launch within seconds (agility, time-to-market)
  - Shares physical resources like virtualization
- **Comparison Table**:

| Aspect | Virtualization | Containerization |
|--------|----------------|------------------|
| Launch Time | 1-2 hours | Within seconds |
| Resource Usage | Shares RAM/CPU but heavyweight | Lightweight sharing |
| Use Case | Traditional applications | Modern cloud-native apps |
| Examples | VMware, Hyper-V | Docker, Kubernetes |

### Cloud Computing Abstraction
Cloud computing targets the core challenge: Operating systems need hardware, but companies don't want hardware management responsibilities.

#### Service Model Evolution
1. **Traditional Approach**: Customer manages hardware, installs OS, runs apps
2. **Cloud Service**: Provider offers services where customers request OS deployment without managing infrastructure

#### AWS Service Portfolio
AWS provides all three OS launching methodologies as services:

| Launch Method | AWS Service | Service Type |
|---------------|-------------|-------------|
| Virtualization/Compute | EC2 | Compute/VM as Service |
| Containerization | ECS | Container as Service |
| Bare Metal | Dedicated Hosts | Metal as Service |

#### Cloud Benefits
- **Abstraction**: Hide infrastructure complexity from users
- **Pay-as-you-go**: Charge based on usage (per hour/minute)
- **Agility**: Spin up resources instantly for business needs
- **Scalability**: Handle traffic spikes (e.g., Netflix, Hotstar cricket matches)

#### Hypervisor Evolution in AWS
- **Xen**: Original hypervisor (open-source, available free)
- **Nitro System**: Custom AWS hypervisor for enhanced performance
- **Benefit**: Faster OS boot times (critical for high-traffic companies)
- **Real-world Impact**: Companies like Hotstar can launch thousands of instances within seconds during traffic surges

### AWS Cloud and EC2 Deep Dive
#### Why AWS Learning Matters
- AWS uses advanced technologies (Xen, Nitro, custom hardware)
- Even professionals working 5+ years may not know internal mechanics
- Right education: Understanding "why" technology was developed and for which scenarios

#### EC2 Service Core
- **Service Name**: EC2 (Elastic Compute Cloud)
- **Function**: Launches operating systems in cloud using virtualization
- **Pricing Model**: Pay-as-you-go, emphasizing cost optimization
- **AMI (Amazon Machine Images)**: Cloud equivalent of OS installation DVDs
  - Thousands of pre-configured images (Amazon Linux, Ubuntu, Red Hat, Windows, Mac)
  - Includes custom AMIs for private use

#### Instance Types and Hardware
- **Concept**: Virtual hardware configurations (CPUs, RAM, storage)
- **Free Tier**: T2.micro (1 CPU, 1GB RAM) for new accounts
- **Pricing Examples**:
  - T2.micro: ~$0.011/hour (750 hours free in free tier)
  - M5.large: ~$0.096/hour
- **Cost Monitoring**: Essential for cloud engineers
- **AWS Cost Tools**: AWS TCO Calculator, Cost Explorer

#### Instance Metadata
- **Tenancy Models**:
  - Shared (default): Hardware shared across accounts
  - Dedicated: Hardware dedicated to single account
- **Availability Zones**: Multiple data centers per region for redundancy
- **Regions**: Geographic areas (e.g., Mumbai = ap-south-1)

#### Security and Access
- **Key Pairs**: RSA private/public keys replace passwords for secure login
- **Network Settings**: Security groups as firewalls (VPC discussion deferred)
- **Storage**: Default 8GB; customizable (EBS discussion deferred)

## Lab Demos
### Launch EC2 Instance Demo
**Prerequisites**: AWS account access, Mumbai region selection

1. **Navigate to EC2 Service**
   - Search "EC2" in AWS console
   - Click "Launch Instance"

2. **Configure Instance**
   - **Name**: "my-test-linux" (naming best practices for tagging)
   - **AMI Selection**: Amazon Linux 2 (free tier eligible)
   - **Instance Type**: t2.micro (free tier)
   - **Key Pair**: Create new key pair "aws-training-key-pairs"
   - **Network Settings**: Leave defaults (VPC demo future)
   - **Storage**: Leave 8GB default (EBS demo future)
   - **Advanced**: Tenancy set to "Default" (Shared)

3. **Launch Instance**
   - Review summary
   - Click "Launch Instance"
   - Instance launches in 1-2 minutes

4. **Connect to Instance**
   - Select instance → Actions → Connect
   - Use browser-based EC2 Instance Connect (no local tools needed)
   - Successfully connected to Amazon Linux in Mumbai region

### Cost Monitoring Demo
1. **Billing Dashboard Access**
   - Account dropdown → Account
   - Billing & Cost Management section
   - View current month usage

2. **Usage Breakdown**
   - EC2 usage in Mumbai region
   - Hours consumed vs free tier limits
   - Service-specific costs

### Instance Termination Demo
1. **Terminate Instance**
   - Select instance → Actions → Terminate (Delete)
   - Warning: Data will be lost
   - Confirm termination

2. **Verify**
   - Instance state changes to "terminated"
   - Charges stop immediately

## Summary
### Key Takeaways
```diff
+ OS launching requires hardware; cloud abstracts infrastructure management
+ Three OS launch methods: bare metal, virtualization, containerization
+ Virtualization enables multiple OS on shared hardware via hypervisors
+ Containerization provides sub-second OS deployment for cloud agility
+ AWS EC2 enables virtualization-as-a-service with pay-as-you-go pricing
+ Cost optimization critical: monitor billing, use free tier, right-size instances
- Avoid using beyond free tier without understanding charges
- Data loss occurs when instances terminate; implement backup strategies
! Cloud success depends on understanding underlying concepts, not just UI clicks
```

### Quick Reference
**AWS Free Tier Limits**:
- EC2: 750 hours t2.micro (Linux/Windows)
- Amazon Linux AMI pricing: Per-second billing after free tier
- Windows AMI: Per-hour minimum

**Common Commands Mentioned**:
- `ls /sys/devices/virtual/dmi/id/` (verify hypervisor type)

**Instance Types**:
- T2.micro: 1 vCPU, 1GB RAM (free tier)
- M5.large: 2 vCPU, 8GB RAM

**Regions Mentioned**:
- Mumbai: ap-south-1 (2 availability zones)

### Expert Insight
#### Real-world Application
AWS EC2 powers massive-scale applications like Netflix and Hotstar, where traffic surges require instant OS provisioning. Without Nitro hypervisor's 1-second boot capability, companies couldn't scale to millions of concurrent users during events like cricket matches. Cost optimization becomes crucial at scale – improper instance selection can result in millions in wasted expenditure.

#### Expert Path
Master EC2 by progressing through: 1) Basic launching (covered here), 2) Networking with VPC/Security Groups, 3) Storage optimization with EBS/Elastic File System, 4) Auto-scaling and load balancing, 5) Cost optimization with Reserved Instances/Spot pricing. Focus on architecture decisions over UI operations.

#### Common Pitfalls
- **Cost Surprise**: Forget to terminate instances → unexpected charges (monitor billing dashboard)
- **Data Loss**: No backups before termination (implement AMI snapshots or EBS volumes)
- **Region Confusion**: Launch in wrong region → latency issues or additional costs
- **Free Tier Overuse**: Beyond 750 hours → pay unexpectedly

#### Lesser-Known Facts
- **Xen Hypervisor Usage**: Despite Nitro adoption, some legacy EC2 instances still use Xen
- **Per-Second Billing Innovation**: AWS pioneered this to prevent overcharging for short workloads
- **Mac OS Support**: EC2 supports Mac instances for dev/testing without buying Apple hardware
- **Hardware Diversity**: AWS uses different hypervisors (Xen, KVM, Hyper-V) based on requirements

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>  
**KK-CS45-V3**
