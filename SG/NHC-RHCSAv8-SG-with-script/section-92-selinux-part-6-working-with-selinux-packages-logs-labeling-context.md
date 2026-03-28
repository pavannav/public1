# Section 92: Working with SELinux

<details open>
<summary><b>Section 92: Working with SELinux (CL-KK-Terminal)</b></summary>

## Table of Contents

- [SELinux Packages](#selinux-packages)
- [SELinux Log Files](#selinux-log-files)
- [SELinux Configuration File](#selinux-configuration-file)
- [Enabling and Disabling SELinux](#enabling-and-disabling-selinux)
- [SELinux Modes](#selinux-modes)
- [Configuring Booleans](#configuring-booleans)
- [Shell Auto Completion](#shell-auto-completion)
- [SELinux Labeling and Relabeling](#selinux-labeling-and-relabeling)
- [Summary](#summary)

## SELinux Packages

SELinux (Security Enhanced Linux) functionality relies on several packages that provide essential utilities and policy management capabilities.

### Core Packages (Usually Installed by Default)

- **policycoreutils**: Provides basic utilities for managing SELinux systems
  ```bash
  rpm -qi policycoreutils
  ```
  This package enables commands like `restorecon`, `setsebool`, and `setfiles`.

- **selinux-policy-targeted**: Provides the SELinux reference policy configuration
  - Used for targeted policy management

- **setroubleshoot-server**: Helps diagnose SELinux problems

- **libselinux-python**: Provides Python bindings for developing SELinux applications
  - Must be installed manually if needed

### Additional Packages (Not Installed by Default)

- **libselinux-python**: For Python development with SELinux APIs
- **checkpolicy**: For creating custom SELinux policies
- **selinux-policy-mls**: For Multi-Level Security configurations
- **policycoreutils-gui**: Graphical interface for SELinux management
- **policycoreutils-python**: Additional audit management utilities

### Package Verification

To check if a package is installed:
```bash
rpm -q package_name
```

## SELinux Log Files

SELinux logs are crucial for monitoring security policy violations and system events.

### Log Storage Location

SELinux logs are stored in `/var/log/audit/audit.log`. Unlike other system logs, SELinux-specific logs are primarily found here rather than in message files.

### Required Services

For logs to be written to `/var/log/audit/audit.log`, the following services must be running:
- **auditd.service**: Main logging service
- **rsyslog.service**: Additional logging service

Check service status:
```bash
systemctl status auditd
systemctl status rsyslog
```

### Viewing SELinux Logs

- View last 10 lines: `tail /var/log/audit/audit.log`
- Search for specific patterns: `grep "SELinux" /var/log/messages`

Access denial messages specifically appear in the audit log, while some informational messages may appear in the regular message log.

> [!WARNING]
> If SELinux logs are not being generated, verify that both auditd and rsyslog services are active and enabled.

## SELinux Configuration File

The main SELinux configuration file controls the system's security policy behavior.

### Configuration File Path

```
/etc/selinux/config
```

### Configuration Options

The file contains two primary settings:
- **SELINUX**: Defines the SELinux operating mode
- **SELINUXTYPE**: Determines the policy type

### Mode Options

- **enforcing**: Strict policy enforcement with access denials logged
- **permissive**: Warnings issued but access granted, with logging
- **disabled**: No policy enforcement or logging

### Policy Type Options

- **targeted**: Default policy protecting specific processes
- **minimum**: Modified targeted policy for selected processes
- **mls**: Multi-Level Security with additional security levels

## Enabling and Disabling SELinux

Changes to SELinux state can be made temporarily or permanently.

### Temporary Changes

```bash
# Switch to permissive mode temporarily
setenforce 0

# Switch to enforcing mode temporarily
setenforce 1
```

### Permanent Changes

Edit `/etc/selinux/config` and set the desired mode:
```bash
vim /etc/selinux/config
```

> [!IMPORTANT]
> Changes take effect after reboot. Never disable SELinux completely in production environments, and avoid permissive mode for compliance requirements.

### Verifying Current Mode

```bash
# Check current enforcement status
sestatus

# Check only the current mode
getenforce
```

## SELinux Modes

Understanding SELinux modes is essential for effective security management.

### Enforcing Mode

- Security policies are strictly enforced
- Access violations result in denial and logging
- Most secure but may require policy adjustments

### Permissive Mode

- Policies generate warnings but allow access
- All violations are logged for analysis
- Useful for troubleshooting without blocking operations

### Disabled Mode

- No security policies are loaded or enforced
- No access control or logging occurs
- Not recommended for production systems

### Policy Types

| Policy Type | Purpose | Usage |
|-------------|---------|--------|
| targeted | Protects specific processes | Default for most systems |
| minimum | Modified targeted policy | For constrained environments |
| mls | Multi-Level Security | For high-security requirements |

## Configuring Booleans

Booleans allow runtime modification of SELinux policy behavior without full policy rewrites.

### Listing Booleans

```bash
# List all booleans with status
semodule -b

# Alternative method
getsebool -a

# Count number of booleans
getsebool -a | wc -l
```

### Searching Specific Booleans

```bash
# Search boolean by name fragment
getsebool -a | grep "ftp"

# Get details for specific boolean
semodule -b | grep "ftp_home_dir"
```

### Modifying Boolean Values

**Temporary changes:**
```bash
# Enable boolean temporarily
setsebool httpd_can_network_connect_db on

# Verify change
getsebool httpd_can_network_connect_db
```

**Permanent changes:**
```bash
# Enable boolean permanently
setsebool -P httpd_can_network_connect_db on
```

### Common Boolean Commands

```bash
# Get status of specific boolean
getsebool boolean_name

# List all booleans (alternative)
semodule -b

# Detailed boolean information
semodule -b | grep "boolean_pattern"
```

## Shell Auto Completion

Shell auto-completion greatly simplifies SELinux command usage in the terminal.

### Using Tab Completion

Press `Tab` after partially typing commands:

```bash
# Complete SELinux commands
setsebool [Tab]        # Shows available boolean names
getsebool [Tab]       # Shows boolean completion options
semodule -b | grep sa # Tab completion after partial typing
```

### Examples

```bash
# Complete samba-related booleans
getsebool samba_[Tab]
# Shows all samba_* booleans for selection

# Complete FTP configuration
semodule -b ftp_[Tab]
# Lists available FTP-related options
```

## SELinux Labeling and Relabeling

SELinux contexts (labels) control access permissions for files and processes.

### Understanding SELinux Context

A typical SELinux context consists of four components:
```
user:role:type:mls_level
```

Example: `unconfined_u:object_r:user_home_t:s0`

### Viewing File Contexts

```bash
# View SELinux context for files
ls -Z filename

# View directory context
ls -dZ /directory/path

# Long listing with context
ls -lZ filename
```

### Temporary Relabeling

Use `chcon` for temporary changes (reverted on reboot):

```bash
# Change file type to httpd content
chcon -t httpd_sys_content_t /path/to/file

# Recursive relabeling
chcon -R -t samba_share_t /path/to/directory
```

**Restore original context:**
```bash
restorecon /path/to/file
```

### Permanent Relabeling

Use `semanage` to make policy-level changes:

```bash
# Add permanent label change
semanage fcontext -a -t samba_share_t "/path/to/file"

# Apply the policy changes
restorecon -v /path/to/file

# For directories and contents
semanage fcontext -a -t httpd_sys_content_t "/web/.*"
restorecon -v /web/
```

### User Context Management

Switch SELinux user context:
```bash
# Change to unconfined user (if available)
semanage login -a -s unconfined_u username
```

### Troubleshooting Labeling Issues

```bash
# Check for relabeling issues
sestatus | grep "SELinux status"
restorecon -Rnv /  # Dry run to check what would change
```

## Summary

### Key Takeaways

```diff
+ SELinux is a security feature providing mandatory access control for Linux systems
+ Three operating modes: enforcing (strict security), permissive (logging without blocking), disabled (no security)
+ Security policies are managed through booleans (runtime changes) and modules (permanent changes)
+ SELinux contexts (labels) define access permissions for files, processes, and users
- Always test policy changes in permissive mode before implementing in production
- Never disable SELinux completely without understanding the security implications
! Use audit logs in /var/log/audit/audit.log to diagnose access denials
! Proper context labeling is crucial for service functionality
- Temporary changes (using setenforce or chcon) revert upon reboot
```

### Quick Reference

**Configuration Management:**
```bash
# Check SELinux status
sestatus
getenforce

# Switch modes
setenforce 1  # enforcing
setenforce 0  # permissive

# Edit configuration
vim /etc/selinux/config
```

**Context Management:**
```bash
# View contexts
ls -Z /etc/
ls -dZ /var/

# Temporary relabeling
chcon -t unconfined_t /file
chcon -R -t httpd_content_t /web/

# Permanent relabeling
semanage fcontext -a -t samba_share_t "/share(/.*)?"
restorecon -v /share/

# Verify changes
matchpathcon /path/to/file
```

**Boolean Management:**
```bash
# List booleans
getsebool -a
semodule -b

# Modify booleans
setsebool boolean_name on           # temporary
setsebool -P boolean_name on        # permanent
```

**Log Analysis:**
```bash
# View SELinux logs
tail /var/log/audit/audit.log
grep "SELinux" /var/log/messages
```

### Expert Insight

**Real-world Application:**
In enterprise environments, SELinux provides defense-in-depth security for servers running web services, databases, and file sharing. The targeted policy protects critical daemons while maintaining usability for development environments. Organizations often use MLS or custom policies for classified systems where data segregation is paramount.

**Expert Path:**
Begin by mastering the relationships between SELinux contexts, domains, and types - understanding how file types determine process domain transitions is crucial. Practice with `audit2why` and `audit2allow` commands for policy analysis. Advanced practitioners write custom policies that incorporate both type enforcement and multi-category security.

**Common Pitfalls:**
1. **Context Confusion**: Misunderstanding the difference between temporary (`chcon`) and permanent (`semanage`) context changes leads to inconsistent security controls.
2. **Over-reliance on Permissive Mode**: Using permanent permissive mode defeats SELinux's purpose and should only be used for diagnostics.
3. **Incomplete Boolean Management**: Failing to set booleans permanently can cause services to function unreliably after reboots.
4. **Manual Policy File Editing**: Directly editing `/etc/selinux/targeted/contexts/files/file_contexts.local` without proper tools can introduce errors.
5. **Ignoring Log Rotation**: SELinux logs can grow rapidly; implement proper log rotation to prevent disk space issues.

</details>
