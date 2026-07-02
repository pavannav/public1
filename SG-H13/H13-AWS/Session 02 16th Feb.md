# Session 02: Operating Systems, Virtualization, and Containerization Fundamentals

<details open>
<summary><b>Session 02 (Claude)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [Operating System Fundamentals](#operating-system-fundamentals)
  - [Three Ways to Launch Operating Systems](#three-ways-to-launch-operating-systems)
    - [Bare Metal Installation](#bare-metal-installation)
    - [Virtualization Technology](#virtualization-technology)
    - [Containerization Technology](#containerization-technology)
- [Lab Demos and Practical Examples](#lab-demos-and-practical-examples)
- [Summary](#summary)

## Overview

Session 02 establishes the fundamental concepts required to understand cloud computing, particularly AWS. The session begins by explaining why operating systems exist (to run programs/apps) and then explores the three primary methods for deploying operating systems: bare metal installation, virtualization, and containerization. This foundational knowledge is crucial for understanding how cloud platforms like AWS operate behind the scenes.

## Key Concepts

### Operating System Fundamentals

**Purpose of Operating Systems**
- The sole purpose of any operating system is to run programs (applications/software)
- Programs can be created by others (VC player, Chrome) or by developers
- Without an OS, programs cannot execute on hardware

**Three Technical Methods to Launch Operating Systems**
Installing plus booting technically equals "launching" an OS. There are exactly three technological methods available worldwide to install any operating system:

### Three Ways to Launch Operating Systems

#### Bare Metal Installation

**Definition and Characteristics:**
- Direct installation of OS on physical hardware
- Physical hardware includes: RAM, CPU, hard disk, graphics card, peripherals
- Examples of bare metal: laptops, desktops, physical servers (Dell, Lenovo, etc.)

**Limitations:**
- One hardware can run only ONE OS at a time
- Cannot boot multiple operating systems simultaneously
- Dual booting allows multiple OS installations but not concurrent execution

**Terminology:**
- OS installed directly on bare metal called "bare metal OS" or just "OS"

#### Virtualization Technology

**Core Concept:**
Virtualization enables running multiple independent operating systems on a single physical hardware through a software layer called a **hypervisor**.

**Architecture:**
```
Physical Hardware
    ↓
Host OS (Windows/Linux/Mac)
    ↓
Hypervisor (Virtualization Software)
    ↓
Guest Machines/VMs (Multiple OS)
```

**Key Components:**

1. **Hypervisor** - The program that enables virtualization
   - Also called Virtual Machine Monitor (VMM)
   - Provides capability to run multiple OS on top of single hardware
   - Available products:
     - Oracle VirtualBox
     - VMware ESXi
     - KVM (open source)
     - Xen (open source)
     - Microsoft Hyper-V

2. **Host Machine** - The base OS running on physical hardware
   - "Hosts" other operating systems
   - Provides resources to guest machines

3. **Guest Machines/VMs** - Operating systems running on hypervisor
   - Virtual Machines (VMs)
   - Completely independent OS instances
   - Share physical resources (RAM, CPU, storage)

**Benefits:**
- Resource optimization and cost saving
- Running multiple OS environments on single hardware
- Better hardware utilization

#### Containerization Technology

**Core Concept:**
Containerization provides OS-level virtualization, allowing multiple isolated user-space instances (containers) to run on a single OS kernel.

**Architecture:**
```
Physical Hardware
    ↓
Host OS
    ↓
Containerization Engine
    ↓
Containers (Lightweight OS instances)
```

**Key Differences from Virtualization:**

| Aspect | Virtualization | Containerization |
|--------|---------------|------------------|
| **Boot Time** | 30 minutes - 2 hours | ~1 second |
| **Resource Usage** | High (full OS) | Low (shares kernel) |
| **Isolation** | Complete OS isolation | Process-level isolation |
| **Size** | GBs per VM | MBs per container |

**Containerization Engine:**
- Docker is the most popular containerization platform
- Enables rapid deployment of applications
- Critical for modern DevOps and agile development practices

**Business Impact:**
- Faster time-to-market
- Enables agile development practices
- Essential for microservices architecture

## Lab Demos and Practical Examples

### Demonstration Scenarios

**Scenario 1: Bare Metal Setup**
```bash
# On a physical server
# Install OS directly on hardware
# Only one OS can run at a time
```

**Scenario 2: Virtualization Setup**
```bash
# Using Oracle VirtualBox
# Create multiple VMs:
# - Windows 10 VM
# - Ubuntu Linux VM
# - Red Hat Linux VM
# All running simultaneously on Windows host
```

**Scenario 3: Containerization Setup**
```bash
# Using Docker
docker run ubuntu:latest
docker run nginx:latest
docker run mysql:8.0
# Multiple containers launched in seconds
```

## Summary

### Key Takeaways

```diff
+ Operating systems exist solely to run programs/applications
+ Three methods exist for OS deployment: bare metal, virtualization, containerization
+ Bare metal: Direct OS installation on physical hardware with limitation of one OS per hardware
+ Virtualization: Uses hypervisors to run multiple VMs on single hardware
+ Containerization: Lightweight, kernel-sharing technology enabling seconds-fast deployments
+ Containerization provides significant speed advantages (seconds vs hours) over virtualization
```

### Quick Reference

| Term | Definition |
|------|------------|
| **Bare Metal** | Physical hardware with direct OS installation |
| **Hypervisor** | Software enabling virtualization (VMware, VirtualBox, KVM) |
| **Host Machine** | Base OS running on physical hardware |
| **Guest Machine/VM** | OS running on hypervisor |
| **Container Engine** | Software enabling containerization (Docker) |

### Expert Insights

**Real-world Application:**
- Understanding these deployment methods is crucial for AWS architecture decisions
- Cloud providers use virtualization as their foundation
- Modern applications increasingly use containerization for microservices
- AWS offers both EC2 (virtualization-based) and ECS/EKS (containerization-based) services

**Expert Path:**
- Master the cost-benefit analysis between these technologies
- Understand performance implications of each deployment method
- Learn container orchestration (Kubernetes) for production containerization
- Study hybrid approaches combining virtualization and containerization

**Common Pitfalls:**
- Assuming all cloud resources use the same underlying technology
- Ignoring resource sharing implications in virtualization
- Underestimating container security requirements
- Not considering boot time requirements for application architecture

</details>