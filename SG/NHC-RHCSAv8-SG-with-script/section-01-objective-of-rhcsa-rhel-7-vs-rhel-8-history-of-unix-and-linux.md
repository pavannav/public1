# Section 01: Introduction to RHCSA Certification and Linux Fundamentals

<details open>
<summary><b>Section 01: Introduction to RHCSA Certification and Linux Fundamentals (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [RHCSA Exam Objectives](#rhcsa-exam-objectives)
- [Why Learn Linux?](#why-learn-linux)
- [History of Unix and Linux](#history-of-unix-and-linux)
- [Differences Between RHEL 7 and RHEL 8](#differences-between-rhel-7-and-rhel-8)
- [Features and Usage of Linux](#features-and-usage-of-linux)
- [Kernel and Shell Basics](#kernel-and-shell-basics)
- [User Accounts and Login](#user-accounts-and-login)
- [Summary](#summary)

## Overview

This section introduces the RHCSA (Red Hat Certified System Administrator) certification exam, including its structure, objectives, and the benefits of pursuing it. It explores the history of Unix and Linux, highlighting key developments and figures. Additionally, it compares RHEL versions, covers Linux features, and provides foundational concepts on kernel, shell, and user management to prepare beginners for hands-on system administration tasks. By the end, you'll understand why Linux is a valuable skill in IT and cloud environments, and how practical exams like RHCSA focus on real-world competency.

## RHCSA Exam Objectives

The RHCSA exam code is EX200, offering hands-on, practical assessment conducted remotely or at authorized centers. You can take it from home or an exam center, where your system's state must demonstrate competency—examiners check the state of the system, not how you achieved it.

Key responsibilities as a system administrator include:
- Understanding and using essential Linux tools.
- Accessing and mastering the shell interface.
- Issuing shell commands, including input/output redirection and operators.
- Searching for files using patterns like grep, regular expressions, and shell.
- Logging into systems and managing files, directories, and permissions.
- Creating and managing file systems, disks, and volumes.
- Configuring network interfaces, IP addresses, subnets, default gateways, and firewalls.
- Installing and managing packages via repositories.
- Booting processes, managing services, and cycling through runlevels.
- CPU and memory management, including monitoring processes.
- Creating and managing users, groups, and permissions.
- Implementing security measures, such as SELinux and firewalls.
- Managing local storage, including creating partitions, file systems, and mounts.

> [!IMPORTANT]
> The exam covers two main parts: system management and security, split roughly into RHCSA and RHCE (Red Hat Certified Engineer). RHCSA builds the foundation for RHCE.

The exam requires 100% practical proficiency, with no memorization-only questions. You need to demonstrate skills in multi-layered secure environments.

## Why Learn Linux?

Linux is a powerful, secure, open-source operating system widely used in data centers, cloud computing, and enterprise networks. Unlike proprietary systems, it's free, highly stable, and customizable. Major companies like Google, Amazon, and IBM rely on Linux for its robustness and scalability.

Common distributions include Red Hat Enterprise Linux (RHEL), Ubuntu, CentOS, Fedora, and others. Learning Linux secures career opportunities in DevOps, cloud engineering, system administration, and more. RHCSA certification validates hands-on skills, making you employable in high-demand roles. Even if you lack a PC, you can create free accounts on platforms like AWS or Google Cloud for practice.

> [!NOTE]
> Linux emphasizes practical skills over theory, with live sessions and study materials to guide you. Support the channel for continued free training.

The exam distinguishes from RHCE by focusing on core system tasks, while RHCE covers advanced topics like automation and storage.

## History of Unix and Linux

Linux traces roots to Unix, initially developed at Bell Labs in 1969 by Dennis Ritchie and Ken Thompson (among others). Unix was created as a research project at AT&T Bell Laboratories, evolving into a multi-user, multitasking OS. Key contributors included Brian Kernighan and others.

Linus Torvalds, studying at the University of Helsinki, extended Unix in 1991 by modifying its kernel to create Linux. Torvalds distributed it as free software, leading to rapid development and community adoption. Today, Linux powers diverse systems, from smartphones (Android uses a Linux kernel) to supercomputers.

The GNU Project, founded by Richard Stallman in 1983, emphasized free software, aligning with Linux's philosophy. Major early contributors include Alan Cox and others.

Linux branched from Unix, becoming more advanced. Linux is often called a "Unix-like" OS, not exact, due to enhancements. It's known as GNU/Linux when including GNU tools.

## Differences Between RHEL 7 and RHEL 8

RHEL (Red Hat Enterprise Linux) versions include RHEL 7 (Maipo) and RHEL 8 (Ootpa). Key differences:

| Feature                | RHEL 7                         | RHEL 8                         |
|------------------------|--------------------------------|--------------------------------|
| Release Date          | June 9, 2014                  | May 7, 2019                   |
| Kernel Version        | 3.10.x (upstream kernel)       | 4.18.x (latest upstream)       |
| File System           | XFS                            | XFS                            |
| Default Network Packets | iptables (via firewalld)      | nftables                      |
| Package Manager       | Yum repositories               | DNF (Dandified Yum)            |
| Init System           | systemd                        | systemd                       |
| SELinux               | Enabled by default             | Enabled by default with updates |
| Maximum File System Size | Up to 500 TB                  | Up to 1,024 TB                |
| Supported RAM         | Up to 12 TB                    | Up to 16 TB                   |
| Repositories          | Single repository for all     | Modules for app streams       |
| Virtualization        | libvirt tools                  | Enhanced with podman/docker alternatives (e.g., Buildah) |
| Security              | Default crypto policy          | Updated crypto policies       |

Changes include modular repositories for version-flexible installations, improved container support (e.g., podman replaces some Docker features), and network filtering via firewalld/nfables.

> [!NOTE]
> RHEL 8 introduces "Application Streams" for installing multiple versions of software.

For installation, both use ISO images and similar processes, but RHEL 8 emphasizes modern tools.

## Features and Usage of Linux

Linux key features:
- Highly secure with permissions, multi-layer security (e.g., SELinux).
- Stable, lightweight, and works on old hardware.
- Free and open-source, customizable.
- Multi-user, multitasking OS.
- Supports countless distributions (e.g., Fedora, Ubuntu, CentOS, Kali).
- Used in servers, desktops, embedded systems, supercomputers, cloud, smartphones, IoT, automotive, defense, etc.

Distributions categorized as:
- Enterprise (e.g., RHEL, SUSE)
- Desktop (e.g., Ubuntu, Fedora)
- Community (e.g., Debian-based)

GNOME provides the graphical desktop, with other options like KDE.

> [!TIP]
> Start with Ubuntu for beginners due to its user-friendliness.

## Kernel and Shell Basics

The **kernel** acts as the central manager, interfacing between hardware and software. It handles CPU, memory, devices, and system calls. Examples: issuing commands via shell → kernel → hardware (e.g., increasing volume).

The **shell** is the command-line interface (CLI) where you type commands to interact with the kernel. Common shells: Bash, Zsh, TCSH, Dash. Linux uses Bash by default.

- Kernel version examples: 5.10 for RHEL 8.
- Shell command flow: User input → Shell → Kernel → Hardware response.

## User Accounts and Login

To use Linux, you need a user account (username and password). Without it, you can't interact with the system. Root is the admin account; regular users have limited permissions.

Booting sequence (basic): Power on → BIOS/UEFI → Boot loader (e.g., GRUB) → Kernel loads → Init system (systemd) → Services start → Login prompt.

> [!IMPORTANT]
> User creation involves setting usernames, passwords, permissions, and groups. Commands like `useradd`, `usermod` are covered in later sections.

## Summary

### Key Takeaways
```diff
+ RHCSA is a hands-on certification focusing on core Linux administration tasks like users, storage, networking, and security.
- Avoid proprietary systems if flexibility is key; Linux's open-source nature prevents vendor lock-in.
! Practice in virtual environments (e.g., AWS free tier) to build skills before the exam.
+ Linux history ties to Unix's centralized development; Linux decentralized it globally.
- RHEL 8 improves on RHEL 7 with modern features like modular repos and enhanced security defaults.
```

### Quick Reference
- **Exam Code**: EX200
- **Common Commands**: `ls`, `cd`, `mkdir`, `chmod` (introduced in later sections)
- **Default Shell**: Bash
- **Kernel Check**: `uname -r`
- **Root User**: Admin account (use with caution)

#### Expert Insight
**Real-world Application**: In production, RHCSA skills are essential for managing cloud servers at companies like Amazon or Google, ensuring uptime, security, and scalability in data centers.

**Expert Path**: Master CLI fundamentals first, then practice partitioning and networking in virtual machines. Join communities like Reddit's r/linux for troubleshooting; pursue RHCE next for automation focus.

**Common Pitfalls**: Assuming Windows knowledge transfers—Linux permissions and processes differ significantly. Skipping regular backups during practice can lead to mistakes; use `sudo` carefully to avoid privilege escalation errors.

</details>
