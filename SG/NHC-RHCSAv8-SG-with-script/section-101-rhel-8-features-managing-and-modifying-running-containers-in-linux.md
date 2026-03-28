# Section 101: Managing and Modifying Running Containers

<details open>
<summary><b>Section 101: Managing and Modifying Running Containers (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Mounting Host Directory to Container](#mounting-host-directory-to-container)
- [Mounting Container Filesystem to Host](#mounting-container-filesystem-to-host)
- [Starting Services with Static IP in Containers](#starting-services-with-static-ip-in-containers)
- [Executing Commands Inside Containers](#executing-commands-inside-containers)
- [Sharing Files Between Containers](#sharing-files-between-containers)
- [Exporting Containers](#exporting-containers)
- [Importing Containers](#importing-containers)
- [Stopping Containers](#stopping-containers)
- [Removing Containers and Images](#removing-containers-and-images)
- [Summary](#summary)

## Mounting Host Directory to Container

### Overview
Mount a host machine directory permanently to a container to ensure logs and files created in the container persist on the host system after container stops. This enables log persistence and bidirectional data sharing between host and container.

### Key Concepts

Container logs and files are ephemeral by default. Volume mounting maps host directories to container paths for data persistence across container lifecycles.

### Deep Dive

When containers run, their filesystems are isolated. The `-v` flag creates bidirectional mounts where changes in either filesystem appear in both locations. This is essential for:
- Application logging to host-accessible locations
- Configuration sharing between host and container
- Data persistence beyond container lifetime

### Implementation Steps

1. **Verify podman installation**:
   ```bash
   podman --version
   ```

2. **Search for container images**:
   ```bash
   podman search ubi8  # Search Red Hat UBI8 images in default registries
   ```
   For specific registries: `podman search --registry <registry-name> image`

3. **Pull the required image**:
   ```bash
   podman pull registry.example.com/ubi8:latest
   ```

4. **Run container with volume mount**:
   ```bash
   podman run --rm --name test-container -v /var/log/container_logs:/var/log -ti registry.example.com/ubi8:latest /bin/bash -c "echo 'Testing log entry from container' >> /var/log/testing.logs && tail -f /var/log/testing.logs"
   ```

### Code Blocks

**Basic volume mount syntax**:
```bash
podman run -v <host_path>:<container_path> <image>
```

**Complete example with named container**:
```bash
podman run --rm --name logging-container -v /opt/host/logs:/app/logs registry.example.com/app:latest
```

### Lab Demo

1. Create host directory: `mkdir -p /tmp/host-logs`
2. Run container with mount: `podman run --rm -v /tmp/host-logs:/var/log/app -ti registry.example.com/ubi8:latest bash`
3. Inside container: `echo "Container log entry" >> /var/log/app/container.log`
4. Exit container: `exit`
5. Verify on host: `cat /tmp/host-logs/container.log`

### Verification

```bash
podman ps                           # Check running containers (empty due to --rm)
podman images                      # Verify downloaded images
journalctl -u podman              # View podman service logs
ls -la /var/log/container_logs/    # Confirm logs persisted on host
```

## Mounting Container Filesystem to Host

### Overview
Access and expose the entire container filesystem to the host machine while the container runs, enabling inspection, debugging, and file extraction from running containers.

### Key Concepts

Running containers have isolated filesystems. Podman's mount capability exposes container internals to host filesystem for inspection without affecting container operations.

### Deep Dive

Container filesystems exist in overlay storage. The `podman mount` command returns a directory path where the container's merged filesystem is accessible, allowing:
- Configuration inspection
- Log extraction
- Application debugging
- File system analysis

### Implementation Steps

1. **Start container in background**:
   ```bash
   podman run -d --name mysql-service registry.example.com/mysql:latest
   ```

2. **Verify container is running**:
   ```bash
   podman ps
   ```

3. **Mount container filesystem**:
   ```bash
   podman mount <container_id_or_name>
   ```
   Returns path like: `/var/lib/containers/storage/overlay/.../merged`

4. **Navigate mounted filesystem**:
   ```bash
   cd /var/lib/containers/storage/overlay/.../merged
   ls -la              # Browse container directory structure
   cat etc/passwd      # Check user configuration
   tail var/log/mysql/error.log  # Examine database logs
   ```

5. **Unmount when finished**:
   ```bash
   podman unmount <container_id_or_name>
   ```

### Code Blocks

**Mount inspection workflow**:
```bash
# Start container
podman run -d --name web-app registry.example.com/nginx:latest

# Get mount point
MOUNT_POINT=$(podman mount web-app)

# Explore filesystem
cd $MOUNT_POINT
find . -name "*.conf" -type f  # Find configuration files
grep "error" var/log/nginx/error.log  # Search for errors

# Cleanup
cd /
podman unmount web-app
```

### Lab Demo

1. Start database container: `podman run -d --name app-db registry.example.com/postgresql:latest`
2. Mount filesystem: `MOUNT_PATH=$(podman mount app-db)`
3. Inspect configuration: `cd $MOUNT_PATH && cat etc/postgresql/postgresql.conf | head -20`
4. Check data directory: `ls -la var/lib/postgresql/data/`
5. Unmount: `podman unmount app-db`

### Use Cases
- **Database Recovery**: Access PostgreSQL data files during corruption
- **Application Debugging**: Extract JVM heap dumps from running Java containers
- **Configuration Auditing**: Verify running container configurations against standards
- **Log Analysis**: Extract historical logs from rolling file systems

> [!WARNING]
> Modifying files through the mounted filesystem can corrupt containers. Use read-only access for debugging.

> [!NOTE]
> Mounted filesystems remain accessible until explicitly unmounted or container stops.

## Starting Services with Static IP in Containers

### Overview
Assign fixed IP addresses to containers during startup to ensure consistent networking for services requiring static addressing (databases, load balancers, APIs).

### Key Concepts

Podman containers receive dynamic IP addresses by default. The `--ip` flag assigns static IPs for predictable network connectivity in production environments.

### Deep Dive

Static IP assignment requires proper network configuration. Podman networks must support static IP allocation ranges configured at the network level.

### Implementation Steps

1. **Run container with static IP**:
   ```bash
   podman run -d --name static-ip-service --ip 192.168.122.100 registry.example.com/httpd:latest
   ```

2. **Inspect network configuration**:
   ```bash
   podman inspect static-ip-service | grep -A 10 "NetworkSettings"
   ```

### Code Blocks

**Complete static IP container startup**:
```bash
podman run \
  --detach \
  --name web-server \
  --ip 10.0.0.50 \
  registry.example.com/nginx:latest
```

**Network configuration verification**:
```bash
# Check container IP assignment
podman inspect web-server --format '{{.NetworkSettings.IPAddress}}'

# Test connectivity
curl http://10.0.0.50
```

### Lab Demo

1. Create custom network: `podman network create --subnet 10.0.0.0/24 static-net`
2. Run container with static IP: `podman run -d --name db-server --net static-net --ip 10.0.0.10 registry.example.com/mysql:latest`
3. Run application container: `podman run -d --name app-server --net static-net --ip 10.0.0.20 -e DB_HOST=10.0.0.10 registry.example.com/app:latest`
4. Verify connectivity: `podman exec app-server ping -c 3 10.0.0.10`

### Use Cases
- **Database Clustering**: Consistent IP addresses for replication
- **Load Balancer Configuration**: Static backend server IPs
- **API Gateway Setup**: Predictable service endpoints
- **Legacy Application Migration**: IP-based authentication systems

> [!IMPORTANT]
> Static IP assignment depends on podman network configuration supporting IP address ranges.

## Executing Commands Inside Containers

### Overview
Run scripts and commands inside running containers for administration, debugging, and operational tasks without full container shell access.

### Key Concepts

Two execution modes:
- **Non-interactive**: Execute and return output (automation scripts)
- **Interactive**: Access container shell (manual operations)

### Deep Dive

Container execution uses `podman exec` with process isolation. Commands run with container privileges and environment variables.

### Implementation

**Non-Interactive Execution:**

```bash
podman exec -ti <container_name> <command> <arguments>
```

**Examples:**

```bash
# System information
podman exec -ti web-server uname -a

# Process listing
podman exec -ti database ps aux

# Network diagnostics
podman exec -ti mysql-server netstat -tuln

# Log monitoring
podman exec -ti app-server tail -f /var/log/application.log
```

**Interactive Container Access:**

```bash
# Enter container shell
podman exec -ti web-server /bin/bash

# Edit configuration
vi /etc/nginx/nginx.conf

# Package management
yum update -y

# Service restart
systemctl restart httpd
```

### Code Blocks

**Database maintenance**:
```bash
# MySQL backup
podman exec mysql-db mysqldump --all-databases > backup.sql

# PostgreSQL vacuum
podman exec postgres-db vacuumdb --analyze

# Redis statistics
podman exec redis-server redis-cli info
```

**Web server management**:
```bash
# Nginx configuration reload
podman exec web-nginx nginx -s reload

# Apache graceful restart
podman exec web-apache httpd -k graceful

# SSL certificate check
podman exec web-server openssl x509 -in /etc/ssl/certs/cert.pem -text -noout
```

### Lab Demo

1. Start application container: `podman run -d --name demo-app registry.example.com/python-app:latest`
2. Check running processes: `podman exec demo-app ps aux`
3. View application logs: `podman exec demo-app cat /app/logs/app.log`
4. Enter container shell: `podman exec -ti demo-app bash`
5. Inside container: `python manage.py migrate` then `exit`

### Use Cases
- **Automated Backups**: Scheduled database dumps
- **Health Checks**: Application status verification
- **Log Rotation**: Log file management and compression
- **Configuration Updates**: Dynamic configuration reloading
- **Troubleshooting**: Command-line debugging tools

> [!NOTE]
> Use `--detach` with exec for background command execution: `podman exec -d container command`

## Sharing Files Between Containers

### Overview
Create persistent shared volumes for bidirectional file exchange between multiple containers using named volumes for data persistence and synchronization.

### Key Concepts

Named volumes provide shared storage mounted simultaneously to multiple containers, enabling seamless data exchange and collaborative container operations.

### Deep Dive

Volumes exist outside container lifecycles, mounted to `/var/lib/containers/volumes/`. Changes in one container immediately appear in others sharing the same volume.

### Implementation Steps

1. **Create named volume**:
   ```bash
   podman volume create shared-data
   ```

2. **Inspect volume details**:
   ```bash
   podman volume inspect shared-data
   ```

3. **Mount volume to first container**:
   ```bash
   podman run -d --name container-1 -v shared-data:/data registry.example.com/ubi8:latest
   ```

4. **Mount same volume to second container**:
   ```bash
   podman run -d --name container-2 -v shared-data:/data registry.example.com/ubi8:latest
   ```

5. **Verify file sharing**:
   ```bash
   # Create file in container-1
   podman exec -ti container-1 bash -c 'echo "Hello from container 1" > /data/shared-file.txt'

   # Read file in container-2
   podman exec -ti container-2 cat /data/shared-file.txt

   # Append from container-2
   podman exec -ti container-2 bash -c 'echo "Hello from container 2" >> /data/shared-file.txt'
   ```

6. **Access from host**:
   ```bash
   VOLUME_PATH=$(podman volume inspect shared-data --format '{{.Mountpoint}}')
   cat $VOLUME_PATH/shared-file.txt
   ```

### Code Blocks

**Volume management commands**:
```bash
# List volumes
podman volume ls

# Remove specific volume
podman volume rm shared-data

# Remove unused volumes
podman volume prune

# Create volume with labels
podman volume create --label environment=production app-data
```

**Multi-container sharing example**:
```bash
# Create shared volume for microservices
podman volume create microservice-config

# Run configuration service
podman run -d --name config-service -v microservice-config:/config registry.example.com/config-service:latest

# Run application services
podman run -d --name auth-service -v microservice-config:/config registry.example.com/auth-service:latest
podman run -d --name api-service -v microservice-config:/config registry.example.com/api-service:latest
```

### Lab Demo

1. Create shared volume: `podman volume create demo-shared`
2. Start producer container: `podman run -d --name producer -v demo-shared:/shared registry.example.com/ubi8:latest sleep infinity`
3. Start consumer container: `podman run -d --name consumer -v demo-shared:/shared registry.example.com/ubi8:latest sleep infinity`
4. Create data in producer: `podman exec producer bash -c 'echo "Data created at $(date)" > /shared/data.txt'`
5. Verify in consumer: `podman exec consumer cat /shared/data.txt`
6. Modify from consumer: `podman exec consumer bash -c 'echo "Modified at $(date)" >> /shared/data.txt'`
7. Check final result: `podman exec producer cat /shared/data.txt`

### Use Cases
- **Configuration Management**: Shared configuration files across services
- **Session Storage**: User session data persistence between web servers
- **Cache Sharing**: Shared cache directories for improved performance
- **Log Aggregation**: Centralized logging from multiple application containers
- **Database Persistence**: Shared database files (with proper locking)

### Tables

**Volume Types Comparison:**

| Volume Type | Persistence | Sharing | Performance | Use Case |
|-------------|-------------|---------|-------------|----------|
| Named Volume | Yes | Yes | High | Multi-container data sharing |
| Host Directory | Yes | Yes | Very High | Host-container file exchange |
| Anonymous Volume | Yes | No | High | Single container data persistence |
| tmpfs | No | No | Very High | Temporary sensitive data |

## Exporting Containers

### Overview
Save complete container state and filesystem to portable archive format for backup, migration, and container state preservation.

### Key Concepts

Container export creates compressed tar archives containing entire filesystem, allowing exact container recreation on different systems or environments.

### Deep Dive

Export captures container filesystem at specific point, including all installed packages, configurations, and data. Archive serves as complete container backup.

### Implementation Steps

1. **Start source container**:
   ```bash
   podman run -d --name export-test registry.example.com/web-app:latest
   ```

2. **Create test data inside container**:
   ```bash
   podman exec -ti export-test bash -c 'echo "Test data for export" > /opt/app/test-file.txt'
   ```

3. **Stop container**:
   ```bash
   podman stop export-test
   ```

4. **Export container to archive**:
   ```bash
   podman export -o web-app-export.tar export-test
   ```

5. **Verify export**:
   ```bash
   ls -lh web-app-export.tar                    # Check file size
   tar -tvf web-app-export.tar \| head -10       # Preview archive contents
   tar -tzf web-app-export.tar \| grep test-file # Find specific files
   ```

### Code Blocks

**Export options**:
```bash
# Export with compression
podman export export-test \| gzip > web-app.gz

# Export to specific path
podman export -o /backups/containers/web-app-$(date +%Y%m%d).tar export-test

# Export with progress indication
podman export --quiet -o backup.tar container-name
```

**Automated backup workflow**:
```bash
#!/bin/bash
CONTAINER_NAME="web-app"
BACKUP_DIR="/opt/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Stop container for consistent backup
podman stop $CONTAINER_NAME

# Export container
podman export -o $BACKUP_DIR/$CONTAINER_NAME-$TIMESTAMP.tar $CONTAINER_NAME

# Restart container
podman start $CONTAINER_NAME

# Compress backup
gzip $BACKUP_DIR/$CONTAINER_NAME-$TIMESTAMP.tar

echo "Backup completed: $BACKUP_DIR/$CONTAINER_NAME-$TIMESTAMP.tar.gz"
```

### Lab Demo

1. Start test container: `podman run -d --name demo-app registry.example.com/fedora:latest sleep infinity`
2. Add content: `podman exec demo-app bash -c 'mkdir /app && echo "Application data" > /app/data.txt && yum install -y vim'`
3. Stop container: `podman stop demo-app`
4. Export: `podman export -o demo-app-backup.tar demo-app`
5. Extract and verify: `tar -tvf demo-app-backup.tar | grep app/data.txt`

## Importing Containers

### Overview
Reconstruct containers from exported archives to restore previous states or deploy containerized applications with preserved configurations and data.

### Key Concepts

Import recreates containers from tar archives, converting archived filesystems into runnable containers while maintaining exact original state.

### Deep Dive

Import process creates new container image from archive, preserving all filesystem contents, configurations, and installed software for exact replication.

### Implementation Steps

1. **Import container archive**:
   ```bash
   podman import web-app-export.tar my-imported-app
   ```

2. **Verify import**:
   ```bash
   podman images  # Check for my-imported-app image
   ```

3. **Start imported container**:
   ```bash
   podman run -d --name restored-app my-imported-app
   ```

4. **Verify restoration**:
   ```bash
   podman exec -ti restored-app cat /opt/app/test-file.txt
   ```

### Code Blocks

**Complete restore workflow**:
```bash
# Import container
podman import backup.tar restored-web-app

# Run with original configuration
podman run -d --name restored-web-app \
  -p 8080:80 \
  restored-web-app

# Verify functionality
curl http://localhost:8080
```

**Migration between systems**:
```bash
# On source system
podman stop source-app
podman export -o app-backup.tar source-app

# Transfer file to destination
scp app-backup.tar user@dest-host:/tmp/

# On destination system
podman import /tmp/app-backup.tar migrated-app
podman run -d --name migrated-app migrated-app
```

### Lab Demo

1. After export demo, import archive: `podman import demo-app-backup.tar restored-demo-app`
2. Verify image: `podman images | grep restored-demo-app`
3. Run imported container: `podman run -d --name restored-demo-app restored-demo-app sleep infinity`
4. Check restored content: `podman exec restored-demo-app cat /app/data.txt`
5. Verify installed packages: `podman exec restored-demo-app rpm -qa | grep vim`

### Use Cases
- **Disaster Recovery**: Restore services from backups
- **Environment Promotion**: Move tested containers to production
- **Container Migration**: Transfer containers between clusters or clouds
- **Service Archival**: Preserve exact service state for compliance

### Tables

**Export vs Image Operations Comparison:**

| Operation | Export | Commit to Image |
|-----------|---------|------------------|
| Preserves exact filesystem | ✓ | ✓ |
| Includes configuration changes | ✓ | ✓ |
| Includes running state changes | ❌ | ✓ |
| Creates portable archive | ✓ | ❌ |
| Can recreate exact container | ✓ | ✓ |
| Includes container metadata | ❌ | ✓ |
| Suitable for backup | ✓ | ⚠️ |

## Stopping Containers

### Overview
Terminate running containers gracefully to free system resources and ensure clean shutdown without data loss or corruption.

### Key Concepts

Container stopping sends SIGTERM signal first, allowing applications to shutdown cleanly, then SIGKILL if necessary. Always prefer graceful stops over forceful termination.

### Deep Dive

Podman stopping process:
1. Send SIGTERM signal
2. Wait for grace period (default 10s)
3. If still running, send SIGKILL
4. Remove from running container list

### Implementation

**Stop single container**:
```bash
podman stop web-server              # By name
podman stop abc123def456            # By ID (first 12 chars)
podman kill web-server              # Force immediate stop
```

**Stop multiple containers**:
```bash
podman stop -a                      # Stop all running containers
podman stop $(podman ps -q)          # Stop all with IDs
podman stop $(podman ps -q --filter name=web-*)  # Pattern matching
```

**Stop with timeout**:
```bash
podman stop --timeout 30 web-server  # 30 second grace period
```

### Code Blocks

**Graceful application shutdown**:
```bash
# Stop database (allows transaction commit)
podman stop --timeout 60 my-database

# Stop web server (allows connection draining)
podman stop --timeout 30 nginx-server

# Emergency stop (use only when necessary)
podman kill -s KILL problematic-container
```

**Automated cleanup script**:
```bash
#!/bin/bash
# Stop all containers except critical ones
for container in $(podman ps --format "{{.Names}}"); do
  case $container in
    critical-app|monitoring)
      echo "Skipping critical container: $container"
      ;;
    *)
      echo "Stopping container: $container"
      podman stop $container
      ;;
  esac
done
```

### Lab Demo

1. Start multiple containers: `podman run -d registry.example.com/app1 && podman run -d registry.example.com/app2`
2. Check running: `podman ps`
3. Stop one by name: `podman stop <container-name>`
4. Stop all remaining: `podman stop -a`
5. Verify stopped: `podman ps -a`

### Use Cases
- **Maintenance Windows**: Controlled service shutdown
- **Resource Reclamation**: Free system resources
- **Application Updates**: Clean shutdown before redeployment
- **Emergency Response**: Immediate service termination
- **Scheduled Shutdowns**: Batch operations during off-hours

> [!WARNING]
> Avoid `podman kill` unless `podman stop` fails, as it may cause data corruption or incomplete transactions.

### Tables

**Stop Methods Comparison:**

| Method | Signal | Graceful | Use Case |
|--------|--------|----------|----------|
| stop | SIGTERM → SIGKILL | ✓ | Normal shutdown |
| stop --timeout N | SIGTERM → SIGKILL | ✓ | Custom grace period |
| kill | SIGKILL | ❌ | Emergency termination |
| kill -s TERM | SIGTERM | ✓ | Graceful kill |
| kill -s KILL | SIGKILL | ❌ | Force termination |

## Removing Containers and Images

### Overview
Clean container infrastructure by removing stopped containers, unused images, and temporary resources to reclaim disk space and optimize system performance.

### Key Concepts

Container ecosystem cleanup requires specific sequencing: stop containers first, then remove them, followed by unused images and volumes.

### Deep Dive

Removal prerequisites:
- **Containers**: Must be stopped before removal
- **Images**: Must have no dependent containers
- **Volumes**: Can be removed independently unless in use

### Implementation

**Container Removal**:
```bash
# Remove stopped container
podman rm web-server                # By name
podman rm abc123def456              # By ID
podman rm -f running-app            # Force remove running container
podman rm $(podman ps -aq --filter status=exited)  # Remove all stopped
```

**Image Removal**:
```bash
# List images
podman images

# Remove specific image
podman rmi registry.example.com/web-app:latest

# Remove unused images
podman image prune -a

# Force remove (ignore dependencies)
podman rmi -f registry.example.com/old-app:latest
```

**System-wide Cleanup**:
```bash
# Clean up everything unused
podman system prune -a

# Remove specific resources
podman volume prune                 # Remove unused volumes
podman network prune               # Remove unused networks
podman container prune            # Remove stopped containers
```

### Code Blocks

**Comprehensive cleanup script**:
```bash
#!/bin/bash
echo "=== Podman System Cleanup ==="

# Stop all running containers
echo "Stopping running containers..."
podman stop -a

# Remove stopped containers
echo "Removing stopped containers..."
podman container prune -f

# Remove unused images
echo "Removing unused images..."
podman image prune -a -f

# Remove unused volumes
echo "Removing unused volumes..."
podman volume prune -f

# Remove unused networks
echo "Removing unused networks..."
podman network prune -f

# Show cleanup results
echo "=== Cleanup Complete ==="
echo "Remaining resources:"
podman ps -a --format "table {{.Names}}\t{{.Status}}"
echo ""
podman images
echo ""
podman volume ls
```

**Selective cleanup by age**:
```bash
# Remove containers stopped more than 24 hours ago
podman rm $(podman ps -a --filter status=exited --filter "exited>86400" -q)

# Remove images created more than 7 days ago
podman rmi $(podman images --filter "dangling=false" --filter "created>7d" -q)
```

### Lab Demo

1. Verify initial state: `podman ps -a && podman images && podman volume ls`
2. Create test resources: `podman run -d --name temp-container registry.example.com/fedora echo "test"`
3. Wait for completion: `sleep 5`
4. Remove stopped container: `podman rm $(podman ps -aq --filter status=exited)`
5. Remove unused images: `podman image prune -f`
6. Check final state: `podman ps -a && podman images`

### Use Cases
- **Disk Space Management**: Reclaim storage from unused containers
- **Security**: Remove containers with vulnerabilities
- **Environment Cleanup**: Remove test/development artifacts
- **Resource Optimization**: Improve host system performance
- **Cost Control**: Reduce storage costs in cloud environments

> [!CAUTION]
> `podman system prune -a` removes all unused containers, images, and volumes. Test in staging first.

### Tables

**Removal Command Matrix:**

| Resource Type | Stop Required | Remove Command | Prune Command | Force Option |
|---------------|---------------|----------------|---------------|--------------|
| Containers | ✓ | podman rm | podman container prune | -f |
| Images | ✓ (containers) | podman rmi | podman image prune | -f |
| Volumes | ❌ | podman volume rm | podman volume prune | -f |
| Networks | ❌ | podman network rm | podman network prune | -f |

## Summary

### Key Takeaways
```diff
+ Container lifecycle management: run → monitor → stop → remove
+ Volume mounting enables persistent data sharing between host and containers
+ Container export/import provides reliable state backup and restoration
+ Static IP assignment ensures predictable service networking
+ Command execution within containers supports debugging and maintenance
+ Shared volumes facilitate inter-container data exchange
! Always prefer graceful stops over forceful killing
! Export containers when precise state preservation is required
! Clean up unused resources regularly to maintain system performance
- Never modify container filesystems through mounted volumes
- Avoid force-removing images with active dependencies
```

### Quick Reference

**Essential Podman Container Commands:**

| Operation | Command | Description |
|-----------|---------|-------------|
| Run container | `podman run -d --name app image` | Start in background |
| Mount volumes | `podman run -v /host:/container image` | Share directories |
| Execute commands | `podman exec -ti container command` | Run inside container |
| Stop containers | `podman stop container-name` | Graceful shutdown |
| Remove containers | `podman rm container-name` | Delete stopped containers |
| Export containers | `podman export -o file.tar container` | Save container state |
| Import containers | `podman import file.tar image-name` | Restore from archive |
| System cleanup | `podman system prune -a` | Remove unused resources |

**Container Volume Mounting Examples:**

```bash
# Host directory to container
podman run -v /opt/host/logs:/app/logs registry.example.com/app:latest

# Named volume creation and sharing
podman volume create shared-config
podman run -v shared-config:/etc/app registry.example.com/app:latest

# Static IP assignment
podman run --ip 192.168.1.100 --name fixed-ip registry.example.com/service:latest
```

**Container Export/Import Workflow:**

```bash
# Export running container
podman stop web-app
podman export -o web-app-backup.tar web-app
podman start web-app

# Import on different system
podman import web-app-backup.tar restored-web-app
podman run -d --name restored-web-app restored-web-app
```

### Expert Insight

**Real-world Application:**
Production container management involves:
- **Automated lifecycle management** using orchestration platforms (Kubernetes, OpenShift)
- **Volume management strategies** for persistent state across node failures
- **Backup and disaster recovery** procedures using export/import cycles
- **Network security** through proper IP management and firewall rules
- **Resource monitoring** to prevent container sprawl and resource exhaustion

**Expert Path:**
- Master container orchestration with Kubernetes/OpenShift
- Implement container security scanning and policy enforcement
- Develop automated backup and recovery procedures
- Understand advanced networking (CNI plugins, service mesh)
- Learn container performance tuning and optimization
- Practice infrastructure-as-code with container definitions

**Common Pitfalls:**
- **Resource exhaustion** from forgotten stopped containers
- **Data loss** from improper volume management
- **Security vulnerabilities** in exported container images
- **Network conflicts** from improper static IP assignment
- **Performance degradation** from excessive container layers
- **Backup corruption** from exporting running containers without stopping

**Corrections noted in transcript:**
- The instructor explains podman consistently throughout the session, not Docker despite brief initial confusion
- All commands use podman syntax correctly
- Container concepts are explained accurately with proper terminology

</details>
