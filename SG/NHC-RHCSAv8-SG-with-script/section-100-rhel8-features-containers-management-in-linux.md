# Section 100: Container Management 

<details open>
<summary><b>Section 100: Container Management (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Running Containers Temporarily](#running-containers-temporarily)
- [Running Containers Interactively](#running-containers-interactively)
- [Installing Packages Inside Containers](#installing-packages-inside-containers)
- [Listing Containers and Logs](#listing-containers-and-logs)
- [Running Containers in Background](#running-containers-in-background)
- [Starting Stopped Containers](#starting-stopped-containers)
- [Inspecting Container Images](#inspecting-container-images)
- [Mounting Local Directories](#mounting-local-directories)
- [Mounting File Systems](#mounting-file-systems)

## Running Containers Temporarily

### Overview
This module covers how to run a container temporarily from your host machine to execute commands inside it without needing interactive access. This is useful for quick operations like checking the operating system version or inspecting container configurations without keeping the container running indefinitely.

### Key Concepts/Deep Dive
To run a container temporarily, use the Podman command with the `--rm` flag, which automatically removes the container after the command executes. Combine this with a command to run inside the container, followed by another command to exit.

**Important:** The `--rm` flag ensures the container stops and is cleaned up automatically after execution, preventing resource waste.

### Code/Config Blocks
```bash
podman run --rm ubuntu cat /etc/os-release
```

This command pulls the Ubuntu image if not present, runs the container, executes `cat /etc/os-release` to display OS information (e.g., version), and then automatically stops and removes the container.

**Example Output:**
```
PRETTY_NAME="Ubuntu 22.04.3 LTS"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
```

> [!NOTE]
> If the image isn't cached locally, Podman will pull it from the registry first.

## Running Containers Interactively

### Overview
Interactive running allows you to enter the container's shell directly, enabling hands-on exploration and execution of multiple commands inside the container environment.

### Key Concepts/Deep Dive
Use the `-it` flags to create an interactive terminal session. This attaches a pseudo-TTY and keeps stdin open, allowing you to work inside the container as if on a host machine.

You can then install packages or run any supported commands. Exit by pressing Ctrl+D.

### Code/Config Blocks
```bash
podman run -it --name my-ubuntu ubuntu /bin/bash
```

Inside the container:
```bash
ps aux  # Might require installing procps package
cat /etc/os-release
```

To install packages for fuller functionality:
```bash
apt update && apt install -y procps
```

### Lab Demos
1. Start an interactive Ubuntu container.
2. Check running processes with `ps aux` (install `procps` if needed).
3. View OS details with `cat /etc/os-release`.
4. Exit using Ctrl+D.

> [!TIP]
> Use `--rm` with `-it` to clean up the container after exiting: `podman run -it --rm ubuntu /bin/bash`.

## Installing Packages Inside Containers

### Overview
Containers often have minimal packages installed. Install additional packages interactively or via commands to extend functionality, such as monitoring tools.

### Key Concepts/Deep Dive
Package installation varies by OS. For Ubuntu/Debian-based containers, use `apt`. This allows running advanced commands like process inspection.

Ensure packages are installed within the interactive session for immediate use.

### Code/Config Blocks
Inside a running container:
```bash
apt update && apt install -y procps
```

## Listing Containers and Logs

### Overview
List running and stopped containers to monitor active instances. View logs to inspect container activities, which persist for a limited time.

### Key Concepts/Deep Dive
- `podman ps` lists running containers.
- `podman ps -a` includes stopped ones.
- `podman logs <container_name_or_id>` shows logged output.

### Code/Config Blocks
```bash
podman logs my-ubuntu
```

## Running Containers in Background

### Overview
Run containers in the background (detached mode) using `-d` flag, allowing host machine access while keeping the container running.

### Key Concepts/Deep Dive
Use `-d` to detach. Note that private registry images may require login via `podman login`. Use public images or search first.

### Code/Config Blocks
```bash
podman search ubuntu
podman run -d --name ubuntu-bg ubuntu
podman ps
```

> [!NOTE]
> For private registries, run `podman login <registry>` first.

## Starting Stopped Containers

### Overview
Start previously run containers by name or ID, useful for resuming work without recreation.

### Key Concepts/Deep Dive
- Use `podman start <name>` to restart.
- Check image IDs with `podman images`.
- Attach interactively with `podman start -ia <name>`.

### Code/Config Blocks
```bash
podman start my-ubuntu
podman start -ia my-ubuntu  # Interactive attach
```

## Inspecting Container Images

### Overview
Inspect images to extract metadata like OS version, layers, or configurations without running them.

### Key Concepts/Deep Dive
- Use `podman inspect` for full JSON details.
- Filter specific data with `--format` and JSON path syntax.

### Code/Config Blocks
Full inspection:
```bash
podman inspect ubuntu
```

Filtered output (e.g., history):
```bash
podman inspect --format '{{.RootFS.Layers}}' ubuntu
```

> [!TIP]
> JSON path uses Go template syntax for precise extraction.

## Mounting Local Directories

### Overview
Mount host directories to containers for data sharing and persistence, allowing edits in host to reflect in container.

### Key Concepts/Deep Dive
Use `-v` flag: `host_path:container_path`. This creates a bind mount for file synchronization.

### Code/Config Blocks
```bash
echo "Testing login to this post" > /tmp/test-log.txt
podman run -it --rm -v /tmp:/var/log ubuntu bash
# Inside container: cat /var/log/test-log.txt
```

From host:
```bash
journalctl -u podman  # Check host logs
```

## Mounting File Systems

### Overview
Mount entire container file systems locally to inspect internals, useful for debugging or analysis.

### Key Concepts/Deep Dive
Use `podman mount` for overlay file systems, exposing the container's root filesystem.

### Code/Config Blocks
```bash
podman run -d --name alpine-test alpine sleep 3600
MOUNT_POINT=$(podman mount alpine-test)
echo $MOUNT_POINT  # e.g., /var/lib/containers/storage/overlay/...
ls $MOUNT_POINT
cat $MOUNT_POINT/etc/os-release
podman umount alpine-test
```

## Summary

### Key Takeaways
```diff
+ Temporary containers clean up automatically with --rm flag
+ Interactive mode (-it) allows shell access for direct commands
+ Background mode (-d) runs containers detached
+ Mounting (-v) shares host data with containers
+ Inspect tool provides detailed image metadata
- Containers stop without active processes unless specified
! Install packages interactively for extended functionality
```

### Quick Reference
- Run temporary command: `podman run --rm <image> <command>`
- Start interactively: `podman run -it --name <name> <image> <shell>`
- List containers: `podman ps -a`
- Start stopped: `podman start <name>`
- Inspect image: `podman inspect <image>`
- Mount directory: `podman run -v /host/path:/container/path <image>`
- Mount filesystem: `podman mount <container>`

### Expert Insight

**Real-world Application**: In production, use Podman for secure container management in enterprise environments, mounting config volumes for persistent apps and running background services.

**Expert Path**: Master Podman registries by exploring UBI (Universal Base Images) variations and practicing with `--network` flags for service isolation.

**Common Pitfalls**: Avoid running privileged containers without necessity; always use specific image tags for reproducibility; monitor resource usage with `podman stats` to prevent host overload.

</details>
