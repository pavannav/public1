# Course Summary and Progress Tracker

## Course Information
- **Course**: GCP Professional Cloud Architect (PCA) Study Guide
- **Model ID**: KK-CS45-V3

## Session Completion Status

### Module Overview
- [ ] Session 01: Introduction and Basic Concepts
- [ ] Session 02: GCP Console and Basic Services
- [ ] Session 03: Virtual Networks and Networking
- [ ] Session 04: Identity and Access Management
- [ ] Session 05: Storage Fundamentals
- [ ] Session 06: Compute Engine Basics
- [ ] Session 07: Workload Identity Federation & SSO
- [ ] Session 08: Security Command Centre & IAM Best Practices
- [ ] Session 09: Compute Options (GKE, Cloud Run, App Engine)
- [ ] Session 10: VM Instances Deep Dive
- [ ] Session 11: CLI, Spot VMs, and Marketplace
- [x] Session 12: Persistent Disk Concepts - Expansion, Formatting, Local SSD
- [ ] Session 13: Advanced Disk Concepts and Snapshots
- [ ] Session 14: Load Balancing and Auto Scaling
- [ ] Session 15: Cloud Storage Deep Dive

## Session Summaries
### Session 12: Persistent Disk Concepts - Expansion, Formatting, Local SSD
- **Topics Covered**: Preemptable vs Spot VM termination, disk resizing (unidirectional), formatting/mounting procedures, regional persistent disks for HA, local SSD characteristics for high-performance workloads
- **Key Concepts**: Preemption logs show system@google.com actor, disks retain data during termination but charged only for storage/IP, regional disks replicate to exactly 2 zones for fail-over capability, local SSDs are machine-attached and lost permanently
- **Notable Commands**: \`gcloud compute disks resize\`, \`sudo resize2fs /dev/sdb\`, \`lsblk\`, \`mkfs.ext4\`, \`mount\`, \`growpart\`

## Course Statistics
- **Total Sessions**: 15
- **Completed Sessions**: 1
- **Last Updated**: 2026-05-08
- **Progress**: 7%
