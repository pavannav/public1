<details open>
<summary><b>Section 97: Image Builder in RHEL 8 (CL-KK-Terminal)</b></summary>

# Section 97: Image Builder in RHEL 8

## Table of Contents
- [Introduction to Image Builder / osbuild-composer](#introduction-to-image-builder-osbuild-composer)
- [Subscribing to Red Hat and Enabling Repositories](#subscribing-to-red-hat-and-enabling-repositories)
- [Installing Required Packages](#installing-required-packages)
- [Creating and Configuring a Blueprint](#creating-and-configuring-a-blueprint)
- [Building Images via Command Line Interface (CLI)](#building-images-via-command-line-interface-cli)
- [Building Images via Cockpit Web Interface](#building-images-via-cockpit-web-interface)
- [Supported Image Types and Usage](#supported-image-types-and-usage)
- [Summary](#summary)

## Introduction to Image Builder / osbuild-composer

Image Builder, formerly known as Lorex Composer and now referred to as osbuild-composer, is a powerful utility in Red Hat Enterprise Linux 8 for creating ready-to-deploy images. It simplifies the process of packaging applications, operating systems, and configurations into various image formats suitable for deployment in different environments, including cloud platforms like AWS, Azure, GCP, and OpenStack.

> [!IMPORTANT]
> Image Builder requires a valid Red Hat subscription to access necessary repositories and packages, as it is not available in CentOS Stream or Rocky Linux.

### Key Features
- Create custom OS images tailored to specific needs.
- Pre-install packages, configurations, and services.
- Build images for multiple cloud providers and virtualization platforms.
- Supports formats like AMI (AWS), VHD (Azure), QCOW2 (KVM), and QCOW2 (OpenStack).

### Why Use Image Builder?
It eliminates the need for manual image creation, reduces deployment time, and ensures consistency across environments. For instance, you can build a web server image with pre-installed Apache, firewall rules, and custom user accounts.

## Subscribing to Red Hat and Enabling Repositories

To use Image Builder, you must subscribe your RHEL system to Red Hat. This process enables access to RHEL repositories containing the required packages.

### Steps to Subscribe
1. Register the system with Red Hat Subscription Manager:
   ```
   subscription-manager register --username <your-red-hat-username> --password
   ```
   - Replace `<your-red-hat-username>` with your Red Hat account username.
   - Enter your password when prompted (avoid displaying it on screen for security reasons).

2. Alternatively, attach a subscription in a single command:
   ```
   subscription-manager register --username <your-red-hat-username> --auto-attach
   ```
   - This command registers and auto-attaches an available subscription.

> [!NOTE]
> If using a developer account (free for one year), ensure your plan allows image building.

3. Refresh repositories:
   ```
   dnf repolist --enabled
   ```
   - If repositories are disabled, enable them using `subscription-manager repos --enable=<repo-name>`.

### Common Repositories
After subscription, you should see BaseOS, AppStream, and other RHEL repositories enabled. Packages like lorax-composer are available from these repos.

## Installing Required Packages

Once subscribed, install the necessary packages for Image Builder.

### Installation Command
```
dnf install lorax-composer cockpit-composer composer-cli
```
- **lorax-composer**: Core composer service (formerly lo-rex-composer).
- **cockpit-composer**: Cockpit plugin for web-based image building.
- **composer-cli**: Command-line tools for composer operations.

### Enable and Start Services
```
systemctl enable --now osbuild-composer
systemctl enable --now cockpit.socket
```
- The composer service is now `osbuild-composer` (previously `lorax-composer`).
- The Cockpit service (`cockpit.socket`) is auto-enabled on subscription but verify with `systemctl status cockpit.socket`.

> [!TIP]
> Add the root user to the `wheel` group for accessing composer tools: `usermod -aG wheel root`.

### Verify Installation
- Check service status: `systemctl status osbuild-composer`.
- If not active, reload and start: `systemctl reload-daemon` followed by `systemctl start osbuild-composer`.

## Creating and Configuring a Blueprint

A blueprint is a text file (e.g., `webserver.toml`) defining the image contents, including users, packages, and services. It acts as a template for the image.

### Location
- Default location: `/etc/osbuild-composer/blueprints/`
- Create a blueprint file manually or via Cockpit.

### Basic Blueprint Structure (TOML Format)
```toml
name = "example-blueprint"
description = "Example blueprint for a web server"
version = "0.1.0"

[customizations]
hostname = "webserver"

[[customizations.user]]
name = "admin"
password = "<encrypted-password>"
groups = ["wheel"]

[customizations.services]
enabled = ["httpd", "sshd"]
disabled = ["chronyd"]

[[packages]]
name = "httpd"

[[packages]]
name = "firewalld"
```

### Generate Encrypted Password
Use Python3 or pwgen to create an encrypted password:
```
python3 -c "import crypt; print(crypt.crypt('rabbit'))"
```
- Replace `"rabbit"` with your desired password.
- Add the output to the blueprint under `[[customizations.user].password]`.

### Push Blueprint to Composer
```
composer-cli blueprints push <blueprint-file.toml>
```

### List Blueprints
```
composer-cli blueprints list
composer-cli blueprints show <blueprint-name>
```

## Building Images via Command Line Interface (CLI)

Once the blueprint is ready, build the image directly from the terminal.

### Supported Image Types Query
```
composer-cli compose types
```
- Examples: AMIs for AWS, VHD for Azure, QCOW2 for KVM/OpenStack, VMDK for VMware.

### Compose Image
```
composer-cli compose start <blueprint-name> QCOW2
```
- Replace `QCOW2` with the desired type (e.g., `AMI` for AWS).
- Monitor progress: `composer-cli compose list` (shows status: RUNNING, FINISHED).
- View logs: `composer-cli compose log <compose-id>`.

### Monitor and Download
```
composer-cli compose status <compose-id>
composer-cli compose image <compose-id>  # Downloads the image to /var/lib/osbuild-composer/
```

> [!NOTE]
> Building can take 5-15 minutes or longer depending on complexity. Images are typically 10GB+ in size.

## Building Images via Cockpit Web Interface

Cockpit provides a graphical way to manage images while retaining CLI functionality.

### Access Cockpit
1. Enable access to port 9090.
2. Open a browser to `https://<server-ip>:9090`.
3. Log in as root or a privileged user.
4. Select "Image Builder" from the Applications menu.

### Create Blueprint in Cockpit
1. Navigate to Image Builder > Create Blueprint.
2. Name: "webserver".
3. Description: e.g., "Blueprint for a web server".
4. Click "Create".

### Add Customizations
- **Users**: Add accounts (e.g., admin with generated password).
- **Hostname**: Set a custom hostname.
- **Packages**: Search and add packages (e.g., httpd, firewalld) using the "+" button.
- **Services**: Enable/disable services (e.g., httpd, firewalld).
- **Other Customizations**: Add groups, SELinux policies, etc.

### Commit Changes
- Click the "Commit" button to save the blueprint.

### Build Image
1. Select "Image Builder" and choose your blueprint.
2. Click "Create Image".
3. Select output type (e.g., QCOW2 for local use).
4. Click "Create".
5. Monitor progress in the "Images" tab (log viewing available).
6. Download completed images from the interface.

> [!NOTE]
> Cockpit automates blueprint file creation and provides real-time status updates, making it user-friendly for beginners.

### Benefits of Cockpit
- Intuitive GUI for those unfamiliar with CLI.
- Integrated with composer status and logs.
- Supports all blueprint features, including package and service management.

## Supported Image Types and Usage

Image Builder supports various formats for different platforms:

| Platform         | Image Type | Extension | Use Case                          |
|------------------|------------|-----------|-----------------------------------|
| AWS             | AMI        | ami       | Deploy to Amazon EC2             |
| Azure           | VHD        | vhd       | Upload to Azure Blob Storage     |
| Google Cloud    | Tar        | tar.gz    | Import to GCP Compute Engine     |
| VMware          | VMDK       | vmdk      | Use with VMware vSphere          |
| KVM/OpenStack   | QCOW2      | qcow2     | Run locally in libvirt or virt-manager |
| OpenStack       | QCOW2      | qcow2     | Upload to OpenStack Glance       |
| PowerVM         | PVPT       | pvpt      | Use with IBM Power Systems       |
| Local/Mini      | QCOW2      | qcow2     | Small images for testing         |

### Real-World Application
- Build a production-ready web server image with Nginx, secure SSH config, and firewall rules.
- Migrate legacy apps to cloud by creating pre-configured images.
- Automate deployments in CI/CD pipelines using Ansible or scripts.

### Deploying Images
1. Download image from `/var/lib/osbuild-composer/` or Cockpit.
2. Upload to cloud provider (e.g., via AWS CLI, Azure CLI).
3. For local use: Import into virtual machine managers like virt-manager: `qemu-img convert -O qcow2 <image> <dest>`.
4. Launch the VM and customize further if needed.

## Summary

### Key Takeaways
```diff
! Image Builder (osbuild-composer) simplifies custom OS image creation for RHEL 8.
+ Requires Red Hat subscription for repo access.
+ Use blueprints (TOML files) to define image contents like users, packages, and services.
- CLI and Cockpit both supported; Cockpit offers GUI for ease.
+ Supported types: AMI, VHD, QCOW2, VMDK, etc., for multi-cloud deployment.
! Building time: 5-15+ minutes; images ~10GB.
! Test images locally before production deployment.
```

### Quick Reference
- **Subscribe System**: `subscription-manager register --username <user> --auto-attach`
- **Install Packages**: `dnf install lorax-composer cockpit-composer composer-cli`
- **Create Blueprint**: Edit `.toml` file with customizations, push via `composer-cli blueprints push <file>`
- **Build Image**: `composer-cli compose start <blueprint> <type>`
- **Check Status**: `composer-cli compose status <id>`
- **Access Cockpit**: `https://<ip>:9090` (enable cockpit.socket)

### Expert Insight
**Real-world Application**: In enterprise environments, use Image Builder to standardize server images across departments, ensuring compliance (e.g., SELinux policies, security hardening) and reducing configuration drift.

**Expert Path**: Dive deeper into blueprint customizing for complex setups, integrating with Ansible for dynamic configurations. Experiment with different image types for hybrid cloud strategies.

**Common Pitfalls**: Without subscription, no access to packages—migrate to paid plans. Incorrect blueprint syntax leads to build failures—validate with `composer-cli blueprints show`. Large images cause storage issues; plan disk space (~20GB free for builds).

</details>
