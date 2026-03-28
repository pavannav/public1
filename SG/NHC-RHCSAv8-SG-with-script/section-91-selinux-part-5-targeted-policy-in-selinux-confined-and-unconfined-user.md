# Section 91: Confined and Unconfined Users in SELinux

<details open>
<summary><b>Section 91: Confined and Unconfined Users in SELinux (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [User Roles and Capabilities](#user-roles-and-capabilities)
- [Mapping Users to Security Contexts](#mapping-users-to-security-contexts)
- [Booleans and Policy Tuning](#booleans-and-policy-tuning)
- [Practical Demonstrations](#practical-demonstrations)
- [Examples and Explanations](#examples-and-explanations)
- [Summary](#summary)

## Overview
Section 91 focuses on confined and unconfined users within SELinux (Security-Enhanced Linux), explaining the difference between discretionary access control (DAC) and mandatory access control (MAC) through SELinux. In SELinux-targeted policies, users can be confined to specific roles, limiting their actions to prevent privilege escalation, while unconfined users have broader access. This section covers user mapping, role assignment, booleans for fine-grained control, and practical steps to convert users between confined and unconfined states.

## Key Concepts
### Confined vs. Unconfined Users
- **Unconfined Users (One Can Find)**: By default, users in SELinux are mapped to the `unconfined_u` security context, allowing discretionary access. They can access any service or resource if DAC permissions allow it, much like standard Linux users.
- **Confined Users**: Users mapped to specific SELinux domains (e.g., `user_u`, `staff_u`) have their access limited by SELinux policies. They can only perform actions expressly allowed by their assigned roles, providing multi-layer security.
- **Security Context**: Each user has a security context (`user_u:role_r:type_t:range_t`). The user component defines the SELinux user identity, which determines available roles.
- **Role Transition**: Users can transition between roles based on policy, but confined users cannot exceed their defined boundaries.
- **Multi-Layer Security**: Confining users adds a layer beyond standard UID/GID-based permissions, protecting against privilege misuse.

### User Mapping and Roles
- SELinux uses user contexts to map Linux accounts to SELinux users. For example:
  | SELinux User | Primary Role | Additional Roles | Capabilities |
  |--------------|--------------|------------------|-------------|
  | unconfined_u | unconfined_r | system_r | Full system access if DAC allows |
  | user_u | user_r | - | Login, basic operations, no admin tasks |
  | staff_u | staff_r | - | Administrative tasks, with boolean restrictions |
  | sysadm_u | sysadm_r | - | System administration, requires boolean enablement |
  | root_u | sysadm_r | unconfined_r | If mapped correctly, inherits sysadm capabilities |

- **Default Behavior**: New users created in Linux are automatically mapped to `unconfined_u` unless policy changes it.

### Booleans and Fine-Tuning
Booleans allow dynamic adjustments to SELinux policies without reloading.
- Common Booleans: Critical for controlling confined user actions (e.g., `selinuxuser_use_tty` for login).
- Querying Booleans: Use `getsebool -a` or `semanage boolean -l` to list states.
- Setting Booleans: Use `setsebool -P <boolean> on/off` for persistent changes.

## User Roles and Capabilities
Each SELinux user role defines what actions are permitted:
- **unconfined_u**: Switches to `unconfined_r`, accessing all processes without SELinux restrictions beyond DAC.
- **user_u**: Limited to `user_r`, cannot perform admin tasks, but can log in and manage personal files.
- **staff_u**: Similar to `user_u` but includes some admin capabilities (e.g., sudo usage with boolean control).
- **sysadm_u**: Administrative role for system management, enabled via booleans.
- **Capabilities Table**:
  | SELinux User | Login to System | Run Admin Commands | Manage Processes | Access All Files |
  |--------------|-----------------|---------------------|------------------|-----------------|
  | unconfined_u | Yes | Yes | Yes | Yes |
  | user_u | Yes | No | No | No |
  | staff_u | Yes | With booleans | Limited | Limited |
  | sysadm_u | With boolean | Yes | Yes | Yes |
  | root_u (mapped) | With boolean | Yes | Yes | Yes |

## Mapping Users to Security Contexts
### Viewing Current Mappings
- List user mappings: `semanage login -l` (shows Linux users mapped to SELinux contexts).
- Check specific user context: `id -Z` (when logged in as that user).
- Example Output:
  ```
  __default__:unconfined_u:s0-s0:c0.c1023
  username:staff_u:s0
  ```

### Changing Mappings
- Map a user to confined context: `semanage login -a -s <selinux_user> <linux_user>` (e.g., `semanage login -a -s staff_u username`).
- Modify existing mapping: `semanage login -m -s <selinux_user> <linux_user>`.
- Map all default users: `semanage login -m -s staff_u __default__` (affects new users).

> [!NOTE]
> Changes take effect after relogin or policy reload.

## Booleans and Policy Tuning
Booleans customize policy enforcement:
- **List Booleans**: `semanage boolean -l` (full with descriptions).
- **Check Boolean State**: `getsebool <boolean>` (e.g., `selinuxuser_use_tty` controls admin logins).
- **Set Boolean Persistent**: `setsebool -P <boolean> on/off`.
- **Important Booleans** for User Control:
  - `selinuxuser_use_tty`: Allows confined users to login.
  - `allow_sysadm_[various]`: Enables specific sys admin tasks.

🔧 This provides granular control over confined user permissions without policy file edits.

## Practical Demonstrations
### Demo 1: Viewing User Mappings and Roles
1. Log in as root.
2. Run: `semanage login -l` to list mappings.
   ```
   Login Name           SELinux User         MLS/MCS Range        Service
   __default__          unconfined_u         s0-s0:c0.c1023        *
   ```
3. Check roles for confined users: `seinfo -r` (lists available roles).
4. For user capabilities: `sesearch --allow -s <role>_t -t <object>_t` (e.g., `sesearch --allow -s user_t -t passwd_t`).

### Demo 2: Creating and Confining a New User
1. Create user: `useradd -G wheel exampleuser`
2. Set password: `passwd exampleuser`
3. Map to confined context: `semanage login -a -s staff_u exampleuser`
4. Check mapping: `semanage login -l` (see `exampleuser` mapped to `staff_u`).
5. Login as `exampleuser` and verify context: `id -Z` (shows `staff_u:staff_r:staff_t:s0`).

### Demo 3: Enabling Booleans for Confined Admin Access
1. Check boolean for sysadmin login: `getsebool selinuxuser_use_tty`
2. Enable persistently: `setsebool -P selinuxuser_use_tty on`
3. Create sysadmin user: `useradd -G wheel sysadmuser`
4. Map to `sysadm_u`: `semanage login -a -s sysadm_u sysadmuser`
5. Login and test: `sudo systemctl restart sshd`
   - If boolean is off, login fails with "broken pipe" error.

### Demo 4: Converting Unconfined to Confined Users for All Default Users
1. Map default users: `semanage login -m -s staff_u __default__`
2. Verify: `semanage login -l` (all new users confined).
3. For existing users, modify individually or relogin to apply.

### Demo 5: Adding Users to Groups with SELinux Context
1. Add user with group: `useradd -G adm examplegroup`
2. Map: `semanage login -a -s user_u examplegroup`
3. Verify group contributions: `id examplegroup` (SELinux context from mapping).

## Examples and Explanations
- **Role Transition Example**: A `user_u` cannot run `systemctl`, but enabling booleans allows limited transitions.
```bash
# Enable boolean for staff sudo
sudo setsebool -P allow_user_sudo on
```
- **Security Range**: Context includes MCS/MLS for multi-level security (e.g., `s0-s0:c0.c1023` for unconfined).
- **Troubleshooting**: Relogin after mapping changes. Check audit logs with `ausearch -m avc -ts recent`.

> [!WARNING]
> Incorrect boolean settings can lock users out. Always test in a virtual environment.

## Summary
### Key Takeaways
```diff
+ Confined users limit access via SELinux roles, enhancing security beyond DAC
- Unconfined users have broad access if DAC allows, suitable for trusted environments
! SELinux user contexts map Linux accounts to security domains with boolean fine-tuning
+ Practical steps involve semanage, setsebool, and relogin for policy enforcement
- Misconfigurations can cause login failures; use audits for debugging
```

### Quick Reference
- **List User Mappings**: `semanage login -l`
- **Add Confined User Map**: `semanage login -a -s <selinux_user> <linux_user>`
- **Enable Login Boolean**: `setsebool -P selinuxuser_use_tty on`
- **Query Booleans**: `semanage boolean -l`
- **Check Context**: `id -Z` (user shell)

### Expert Insight
**Real-world Application**: In enterprise Linux deployments, confine admin users to `staff_u` with boolean controls to prevent accidental system changes. This multi-layer approach protects servers from insider threats and malware.

**Expert Path**: Master SELinux by auditing policies with `seaudit` and creating custom policies for unique roles. Experiment with MLS for high-security scenarios.

**Common Pitfalls**: Forgetting to enable login booleans locks users out permanently. Always backup mappings before bulk changes. Avoid mapping root directly without boolean verification.
</details>
