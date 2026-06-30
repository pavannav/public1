# Section 4: The SU Command

<details open>
<summary><b>Section 4: The SU Command (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [4.1 The SU Command](#41-the-su-command)
- [4.2 Using the SUDO Command](#42-using-the-sudo-command)
- [4.3 SUDOERS](#43-sudoers)
- [4.4 Assigning a Regular User sudo Permissions](#44-assigning-a-regular-user-sudo-permissions)
- [Summary](#summary)

---

## 4.1 The SU Command

### Overview
The `su` (substitute user) command allows switching between user accounts in Linux. This module covers the two variations of the command (`su` vs `su -`), their behavioral differences, and practical demonstrations of switching between user accounts with varying privilege levels.

### Key Concepts/Deep Dive

#### Understanding SU Command Fundamentals
- **`su`** is short for "substitute user" (not "switch user" as commonly thought)
- Previously known as "super user" when primarily used to connect as root
- The proper name is "substitute user" - enabling you to substitute one user identity for another
- Two command variations exist:
  - `su username` - Basic substitution without environment change
  - `su - username` - Full login shell with new user's environment

#### Critical Differences Between Command Variations

| Feature | `su username` | `su - username` |
|---------|---------------|-----------------|
| **Working Directory** | Remains in current directory | Changes to target user's home directory |
| **Environment** | Keeps current environment variables | Loads target user's full environment |
| **Shell Type** | Does not open new login shell | Opens new login shell |
| **Use Case** | Quick user switches without path changes | Complete user context switch |

#### Authentication Behavior
- **Root users**: No password required when switching to any account
  - Root has full system power and can access any account without authentication
  - Example: `su sysadmin` as root requires no password
- **Regular users**: Must know the target account's password
  - Non-root users must authenticate with target's credentials
  - Example: Regular user attempting `su sysadmin` must provide sysadmin's password

#### Path and Environment Implications

**Using `su` (without dash):**
```bash
# Current location: /home/user
su sysadmin
# Now logged in as sysadmin but still in /home/user
pwd  # Shows: /home/user
ls /root  # Permission denied - cannot access root's directory
```

**Using `su -` (with dash):**
```bash
# Current location: /home/user
su - sysadmin
# Now in sysadmin's home directory with full environment
pwd  # Shows: /home/sysadmin
ls  # Shows sysadmin's files (if any exist)
```

#### Working with Root Account
- Username can be omitted when targeting root
- Both `su root` and `su - root` equivalent to `su` and `su -`
- Root account typically located in `/root` directory
- Access to `/root` is restricted to root user only

#### Practical Demonstration

**Lab Setup Requirements:**
1. Create sysadmin account if not exists: `adduser sysadmin`
2. Ensure root password is known for demonstrations

**Demonstration Steps:**
```bash
# As root user
su sysadmin          # Switches without password, stays in /root
pwd                  # Shows: /root
ls                   # Permission denied
exit                 # Returns to root

su - sysadmin        # Full login, changes to /home/sysadmin
pwd                  # Shows: /home/sysadmin
ls                   # Shows directory contents
exit                 # Returns to root

# From regular user account
su - sysadmin        # Prompts for sysadmin password
# Only succeeds with correct password
```

#### Nested Account Switching
- Linux allows "Russian doll" style nesting of user sessions
- Possible to switch: user → sysadmin → root → another user
- Critical to track current user identity to avoid confusion
- Use `whoami` or `id` commands to verify current user context

#### Lab Exercises and Resources
- **Lab 7** in repository provides hands-on practice
- **Extra Credit**: Explore `su --help` and man pages
- **Take it to the Next Level**: Advanced questions with answers elsewhere in repository

### Expert Insight

> [!IMPORTANT]
> Always use `su -` (with dash) when you need the target user's complete environment and working directory. This prevents permission issues and confusion about file locations.

> [!NOTE]
> Root can access any account without passwords, making root the ultimate backup access method - but also a significant security risk if compromised.

---

## 4.2 Using the SUDO Command

### Overview
The `sudo` command provides controlled administrative access to regular users. This module explores sudo's multiple meanings (program, group, command), installation requirements, usage patterns, and the relationship between sudo and user groups across different Linux distributions.

### Key Concepts/Deep Dive

#### Multiple Meanings of SUDO
Sudo has three distinct meanings that often cause confusion:

1. **SUDO as a Program**
   - The actual `sudo` binary installed on Linux systems
   - Associates permissions with users and groups
   - Controls which commands users can execute with elevated privileges

2. **SUDO as a Group**
   - User group for Debian/Ubuntu systems: `sudo`
   - User group for Fedora/RHEL/CentOS systems: `wheel`
   - Membership grants administrator/superuser capabilities

3. **SUDO as a Command**
   - Precedes other commands requiring administrative access
   - Allows execution as superuser when properly configured
   - Example: `sudo apt update` instead of just `apt update`

#### Distribution-Specific Group Names

| Distribution Family | Admin Group | Examples |
|---------------------|-------------|----------|
| Debian/Ubuntu | `sudo` | Debian, Ubuntu, Linux Mint |
| Fedora/RHEL/CentOS | `wheel` | Fedora, Red Hat, CentOS, Rocky Linux |

#### Installation Requirements
- **Debian Server**: sudo not installed by default
  ```bash
  apt install sudo  # Required to enable sudo functionality
  ```
- **Most other distributions**: sudo pre-installed
- Debian's philosophy: server administrators often work directly as root

#### Authentication and Privilege Requirements
- User must be member of sudo/wheel group
- Must preface administrative commands with `sudo`
- **Exception**: No sudo needed when already working as root
- Failed sudo attempts are logged and reported to the system

#### The sudo -i Command
- Provides access to root account with full sudo privileges
- Similar to `su -` but doesn't require root's password
- Essential for Ubuntu/Fedora systems where root has no password by default
- Usage: `sudo -i` (switches to root without root password)

#### Practical Demonstration

**Initial State Verification:**
```bash
id sysadmin  # Shows basic groups, no sudo/wheel membership
```

**Failed Access Attempt:**
```bash
su - sysadmin
apt update   # Permission denied - not a sudo user
sudo apt update  # "sysadmin is not in the sudoers file"
```

**Successful sudo Usage (with proper group membership):**
```bash
id  # Shows user is member of sudo group
sudo apt update  # Works after password authentication
```

**Root Access via sudo:**
```bash
sudo -i  # Accesses root account without root's password
# Only works if user has full sudo privileges
```

#### Security Logging
- Failed sudo attempts generate system logs
- Incidents reported to Linux operating system
- Important for security auditing and monitoring
- Demonstrates principle of least privilege in action

#### Best Practices
- Use sudo-based users instead of direct root access
- Principle of least privilege: only grant necessary permissions
- Regular users cannot perform administrative tasks without sudo
- sudo provides controlled elevation of privileges

### Expert Insight

> [!IMPORTANT]
> Remember that `sudo` has three meanings (program, group, command). Understanding this helps avoid confusion when troubleshooting permission issues.

> [!NOTE]
> The `sudo -i` command is particularly useful on modern distributions where root accounts have no passwords by default.

---

## 4.3 SUDOERS

### Overview
The sudoers file is the central configuration for user permissions in Linux. This module covers locating and safely editing the sudoers file using visudo, understanding permission syntax, configuring password timeouts, and distribution-specific differences in sudoers configuration.

### Key Concepts/Deep Dive

#### SUDOERS File Location and Access
- **Location**: `/etc/sudoers`
- **Direct editing forbidden**: Results in "permission denied"
- **Proper editing method**: Use `visudo` command (requires sudo privileges)
- **Filename origin**: "sudoers" refers to users with administrative privileges

#### The visudo Command
- Preferred method for modifying sudoers file
- Provides syntax checking to prevent configuration errors
- Requires sudo permissions: `sudo visudo`
- Opens file in read-write mode (unlike vim which shows "read only")

#### Default SUDOERS Configuration Structure

**User Privilege Specification:**
```
root    ALL=(ALL:ALL) ALL
```
- Grants root account full permissions across all systems and commands

**Group Privilege Specification:**
```
%sudo   ALL=(ALL:ALL) ALL    # Debian/Ubuntu systems
%wheel  ALL=(ALL:ALL) ALL    # Fedora/RHEL/CentOS systems
```
- Groups identified by `%` prefix before group name
- Provides same full permissions to all group members

#### Distribution Differences in SUDOERS

| Aspect | Debian/Ubuntu | Fedora/RHEL/CentOS |
|--------|---------------|-------------------|
| **Default Editor** | vim | nano |
| **Admin Group** | sudo | wheel |
| **Permission Syntax** | Standard format | Slightly different format |
| **Group Identifier** | `%sudo` | `%wheel` |

#### Password Timeout Configuration
- **Default behavior**: Password cached for 5 minutes of inactivity
- **Subsequent sudo commands**: No password required within timeout period
- **Global configuration**: Modify timeout for all users/groups
- **Individual configuration**: Set different timeouts per user

#### Customizing Password Timeout
Add to sudoers file:
```
Defaults:%sudo timestamp_timeout=30
Defaults:user timestamp_timeout=30
```
- Change from default 5 minutes to 30 minutes
- **Security warning**: Setting to 0 means infinite timeout (not recommended)
- Balances convenience with security considerations

#### Password-less sudo (Advanced)
```
%wheel  ALL=(ALL)       NOPASSWD: ALL
```
- Uncommenting this line allows password-less sudo for group members
- **Not recommended** for production systems
- Security risk: anyone accessing the system can run administrative commands
- Only suitable for isolated test systems

#### Practical Demonstration

**Accessing sudoers:**
```bash
sudo visudo  # Opens with appropriate editor
```

**Viewing Default Configuration:**
```bash
# Scroll to user privilege specification section
root    ALL=(ALL:ALL) ALL
%sudo   ALL=(ALL:ALL) ALL    # or %wheel for Fedora systems
```

**Adding Custom Timeout:**
```bash
# Add at end of file
Defaults:%sudo timestamp_timeout=30
```

**Verification:**
- After saving, password required only every 30 minutes instead of 5
- Configuration applies to all sudo group members

### Expert Insight

> [!IMPORTANT]
> Never set timestamp_timeout to 0 (infinity) as this creates a significant security vulnerability.

> [!NOTE]
> The visudo command includes syntax validation, preventing configuration errors that could lock you out of administrative access.

---

## 4.4 Assigning a Regular User sudo Permissions

### Overview
This final module demonstrates the complete process of creating administrative users from scratch. It covers user creation, group assignment for both sudo and wheel groups, verification steps, and testing across Ubuntu and CentOS systems.

### Key Concepts/Deep Dive

#### Complete Administrative User Creation Process

**Ubuntu/Debian Process (sudo group):**
1. Create user account as root
2. Add user to sudo group using usermod
3. Verify group membership
4. Test sudo functionality

**CentOS/Fedora Process (wheel group):**
1. Create user account as root
2. Add user to wheel group using usermod
3. Set user password
4. Verify and test sudo functionality

#### User Creation Commands by Distribution

| Distribution | Command | Notes |
|--------------|---------|-------|
| Ubuntu/Debian | `adduser sysadmin` | Interactive, creates home directory, sets password |
| CentOS/Fedora | `useradd sysadmin` | Creates account only, password set separately |

#### Group Assignment Process
```bash
# Ubuntu/Debian - add to sudo group
usermod -aG sudo sysadmin

# CentOS/Fedora - add to wheel group
usermod -aG wheel sysadmin
```
- `-a` flag: append (don't replace existing groups)
- `-G` flag: specify groups to add user to
- Can combine as `-aG` for efficiency

#### Verification Commands
```bash
id sysadmin  # Shows all group memberships including sudo/wheel
```

#### Ubuntu-Specific User Experience
After adding user to sudo group:
```
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
```
- Ubuntu provides helpful guidance message for new sudo users
- Indicates successful group membership assignment

#### CentOS-Specific Considerations
- `useradd` creates account without password
- Must separately set password: `passwd sysadmin`
- Includes security reminder about responsible sudo usage
- Different package manager (dnf vs apt)

#### Practical Demonstration

**Ubuntu Server Process:**
```bash
# As root
adduser sysadmin          # Interactive creation with password
su - sysadmin            # Switch to test account
apt update               # Fails - permission denied
sudo apt update          # Fails - "not in sudoers file"
exit                     # Return to root

usermod -aG sudo sysadmin # Add to sudo group
id sysadmin              # Verify sudo group membership

su - sysadmin            # Switch back to test
sudo apt update          # Now works after password entry
```

**CentOS Server Process:**
```bash
# As root
useradd sysadmin         # Creates account only
usermod -aG wheel sysadmin # Add to wheel group immediately
passwd sysadmin          # Set password for the account
id sysadmin              # Verify wheel group membership

su - sysadmin            # Switch to test account
sudo dnf update          # Works after password entry
# Shows security reminder message
```

#### Testing Administrative Functionality
**Successful sudo command execution:**
```bash
sudo apt update    # Ubuntu/Debian
sudo dnf update    # CentOS/Fedora/RHEL
```
- Prompts for user password (not root password)
- Executes with administrative privileges
- Demonstrates successful sudoer configuration

#### Security Auditing Mentions
- Failed sudo attempts logged to system
- Important topic for future Module 4 (auditing)
- Demonstrates importance of monitoring administrative access attempts

#### Course Completion Notes
- Terms `su`, `sudo`, and `sudoers` can be confusing
- Recommended: re-watch lesson at high speed for quick review
- All concepts interrelate and benefit from repetition

### Expert Insight

> [!IMPORTANT]
> Always use `usermod -aG` (with append flag) to avoid accidentally removing users from other important groups.

> [!NOTE]
> The "great power comes with great responsibility" message in CentOS serves as an important reminder about the security implications of sudo access.

---

## Summary

### Key Takeaways
```diff
+ SU provides user switching with two modes: basic (su) and full environment (su -)
+ SUDO has three meanings: program, group (sudo/wheel), and command prefix
+ SUDOERS file controls all administrative permissions and requires visudo for editing
+ Regular users become administrators through group membership (sudo/wheel)
+ Password timeouts and authentication behavior vary based on configuration
+ Distribution differences exist but core concepts remain consistent
- Never set infinite password timeouts or enable password-less sudo in production
- Root access should be protected and used sparingly
```

### Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `su username` | Switch user, keep current environment | `su sysadmin` |
| `su - username` | Switch user with full environment | `su - sysadmin` |
| `sudo command` | Execute with admin privileges | `sudo apt update` |
| `sudo -i` | Access root without root password | `sudo -i` |
| `sudo visudo` | Safely edit sudoers file | `sudo visudo` |
| `usermod -aG group user` | Add user to admin group | `usermod -aG sudo sysadmin` |
| `id username` | Verify group memberships | `id sysadmin` |

### Expert Insight

**Real-world Application**:
In production environments, create dedicated administrative users with sudo access rather than sharing root passwords. This provides better audit trails and allows for granular permission control through sudoers configuration.

**Expert Path**:
Master the sudoers file syntax to create role-based access with specific command permissions. Learn to configure command aliases, host specifications, and user-specific timeouts for enterprise environments.

**Common Pitfalls**:
- Using `su` instead of `su -` and wondering why commands fail due to wrong working directory
- Forgetting the append flag (`-a`) when using usermod and accidentally removing users from groups
- Setting overly permissive sudoers configurations that compromise security
- Not understanding that sudo and wheel groups serve the same purpose on different distributions

**Lesser-Known Facts**:
- The sudoers file syntax supports complex rules including time-based restrictions and command-specific permissions
- Failed sudo attempts can trigger email notifications to administrators
- The visudo command creates temporary files and only replaces the original if syntax is valid, preventing lockouts from configuration errors

</details>