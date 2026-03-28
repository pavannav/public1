# Section 93: Managing SELinux Security Contexts and Labels

<details open>
<summary><b>Section 93: Managing SELinux Security Contexts and Labels (CL-KK-Terminal)</b></summary>

## Table of Contents
1. [Managing Ports in SELinux Policies](#managing-ports-in-selinux-policies)
2. [Managing Security Contexts of Files and Directories](#managing-security-contexts-of-files-and-directories)
3. [File Contexts After System Relabeling](#file-contexts-after-system-relabeling)
4. [SELinux Contexts for Extended File Systems](#selinux-contexts-for-extended-file-systems)
5. [Mounting File Systems and Sharing Volumes](#mounting-file-systems-and-sharing-volumes)
6. [Maintaining SELinux Labels with File Operations](#maintaining-selinux-labels-with-file-operations)

## Managing Ports in SELinux Policies
### Overview
SELinux policies define allowed ports for services. You can list, add, or modify port rules using `semanage port` commands to ensure proper network security.

### Key Concepts
- **Listing Ports**: Use `semanage port -l` to view all defined ports and associated policies.
- **Adding Ports**: For custom ports, use `semanage port -a -t <policy_type> -p <protocol> <port_number>`.
- **Modifying Existing Ports**: Edit policy files like `/etc/selinux/example/modules/active/ports.local` for complex changes.
- **Verifying Changes**: Attempts to use undeclared ports fail; reassess ports via policy rules if needed.

### Lab Demo: Adding a Custom Port
```bash
# List all ports
semanage port -l | grep <service>

# Add a custom port, e.g., SSH alternative on port 71
semanage port -a -t ssh_port_t -p tcp 71

# Verify the port is listed
semanage port -l | grep 71

# Edit port list if changes don't persist recipes via `semanage port -list`
```

> [!IMPORTANT]
> Custom ports must match service policies; otherwise, access is denied. Reload policies after changes.

## Managing Security Contexts of Files and Directories
### Overview
File and directory contexts (labels) control access. Contexts include user, role, type, and security level. Temporary changes reset on relabeling, while permanent changes need policy edits or `setfiles`.

### Key Concepts
- **Temporary Changes**: Use `chcon` with `-R` for recursive changes; these reset on relabeling or reboots.
- **Permanent Changes with semanage**: Edit rules with `semanage fcontext` and apply with `restorecon` or `setfiles`.
- **Direct File Editing**: Modify context files like `/etc/selinux/targeted/contexts/files/file_contexts.local` for local policies.
- **Verification**: Use `ls -Z` to check contexts after changes.

### Lab Demo: Changing File Contexts
```bash
# Create test files
touch /root/file1 /root/file2 /root/file3

# Apply samba share context temporarily
chcon -t samba_share_t /root/file1
ls -Z /root/file1  # Verify context

# Make permanent via semanage
semanage fcontext -a -t samba_share_t /root/file2
restorecon -R /root/file2  # Apply to filesystem

# Edit directly in policy file
# /etc/selinux/targeted/contexts/files/file_contexts.local
# Add: /root/file3 system_u:object_r:samba_share_t:s0
# Then apply
setfiles -F /etc/selinux/targeted/contexts/files/file_contexts.local /root/file3

ls -Z /root/file1 /root/file2 /root/file3  # Compare contexts
```

## File Contexts After System Relabeling
### Overview
Upon reboot or forced relabeling (e.g., via `touch /.autorelabel`), temporary context changes via commands like `chcon` reset to default policies. Permanent policy edits in configuration files persist.

### Key Difference Visualization
```diff
- Temporary contexts (e.g., from chcon) get reset during relabeling
+ Permanent contexts from semanage or direct file edits are restored
```

> [!NOTE]
> Boots with an `.autorelabel` file trigger SELinux relabeling. Use appropriate commands for permanence.

## SELinux Contexts for Extended File Systems
### Overview
For extended (e.g., XFS or ext4) file systems outside standard policies, you may see context like `unconfined_u:object_r:default_t:s0` or `system_u:object_r:httpd_sys_content_t:s0`. Local rules resolve mismatches.

### Common Contexts
- **Unlabeled System SC Objects**: Seen on new or imported file systems requiring context rules.
- **Default Contexts**: Files without matching patterns get `default_t`.
- **Adding Rules**: Use `semanage fcontext -a -t <type> <path>` and reload with `restorecon`.

### Lab Demo: Fixing Unmatched Contexts
```bash
# Create a file on extended filesystem
mkdir /mnt/extended
touch /mnt/extended/testfile
ls -Z /mnt/extended/testfile  # Might show default_t or no context

# Add matching rule
semanage fcontext -a -t httpd_sys_content_t /mnt/extended/testfile
restorecon -R /mnt/extended/testfile

ls -Z /mnt/extended/testfile  # Verify updated context
```

> [!WARNING]
> Context mismatches can block service access. Always define rules for non-standard paths.

## Mounting File Systems and Sharing Volumes
### Overview
When mounting NFS or CIFS shares, specify SELinux context at mount time using options like `context=<user>:<role>:<type>:<level>` to allow sharing across services.

### Key Concepts
- **Preventing Шар sharing**: SELinux blocks cross-service sharing by default for security.
- **Mounting with Context**: Use `-o context=` in mount commands to set appropriate type (e.g., `httpd_sys_content_t` for httpd).
- **Permanent Mounts**: Add entries to `/etc/fstab` with context options.

### Lab Demo: Mounting a Share
```bash
# Mount a CIFS share for httpd
mount -t cifs -o username=user,password=pass,context=system_u:object_r:httpd_sys_content_t:s0 //server/share /mnt/share

# Check mount
ls -Z /mnt/share

# Add to /etc/fstab for permanence
# //server/share /mnt/share cifs username=user,password=pass,context=system_u:object_r:httpd_sys_content_t:s0 0 0
mount -a  # Reload mounts
```

> [!IMPORTANT]
> Without correct context, services like httpd cannot access mounted volumes.

## Maintaining SELinux Labels with File Operations
### Overview
Operations like copy, move, or override can change contexts. Use flags like `--preserve=context` or tools like `tar` with preservation options to maintain labels.

### Key Concepts
- **Copying**: `cp --preserve=context` keeps original context; otherwise, it inherits parent directory's context.
- **Moving**: Moves preserve context since files relocate without recreation.
- **Archiving**: Use `tar --selinux` or `cpio --preserve-context` for label maintenance during compression/decompression.
- **Verification**: Use `matchpathcon` to check actual vs. expected contexts.

### Lab Demo: Preserving Contexts
```bash
# Create and label test file
touch /root/sourcefile
chcon -t samba_share_t /root/sourcefile

# Copy without preservation (label changes)
cp /root/sourcefile /var/www/html/
ls -Z /var/www/html/sourcefile  # Will show httpd_sys_content_t

# Copy with preservation
cp --preserve=context /root/sourcefile /var/www/html/targetfile
ls -Z /var/www/html/targetfile  # Preserves samba_share_t

# Verify expected context
matchpathcon -V /var/www/html/targetfile
```

> [!TIP]
> Tools like `star` can preserve contexts automatically; install via `yum install star` for advanced archiving.

## Summary
### Key Takeaways
```diff
+ Permanent context changes require policy edits or semanage commands to survive reboots.
- Temporary changes via chcon reset during relabeling, leading to potential access denials.
! Always verify contexts with ls -Z and matchpathcon before troubleshooting service issues.
+ Mounting shared volumes requires explicit SELinux context specification for cross-service access.
- Unmatched context patterns (e.g., on extended file systems) result in default_t, blocking data access.
```

### Quick Reference
- **List ports**: `semanage port -l`
- **Add port**: `semanage port -a -t <type> -p <proto> <port>`
- **Temporary context change**: `chcon -t <type> <file>`
- **Permanent context change**: `semanage fcontext -a -t <type> <path>; restorecon <path>`
- **Preserve context on copy**: `cp --preserve=context <src> <dst>`
- **Mount with context**: `mount -o context=<context> <device> <mountpoint>`
- **Check vs. expected context**: `matchpathcon <file>`

### Expert Insight
**Real-world Application**: In production environments, ensure SELinux contexts align with application needs (e.g., Web servers require `httpd_t` type for security and functionality). Automated scripts using Ansible often include `restorecon` post-deploy to enforce policies.

**Expert Path**: Master advanced modules with `semodule` and audit logs via `sealert` for forensic analysis. Track policy changes with version control for scalability.

**Common Pitfalls**: Forgetting to reload policies after edits leads to stale contexts. Ignoring extended file systems causes silent failures—always add rules explicitly.

</details>
