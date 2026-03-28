# Section 101: Managing and Modifying Running Containers in Linux

<details open>
<summary><b>Section 101: Managing and Modifying Running Containers in Linux (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Mounting Host Directories to Containers](#mounting-host-directories-to-containers)
- [Mounting Container Filesystem to Host Machine](#mounting-container-filesystem-to-host-machine)
- [Running Services with Static IP Addresses](#running-services-with-static-ip-addresses)
- [Executing Commands in Running Containers](#executing-commands-in-running-containers)
- [Sharing Files Between Containers Using Volumes](#sharing-files-between-containers-using-volumes)
- [Exporting and Importing Containers](#exporting-and-importing-containers)
- [Stopping and Removing Containers](#stopping-and-removing-containers)
- [Summary](#summary)

## Mounting Host Directories to Containers

### Overview
Learn how to mount host machine directories to running containers for persistent storage, such as logging application output that can be accessed from the host.

### Key Concepts
Containers are ephemeral by default, meaning any data written inside them is lost when the container stops. To persist data like logs, mount host directories into the container.

### Practical Demo
1. First, ensure Podman is installed:
   ```bash
   sudo dnf install podman
   ```

2. Pull an image (e.g., UBI8 image):
   ```bash
   podman search ubi8
   podman pull registry.redhat.io/ubi8/ubi8:latest
   ```

3. Run container with volume mount:
   ```bash
   podman run --name test-container -v /host/logs:/var/log/app --rm -it registry.redhat.io/ubi8/ubi8:latest bash -c "echo 'Testing logs' >> /var/log/app/testing.log"
   ```

   - \`-v /host/logs:/var/log/app\`: Mounts host directory \`/host/logs\` to container path \`/var/log/app\`
   - Container runs, writes to the log file, and exits due to \`--rm\` flag

4. Verify on host:
   ```bash
   cat /host/logs/testing.log
   ```
   Output: \`Testing logs\`

### Important Notes
- Use absolute paths for host directories
- Ensure host directory exists and has appropriate permissions
- The container can read/write to the mounted directory

## Mounting Container Filesystem to Host Machine

### Overview
Access and inspect the filesystem of a running container directly from the host machine using Podman's mount functionality.

### Key Concepts
Sometimes you need to examine container contents without stopping it. Podman's mount command exposes the container's filesystem for inspection and debugging.

### Practical Demo
1. Start a container in background:
   ```bash
   podman run -d --name my-service registry.redhat.io/rhel8/rsyslog:latest
   ```

2. Mount the container filesystem:
   ```bash
   podman mount my-service
   ```
   Output: \`/var/lib/containers/storage/overlay/.../merged\` (mount point)

3. Access the filesystem on host:
   ```bash
   cd /var/lib/containers/storage/overlay/.../merged
   ls -la
   cat /etc/os-release
   ```

4. Unmount when done:
   ```bash
   podman unmount my-service
   ```

### Security Considerations
- Mounted containers are read-write accessible from host
- Use for debugging and inspection only
- Unmount after use to maintain container isolation

> [!WARNING]
> Mounting exposes container internals. Use cautiously in production environments.

## Running Services with Static IP Addresses

### Overview
Start containers with specific static IP addresses for networking requirements and service accessibility.

### Key Concepts
Podman supports assigning static IP addresses to containers using the \`--ip\` flag, which assigns the IP to the container's network interface.

### Practical Demo
1. Start container with static IP:
   ```bash
   podman run -d --name my-static-service --ip 192.168.122.100 registry.redhat.io/ubi8/httpd-24:latest
   ```

2. Verify IP assignment:
   ```bash
   podman inspect my-static-service | grep -A 5 "NetworkSettings"
   ```

3. Test connectivity:
   ```bash
   curl http://192.168.122.100
   ```

### Network Requirements
- IP must be available on the host network
- Use appropriate subnet for your network configuration
- Consider using Podman networks for more complex setups

## Executing Commands in Running Containers

### Overview
Run ad-hoc commands inside running containers without stopping them, useful for debugging and maintenance.

### Key Concepts
Two primary methods for command execution:
1. Non-interactive (runs command and returns output)
2. Interactive (starts shell session in container)

### Command Execution Methods

#### Method 1: Non-Interactive Execution
```bash
podman exec my-container ls -la /var/log
```

#### Method 2: Interactive Shell Access
```bash
podman exec -it my-container /bin/bash
# Or for sh:
podman exec -it my-container /bin/sh
```

### Practical Examples
1. Check system information:
   ```bash
   podman exec my-container uname -a
   podman exec my-container cat /etc/os-release
   ```

2. View logs within container:
   ```bash
   podman exec my-container tail -f /var/log/application.log
   ```

### Best Practices
- Use non-interactive for quick checks and scripted operations
- Interactive shells are essential for debugging tasks
- Always check container status before exec: \`podman ps\`

> [!NOTE]
> Use Ctrl+P, Ctrl+Q to detach from interactive session without stopping container.

## Sharing Files Between Containers Using Volumes

### Overview
Use Podman volumes to share data between multiple containers persistently and securely.

### Key Concepts
Podman volumes provide managed storage that can be attached to multiple containers simultaneously, enabling data sharing and persistence.

### Volume Management
1. Create a named volume:
   ```bash
   podman volume create shared-data
   ```

2. Inspect volume location:
   ```bash
   podman volume inspect shared-data
   ```
   Output shows mount point (e.g., \`/var/lib/containers/storage/volumes/shared-data/_data\`)

3. Run containers with shared volume:
   ```bash
   podman run -d --name container1 -v shared-data:/app/data registry.redhat.io/ubi8/ubi8:latest sleep infinity
   podman run -d --name container2 -v shared-data:/app/data registry.redhat.io/ubi8/ubi8:latest sleep infinity
   ```

4. Access shared data from either container:
   ```bash
   podman exec -it container1 bash
   echo "Data from container 1" > /app/data/shared-file.txt
   exit
   podman exec -it container2 bash
   cat /app/data/shared-file.txt
   ```

### Volume Benefits
- Data persists across container restarts and recreation
- Can be shared between multiple containers simultaneously
- Managed by Podman (automatic cleanup and lifecycle management)
- Better performance than bind mounts for certain workloads

## Exporting and Importing Containers

### Overview
Save running containers to tar archives for backup, migration, or sharing between systems.

### Practical Demo

#### Exporting a Container
1. Start a container and add some data:
   ```bash
   podman run -d --name export-test registry.redhat.io/ubi8/ubi8:latest sleep infinity
   podman exec export-test bash -c "echo 'test data' > /tmp/test-file.txt"
   ```

2. Export to tar file:
   ```bash
   podman export export-test > exported-container.tar
   ```

#### Importing a Container
1. Import from tar file:
   ```bash
   podman import exported-container.tar imported-container:latest
   ```

2. Run the imported container:
   ```bash
   podman run -d --name my-imported imported-container:latest sleep infinity
   ```

3. Verify data persistence:
   ```bash
   podman exec my-imported cat /tmp/test-file.txt
   ```

### Use Cases
- Backup and restore containers
- Migrate containers between different systems
- Share complete containerized applications
- Create container templates for quick deployment

> [!TIP]
> Export creates a flattened image. Use \`podman save\`/\`podman load\` for layered images with history.

## Stopping and Removing Containers

### Overview
Properly manage container lifecycle by stopping running containers and cleaning up resources.

### Container Lifecycle Management

#### Stopping Individual Containers
```bash
podman stop container-name
# Or using container ID:
podman stop \$(podman ps -q)
```

#### Stopping All Containers
```bash
podman stop \$(podman ps -aq)
```

#### Removing Stopped Containers
```bash
podman rm container-name
podman rm \$(podman ps -aq)  # Remove all containers
```

#### Force Removal (if needed)
```bash
podman rm -f container-name
```

### Image Management
1. List all images:
   ```bash
   podman images
   ```

2. Remove individual images:
   ```bash
   podman rmi image-id
   ```

3. Remove all unused images:
   ```bash
   podman rmi \$(podman images -q)
   ```

### Important Sequence
Always follow this sequence: Stop containers → Remove containers → Remove images. Containers must be stopped before removal. Images can only be removed after all dependent containers are removed.

## Summary

### Key Takeaways
\`\`\`diff
+ Podman is the container tool used in RHEL 8 (not Docker)
+ Volume mounting enables persistent data storage and sharing
+ Static IP assignment provides predictable networking
+ Container filesystem mounting facilitates debugging
+ Proper cleanup prevents resource accumulation
- Always verify container status before operations
- Remember to unmount containers after inspection
\`\`\`

### Quick Reference

#### Essential Podman Commands
\`\`\`bash
# Volume operations
podman volume create shared-vol
podman volume inspect shared-vol
podman run -v shared-vol:/data my-image

# Mount/unmount container filesystem
podman mount container-name
podman unmount container-name

# Network operations
podman run --ip 192.168.1.100 my-service
podman inspect container-name

# Command execution
podman exec container-name command
podman exec -it container-name /bin/bash

# Export/Import operations
podman export container-name > exported.tar
podman import exported.tar imported-image

# Cleanup operations
podman stop container-name
podman rm container-name
podman rmi image-id
podman ps -aq | xargs podman rm -f  # Remove all
\`\`\`

### Expert Insight

#### Real-world Application
In production RHEL 8 environments, combine volume mounting with systemd services using \`podman generate systemd\` for automatic container management. Use named volumes for database storage and configuration files that need to persist across deployments.

#### Expert Path
Master advanced Podman features like pods for multi-container applications, custom networks with \`podman network create\`, and secret management. Learn to work with rootless containers and SELinux contexts.

#### Common Pitfalls
- Attempting to remove running containers without stopping them first
- Mounting host directories with incorrect permissions causing access issues
- Accumulating stopped containers by not using \`--rm\` flag appropriately
- Running privileged containers unnecessarily, creating security risks

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>

</details>
