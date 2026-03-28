# Section 88: SELinux Contexts - Domain Transitions

<details open>
<summary><b>Section 88: SELinux Contexts - Domain Transitions (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to SELinux Contexts](#introduction-to-selinux-contexts)
- [SELinux Context Components](#selinux-context-components)
- [Understanding SELinux Users](#understanding-selinux-users)
- [Understanding Role (Role-Based Access Control)](#understanding-role-role-based-access-control)
- [Understanding Type (Type Enforcement)](#understanding-type-type-enforcement)
- [Understanding Level (Multi-Level Security - MLS)](#understanding-level-multi-level-security---mls)
- [Domain Transitions](#domain-transitions)
- [Practical Demonstrations](#practical-demonstrations)
- [Summary](#summary)

## Introduction to SELinux Contexts

SELinux (Security-Enhanced Linux) contexts are additional security attributes that provide Mandatory Access Control (MAC) mechanisms in Linux systems. Contexts apply to users, files, and processes, enabling stringent security through role-based access control, type enforcement, and multi-level security.

SELinux contexts consist of four components: user, role, type, and security level. These components work together to make access control decisions, preventing unauthorized access and providing an extra layer of security.

## SELinux Context Components

A complete SELinux context follows this format:
```
user:role:type:level
```

For example:
```bash
system_u:object_r:httpd_t:s0:c0.c1023
```

This combines:
- **Role-Based Access Control (RBAC)**
- **Type Enforcement (TE)**
- **Multi-Level Security (MLS)**

These three components provide the core security mechanisms in SELinux implementations across distributions like Fedora and Red Hat Enterprise Linux.

## Understanding SELinux Users

SELinux users are not the same as standard Linux users. They are SELinux-specific identities mapped to local user accounts through SELinux policies.

Key characteristics:
- SELinux users are defined in SELinux policies
- They authorize users for specific sets of roles and MLS ranges
- One SELinux user can be mapped to multiple local accounts
- Restricts inheritance of restrictions from local user accounts

### Listing SELinux Users
```bash
semanage login -l
```

Example output:
```
Login Name           SELinux User         MLS/MCS Range        Service

__default__          unconfined_u         s0-s0:c0.c1023       *
root                 unconfined_u         s0-s0:c0.c0          *
```

### Key Points
- Most standard users map to `unconfined_u` SELinux user
- The `unconfined_u` user provides authorizations for roles and MLS ranges
- SELinux policies define which roles and levels each user can access
- This mapping helps control what a local user can do in the SELinux environment

## Understanding Role (Role-Based Access Control)

Roles in SELinux are a core component of Role-Based Access Control (RBAC) security model.

Key characteristics:
- Roles determine which types users can enter
- Roles are authorized for specific domains and processes
- They serve as intermediaries between SELinux users and domains
- Default role for most users is `object_r`

### Role Structure
- **Roles** control domain access
- **Users** own roles and authorizations
- **Domains** are sets of permissions for running processes

Example context showing role:
```bash
unconfined_u:object_r:user_t:s0
```

Roles ensure that if a user is authorized for a role, they can only perform operations within authorized domains.

## Understanding Type (Type Enforcement)

Types are the most critical component for processes and files in SELinux. Type Enforcement (TE) determines:
- Which domains processes can run in
- Which files/types other domains can access
- Access patterns between domains

### For Process Domains
```bash
# List process contexts
ps -Z
```

Example output:
```
LABEL                           PID TTY      STAT   TIME COMMAND
system_u:system_r:httpd_t:s0    1234 ?        Ss     0:01 httpd
```

### For Files
```bash
# List file contexts
ls -Z /etc/passwd
```

Example output:
```bash
system_u:object_r:passwd_file_t:s0 /etc/passwd
```

### Type Enforcement Rules
- **Processes**: Confined to specific domains based on their type
- **Files**: Access controlled based on their type
- **Policy Rules**: Define which types can access other types
- **Network Services**: Type enforcement prevents unauthorized network access

*!IMPORTANT*
Type enforcement is crucial for controlling which processes can access which resources, providing the foundation for SELinux security.

## Understanding Level (Multi-Level Security - MLS)

Levels implement Multi-Level Security (MLS) using sensitivity and category ranges.

### Sensitivity Levels
- Range from `s0` to `s15` (0-15 in decimal)
- `s0` = lowest sensitivity (public data)
- Higher numbers = higher sensitivity (confidential data)
- Represents data classification levels

### Categories
- Range from `c0` to `c1023`
- 1024 possible categories (2^10)
- Each category represents a security compartment
- Allows for fine-grained access control

### MLS Examples
```bash
# Single level and category
s0:c0

# Range format
s0-s0:c0.c1023

# Multiple categories
s2:c10,c15,c20
```

Categories allow you to create 1024 different security compartments, enabling complex security scenarios where data is compartmentalized.

## Domain Transitions

Domain transitions occur when a process running in one domain needs to access resources in another domain, subject to SELinux policy rules.

### How Domain Transitions Work
1. A process in domain A calls an entry point for domain B
2. SELinux policy must allow the transition
3. Process runs with the context of domain B

### Real-World Example: passwd Command
```bash
# Check current processes
ps -Z | grep passwd

# Run passwd command
passwd
# This triggers a domain transition

# Check processes again
ps -Z | grep passwd
```

The `passwd` command demonstrates how users can transition to privileged domains for specific operations, then return to their original domain.

### Entry Points
- **Entry Points**: Specific functions allowing domain transitions
- **Policy Rules**: Must exist for transitions to occur
- **Type Enforcement**: Determines which domains can make transitions

```diff
! Client Request → Initial Process → Domain Transition → Privileged Domain → Resource Access
```

## Practical Demonstrations

### Listing File Contexts
```bash
# List SELinux context for /etc/passwd
ls -Z /etc/passwd

# List context for /etc/shadow
ls -Z /etc/shadow

# List context for a directory
ls -Zd /etc
```

### Listing Process Contexts
```bash
# Show all processes with SELinux contexts
ps -Z

# Show specific process context
ps -Z -p <PID>
```

### Listing User Contexts
```bash
# Show current user's SELinux context
id -Z

# List all login mappings
semanage login -l

# Show SELinux user details
seinfo -u
```

### Domain Transition Demonstration
```bash
# Before running passwd
ps -Z | grep -E "(passwd|system)"

# Start passwd process (will prompt for password)
passwd

# Check running processes during passwd execution
ps -Z | grep passwd

# Process will show context like:
# system_u:system_r:passwd_t:s0 /usr/bin/passwd
```

### Killing Processes to Observe Transitions
```bash
# Kill passwd process (Ctrl+C during execution)
# Then check if it disappears from process list
ps -Z | grep passwd
```

## Summary

### Key Takeaways
```diff
+ SELinux contexts provide Mandatory Access Control with four components: user, role, type, level
+ Type Enforcement is the most critical for controlling process and file access
+ Roles serve as intermediaries between users and process domains
+ Multi-Level Security uses sensitivity levels and categories for data classification
+ Domain transitions allow controlled movement between security domains
+ Type enforcement determines which domains processes can run in and which files they can access
- Common mistake: Confusing SELinux users with Linux system users
- Forgetting that context changes don't persist across sessions without permanent modifications
```

### Quick Reference
**Common Commands:**
```bash
ls -Z              # List file SELinux contexts
ps -Z              # List process SELinux contexts
id -Z              # Show current user SELinux context
semanage login -l  # List user-role mappings
seinfo -u          # Show SELinux user information
```

**Context Format:**
```bash
user:role:type:level
```

**MLS Range Format:**
```bash
s0-s15:c0.c1023    # Sensitivity 0-15, categories 0-1023
```

### Expert Insight
**Real-World Application**: SELinux contexts are essential in production environments for confining services and preventing privilege escalation attacks. Domain transitions ensure that even privileged operations are strictly controlled.

**Expert Path**: Master SELinux by studying policy creation and customization. Learn to write custom policy modules for complex applications.

**Common Pitfalls**: 
- Assuming SELinux users are system users (they're separate identities)
- Overlooking that permissive mode doesn't enforce restrictions
- Forgetting that file relabeling is temporary unless made permanent

</details>
