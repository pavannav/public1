# Section 1: Introduction to Linux Users

## Table of Contents

- [1.1 Introduction to Linux Users](#11-introduction-to-linux-users)
- [1.2 Principle of Least Privilege](#12-principle-of-least-privilege)
- [1.3 Accessing the Repository and Network Map](#13-accessing-the-repository-and-network-map)
- [1.4 The id Command](#14-the-id-command)
- [Summary](#summary)

---

<details open>
<summary><b>Section 1: Introduction to Linux Users (KK-CS45-script-v2-Inst-v1)</b></summary>

## 1.1 Introduction to Linux Users

### Overview
This module introduces the fundamental concepts of user account types in Linux systems, focusing on the distinction between the superuser (root) account and regular user accounts. Understanding these account types is essential for proper Linux system administration and security management.

### Key Concepts/Deep Dive

#### Two Main Types of User Accounts

Linux systems have two primary categories of user accounts:

**1. Superuser Account (Root)**
- Also known as the root account or superuser account
- Has **full control** over the Linux system with **no restrictions**
- Critical security consideration: Exercise extreme caution when working as root
- Command line prompt indicator: **#** (number sign/pound sign)
- Can perform any action on the system without permission restrictions
- Essential to note: Every Linux system has exactly one root account

**2. Regular User Accounts**
- Standard accounts used for daily work at home and in professional environments
- **Restricted by default** - do not have administrative access
- Can be granted administrative permissions through sudo (superuser do)
- Command line prompt indicator: **$** (dollar sign)
- Each regular user gets their own home directory under `/home/`

#### Real-World Terminal Examples

The instructor demonstrates the differences using a Debian Linux system:

**Root Account Terminal:**
```bash
root@deb-client:~# pwd
/root
```

**Regular User Terminal:**
```bash
user@deb-client:~$ pwd
/home/user
```

#### Additional Account Types (Mentioned for Context)

While not covered in detail in this module, Linux also includes:
- **System accounts**: Built into the operating system
- **Service accounts**: Created automatically by installed services/programs
- These are **not actual user accounts** and will be discussed later in the course

### Lab Demonstrations

No specific lab commands were shown in this module, but the visual demonstration clearly shows the differences between root and regular user environments.

---

## 1.2 Principle of Least Privilege

### Overview
The Principle of Least Privilege is a fundamental security concept that mandates users and processes should only receive the minimum privileges necessary to perform their required functions. This module demonstrates practical applications of this principle in Linux environments.

### Key Concepts/Deep Dive

#### Definition and Scope
The Principle of Least Privilege states that:
- User accounts should receive only essential privileges for their work
- Processes should operate with minimal required permissions
- Applies to: Operating systems, applications, users, networks, and especially data

#### Security Red Flags in Practice

The instructor identifies several concerning practices:

**1. SSH as Root**
```bash
# Problematic - SSH directly as root
ssh root@10.0.2.78

# Preferred approach
ssh user@10.0.2.78
# Then use sudo for administrative tasks
```

**Warning Indicators:**
- Transmitting root account credentials through SSH tunnels
- Granting immediate full system access upon connection
- Should be disabled immediately after initial server setup

**2. Generic User Account Names**
- Account named simply "user" is inappropriate for production
- Recommended naming conventions:
  - `firstname_lastname`
  - `firstname.lastname`
  - Real employee identifiers
- Avoid generic names like "user", "admin", or "test"

**3. Inappropriate Container Access**
- Regular users shouldn't have container system access without justification
- Principle applies to questioning why specific access is granted

#### Practical Demonstration

**Without Administrative Access:**
```bash
user@deb-client:~$ apt update
E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)
E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), are you root?
```

**With Root Access:**
```bash
root@deb-client:~# apt update
# Successfully updates package lists
```

#### Requirements for Administrative Access

For a regular user to execute administrative commands:

1. **User must be a member of the sudoers group**
2. **Must prefix commands with `sudo`**
3. **Must provide password authentication**

```bash
# Correct approach for sudo-capable users
sudo apt update

# Incorrect - will fail without sudo
apt update
```

### Security Best Practices

> [!IMPORTANT]
> A user that doesn't need access shouldn't get access. Configure systems properly to enforce this principle.

---

## 1.3 Accessing the Repository and Network Map

### Overview
This module guides students through accessing the course repository containing all lab materials and provides an overview of the instructor's network infrastructure used throughout the course.

### Key Concepts/Deep Dive

#### Repository Access

**Repository Location:** `github.com/daveprowse/linux-security`

**Available Options:**
1. **Direct Access**: Browse lab-setup.md and individual lab documents directly on GitHub
2. **Clone Repository**:
   ```bash
   git clone https://github.com/daveprowse/linux-security
   cd linux-security
   ```

#### Repository Structure
- Lab documents organized in numbered directories (lab-01, lab-02, etc.)
- Each lab contains step-by-step markdown documentation
- Lab setup document provides detailed configuration guidance

#### Network Infrastructure Overview

**Virtualization Platform:** KVM (Kernel-based Virtual Machine)
- **Network**: 10.0.2.0/24 (emulates VirtualBox NAT network)
- **Alternative Options**: VirtualBox, VMware, or any preferred virtualization platform

**Key Systems:**
- **.51**: Debian server
- **.52**: Debian client (primary demonstration system)
- Multiple additional virtual machines for various exercises

**Cloud Integration:**
- AWS and other cloud-based systems used for specific demonstrations
- Primary work conducted within local virtualization environment

#### Lab Environment Setup Requirements

> [!NOTE]
> Students need physical or virtual Linux systems that can network together for practicing security techniques.

---

## 1.4 The id Command

### Overview
This hands-on lab introduces the `id` command for viewing user identification information and demonstrates the practical application of user privilege concepts learned in previous modules.

### Key Concepts/Deep Dive

#### Basic id Command Usage

**Regular User Output:**
```bash
user@deb-client:~$ id
uid=1000(user) gid=1000(user) groups=1000(user),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),109(netdev),115(bluetooth),120(scanner),997(docker)
```

**Root User Output:**
```bash
root@deb-client:~# id
uid=0(root) gid=0(root) groups=0(root)
```

#### Understanding id Output Components

| Component | Meaning | Example |
|-----------|---------|---------|
| **uid** | User ID number | uid=1000(user) |
| **gid** | Primary Group ID | gid=1000(user) |
| **groups** | All group memberships | Multiple groups listed |

**UID Significance:**
- **0**: Reserved exclusively for root/superuser
- **1000+**: Regular user accounts (1000 being the first created)

#### Administrative Group Membership

**Sudo Group (Debian/Ubuntu):**
- Group number **27**
- Grants ability to execute administrative commands
- Users must still use `sudo` prefix to activate privileges

**Wheel Group (Fedora/RHEL):**
- Equivalent to sudo group on Red Hat-based systems
- Same functionality, different name

#### Practical Demonstration

**Failed Administrative Command:**
```bash
user@deb-client:~$ apt update
E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)
```

**Successful Command with sudo:**
```bash
user@deb-client:~$ sudo apt update
[sudo] password for user:
Hit:1 http://deb.debian.org/debian bullseye InRelease
# ... update proceeds successfully
7 packages can be upgraded. Run 'apt list --upgradable' to see them.
```

#### Advanced id Command Usage

**Query Specific User Information:**
```bash
root@deb-client:~# id user
uid=1000(user) gid=1000(user) groups=1000(user),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),109(netdev),115(bluetooth),120(scanner),997(docker)
```

#### Learning Additional Command Information

**Help Documentation:**
```bash
id --help
```

**Manual Pages:**
```bash
man id
# Press 'q' to quit manual page
```

> [!NOTE]
> Always explore `--help` and `man` pages for new commands to understand full capabilities and options.

### Lab Exercises

**Extra Credit Assignment:**
- Execute `id --help` to explore available options
- Run `man id` to review comprehensive documentation
- Practice using `id` with various user accounts

---

## Summary

### Key Takeaways

```diff
+ Linux has two primary user account types: root (superuser) and regular users
+ Root accounts use # prompt and have unrestricted system access
+ Regular users use $ prompt and have limited privileges by default
+ Principle of Least Privilege: grant only minimum necessary access
+ SSH as root should be avoided in production environments
+ Use sudo prefix and group membership for administrative access
+ Generic usernames like "user" are inappropriate for production
+ The id command reveals user IDs, group memberships, and sudo capabilities
+ UID 0 is exclusively reserved for root; regular users start at 1000
+ Always use --help and man pages to learn command capabilities
```

### Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `id` | Display user/group information | `id` |
| `id username` | Query specific user | `id user` |
| `sudo command` | Execute with administrative privileges | `sudo apt update` |
| `id --help` | Get command help | `id --help` |
| `man id` | View manual documentation | `man id` |

### Expert Insight

**Real-world Application:**
In production environments, implement centralized user management through directory services (Active Directory, LDAP) rather than local accounts. Configure sudoers files with specific command allowances rather than blanket administrative access. Use SSH key authentication instead of password-based login, and implement fail2ban or similar tools to protect against brute force attacks.

**Expert Path:**
Master user management by learning to configure `/etc/sudoers` and `/etc/sudoers.d/` for granular privilege control. Understand PAM (Pluggable Authentication Modules) configuration for advanced authentication policies. Practice creating service accounts with minimal required permissions for applications and databases.

**Common Pitfalls:**
- Leaving SSH root login enabled on internet-facing servers
- Adding users to sudo/wheel groups without proper justification
- Using generic account names that obscure accountability
- Forgetting that `sudo` commands are logged, creating audit trails
- Not implementing password complexity requirements for sudo-capable accounts

**Lesser-Known Facts:**
- The root account cannot be deleted or renamed on standard Linux systems
- User IDs below 1000 are traditionally reserved for system accounts
- The `id` command can display security context information with SELinux enabled using `id -Z`
- Sudo can be configured to allow specific commands without password authentication through NOPASSWD directives

</details>