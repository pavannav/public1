# Session 20: Introduction to AWS EFS (Elastic File System)

## Table of Contents
- [Session Overview](#session-overview)
- [Announcements and Community Building](#announcements-and-community-building)
- [Technical Deep Dive: Understanding EFS](#technical-deep-dive-understanding-efs)
- [Summary](#summary)

## Session Overview

Welcome to Session 20, where we explore AWS Elastic File System (EFS) as an advancement in cloud storage solutions. The session begins with inspirational announcements about community involvement in Linux World initiatives, including the annual "Square Root of Pi" event. Following this, the focus shifts to technical content comparing Elastic Block Store (EBS) and introducing EFS as a serverless, scalable file storage service. Key discussions include storage types, replication, multi-AZ support, and practical setups. The session was unexpectedly terminated due to an earthquake in Jaipur.

This session emphasizes transitioning from managed but planning-intensive block storage (EBS) to fully managed file storage (EFS), highlighting benefits for scalability, durability, and cross-regional access. Perfect for beginners aiming to master AWS storage services.

## Announcements and Community Building

### Overview
The first portion of the session featured announcements by the moderator (Priyanka) and instructor (Viml Daga), focusing on community engagement, personal development, and upcoming Linux World events. This segment underscored the importance of mentorship, volunteering, and leadership within the tech community, especially for aspiring professionals and students.

### Key Concepts / Deep Dive
The instructor stressed the value of having "two people" in one's life: a trusted mentor (personified by Viml Daga himself) and a reliable support figure (e.g., parents, friends). This was illustrated through meditation exercises to visualize these relationships for confidence and resilience.

**Community Impact and Initiatives:**
- **Linux World Family**: Highlighted the role of technical volunteers (TVs), ambassadors, and learners in scaling initiatives like free AWS training programs.
- **Gratitude Exercise**: Attendees were encouraged to thank mentors or friends who introduced them to Linux World, emphasizing karmic benefits (giving leads to receiving in multiples) and societal contributions (e.g., helping engineering students).

**Event Announcement: "Square Root of Pi":**
- Described as a two-day physical event in Jaipur featuring learning, spiritual, conceptual, and technical sessions with Viml Daga.
- Exclusive to core team members (ambassadors, TVs).
- Benefits: Hosting, awards (e.g., "Leadership Icon"), interactions with industry experts (e.g., IBM VP, Red Hat leaders), physical activities, dancing, and life-transforming experiences.
- Eligibility: Become a volunteer or contributor via a shared form (linked in chat) to join the "pillars of Linux World."
- Past Events: Showcased via shared screen/photos – awards for volunteers (e.g., honorable mentions with skills like "honest and good listener"), industry meetings, and uplifting activities (e.g., magic shows by Viml Daga as a magician).
- Personal Stories: Sharing of health issues resolved through spiritual guidance, demonstrating holistic integration of tech and personal development.

**Call to Action:**
- Join as ambassadors/contributors for rewards like industry connections, technical learning, and leadership recognition (e.g., red carpet awards).
- No monetary incentives mentioned; focus on self-development and community service.

**Interactive Elements:**
> [!NOTE]
> Attendees participated via chat, polls, and hand-raising to express excitement for mentorship, dancing with Viml Daga, and event attendance.

### Lab Demos (Announcements Segment)
No hands-on tech labs here; instead, video/photo shares of past events.
1. Shared screen: Photos of "Square Root of Pi" event (2022 in Jaipur for 2 days, hosting 200-300 people).
2. Visualized awards, partnerships (e.g., media coverage), and activities (e.g., dance sessions with Viml Daga).
3. Form shared in chat for volunteer applications.

## Technical Deep Dive: Understanding EFS

### Overview
Transitioning from announcements, Viml Daga introduced EFS as the next storage service after EBS, focusing on its serverless nature for file-level storage. The session contrasted EBS limitations (e.g., pre-planning, single-instance attachment, AZ-bound replication) with EFS benefits (automatic scaling, multi-AZ replication, NFS-protocol sharing). This deep dive explains why EFS is ideal for shared, elastic storage needs in cloud environments.

### Key Concepts / Deep Dive
Following the instructor's flow, we started with EBS challenges to contextualize EFS.

**EBS Limitations (Block Storage Recap):**
- **Pre-Planning and Scalability**: EBS requires estimating storage size upfront (e.g., 10 GB initial). Increasing size is possible but complex and not always supported across all types.
- **Maintenance Overhead**: Users must create partitions, format, and manage drivers. No built-in multi-instance sharing (multiattaach limited to high-performance types like IO1, max 16 VMs).
- **Cost and Utilization**: Charged for provisioned size (e.g., 10 GB/month even if using 1 GB), leading to overage costs.
- **Performance Planning**: Choose types (GP2, IO1) for speed/cost, but difficult to predict future needs.
- **Replication and Disaster Recovery**: 
  - Backup via snapshots (point-in-time, not real-time).
  - Replication (real-time mirroring) possible with third-party software (e.g., RAID 1/RAID concepts), but limited to same AZ for failover resilience. No native multi-AZ mirroring.
- **Attachment Constraints**: One EBS volume per instance (or limited multi via special types). Not suited for hundreds/thousands of VMs sharing data.
- **Regional Limitations**: EBS volumes are AZ-specific; data loss if AZ fails (despite possible cross-AZ backups, no native replication).
- **Use Cases for EBS**: Essential for EC2 root volumes, local-feel block storage for clustering/OS nuances, or raw disk management.

**Introducing EFS (File Storage Solution):**
- **Core Difference**: EFS is serverless, fully managed NFS (Network File System) for shared file-level access, addressing EBS gaps.
- **Elasticity**: Scales automatically (pay for used storage). No pre-planning; grows from 1 GB to terabytes seamlessly.
- **Multi-Instance Sharing**: Supports thousands of VMs/EC2 instances without attachment limits.
- **Replication and Durability**: Native multi-AZ replication using redundant storage in multiple AZs. Automatic failover ensures high availability (99.99% uptime).
- **Protocol and Access**: Uses NFS protocol for network sharing. Clients (primarily Linux) connect via mount points. Technically, EFS provides managed NFS server capabilities (partitioning, formatting, drivers, performance tuning handled by AWS).
- **Cross-Regional and Hybrid Access**: Supports connecting from multiple AWS regions or even on-premises (hybrid cloud) over public internet with security (e.g., VPC tunneling). Enables use cases like multi-cloud data sharing, backups, or offloading data to on-premises.
- **Performance Modes**: Standard/One Zone (cost vs. durability trade-off).
- **Use Cases for EFS**: Web content sharing, big data analytics, media processing, application data sharing across teams, or backups to on-premises.

**Storage Types Comparison:**

| Feature              | EBS (Block)                        | EFS (File)                          |
|----------------------|------------------------------------|-------------------------------------|
| Storage Type         | Block (raw disk emulation)        | File (shared file system via NFS)  |
| Scaling              | Manual or limited                 | Automatic elastic                  |
| Sharing              | Limited (max 16 VMs select types) | Unlimited (thousands of instances) |
| Replication          | Manual (same AZ), backups         | Native multi-AZ real-time          |
| Protocol             | iSCSI, local feel                 | NFS                                |
| Access               | EC2/OS management needed          | Network-mounted, managed           |
| Regional Support     | Single AZ                         | Multi-AZ/regional                  |
| Use Case Fit         | Root volumes, raw performance     | Shared multi-user/multi-region     |

> [!IMPORTANT]
> EFS excels in scenarios needing shared, scalable, and highly available storage without operational overhead. Beginners should start with EFS for web apps, while EBS suits custom OS setups.

### Lab Demos (Technical Segment)
The session included a partial demo before interruption:

**Spawning EFS in AWS Console:**
1. Navigate to AWS Console > EFS Service.
2. Select Region (e.g., Mumbai/ap-south-1).
3. Create File System: Choose VPC, subnets, security groups.
4. Mount Targets: Auto-created for multi-AZ access.
5. Command to Mount on EC2 (NFS Client):
   ```bash
   sudo yum install nfs-utils  # Install NFS utils if needed
   sudo mkdir /efs-mount-point
   sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-xxxxxxx.efs.ap-south-1.amazonaws.com:/ /efs-mount-point
   ```
6. Verify: Use `df -h` to check mounted storage.

> [!WARNING]
> Demo was interrupted mid-creation; ensure IAM roles for EFS access in production.

## Summary

### Key Takeaways
```diff
+ EFS is a serverless NFS-based file storage for elastic, shared access across multiples instances and regions, solving EBS limitations like pre-planning and replication constraints.
- EBS remains essential for block-specific needs (e.g., root volumes), but lacks native multi-AZ mirroring.
! Announcements emphasize community roles; volunteering unlocks events like "Square Root of Pi" for networking and personal growth.
```

### Quick Reference
- **EBS vs EFS**: Block (local-like, manual) vs File (network-shared, auto-scaling).
- **Common Commands**:
  - Mount EFS: `mount -t nfs4 -o ... [EFS-DNS]:/ /mnt`
  - Check Storage: `df -h`
- **Configs**: Multi-AZ enabled by default in EFS; security via VPC groups.
- **Protocols**: EBS (~SAN), EFS (NFS), S3 (HTTP).

### Expert Insight

**Real-world Application**: EFS powers applications like WordPress farms (shared config/media), data lakes for analytics (multi-VM access), or hybrid backups (on-premises to cloud sync). In production, combine with EBS for databases and EFS for shared logs/assets.

**Expert Path**: Master storage types by building multi-tier apps (EBS for DB, EFS for files, S3 for archives). Practice labs: Mount EFS on EC2 clusters, stress-test multi-AZ failover. Next, explore FSx for Windows (SMB-based) or hybrid tools like AWS Storage Gateway.

**Common Pitfalls**: Overlooking NFS version (use 4.1 for EFS); forgetting security groups for mount targets (blocks access). Ensure Linux clients; Windows NFS hacks unstable.

**Lesser-Known Facts**: EFS integrates with EKS/Kubernetes as persistent volumes. Free tier offers 5 GB/month for 12 months. Viml Daga highlighted spiritual/medical guides (e.g., treating health issues via energy practices), bridging tech and well-being. Events like "Square Root of Pi" blend tech talks with life coaching.
