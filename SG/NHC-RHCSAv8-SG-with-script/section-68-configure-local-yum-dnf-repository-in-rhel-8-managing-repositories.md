# Section 68: Local and EPEL Repository Configuration

<details open>
<summary><b>Section 68: Local and EPEL Repository Configuration (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Repositories](#introduction-to-repositories)
- [Local Repository Configuration from ISO Image](#local-repository-configuration-from-iso-image)
- [Manual Repository File Creation](#manual-repository-file-creation)
- [Enabling and Managing Repositories](#enabling-and-managing-repositories)
- [Installing Packages and Verifying Repositories](#installing-packages-and-verifying-repositories)
- [Configuring EPEL Repository](#configuring-epel-repository)
- [Disabling Subscription Manager Warnings](#disabling-subscription-manager-warnings)
- [Command-Line Repository Management](#command-line-repository-management)
- [Using yum-config-manager for Repositories](#using-yum-config-manager-for-repositories)
- [Summary](#summary)

## Introduction to Repositories

### Overview
Repositories are collections of software packages and documentation that allow systems to install, update, and manage software. In Red Hat Enterprise Linux (RHEL), repositories can be local (from mounted ISO or disk) or external (online or centralized servers). This section covers configuring local repositories from ISO images and enabling external repositories like EPEL for access to additional packages when subscription is not available.

### Key Concepts
- **Local Repository**: A repository hosted on the local system, often from an ISO image containing base packages (e.g., RHEL 7.9 ISO with `BaseOS` and `AppStream` directories).
- **External/Online Repository**: Repositories accessible via internet or network, such as EPEL (Extra Packages for Enterprise Linux), which provides additional packages not in core RHEL repos.
- **Repository File**: Configuration files in `/etc/yum.repos.d/` defining repository details like name, baseurl, gpgcheck, etc.

### Deep Dive
Repositories enable package managers like DNF/YUM to locate and install software. Without a subscription, online repositories like Red Hat's are unavailable, necessitating local setups. Key directories in ISO include:
- `AppStream`: Application-specific packages.
- `BaseOS`: Core OS packages.

Packages are stored as RPMs, and repositories ensure dependencies are resolved during installation.

## Local Repository Configuration from ISO Image

### Overview
To configure a local repository, mount the RHEL installation ISO and point the system to the package locations.

### Lab Demo: Mounting ISO and Setting Up Local Repo
1. Verify ISO is accessible (e.g., via loop device or mount).
2. Create a mount point directory.
3. Mount the ISO.
4. Create repository file in `/etc/yum.repos.d/`.

```bash
# Example commands for mounting ISO
mkdir /local_repo
mount /dev/sr0 /local_repo  # Assuming sr0 is the ISO device
ls /local_repo/AppStream/  # Verify contents
ls /local_repo/BaseOS/
```

### Key Concepts
- Mount ISO using `mount` command with read-only options to avoid corruption.
- Repository files use `.repo` extension and specify baseurl as file:// path.

### Configuration File Example
Create `/etc/yum.repos.d/local_repo.repo`:

```ini
[base]
name=Base Repo
baseurl=file:///local_repo/BaseOS/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[appstream]
name=AppStream Repo
baseurl=file:///local_repo/AppStream/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
```

After configuration, run `yum repolist` to verify.

## Manual Repository File Creation

### Overview
Repository files are text files with sections for each repo, defining parameters like name, baseurl, gpgcheck.

### Deep Dive
- **[section_name]**: Unique identifier.
- **name**: Human-readable name.
- **baseurl**: URL to packages (file:// for local).
- **gpgcheck**: Enable (1) or disable (0) package signature verification.
- **enabled**: Enable (1) or disable (0) repo.
- **gpgkey**: Path to GPG key for verification if gpgcheck is enabled.

### Code Config Block
Example for base repo:

```ini
[base]
name=Base OS Local Repo
metadata_expire=never  # Optional: Disable metadata expiry
gpgcheck=1
enabled=1
baseurl=file:///local_repo/BaseOS/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
```

For AppStream:

```ini
[appstream]
name=AppStream Local Repo
gpgcheck=1
enabled=1
baseurl=file:///local_repo/AppStream/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
```

### Lab Demo
- Edit file with `vim /etc/yum.repos.d/local_repo.repo`.
- Save and run `yum repolist` to check status.

## Enabling and Managing Repositories

### Overview
Repositories can be enabled/disabled via config files or commands to control package sources.

### Deep Dive
- In `.repo` file, set `enabled=1` for enable, `enabled=0` for disable.
- Use `yum-config-manager` or edit files directly.
- Check status with `yum repolist all` to see enabled/disabled repos.

### Commands
- `yum repolist`: List enabled repos.
- `yum config-manager --disable repo_name`: Disable a repo.
- `yum config-manager --enable repo_name`: Enable a repo.

### Alert
> [!NOTE]
> Changes to `.repo` files require reloading repo metadata via `yum clean all` or `yum makecache`.

## Installing Packages and Verifying Repositories

### Overview
Once configured, install packages using `yum` or `dnf`.

### Lab Demo
```bash
yum install httpd  # Install Apache, verifying local repo works
rpm -q httpd       # Verify installation
```

### Key Concepts
- Packages are pulled from enabled repos.
- If gpgcheck fails, it may indicate key issues; resolve with correct gpgkey path.

## Configuring EPEL Repository

### Overview
EPEL provides extra packages for RHEL, installed via RPM download.

### Lab Demo
1. Download EPEL RPM from Fedora project site.
2. Install the RPM.
3. Verify with `yum repolist`.

```bash
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm  # For RHEL 7
yum repolist | grep epel  # Check EPEL repos are added
yum install chromium  # Example: Install package from EPEL
```

### Deep Dive
- EPEL RPM adds repository files automatically.
- Contains packages like VLC, Chromium not in standard RHEL repos.
- Ensure compatibility with RHEL version.

### Table: Common EPEL Repos
| Repository | Description |
|------------|-------------|
| epel | Main EPEL repo |
| epel-testing | Testing repository |

## Disabling Subscription Manager Warnings

### Overview
Disable warnings for unregistered systems using configuration files.

### Deep Dive
- Edit `/etc/yum/pluginconf.d/subscription-manager.conf`.
- Set `enabled=0` under `[main]` section.

### Code Config Block
```ini
[main]
enabled=0
```

After change, warnings are suppressed during package operations.

## Command-Line Repository Management

### Overview
Use `yum-config-manager` for adding reps without manual file editing.

### Deep Dive
- Syntax: `yum-config-manager [options] [repo_name]`.
- For local: Specify baseurl as file://.
- For remote: Provide HTTP/HTTPS URL.

### Example
```bash
yum-config-manager --add-repo="file:///local_repo/BaseOS/"
yum-config-manager --enable local_repo_BaseOS_
```

### Alert
> [!IMPORTANT]
> If GPG keys are needed, copy them to `/etc/pki/rpm-gpg/` and reference in config.

## Using yum-config-manager for Repositories

### Overview
Add repositories dynamically, especially for web/FTP sources.

### Lab Demo
```bash
yum-config-manager --add-repo="https://example.com/repo"
```

This creates `.repo` files in `/etc/yum.repos.d/`.

### Key Concepts
- Automatically handles basic options; manual tweaks may be needed for GPG.
- Useful for centralized repos in organizations.

## Summary

### Key Takeaways
```diff
+ Repositories are essential for package management in RHEL, enabling installation without subscription via local ISO mounts or external repos like EPEL.
- Ensure correct baseurl, gpgcheck, and gpgkey paths to avoid installation failures.
! Always verify repository status with 'yum repolist' before installing packages.
- Misconfigurations can lead to dependency errors or security risks if GPG is disabled improperly.
```

### Quick Reference
- Mount ISO: `mount /dev/sr0 /local_repo`
- Create repo file: Edit `/etc/yum.repos.d/local.repo` with baseurl=file:///path
- Enable VLC: `yum install vlc` (after EPEL setup)
- Repolist: `yum repolist all`
- Disable warnings: Edit `/etc/yum/pluginconf.d/subscription-manager.conf`, set enabled=0
- Add repo: `yum-config-manager --add-repo="url"`

### Expert Insight
**Real-world Application**: Use local repos in air-gapped environments or for staging testing before production deployments. For larger organizations, set up centralized mirrors using tools like Pulp or Satellite.

**Expert Path**: Explore advanced repro CM with createrepo for custom repos, and integrate with Ansible for automation. Master GPG key management to ensure package integrity.

**Common Pitfalls**: Incorrect file permissions on mounted ISO can prevent access; always mount read-only. Forgetting to enable repos post-config; test with small packages first. EPEL compatibility issues—verify versions match RHEL.

</details>
