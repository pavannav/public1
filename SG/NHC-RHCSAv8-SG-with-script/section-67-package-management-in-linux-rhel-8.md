# Section 67: Package Management in Linux

<details open>
<summary><b>Section 67: Package Management in Linux (CL-KK-Terminal)</b></summary>

## Table of Contents

- [1. Introduction to Package Management](#1-introduction-to-package-management)
- [2. Managing Packages in Debian-based Systems](#2-managing-packages-in-debian-based-systems)
- [3. Managing Packages in Red Hat-based Systems (RHEL/CentOS/Fedora)](#3-managing-packages-in-red-hat-based-systems-rhelcentosfedora)
- [4. Repository Management](#4-repository-management)
- [5. Package Conversion and Installing from Source Code](#5-package-conversion-and-installing-from-source-code)

## 1. Introduction to Package Management

### Overview
Package management is a critical aspect of Linux system administration, enabling users to efficiently handle software installations, updates, and removals across different distributions. This section covers the fundamentals of package management, dependencies, repositories, and the various tools used in Debian-based (like Ubuntu) and Red Hat-based (like CentOS/RHEL) systems. Understanding these concepts ensures reliable software deployment and maintenance.

### Key Concepts
- **Package**: Software bundled for easy installation. Packages have extensions like `.deb` for Debian-based systems and `.rpm` for Red Hat-based systems.
- **Dependencies**: Programs that must be installed for another package to function. For example, GCC requires kernel-related packages.
  - Resolving dependencies manually with `dpkg` or `rpm` can be problematic; tools like `apt-get`, `yum`, or `dnf` handle this automatically.
- **Repository**: A collection of software packages and documentation available online or locally. Examples include official distribution repos for Ubuntu CentOS.
  - Public repos: Ubuntu repos, CentOS repos.
  - Local repos: Custom servers for air-gapped environments.
- **Package Managers**:
  - Debian-based: `dpkg`, `apt-get`, `aptitude`.
  - Red Hat-based: `rpm`, `yum`, `dnf`.
  - Concepts like open-source software (freely available source code) are integral to package ecosystems.

> **Note**: Repositories provide metadata for packages, enabling tools to check for updates and installations.

### Common Operations Overview
- **Install**: Add software.
- **Remove/Purge**: Remove software (purge also deletes config files).
- **Update/Upgrade**: Fetch latest package lists from repos and apply updates.
- **Search/List**: Find and query installed/available packages.

## 2. Managing Packages in Debian-based Systems

### Overview
Debian-based distributions like Ubuntu use `.deb` packages managed primarily with `dpkg`, `apt-get`, and `aptitude`. These tools handle dependencies automatically, unlike raw `dpkg`. Official repos are pre-configured, but custom repos can be added. This section demonstrates commands for listing, installing, updating, and removing packages.

### Key Concepts and Commands

**Listing Installed Packages**
- View total installed packages: `dpkg -l | head -20` or `dpkg -l | wc -l` for count.
- Check if a specific package is installed: `dpkg -l | grep <package_name>`.

**Querying Package Details**
- Show detailed info for an installed package: `dpkg -s <package_name>`.
- List files installed by a package: `dpkg -L <package_name>`.
- Find which package owns a file: `dpkg -S <file_path>`.

**Installing Packages with dpkg**
- Basic install: `sudo dpkg -i <package.deb>`.
- Issues: Fails if dependencies are missing (e.g., trying to install `apache2.deb` without libs).
- Resolve with `apt-get` for dependencies.

**apt-get Commands (Recommended for Debian)**
- Update package lists from repos: `sudo apt-get update`.
- Upgrade installed packages: `sudo apt-get upgrade`.
- Safely upgrade (resolves conflicts): `sudo apt-get dist-upgrade`.
- Clean old package caches: `sudo apt-get autoclean` or `sudo apt-get autoremove` for unused deps.
- Install a package: `sudo apt-get install <package_name>`.
- Remove a package: `sudo apt-get remove <package_name>`.
- Purge (remove including configs): `sudo apt-get purge <package_name>`.
- Search for packages: `apt-cache search <keyword>` or `apt-get search <package_name>`.

**aptitude Commands (Advanced Alternative to apt-get)**
- Install aptitude if not present: `sudo apt-get install aptitude`.
- Update: `sudo aptitude update`.
- Safe upgrade: `sudo aptitude safe-upgrade`.
- Install: `sudo aptitude install <package_name>`.
- Remove: `sudo aptitude remove <package_name>`.
- Purge: `sudo aptitude purge <package_name>`.
- Search: `sudo aptitude search <package_name>`.

**Repository Management in Debian**
- Repo config file: `/etc/apt/sources.list`.
- Add repos manually: Edit `sources.list` or use `sudo apt-get add-repository <repo_url>`.
- For EPOL (EPEL) equivalent, add: `sudo apt-get install software-properties-common` then `sudo add-apt-repository <repo>`.

```bash
# Example: Install Apache2
sudo apt-get update
sudo apt-get install apache2

# Remove with purge
sudo apt-get purge apache2
```

> **Important**: Use `apt-get` over `dpkg` for automatic dependency resolution. Always run `apt-get update` before installs/upgrades.

## 3. Managing Packages in Red Hat-based Systems (RHEL/CentOS/Fedora)

### Overview
Red Hat-based distributions (RHEL, CentOS, Fedora) use `.rpm` packages. `rpm` is the low-level tool (manual deps), while `yum` (RHEL 6/7) and `dnf` (RHEL 8/9, Fedora) handle automated dependency resolution. Repos are configured in `/etc/yum.repos.d/`. CentOS uses CentOS repos; enable EPEL for extras.

### Key Concepts and Commands

**RPM Commands (Low-Level)**
- List all installed packages: `rpm -qa` (count with `rpm -qa | wc -l`).
- Query if package is installed: `rpm -q <package_name>` (e.g., `rpm -q samba-common`).
- Show package info: `rpm -qi <package_name>`.
- List files by package: `rpm -ql <package_name>`.
- Verify package integrity: `rpm -V <package_name>`.
- Install from local file: `sudo rpm -ivh <package.rpm>` (verbose, hash progress).
- Upgrade: `sudo rpm -Uvh <package.rpm>`.
- Erase: `sudo rpm -e <package_name>`.

Issues: Manual dependency resolution sucks; use `yum/dnf`.

```bash
# Example: Mount ISO for offline install
sudo mkdir /mnt/iso
sudo mount /path/to/CentOS.iso /mnt/iso
# Access packages in /mnt/iso/BaseOS/Packages/
```

**yum/dnf Commands (High-Level, Preferred)**
- Older systems (RHEL 7): `yum`.
- Newer (RHEL 8+): `dnf`.
- List available packages: `dnf list available`.
- Search: `dnf search <keyword>` or `dnf list <partial_name>`.
- Show package info: `dnf info <package_name>`.
- List installed packages: `dnf list installed`.
- Install: `sudo dnf install <package_name>`.
- Remove: `sudo dnf remove <package_name>` or `sudo dnf erase <package_name>`.
- Update system: `sudo dnf update` (or `dnf upgrade`).
- Upgrade specific: `sudo dnf upgrade <package_name>`.
- Group management: `dnf grouplist`, `sudo dnf groupinstall <group>` (e.g., "Development Tools").
- Clean cache: `sudo dnf clean packages`.

**Repository Management in Red Hat**
- Repo files: `/etc/yum.repos.d/*.repo`.
- Enable/disable repos: Edit `.repo` files (e.g., `enabled=1`).
- Add custom repo: Create file in `/etc/yum.repos.d/` with URL.
- Install EPEL: `sudo dnf install epel-release` then `sudo dnf repolist` to enable.

```bash
# Example: Install httpd
sudo dnf update
sudo dnf install httpd

# Reinstall
sudo dnf reinstall vsftpd
```

> **Note**: `dnf` is the successor to `yum`; use `dnf` for RHEL 8+. Cold updates require repos; handle manually for offline.

**Converting Formats**
- RPM to CPIO: `rpm2cpio <package.rpm> > <archive.cpio>`.
- Extract file from RPM: `rpm2cpio <package.rpm> | cpio -idv <file_path>`.

## 4. Repository Management

### Overview
Repositories centralize package access. Debian uses `/etc/apt/sources.list`; Red Hat uses `/etc/yum.repos.d/`. For offline environments, create local repos by copying packages to a server and configuring access.

### Key Concepts
- **Local Repo Setup** (Red Hat): 
  - Copy packages from ISO/DVD to `/var/www/html/repo`.
  - Use `createrepo` to generate metadata.
  - Point clients to local server via `/etc/yum.repos.d/`.
- **Adding Online Repos**:
  - Debian: `sudo apt-get add-repository <url>`.
  - Red Hat: Edit `.repo` files or use `yum-config-manager`.

```bash
# Add repo via shell
sudo yum add-repository <repo_url>
sudo yum repolist
```

## 5. Package Conversion and Installing from Source Code

### Overview
Sometimes packages need conversion or installation from source (e.g., custom software). Use `alien` for format changes; compile source for platform-specific builds.

### Key Concepts
- **Alien for Conversion**:
  - Install: `sudo apt-get install alien` (Debian) or `sudo dnf install alien`.
  - Convert RPM to DEB: `sudo alien -d <package.rpm>`.
  - Convert DEB to RPM: `sudo alien -r <package.deb>`.
  - Not always reliable; system-specific deps may fail.

```bash
# Example: Convert RPM to DEB
sudo alien --to-deb <package.rpm>
```

- **Installing from Source**:
  - Download tarball: `wget <source_url>.tar.gz`.
  - Extract: `tar -xzf <file.tar.gz>`.
  - Configure: `./configure`.
  - Build: `make`.
  - Install: `sudo make install`.
  - Requires GCC and dev tools (e.g., `dnf groupinstall "Development Tools"`).

```bash
# Example: Compile Putty from source
wget https://putty/releases/source/putty-0.76.tar.gz
tar -xzf putty-0.76.tar.gz
cd putty-0.76
./configure
make
sudo make install
```

> **Note**: Source installs are optimal but require dev env setup.

## Summary

### Key Takeaways
- Understand distribution families: Debian (apt-based) vs. Red Hat (rpm/yum/dnf-based).
- Always update repos before installs/upgrades.
- Use high-level tools (apt, yum/dnf) for automated deps.
- Repos enable online updates; local repos for offline.
- Source compilation offers customization but complexity.

### Quick Reference
| Operation | Debian/Ubuntu | RHEL/CentOS/Fedora |
|-----------|----------------|---------------------|
| Update repos | `sudo apt-get update` | `sudo dnf update` |
| Install package | `sudo apt-get install <pkg>` | `sudo dnf install <pkg>` |
| Remove package | `sudo apt-get remove <pkg>` | `sudo dnf remove <pkg>` |
| Search | `apt-cache search <pkg>` | `dnf search <pkg>` |
| List installed | `dpkg -l` | `rpm -qa` or `dnf list installed` |
| Upgrade system | `sudo apt-get upgrade` | `sudo dnf upgrade` |
| Group install | N/A | `sudo dnf groupinstall "<group>"` |

### Expert Insight
**Real-world Application**: In production environments, use repos for consistent deployments (e.g., Ansible with yum/dnf/apt). Resolve deps automatically to avoid conflicts; monitor with tools like `yum history` or `apt log`.

**Expert Path**: Master scripting package management (e.g., Bash scripts for mass installs). Learn RHCSA/RHCE for enterprise tools like Satellite.

**Common Pitfalls**: Forgetting `apt-get update` leads to old packages. Ignoring dependencies with `rpm` causes breaks. Mixing repos without testing can create conflicts.

</details>
