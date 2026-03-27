# Section 69: Building RPM Packages

<details open>
<summary><b>Section 69: Building RPM Packages (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to RPM Package Building](#introduction-to-rpm-package-building)
- [Preparing the Environment for RPM Building](#preparing-the-environment-for-rpm-building)
- [RPM Build Directory Structure](#rpm-build-directory-structure)
- [Creating RPM Spec Files](#creating-rpm-spec-files)
- [Building the RPM Package](#building-the-rpm-package)
- [Installing and Testing the RPM Package](#installing-and-testing-the-rpm-package)

## Introduction to RPM Package Building

RPM (Red Hat Package Manager) packages are used to distribute and install software on Red Hat-based Linux distributions like RHEL and CentOS. Building RPM packages from source code allows you to create custom packages, such as for local repositories, without relying on external package managers.

```bash
# Install required RPM build tools
yum install rpmdevtools rpm-build
```

> [!NOTE]
> RPM packages can be built using either source code or custom spec files. This section demonstrates creating a package for a local repository configuration.

> [!IMPORTANT]
> Always build RPM packages as a normal user, never as root, for security reasons.

### Use Cases
- Creating custom packages for local repositories
- Packaging applications or configurations not available in standard repos
- Automating software deployment in enterprise environments

## Preparing the Environment for RPM Building

Before building RPM packages, ensure the required toolchain is installed and the build environment is set up.

### Step 1: Install Required Packages
```bash
yum install rpmdevtools rpm-build
```

### Step 2: Set Up RPM Build Directory Structure
Run the following command as a normal user to create the required directory hierarchy:
```bash
rpmdev-setuptree
```

This command creates the following structure in your home directory:
- `~/rpmbuild/BUILD/` - Temporary build directory
- `~/rpmbuild/BUILDROOT/` - Simulated root filesystem during build
- `~/rpmbuild/RPMS/` - Final RPM package location
- `~/rpmbuild/SOURCES/` - Source files directory
- `~/rpmbuild/SPECS/` - Spec files directory
- `~/rpmbuild/SRPMS/` - Source RPM storage (optional)

> [!NOTE]
> The spec file contains all package metadata and build instructions.

## RPM Build Directory Structure

The RPM build system uses a specific directory structure under `~/rpmbuild/`. Each subdirectory serves a specific purpose during the package building process.

### Key Directories and Their Purposes

| Directory | Purpose |
|-----------|---------|
| BUILD | Temporary directory where source code is unpacked and compiled |
| BUILDROOT | Root filesystem simulation for package installation |
| RPMS | Final location of built binary RPM packages |
| SOURCES | Stores source files, patches, and compressed archives |
| SPECS | Contains `.spec` files with package metadata and build instructions |
| SRPMS | Optional location for source RPM packages |

### File Organization Example
```
~/rpmbuild/
├── BUILD/
├── BUILDROOT/
├── RPMS/
├── SOURCES/
│   └── local-repo.tar.gz
└── SPECS/
    └── local-repo.spec
```

## Creating RPM Spec Files

A spec file (`.spec`) is the blueprint for building an RPM package. It contains package metadata, source information, build instructions, and installation commands.

### Creating a Basic Spec File

1. Use `rpmdev-newspec` to generate a template:
```bash
rpmdev-newspec local-repo.spec
```

2. Edit the spec file with package details:

```bash
Name:           local-repo
Version:        1
Release:        1%{?dist}
Summary:        Local repository configuration package

License:        GPL
Source0:        %{name}.tar.gz

BuildRoot:      %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

BuildRequires:  
Requires:       

%description
Create a local repo file in /etc/yum.repos.d/ for managing local packages

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
install -d %{buildroot}/etc/yum.repos.d/
install -m 0644 local-repo.repo %{buildroot}/etc/yum.repos.d/

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
/etc/yum.repos.d/local-repo.repo

%changelog
* Mon Mar 27 2023 Development Nahra <dev@nagra.com>
- Initial package
```

### Key Spec File Components

| Section | Description |
|---------|-------------|
| `%description` | Package description |
| `%prep` | Source unpacking and preparation |
| `%build` | Compilation commands |
| `%install` | File installation to buildroot |
| `%files` | List of files to package |
| `%changelog` | Version history |

## Building the RPM Package

After creating the spec file and placing source files in the SOURCES directory, build the RPM package.

### Building the Package
```bash
# From ~/rpmbuild/SPECS/ directory
rpmbuild -ba local-repo.spec
```

This command:
- Validates the spec file syntax
- Unpacks source archives
- Executes build steps
- Creates the RPM package in `~/rpmbuild/RPMS/`

### Common Build Errors
- Missing source files in SOURCES/
- Incorrect file paths in spec file
- Missing build dependencies
- Syntax errors in spec macros

## Installing and Testing the RPM Package

Once the RPM is built, install it for testing and verify functionality.

### Installing the Package
```bash
# As root or with sudo
rpm -ivh ~/rpmbuild/RPMS/noarch/local-repo-1-1.el8.noarch.rpm
```

### Testing the Installation
```bash
# Check if repo file was created
ls -la /etc/yum.repos.d/local-repo.repo

# Test yum operations
yum repolist
yum search package_name
```

### Verifying Package Details
```bash
# Get package information
rpm -qi local-repo

# List package files
rpm -ql local-repo
```

## Summary

### Key Takeaways
```diff
+ RPM building allows creating custom software packages
- Always use normal user accounts for building packages
! Never include root-level commands directly in spec files
+ Spec files contain all package metadata and instructions
- Test packages thoroughly before deployment
```

### Quick Reference Commands
- Setup build environment: `rpmdev-setuptree`
- Create spec template: `rpmdev-newspec package.spec`
- Build package: `rpmbuild -ba package.spec`
- Install package: `rpm -ivh package.rpm`
- Query package: `rpm -qi package`

### Expert Insight

**Real-world Application**: RPM packages are essential for enterprise Linux deployments where custom software or configurations need to be distributed across multiple systems. They ensure consistent installations and can be integrated with configuration management tools like Ansible or Puppet.

**Expert Path**: Master advanced spec file features like triggers, dependencies, and scripting. Learn to create packages for different architectures and handle complex build requirements.

**Common Pitfalls**: 
- Forgetting to specify correct file permissions in the `%files` section
- Including absolute paths that don't exist in the build environment
- Not handling architecture-specific builds correctly
- Ignoring build dependencies that cause compilation failures

</details>
