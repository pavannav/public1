# Section 100: RHEL8 Features - Containers Management in Linux

<details open>
<summary><b>Section 100: RHEL8 Features - Containers Management in Linux (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Installing Container Tools](#installing-container-tools)
- [Running Containers Temporarily with Commands](#running-containers-temporarily-with-commands)
- [Interactive Mode in Containers](#interactive-mode-in-containers)
- [Installing Packages Inside Containers](#installing-packages-inside-containers)
- [Listing Containers](#listing-containers)
- [Background Running of Containers](#background-running-of-containers)
- [Starting Stopped Containers](#starting-stopped-containers)
- [Inspecting Container Images](#inspecting-container-images)
- [Inspecting Specific Parameters](#inspecting-specific-parameters)
- [Mounting Local Directories](#mounting-local-directories)
- [Mounting File Systems](#mounting-file-systems)
- [Summary](#summary)

## Overview

This session covers advanced container management techniques in RHEL8 Linux. Learn how to run containers temporarily, execute commands interactively within containers, install packages, list and inspect containers, run containers in the background, restart stopped containers, and mount local directories and file systems to containers for enhanced management and troubleshooting.

## Installing Container Tools

To use containers on your RHEL8 machine, you need to install the container tools module. This includes all necessary packages for container management.

```bash
yum module install container-tools
```

Alternatively, you can install specific packages:
```bash
yum install podman buildah skopeo
```

## Running Containers Temporarily with Commands

Run containers temporarily to execute commands without keeping them running permanently:

```bash
podman run --rm ubi8/ubi:latest cat /etc/redhat-release
```

This command pulls the image if not present, runs the container, executes the command, and automatically removes the container afterward.

> [!NOTE]
> The `--rm` flag ensures the container is removed after execution.

## Interactive Mode in Containers

Access a container interactively to run commands directly inside it:

```bash
podman run -it --name my-web ubi8/ubi:latest /bin/bash
```

- `-i`: Interactive mode
- `-t`: Allocate a pseudo-TTY
- `--name`: Assign a name to the container

Exit the container with `Ctrl+D`.

## Installing Packages Inside Containers

Install packages within a running container for additional functionality:

```bash
yum install -y procps-ng
```

For example, this installs the `ps` command to view processes inside the container.

> [!IMPORTANT]
> Package installation persists only for the container's runtime unless committed to a new image.

## Listing Containers

View all containers (running and stopped):

```bash
podman ps -a
```

This shows comprehensive information about all containers that have been run on the system.

> [!NOTE]
> Container information persists for 24 hours after stopping.

## Background Running of Containers

Run containers in the background (detached mode):

```bash
podman run -d --name my-web ubi8/ubi:latest
```

Check running containers:
```bash
podman ps
```

## Starting Stopped Containers

Restart previously created containers using their name or ID:

```bash
podman start my-web
```

View container names and IDs:
```bash
podman images
```

Attach to a running container interactively:
```bash
podman start -ai my-web
```

## Inspecting Container Images

Get detailed information about downloaded container images:

```bash
podman inspect <image_id>
```

Navigate through the JSON output to view specific details.

## Inspecting Specific Parameters

Extract specific information from container metadata:

```bash
podman inspect --format '{{.Name}}' <container_id>
```

Examples:
- Get container name history:
  ```bash
  podman inspect --format '{{.Name}}' <image_id>
  ```
- Get manifest details:
  ```bash
  podman inspect --format '{{.Manifest}}' <image_id>
  ```

## Mounting Local Directories

Mount host directories to containers for data sharing:

```bash
podman run -v /host/path:/container/path ubi8/ubi:latest
```

Example:
```bash
podman run -v /var/log:/var/log ubi8/ubi:latest echo "Testing log entry" >> /var/log/test.log
```

Access logs from host:
```bash
journalctl | grep "Testing log entry"
```

## Mounting File Systems

Mount container file systems to the host for inspection:

```bash
podman run -d --name my-test ubi8/ubi:latest
podman mount my-test
```

This mounts the container's filesystem (e.g., at `/var/lib/containers/storage/overlay/...`) allowing direct access to its contents from the host.

Navigate to the mounted directory to explore the container's internal structure:
```bash
cd /var/lib/containers/storage/overlay/...
ls -la
cat etc/redhat-release  # View OS information
```

## Summary

### Key Takeaways
```diff
+ Container management in RHEL8 uses podman as the primary tool
+ Interactive mode (-it) enables direct command execution inside containers
+ Background running (-d) keeps containers running in detached mode
+ Mounting allows data sharing between host and containers
+ Inspection provides detailed metadata about images and containers
- Always use --rm for temporary containers to avoid accumulation
```

### Quick Reference
| Command | Purpose |
|---------|---------|
| `podman run --rm <image> <command>` | Run temporary container |
| `podman run -it <image>` | Interactive container access |
| `podman run -d <image>` | Background container |
| `podman ps -a` | List all containers |
| `podman start <name>` | Restart stopped container |
| `podman inspect <id>` | Detailed container info |
| `podman mount <name>` | Mount container filesystem |

### Expert Insight
**Real-world Application**: Container mounting is crucial for debugging production applications, log analysis, and developing containerized applications with external data sources.

**Expert Path**: Master advanced podman features like networking, security policies, and custom image builds to handle complex enterprise container deployments.

**Common Pitfalls**: 
- Forgetting --rm flag leads to container accumulation
- Not handling permissions when mounting host directories
- Assuming container changes persist (they don't unless committed)

</details>
