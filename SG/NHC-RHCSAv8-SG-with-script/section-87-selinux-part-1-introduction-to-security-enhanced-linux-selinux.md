# Section 87: Security and SELinux

<details open>
<summary><b>Section 87: Security and SELinux (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Security and SELinux Overview](#security-and-selinux-overview)
- [Discretionary Access Control (DAC) vs Mandatory Access Control (MAC)](#discretionary-access-control-dac-vs-mandatory-access-control-mac)
- [SELinux: How It Works](#selinux-how-it-works)
- [SELinux Policies and Enforcement](#selinux-policies-and-enforcement)
- [SELinux Modes](#selinux-modes)
- [Benefits of SELinux](#benefits-of-selinux)
- [Practical Demonstration](#practical-demonstration)
- [Summary](#summary)

## Security and SELinux Overview
SELinux (Security Enhanced Linux) is an advanced security feature in Linux that provides an additional mandatory access control (MAC) layer beyond traditional discretionary access control (DAC). It enforces policies at the kernel level to control what processes, users, and applications can do on the system. SELinux is particularly beneficial for production environments where fine-grained security controls can prevent privilege escalation attacks, limit malware impact, and ensure data confidentiality and integrity.

This section introduces SELinux as a mandatory access control mechanism that adds an extra security layer to Linux. It explains why SELinux is crucial for securing systems that were previously reliant only on weaker DAC models, making Linux stand out from other operating systems. The session covers core concepts, how SELinux works, its enforcement modes, benefits, and basic practical demonstrations.

## Discretionary Access Control (DAC) vs Mandatory Access Control (MAC)
Traditional operating systems, including Linux without SELinux, primarily use Discretionary Access Control (DAC). In DAC, access permissions are discretionary—decision-making is based on the owner's or administrator's choice and can vary per user or resource. For example, if a root user owns a file and grants read-write access to specific users or groups, the access is flexible but vulnerable if the owner misconfigures permissions.

MAC, implemented through SELinux, enforces a strict policy where access is granted or denied based on predefined rules, without regard for owner discretion. Think of it as a security guard with a fixed access list: only those explicitly allowed can enter, unlike DAC where the owner has broad control. SELinux's MAC layer acts after DAC in the access decision process, providing layered security.

### Key Differences
| Feature | DAC (Discretionary) | MAC (Mandatory) |
|---------|---------------------|-----------------|
| Decision Basis | Owner/Admin choice | Predefined policy rules |
| Flexibility | High, varies per resource | Low, fixed rules |
| Vulnerability to Misconfiguration | High | Low |
| User Override | Possible | Not allowed |
| Enforcement Level | File system permissions | Kernel-level policies |

> [!IMPORTANT]
> SELinux provides defense-in-depth by layering MAC on top of DAC, ensuring that even if DAC is bypassed, MAC rules can block unauthorized access.

## SELinux: How It Works
SELinux operates within the Linux kernel, intercepting every access attempt (e.g., file reads, process executions, network connections) and checking it against policies. It labels all system resources—files, processes, users, and devices—with security contexts. A security context includes:

- **User Context**: Identifies the SELinux user (e.g., `unconfined_u` for unrestricted access).
- **Role Context**: Defines user roles (e.g., `object_r` for objects).
- **Type Context**: Specifies types (e.g., `user_t` for processes in user domain).

### Enforcement Process
1. A user or process attempts an operation (e.g., reading a file).
2. DAC checks permissions first (e.g., file ownership and permissions).
3. If DAC allows, SELinux's MAC checks the policy for a matching rule.
4. If the policy permits (e.g., user `unconfined_u` can access type `user_t`), access is granted; otherwise, denied with an audit log.

To view SELinux contexts:
- Files: `ls -Z /path/to/file` (shows user, role, type, and sensitivity level).
- Users: `id -Z` (displays current SELinux user context).
- Processes: `ps -Z` (lists process contexts, e.g., `system_u:system_r: httpd_t`).

SELinux uses three parts for access decisions: SELinux user, role, and type, along with a sensitivity level (0-1023).

> [!NOTE]
> Contexts are defined per object and can be customized for fine-grained control.

## SELinux Policies and Enforcement
SELinux policies are precompiled rules that dictate what actions are allowed. Policies are divided into targeted (default, focusing on vulnerable services) and multi-level security (MLS for strict classifications). Enforcement is rule-based: "allow" or "deny" based on context matches.

Key commands:
- Check enforcement status: `getconf ENFORCING` (1 = enforcing, 0 = permissive).
- Change enforcement: `setenforce 0` (temporary permissive) or `setenforce 1` (enforcing).
- View policy: Look at `/etc/selinux/config` for mode settings.

If a policy doesn't match, access is denied by default, preventing exploitation.

## SELinux Modes
SELinux operates in three modes:

1. **Enforcing Mode**: Policies are actively enforced at kernel level. Denials are blocked, and failures are logged. This is default for Fedora and recommended for production.
2. **Permissive Mode**: Policies are checked but not enforced—access is allowed, but violations are logged. Useful for debugging without breaking applications.
3. **Disabled Mode**: SELinux is completely off, allowing only DAC. Not recommended for security, as it removes MAC benefits.

### Switching Modes Temporarily
- To permissive (audits without blocking): `sudo setenforce 0`
- To enforcing: `sudo setenforce 1`
- Reboot to permanent mode change via `/etc/selinux/config` (edit `SELINUX=enforcing|permissive|disabled`).

Reboot after disabling, as it requires kernel reload. Always use enforcing mode for security.

> [!IMPORTANT]
> Never disable SELinux without necessity, as it undermines the "defense-in-depth" strategy.

## Benefits of SELinux
SELinux enhances security through process separation, confinement, and limiting damage from exploits. Processes run in isolated domains, preventing compromise spread (e.g., web server daemon confined to its domain). It provides fine-grained access control where users, roles, and types control operations precisely.

Key Benefits:
- **Privilege Escalation Prevention**: Limits lateral movement in system breaches.
- **Data Protection**: Forces confidentiality and integrity even from legitimate users.
- **Application Isolation**: Processes can't access unrelated resources if policies disallow.
- **Limiting Exploits**: Reduces impact of malware or untrusted applications.
- **Process Separation**: Each app runs in its domain, blocking cross-contamination.

Unlike Windows, SELinux's MAC ensures no system-wide access from compromised processes.

## Practical Demonstration
In this demo, create a file and observe DAC vs SELinux contexts.

1. Create a temp file: `echo "test" > /tmp/test.txt`
2. Check permission: `ls -l /tmp/test.txt` (shows owner, group, permissions).
3. Check SELinux context: `ls -Z /tmp/test.txt` (displays user, role, type, e.g., `unconfined_u:object_r:user_tmp_t:s0`).
4. Try limiting access: Change owner to root some and observe enforcement blocking.

If in permissive mode, violations log but don't block; enforcing denies access.

To reset contexts after root password reset (if needed): Use `touch /.autorelabel` and reboot for permanent relabeling.

Lab Steps Summary:
- Enable SELinux enforcing mode.
- Create test files and processes.
- Modify contexts using `chcon` or policies (advanced).
- Monitor denials with `ausearch -m avc` for troubleshooting.

> [!NOTE]
> Practice in a VM to avoid breaking your system; SELinux demos require careful policy management.

## Summary
### Key Takeaways
```diff
+ SELinux adds mandatory access control for robust Linux security
+ Operates in enforcing, permissive, or disabled modes; use enforcing by default
+ Labels resources with contexts (user, role, type) checked against policies
+ Process separation and fine-grained control limit exploit damage
! Default deny ensures only explicit policy matches allow access
- Do not disable SELinux unnecessarily; it provides critical defense layers
```

### Quick Reference
- **Check Status**: `getconf ENFORCING`
- **Set Permissive**: `setenforce 0`
- **Set Enforcing**: `setenforce 1`
- **View Contexts**: `ls -Z` (files), `ps -Z` (processes), `id -Z` (users)
- **Audit Logs**: `ausearch -m avc`
- **Config File**: `/etc/selinux/config`

### Expert Insight
**Real-world Application**: In production servers (e.g., web servers), SELinux confines daemons like Apache (`httpd_t`) to their directories, preventing hacked processes from accessing sensitive files. Use targeted policies for common services to balance security and usability.

**Expert Path**: Master SELinux by configuring custom modules with `semanage` and policies with `semodule`. Study AVC denials logs to tune rules—start with permissive mode for learning. Pursue certifications like RHCSA/RHCE covering SELinux deeply.

**Common Pitfalls**: Misconfigured contexts can break apps (e.g., wrong file type); relabel with `restorecon`. Over-permissive policies defuse security—always audit rules. Avoid disabling SELinux in production; use permissive for troubleshooting instead.

</details>
