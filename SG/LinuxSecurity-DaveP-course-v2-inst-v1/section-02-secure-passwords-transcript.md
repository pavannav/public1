# Section 2: Secure Passwords

<details open>
<summary><b>Section 2: Secure Passwords (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [2.1 Secure Passwords](#21-secure-passwords)
- [2.2 Setting the Password](#22-setting-the-password)
- [2.3 Generating Passwords with OpenSSL and KeePass](#23-generating-passwords-with-openssl-and-keepass)
- [2.4 The passwd and shadow Files](#24-the-passwd-and-shadow-files)
- [2.5 Password Settings](#25-password-settings)
- [2.6 Password Policy Configuration](#26-password-policy-configuration)
- [Summary](#summary)

---

## 2.1 Secure Passwords

### Overview
This module introduces the fundamental principles of creating secure passwords, emphasizing length and complexity as the two critical factors. The content covers NIST guidelines and best practices for password security that protect against brute force and password cracking attempts.

### Key Concepts/Deep Dive

#### Password Length: The Foundation of Security
Password length is identified as the most important security factor:

- **Minimum Recommended Length**: 16-20 characters for standard passwords
- **Passphrases**: Can extend to 64 characters or even 15+ words for enhanced security
- **Current Standard (2024)**: 16-20 characters is considered a safe benchmark

#### Password Complexity Components
Four essential character categories work together to create complexity:

| Character Type | Character Count | Example Characters |
|----------------|-----------------|-------------------|
| Lowercase Letters | 26 | a-z |
| Uppercase Letters | 26 | A-Z |
| Numbers | 10 | 0-9 |
| Special Characters | Varies | !@#$%^&*() |

**Complexity Build-Up Process:**
1. Lowercase only: 26 values per character
2. + Uppercase: 52 values per character
3. + Numbers: 62 values per character
4. + Special characters: Significantly expands possibilities

#### NIST Special Publication 800-63B: Digital Identity Guidelines
This authoritative document provides expert guidance on password security:

- **Focus Areas**: Authentication, lifecycle management, and password guidelines
- **Key Recommendations**:
  - Emphasizes password length over periodic changes
  - Recommends against forcing regular password changes due to increased support calls
  - Details how longer passwords defeat brute force attacks

> [!IMPORTANT]
> Companies should consider importing NIST recommendations into their password policies rather than forcing periodic changes that reduce productivity.

---

## 2.2 Setting the Password

### Overview
This module demonstrates practical password setting through both Graphical User Interface (GUI) and Command Line Interface (CLI) methods on Debian systems, highlighting built-in security validations and the differences between user and root privileges.

### Key Concepts/Deep Dive

#### GUI Password Setting Process
The GNOME desktop provides guided password creation with real-time validation:

**Navigation Steps:**
1. Press Super key (Windows/Command key) to open application overview
2. Type "settings" or access via user menu → settings sprocket
3. Navigate to Users section
4. Select account and click "Change Password"

**Built-in Validation Features:**
- Real-time password strength feedback
- Color-coded security indicators (red = insufficient, green = acceptable)
- Specific guidance messages:
  - "Password needs to be longer. Try adding more letters, numbers and punctuation"
  - "Try to avoid common words"
- Prevents weak password selection before confirmation

**Character Requirements Displayed:**
- Capital letters (A-Z)
- Lowercase letters (a-z)
- Numbers (0-9)
- Special characters

#### CLI Password Setting with passwd Command

**Basic Usage:**
```bash
passwd
```
Interactive prompts guide through:
1. Current password verification
2. New password entry
3. Password confirmation

**Root Privileges for Other Users:**
```bash
passwd username
```
- Root can change any user's password without knowing the current password
- Useful for administrative password resets

**Getting Help:**
```bash
passwd --help    # Basic usage information
man passwd       # Detailed manual page
```

#### Password History and Restrictions
- **Debian Behavior**: Allows reusing previous passwords immediately
- **Enhanced Systems**: Maintain password history databases
  - Prevent reuse of recently used passwords
  - Implement time-based restrictions on password reuse

> [!NOTE]
> Server-focused courses emphasize CLI methods as most systems operate without GUI interfaces.

---

## 2.3 Generating Passwords with OpenSSL and KeePass

### Overview
This module covers automated password generation using OpenSSL command-line tools and demonstrates KeePassXC as a secure password vault solution, including database creation, entry management, and secure password handling practices.

### Key Concepts/Deep Dive

#### OpenSSL Password Generation Methods

**Cryptographic Hash Generation:**
```bash
openssl passwd -6
```
- Uses SHA-512 algorithm ($6 identifier)
- Generates cryptographically secure password hashes
- Output format: `$6$[salt]$[hashed_password]`

**Random Passcode Generation:**
```bash
openssl rand -base64 24
```
- **Base64 Encoding**: Characters from a-z, A-Z, 0-9, +, /
- **Hexadecimal Encoding**: Characters 0-9, A-F
```bash
openssl rand -hex 24
```

**File Output Options:**
```bash
openssl rand -base64 24 -out password.txt
openssl rand -base64 128 -out large_password.txt
```

#### KeePassXC Password Vault Management

**Installation and Setup:**
- Cross-platform, open-source password manager
- Database formats: KDBX 4 (recommended)
- Encryption settings configurable for security vs performance trade-offs

**Database Creation Process:**
1. Create new database with custom name
2. Configure encryption settings
3. Set master password (must be highly secure)
4. Database naming best practices (avoid obvious names like "password_database")

**Entry Creation Features:**
- **Random Generation**: Built-in password generator with entropy measurement
- **Configurable Options**:
  - Character classes (uppercase, lowercase, numbers, special)
  - Extended ASCII and logogram support
  - Passphrase generation alternative
  - Custom length settings

**Entropy Security Levels:**
- 80+ bits: Good security baseline
- 115+ bits: Strong security (20 character example)
- 200+ bits: Maximum security passwords

#### Secure Password Handling Practices

**Copy/Paste Security:**
- Right-click or Ctrl+C for secure clipboard copy
- Time-limited clipboard (10 seconds default)
- Automatic clipboard clearing after timeout

**Master Password Management:**
- Must be memorable yet complex
- Consider using passphrases for master credentials
- Can be updated through Database → Database Security settings

> [!IMPORTANT]
> NIST guidelines support secure copying/pasting of passwords rather than manual entry, reducing human error and supporting complex password usage.

---

## 2.4 The passwd and shadow Files

### Overview
This module examines the Linux authentication file structure, focusing on the `/etc/passwd` and `/etc/shadow` files that manage user accounts and password storage, including file permissions and the principle of least privilege.

### Key Concepts/Deep Dive

#### /etc/passwd File Structure

**File Location and Access:**
```bash
vim /etc/passwd
```
- Readable by all users (no elevated privileges required)
- Colon-separated field format

**Account Categories by UID:**

| UID Range | Account Type | Examples |
|-----------|--------------|----------|
| 0 | Root/Superuser | root |
| 1-999 | System/Service Accounts | sshd, daemon, bin |
| 1000+ | Regular User Accounts | user, dpro, sysadmin |

**Account Field Structure:**
```
username:password:UID:GID:GECOS:home_directory:shell
```

**Security Configuration Example:**
```bash
# Disabling root login by changing shell
root:x:0:0:root:/root:/usr/sbin/nologin
```

#### /etc/shadow File Security

**Access Restrictions:**
- Root or sudo access required
- Implements principle of least privilege
- Contains actual password hashes

**Password Hash Format:**
```
$y$[parameters]$[salt]$[hash]
```
- `$y`: yescrypt algorithm (newer Debian systems)
- `$6`: SHA-512 (older systems)
- Parameters include work factors and salt values

**Shadow File Field Structure:**
```
username:hash:last_change:min_age:max_age:warning:inactive:expire:reserved
```

**Key Field Explanations:**

| Field | Example Value | Description |
|-------|---------------|-------------|
| Last Password Change | 19800 | Days since Unix epoch (Jan 1, 1970) |
| Minimum Password Age | 0 | Days before password can be changed again |
| Maximum Password Age | 99999 | Days until forced password change (unlimited) |
| Warning Period | 7 | Days of warning before expiration |
| Account Expiration | - | Days since epoch when account expires |

#### Security Best Practices
- Regular users cannot access shadow file directly
- Passwords stored as cryptographic hashes, never plaintext
- System accounts typically don't have passwords
- Service accounts use `nologin` shell to prevent interactive access

---

## 2.5 Password Settings

### Overview
This module demonstrates practical user account management and password aging configuration using `chage` and `login.defs`, covering both individual user settings and global policy modifications with hands-on examples.

### Key Concepts/Deep Dive

#### User Account Creation

**Debian/Ubuntu Method:**
```bash
adduser sysadmin
```
- Interactive prompts for user information
- Automatically creates home directory
- Sets up default group membership

**Fedora/RHEL Environment:**
```bash
useradd username
```
Different default behaviors between distribution families.

#### Password Aging with chage Command

**Basic Usage:**
```bash
chage username
```
Interactive configuration of all aging parameters.

**Direct Parameter Setting:**
```bash
chage -d 0 username          # Force password change at next login
chage -M 365 username        # Set maximum password age to 365 days
chage -E 2025-03-18 username # Set account expiration date
```

**Password Aging Parameters:**
- **Minimum Days (0)**: Days before password can be changed
- **Maximum Days (99999)**: Days until forced change (interpreted as unlimited)
- **Warning Period**: Days of advance warning before expiration
- **Inactive Days**: Days account remains active after password expiration
- **Expiration Date**: Absolute date when account becomes disabled

#### Global Password Policy Configuration

**Login Definitions File:**
```bash
vim /etc/login.defs
```
- Global settings affecting all users
- Search for `PASS_MAX_DAYS` to modify maximum password age
- Changes apply to new users only, not existing accounts

**Individual vs Global Settings:**
- `chage`: Affects specific user accounts immediately
- `login.defs`: Sets defaults for future user creation

#### Account Management Workflow Example

**Creating Administrative User:**
```bash
# As root
su -
adduser sysadmin
# Set initial password (bypasses complexity checks)
passwd sysadmin  # Can set weak password as root
```

**Subsequent Security Hardening:**
```bash
# As sysadmin (now subject to complexity rules)
passwd
# Must meet current password policy requirements
```

**Forcing Password Change:**
```bash
chage -d 0 sysadmin  # Requires password change on next login
```

> [!NOTE]
> Root privileges bypass password complexity requirements, allowing creation of accounts with weak initial passwords that must be changed by the user.

---

## 2.6 Password Policy Configuration

### Overview
This module covers Pluggable Authentication Modules (PAM) configuration for implementing comprehensive password policies, including minimum length requirements and complexity rules through the modification of system authentication libraries.

### Key Concepts/Deep Dive

#### PAM (Pluggable Authentication Modules) Framework

**Purpose and Scope:**
- Integrated authentication framework for Linux
- Used by CLI logins and display managers (GNOME, KDE)
- Supports external authentication sources (LDAP, etc.)
- Configuration located in `/etc/pam.d/`

**Key PAM Files:**
- `common-password`: Password authentication settings
- `common-auth`: General authentication module
- Distribution-specific implementations vary

#### Password Quality Libraries

**Installing Password Quality Module:**
```bash
apt install libpam-pwquality
```
- Provides enhanced password complexity checking
- Adds `pam_pwquality.so` module to PAM configuration

#### Configuring Password Policies

**Minimum Length Configuration:**
Edit `/etc/pam.d/common-password`:
```
password [success=1 default=ignore] pam_unix.so obscure yescrypt minlen=12
```

**Complexity Requirements:**
Add `pam_pwquality.so` parameters:
```
password requisite pam_pwquality.so ucredit=1 dcredit=1 ocredit=-2 minclass=3
```

**PAM Quality Parameters:**

| Parameter | Description | Example |
|-----------|-------------|---------|
| `minlen=N` | Minimum password length | minlen=12 |
| `ucredit=N` | Required uppercase letters | ucredit=1 |
| `dcredit=N` | Required digits | dcredit=1 |
| `ocredit=N` | Required special characters | ocredit=-2 |
| `minclass=N` | Minimum character classes required | minclass=3 |

**Credit System Explained:**
- **Positive values (+1)**: Must contain at least one character from class
- **Negative values (-2)**: Must contain exactly N characters from class
- **Character Classes**: Uppercase, lowercase, digits, special characters

#### Distribution-Specific Implementation

**Debian/Ubuntu Systems:**
- Direct PAM configuration file editing
- Real-time application (no service restart required)

**Fedora/RHEL Systems:**
- Use `authselect` tool for PAM configuration
- Different file structure and management approach

#### Practical Policy Implementation Example

**Testing Password Requirements:**
```bash
# Attempt password change with insufficient complexity
passwd
# System enforces configured policies automatically
```

**Successful Complex Password:**
```
LinuxISaW3S0M##
```
- Meets length requirement (12+ characters)
- Contains uppercase, lowercase, numbers, special characters
- Satisfies `ocredit=-2` requirement for two special characters

> [!IMPORTANT]
> PAM changes take effect immediately without requiring service restarts or system reboots.

---

## Summary

### Key Takeaways
```diff
+ Password length (16-20 characters) is the most critical security factor
+ Complexity through character diversity significantly increases password strength
+ /etc/shadow stores cryptographic password hashes, not /etc/passwd
+ Root privileges bypass password complexity requirements for account creation
+ PAM configuration enables real-time password policy enforcement
+ NIST recommends against forced periodic password changes
+ Password vaults like KeePassXC enable secure storage of complex passwords
+ chage command provides granular control over individual password aging
+ Global policies in login.defs affect default settings for new accounts
```

### Quick Reference

**Essential Commands:**
```bash
# Password Management
passwd                    # Change current user password
passwd username          # Change specific user password (root)
chage username           # Configure password aging for user
chage -d 0 username      # Force password change at next login

# Account Management
adduser username         # Create new user (Debian/Ubuntu)
useradd username         # Create new user (Fedora/RHEL)
su -                    # Switch to root user

# Password Generation
openssl rand -base64 24  # Generate 24-character Base64 password
openssl rand -hex 24     # Generate 24-character hex password
openssl passwd -6        # Generate SHA-512 password hash

# File Access
vim /etc/passwd          # View user account information
sudo vim /etc/shadow     # View password hashes (requires sudo)
vim /etc/login.defs      # Configure global password policies
vim /etc/pam.d/common-password  # Configure password requirements
```

### Expert Insight

#### Real-world Application
In production environments, implement defense-in-depth password security by combining multiple layers: enforce minimum password lengths through PAM, use password vaults for complex credential management, implement account expiration for temporary access, and maintain separate administrative accounts instead of using root directly.

#### Expert Path
Master the interplay between different password policy layers: understand how PAM modules stack and interact, learn to troubleshoot authentication issues through PAM debugging, explore integration with centralized authentication systems like LDAP or Active Directory, and develop automation scripts for consistent policy deployment across multiple systems.

#### Common Pitfalls
- Setting overly restrictive policies that encourage password reuse or insecure storage methods
- Forgetting that root-created accounts may have weak initial passwords requiring immediate user intervention
- Modifying global policies without understanding the impact on existing vs. new user accounts
- Using adjacent identical special characters in passwords, which password crackers specifically target
- Neglecting to test password policies after implementation to ensure they work as intended

#### Lesser-Known Facts
- The Unix epoch date (January 1, 1970) used in shadow file calculations means account expiration dates far in the future may appear as large numbers like 20,165 days
- PAM modules process authentication in stack order, and a single "requisite" failure stops the entire authentication process
- The entropy measurement in bits provides a mathematical measure of password randomness, with 88+ bits considered strong by current standards
- Some systems maintain password history databases that prevent reuse of the last 5-24 passwords, significantly impacting user password rotation strategies

</details>