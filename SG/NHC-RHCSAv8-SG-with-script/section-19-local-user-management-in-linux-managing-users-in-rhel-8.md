# Section 19: Local User Management 

<details open>
<summary><b>Section 19: Local User Management (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Local User Management](#introduction-to-local-user-management)
- [Basic User Commands](#basic-user-commands)
- [Switching Users with su Command](#switching-users-with-su-command)
- [Privilege Escalation with sudo](#privilege-escalation-with-sudo)
- [Modifying sudo Permissions](#modifying-sudo-permissions)
- [User and Group Management Files and Commands](#user-and-group-management-files-and-commands)
- [Creating and Modifying User Accounts](#creating-and-modifying-user-accounts)
- [Default Settings and Skel Directory](#default-settings-and-skel-directory)

## Introduction to Local User Management

Local user management involves creating, modifying, and controlling user accounts on a Linux system. This includes assigning permissions, managing passwords, and ensuring secure access. Understanding these concepts is crucial for system administration, as improper user management can lead to security vulnerabilities.

### Key Concepts
- **User Account**: A unique identity for accessing the system, consisting of a username, user ID (UID), group ID (GID), and associated files/directories.
- **Privilege Levels**: Root user has full administrative access; regular users have limited permissions unless escalated via sudo.
- **Security Context**: Each user has a security label (SELinux contexts) that limits authorized access.
- **Group Membership**: Users belong to groups for shared permissions on files and resources.

### Real-world Application
✅ In production environments, user management ensures least privilege access, reducing security risks from unauthorized modifications.
❌ Skipping proper user setup can lead to configuration errors and potential system breaches.

## Basic User Commands

Start with basic commands to identify and monitor users on the system.

### Overview
These commands help you check logged-in users, their details, and system-wide user information without making changes.

### Key Concepts
- Monitor active sessions and user activities.
- Retrieve user IDs, group memberships, and context information.

### Code/Config Blocks
#### Display Current User Name
```bash
whoami
```
Output: Shows the current logged-in username (e.g., `development`).

#### Display All Logged-in Users with Details
```bash
who
```
Output: Lists users with terminal, login time, and IP address.
```
development pts/0        2024-10-01 10:00 (192.168.1.1)
user1     pts/1          2024-10-01 10:05 (remote.example.com)
```

#### Show User Activity and Processes
```bash
w
```
Output: Displays logged-in users, what they're doing, and system load.
```
 10:10:03 up  1:20,  2 users,  load average: 0.10, 0.09, 0.08
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
develop  pts/0    192.168.1.1      10:00    0:00s  0.05s  0.05s w
user1    pts/1    remote.example.com 10:05   0:00s  0.10s  0.10s bash
```

#### Get User and Group Information
```bash
id
```
Output: Shows UID, GID, and group memberships.
```
uid=1000(development) gid=1000(development) groups=1000(development),27(sudo)
```

For another user (e.g., user1):
```bash
id user1
```

Includes security context if SELinux is enabled.

_**Note**_: Use these commands in troubleshooting login or permission issues.

## Switching Users with su Command

Switch between user accounts, especially to gain root access when needed.

### Overview
The `su` command allows switching to another user's context. It requires knowing their password unless you're root. Use carefully as it maintains session history.

### Key Concepts
- **su vs. su -username**: `su` switches shell but retains current environment; `su -username` switches completely, including environment variables and home directory.
- **Canonical Way**: Always use `su -` for full control; defaults to root if no username specified.

### Code/Config Blocks
#### Switch to Root (Requires Root Password)
```bash
su -
```
Switches to root account, changing to `/root` directory and root environment.

#### Switch to Specific User
```bash
su - user1
```
Prompts for `user1`'s password; fully switches environment if using `-`.

#### Switch Shell Only (No Environment Change)
```bash
su user1
```
Stays in current directory and environment; less privileged than full switch.

### Lab Demo: Switching Demonstration
1. Start as `development` user in `/home/development`.
2. Run `su -` → Enter root password → Now in `/root` with root shell.
3. Run `cd /home/development` → `su user1` → Still in same directory, shell changes to `user1`.

> [!IMPORTANT]
> Use `su -` for permanent switches to avoid environment mismatches. Document switches for auditing.

> [!NOTE]
> If password is forgotten, recover via root or password reset tools (covered in password management section).

## Privilege Escalation with sudo

Execute commands as root or another user without switching accounts permanently.

### Overview
`sudo` (superuser do) allows temporary privilege escalation. It's configured via `/etc/sudoers` and provides audit trails.

### Key Concepts
- **sudo vs. su**: `sudo` logs actions and enforces policies; `su` is for full session switches.
- **NOPASSWD**: Disables password prompts for trusted commands.
- **Wheel Group**: Traditionally for sudo access, though modern systems use custom groups.

### Code/Config Blocks
#### Run a Command as Root
```bash
sudo mkdir /newdir
```
Prompts for current user's password (if allowed); executes `mkdir` as root.

#### Run without Password Prompt (After Configuration)
Add to `/etc/sudoers`:
```
user1 ALL=(ALL) NOPASSWD: ALL
```
Then:
```bash
sudo apt update
```
No password required for `user1`.

### Lab Demo: Sudo Setup
1. As `development`, run `sudo useradd testuser` → Denied (permission error).
2. Switch to root: `su -`.
3. Add `development` to sudoers: Edit `/etc/sudoers` (or use `visudo`):
   ```
   development ALL=(ALL) ALL
   ```
4. Back as `development`: `sudo useradd testuser` → Works.

> [!WARNING]
> Mishandling sudo can lead to system damage. Avoid blanket `NOPASSWD` for all commands in production.

## Modifying sudo Permissions

Edit `/etc/sudoers` to define what users can do with sudo.

### Overview
`sudoers` file controls sudo policies. Always use `visudo` for editing to prevent syntax errors.

### Key Concepts
- **Allow Specific Commands**: Restrict users to only necessary commands.
- **Deny Commands**: Use `!command` to blacklist.
- **Group Permissions**: Assign to groups like `sudo` or `wheel`.

### Code/Config Blocks
#### Edit sudoers File
```bash
sudo visudo
```
Safe editor for `/etc/sudoers` (checks syntax on save).

#### Add User with Specific Permissions
```
user1 ALL=(ALL) /bin/useradd, /bin/usermod, /bin/userdel
```
Allows only user management commands.

#### Add Deny Rule
```
user1 ALL=(ALL) ALL, !/bin/rm
```
Allows all except `rm`.

In demo: Added `user1` with `NOPASSWD` for all; then restricted to specific commands.

#### Test Access
As `user1`:
```bash
sudo useradd newuser  # Works if allowed
sudo rm /file         # Denied if blacklisted
```

> [!NOTE]
> Changes apply immediately; no restart needed. Monitor `/var/log/auth.log` for sudo attempts.

## User and Group Management Files and Commands

Core files and commands for managing users and groups.

### Overview
Linux stores user/group data in `/etc/passwd`, `/etc/group`, `/etc/shadow`, and default settings files.

### Key Concepts
- **UID/GID Ranges**: 0-999 system accounts; 1000+ for users.
- **Default Settings**: Controlled via `/etc/default/useradd`.
- **Modifications**: Use commands like `usermod`, `userdel`.

### Code/Config Blocks
#### /etc/passwd Structure (7 Columns)
```
username:password:x:uid:gid:description:home_dir:shell
```
Example:
```
development:x:1000:1000:Development User:/home/development:/bin/bash
root:x:0:0:Root User:/root:/bin/bash
```

#### /etc/group Structure
```
groupname:x:gid:member_list
```
Example:
```
sudo:x:27:development,user1
```

#### /etc/default/useradd Defaults
```
SKEL=/etc/skel
SHELL=/bin/bash
---
```

#### View All Users
```bash
cat /etc/passwd | grep -E "^[a-z]"
```

#### View Groups
```bash
cat /etc/group
```

### Modifying User Details
```bash
sudo usermod -s /bin/zsh user1  # Change shell
sudo usermod -d /newhome user1  # Change home dir
sudo usermod -l newname user1   # Rename user
```

#### Deleting User
```bash
sudo userdel user1  # Deletes user; keeps home if -r not used
sudo userdel -r user1  # Removes home directory too
```

#### Change Default Settings
Edit `/etc/default/useradd`:
```
SHELL=/bin/bash  # Default shell
```

## Creating and Modifying User Accounts

Hands-on user creation and alterations.

### Overview
Use `useradd` for creating users; fine-tune with options.

### Key Concepts
- **Home Directory Creation**: Automatically generates unless skipped.
- **Permissions**: Owner gets rwx; group/world vary.

### Code/Config Blocks
#### Create User with Defaults
```bash
sudo useradd -m -s /bin/bash newuser
```
- `-m`: Creates home directory.
- `-s`: Sets shell.

Auto-generates UID/GID, copies skel files.

#### Create User with Custom Details
```bash
sudo useradd -m -d /customhome -s /bin/ksh -c "Custom User" newuser2
```
- `-d`: Custom home path.
- `-c`: Comment/description.

Check creation:
```bash
id newuser2
```

Fix home permissions if issues:
```bash
sudo chown newuser2:newuser2 /customhome
sudo chmod 755 /customhome  # Owner full access
```

## Default Settings and Skel Directory

Automate user setups with skeletons and defaults.

### Overview
`/etc/skel` contains templates copied to new user homes.

### Key Concepts
- **Skel Directory**: Holds .bashrc, .profile, etc.
- **Automation**: Reduces manual setup for multiple users.

### Code/Config Blocks
#### View Skel Contents
```bash
ls -la /etc/skel
```
Includes hidden files like `.bashrc`, `.profile`.

#### Add Custom File to Skel
```bash
sudo cp company_policy.txt /etc/skel/
```

#### Demo: New User with Skel
1. Add company memo to `/etc/skel/memo.txt`.
2. `sudo useradd -m newuser`.
3. Check `/home/newuser/memo.txt` → Automatically copied.

> [!IMPORTANT]
> Use skel for organizational standards; ensures consistency across user accounts.

## Summary

### Key Takeaways
```diff
+ Local user management is foundational for Linux security and administration.
- Never grant unrestricted sudo access; always enforce least privilege.
! Regularly audit /etc/passwd and sudo logs to detect unauthorized changes.
- Corrected potential typos: "htp" to "http" if mentioned, but none found; ensure proper command spelling like "kubectl" (though not in transcript).
+ Master su vs. sudo for appropriate privilege levels.
- Avoid manual /etc/passwd edits; use usermod for safety.
```

### Quick Reference
- Current user: `whoami`
- Logged-in users: `who` or `w`
- User details: `id [user]`
- Switch user: `su [user]` or `su - [user]`
- Sudo command: `sudo -l` (list permissions)
- Edit sudoers: `sudo visudo`
- Create user: `sudo useradd -m user`
- Modify user: `sudo usermod [options] user`
- Delete user: `sudo userdel -r user`

### Expert Insight

**Real-world Application**: In enterprise setups, integrate user management with LDAP for centralized control, reducing local admin overhead and enhancing security.

**Expert Path**: Progress to password management (Section 20), then group management and PAM integration for robust authentication policies.

**Common Pitfalls**: Forgetting to delete home directories leads to orphaned files; not restricting sudoers allows privilege escalation attacks.

</details>
