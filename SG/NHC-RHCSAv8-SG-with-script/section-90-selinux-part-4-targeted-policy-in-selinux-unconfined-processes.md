# Section 90: Targeted Policy in SELinux - Unconfined Processes

<details open>
<summary><b>Section 90: Targeted Policy in SELinux - Unconfined Processes (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Deep Dive into Unconfined Processes](#deep-dive-into-unconfined-processes)
- [Comparisons: Confined vs. Unconfined Processes](#comparisons-confined-vs-unconfined-processes)
- [Lab Demo: Changing Process Context](#lab-demo-changing-process-context)
- [Summary](#summary)
- [Key Takeaways](#key-takeaways)
- [Quick Reference](#quick-reference)
- [Expert Insight](#expert-insight)

## Overview
In this section of the SELinux training series, we explore the Targeted Policy and specifically focus on unconfined processes. Unlike confined processes that run within SELinux domains (like confined_t), unconfined processes operate in domains that allow broader access to system resources. The session demonstrates practical examples showing how changing a process's SELinux context can enable it to bypass restrictions, emphasizing security implications when processes are compromised.

> [!IMPORTANT]  
> Understanding the distinction between confined and unconfined processes is crucial for effective SELinux policy management. Unconfined processes can access any file or resource, regardless of permissions, which undermines SELinux's mandatory access control.

## Key Concepts
- **SELinux Domains**: Domains determine what a process can access. Confined domains restrict access, while unconfined domains like `unconfined_t` grant broader privileges.
- **Context Labels**: SELinux labels processes and files with contexts in the format `user:role:type:optional_range`. Changing the type (e.g., from `confined_t` to `unconfined_t`) alters access permissions.
- **Targeted Policy**: This policy primarily confines specific high-risk services while leaving most processes running unconfined for usability.
- **Process Types**: 
  - User-initiated processes may run in `unconfined_t`.
  - System processes executed by the kernel use specific domains like `system_u:system_r:init_t`.
  - Services listening on networks are confined to `confined_t` unless configured otherwise.
- **Security Implications**: If an unconfined process is compromised, attackers can access the entire file system, bypassing discretionary access controls.

> [!NOTE]  
> In SELinux, policies apply rules to processes based on their domains. Unconfined processes are exempt from most restrictions for operational flexibility.

## Deep Dive into Unconfined Processes
Unconfined processes in SELinux run in domains that do not enforce mandatory access controls (MAC), allowing them to interact with the system as if SELinux were disabled for them. This is common for user applications and many system processes to avoid usability issues.

### Types of Unconfined Processes in Targeted Policy
- **User-Initiated Processes**: If started by an unprivileged user, they run in `unconfined_t`, capable of accessing system-wide resources.
- **Kernel-Managed System Processes**: Executed by the kernel, these use domains like `system_u:system_r:device_t` for hardware management and `system_u:system_r:init_t` for system initialization.
- **Third-Party Applications**: Processes from manually launched tools or scripts may fall into `unconfined_t` if not explicitly confined.

### Why Unconfined Processes Exist
SELinux prioritizes security without breaking functionality. Confining all processes could lead to usability problems, so the targeted policy leaves most unconfined while focusing protections on critical network services.

### Risks of Compromised Unconfined Processes
- Attacker can read/write to any file system location.
- Bypasses file permissions and other discretionary controls.
- Can escalate privileges or exfiltrate sensitive data undetected.

```bash
# Check current SELinux domain of a process (e.g., PID 1234)
ps -Z 1234

# Output might show: system_u:system_r:httpd_t:s0 (confined) or system_u:system_r:unconfined_t:s0 (unconfined)
```

💡 **Tip**: Always verify process domains using `ps -Z` before making configuration changes.

## Comparisons: Confined vs. Unconfined Processes
The following table highlights key differences:

| Aspect              | Confined Processes (e.g., httpd_t) | Unconfined Processes (e.g., unconfined_t) |
|---------------------|-------------------------------------|-------------------------------------------|
| Access Control      | Strict MAC enforced                 | Broad access, MAC relaxed                |
| Domain Restrictions | Limited to specific resources       | Can access entire file system            |
| Network Listening   | Typically confined                  | All privileges granted                   |
| Compromise Impact   | Access limited to process scope     | Full system compromise possible          |
| Common Use Case     | Web servers, databases              | User CLI tools, general applications     |

```diff
+ Confined: Protects specific high-risk services in targeted policy
- Unconfined: High risk if compromised; bypasses SELinux boundaries
! Key Insight: Targeted policy balances security and usability by confining only the essentials
```

## Lab Demo: Changing Process Context
This lab demonstrates changing an Apache process from confined to unconfined, showing how it bypasses SELinux restrictions. ⚠ **Warning**: This is for educational purposes only. Changing contexts in production can violate security policies—always revert changes after testing.

### Prerequisites
- SELinux enabled in enforcing mode.
- Apache web server installed (`httpd` package).
- A test file in `/var/www/html/` with restrictive SELinux context.

### Step-by-Step Demo
1. **Create a Test File**:
   - Create a test web file in `/var/www/html/test.php`:
     ```bash
     echo "Hello from restricted file!" > /var/www/html/test.php
     ```
   - Change its SELinux context to Samba share (restrictive):
     ```bash
     chcon -t samba_share_t /var/www/html/test.php
     ```
   - Verify contexts:
     ```bash
     ls -Z /var/www/html/
     # Output: -rw-r--r--. apache apache samba_share_t:s0 test.php
     ```

2. **Stop Apache Service**:
   - Stop and check service status:
     ```bash
     systemctl stop httpd
     systemctl status httpd
     ```

3. **Modify Apache Binary Context** (To Make Process Unconfined):
   - Locate Apache binary (e.g., `/usr/sbin/httpd`):
     ```bash
     ls -Z /usr/sbin/httpd
     # Initially: system_u:object_r:bin_t:s0 (use system_r:confined_t for confined processes)
     ```
   - Change binary's context to unconfined:
     ```bash
     chcon system_u:object_r:unconfined_exec_t:s0 /usr/sbin/httpd
     ```
   - Verify change:
     ```bash
     ls -Z /usr/sbin/httpd
     # Now: system_u:object_r:unconfined_exec_t:s0
     ```

4. **Add Firewall Rule and Start Service**:
   - Allow HTTP traffic:
     ```bash
     firewall-cmd --permanent --add-service=http
     firewall-cmd --reload
     ```
   - Start Apache:
     ```bash
     systemctl start httpd
     ```
   - Verify process domain:
     ```bash
     ps -Z | grep httpd
     # Output: system_u:system_r:unconfined_t:s0 (unconfined domain)
     ```

5. **Test Access**:
   - Download restricted file via `wget` (should succeed now):
     ```bash
     wget localhost/test.php
     # Success: file downloads despite samba_share_t context
     ```
   - Access via browser: Navigate to `http://localhost/test.php` — content displays despite restrictions.

6. **Revert Changes**:
   - Stop service and restore original context:
     ```bash
     systemctl stop httpd
     restorecon /usr/sbin/httpd
     ```
   - Change test file back:
     ```bash
     restorecon /var/www/html/test.php
     ```
   - Restart service to verify confinement:
     ```bash
     systemctl start httpd
     ps -Z | grep httpd
     # Should return to system_u:system_r:httpd_t:s0
     ```
   - Retest download (should fail):
     ```bash
     wget localhost/test.php  # Expected: Forbidden or permission denied
     ```

```diff
+ Lab Outcome: Unconfined process bypasses SELinux restrictions
- Pitfall: Never leave processes unconfined in production environments
! Real-World Note: This demo illustrates attack vectors; always confine network-facing services
```

## Summary
Section 90 covered the targeted policy in SELinux, focusing on unconfined processes that run in domains like `unconfined_t`, granting them unrestricted access. The lab showed how changing an Apache process's context from confined to unconfined allows bypassing file permission restrictions, highlighting security risks. Confined processes in `confined_t` domains protect specific services, while unconfined ones balance flexibility but increase vulnerability if compromised.

## Key Takeaways
```diff
+ Unconfined processes run in unconfined_t domain and can access any system file, ignoring traditional permissions.
- If an unconfined process is exploited, attackers gain full system access, rendering SELinux ineffective for that process.
! Targeted policy confines only network services; user processes remain unconfined for usability.
+ Change contexts carefully: Use chcon/restorecon; monitor with ps -Z audit logs.
- Mistake: Leaving processes unconfined post-compromise—always restore restrictive contexts.
+ Best Practice: Limit unconfined processes to trusted internal tools only.
```

## Quick Reference
- **Check Process Domains**: `ps -Z <PID>`
- **View File Contexts**: `ls -Z <file>`
- **Change Context Temporarily**: `chcon -t <new_type> <file/binary>`
- **Restore Default Context**: `restorecon <file/binary>`
- **Audit SELinux Logs**: `grep "avc: denied" /var/log/audit/audit.log`
- **Set SELinux Mode**: `setenforce 1` (enforcing) or `0` (permissive)

## Expert Insight
### Real-world Application
In production environments, SELinux targeted policy is standard for RHEL/CentOS systems. Network services like web servers (httpd) run confined to prevent web-based attacks from compromising the entire system. System administrators use tools like `audit2why` to analyze denial logs and adjust policies without downgrading to unconfined modes. For high-security setups, consider MLS (Multi-Level Security) policy extensions.

### Expert Path
Master SELinux by studying custom policy development using `sepolicy` and `semodule`. Practice in labs simulating attacks on confined services. Pursue certifications like Red Hat's RHCE or CompTIA Security+, focusing on intrusion detection. Contribute to SELinux mailing lists for advanced tuning.

### Common Pitfalls
- Over-relaxing policies (e.g., setting `setenforce 0`)—leads to unprotected systems.
- Ignoring audit logs—miss policy violations; always review with `ausearch`.
- Using `chcon` permanently instead of policy modules—changes don't survive reboots; use SELinux policy tools.
- Assuming unconfined equals fully secure—always monitor for anomalies and apply least privilege.

💡 **Final Advice**: SELinux is a layered defense; combine with other controls like firewalls and monitoring. Regular audits ensure policies evolve with system changes.

</details>
