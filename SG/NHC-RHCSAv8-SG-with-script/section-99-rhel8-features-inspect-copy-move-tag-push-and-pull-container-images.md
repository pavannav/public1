# Section 99: Inspecting, Copying, Moving, Tagging and Pushing Container Images 

<details open>
<summary><b>Section 99: Inspecting, Copying, Moving, Tagging and Pushing Container Images (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction](#introduction)
- [Checking Podman Configuration](#checking-podman-configuration)
- [Logging into a Registry](#logging-into-a-registry)
- [Searching for Images](#searching-for-images)
- [Pulling Images](#pulling-images)
- [Inspecting Images](#inspecting-images)
- [Copying Images Between Registries](#copying-images-between-registries)
- [Copying Images to a Local Directory](#copying-images-to-a-local-directory)
- [Tagging Images](#tagging-images)
- [Running Containers](#running-containers)
- [Saving Images to an Archive](#saving-images-to-an-archive)
- [Loading Images from an Archive](#loading-images-from-an-archive)
- [Pushing Images to a Registry](#pushing-images-to-a-registry)
- [Verifying Image Signatures](#verifying-image-signatures)
- [Removing Images](#removing-images)

## Introduction

This section covers essential operations for managing container images using Podman, including inspecting, copying, moving, tagging, and pushing images. These skills are crucial for working with containers in production environments and preparing for certification exams. We'll explore commands for handling images across registries and local systems.

## Checking Podman Configuration

<!-- Corrected from "apointment" to "podman" throughout the transcript -->

### Overview
Before working with images, check where images are stored and configured in your system.

### Key Concepts
- **Storage Location**: Depends on your user account (root vs. non-root).
- **Configuration**: Root user stores in `/var/lib/containers`, non-root in `~/.local/share/containers`.

### Commands
```bash
# Get detailed podman configuration info
podman info

# Check storage loiaction and registry details
podman info | grep -A 20 storage
```

> [!NOTE]
> The registry and storage paths vary based on privilege level and custom configurations.

## Logging into a Registry

### Overview
Logging into a registry allows you to push images or access private images.

### Key Concepts
- Authentication is required for private registries
- Supports credentials via username/password
- Token-based authentication for some registries

### Commands
```bash
# Login to registry.example.com
podman login registry.example.com
# Enter username and password when prompted
```

> [!WARNING]
> Never store credentials in plain text; use secure methods for private registries.

## Searching for Images

### Overview
Search public registries to find available images without manual browsing.

### Key Concepts
- Search works across configured registries
- Results show image name, tags, and descriptions

### Commands
```bash
# Search for httpd images
podman search httpd

# Include official images from Docker Hub
podman search --filter is-official=true nginx
```

## Pulling Images

### Overview
Download container images from a registry to your local system.

### Key Concepts
- Images are pulled by repository:tag
- Specify full registry URLs if needed

### Commands
```bash
# Pull nginx:latest from Docker Hub
podman pull nginx

# Pull from specific registry
podman pull httpd@sha256:xyz...

# List pulled images
podman images
```

> [!NOTE]
> Large images may take time to download depending on your internet connection.

## Inspecting Images

### Overview
Examine image metadata, layers, and configuration to understand contents.

### Key Concepts
- **Local Images**: Inspect stored images on your system
- **Remote Images**: Inspect without downloading
- Shows software versions, entrypoints, labels

### Commands
```bash
# Inspect local image
podman inspect nginx:latest

# Inspect remote image (without pulling)
podman inspect --remote docker.io/library/httpd:latest

# Get image history
podman history nginx
```

> [!TIP]
> Inspection helps verify image contents before deployment.

## Copying Images Between Registries

### Overview
Transfer images from one registry to another, useful for migrating between environments.

### Key Concepts
- Requires authentication to both registries
- Copies layers and metadata intact

### Commands
```bash
# Copy from source to destination registry
podman copy docker.io/library/nginx:latest destination-registry.com/nginx:latest

# Must be logged into both registries first
podman login source-registry.com
podman login destination-registry.com
```

> [!IMPORTANT]
> Ensure both registries support this operation and you have appropriate permissions.

## Copying Images to a Local Directory

### Overview
Save container images to a local filesystem location for backup or offline use.

### Key Concepts
- Exports image to a directory structure
- Creates image artifact files

### Commands
```bash
# Create destination directory
mkdir -p /tmp/container-images

# Copy image to local directory
podman copy docker.io/library/nginx:latest dir:/tmp/container-images

# Verify the copied image files
ls -la /tmp/container-images/
```

> [!NOTE]
> Use absolute paths for clarity and avoid permission issues.

## Tagging Images

### Overview
Assign custom names or versions to images for organization.

### Key Concepts
- Tags are mutable aliases for image IDs
- Help version control and deployment strategies

### Commands
```bash
# Tag an existing image
podman tag nginx:latest my-webserver:latest

# Tag with specific version
podman tag 0123456789ab my-webserver:v1.0

# List images to verify tagging
podman images
```

💡 **Pro Tip**: Use descriptive tags following semantic versioning (e.g., v1.2.3).

## Running Containers

### Overview
Test images by running containers (brief introduction; covered in depth in future sections).

### Key Concepts
- Validate image functionality
- Check for configuration issues

### Commands
```bash
# Run a container from the image
podman run -d my-webserver:latest

# Check container logs
podman logs <container_id>
```

## Saving Images to an Archive

### Overview
Export images to compressed archive files for storage or transfer.

### Key Concepts
- Creates .tar files for images
- Supports OCI or Docker archive formats

### Commands
```bash
# Save to Docker-style tar
podman save -o my-webserver.tar my-webserver:latest

# Save as OCI archive
podman save --format oci-archive -o my-webserver.tar.oc i my-webserver:latest
```

> [!TIP]
> Archives can be shared via USB or stored for disaster recovery.

## Loading Images from an Archive

### Overview
Import container images from saved archive files.

### Key Concepts
- Loads both Docker and OCI formats
- Restores images to local storage

### Commands
```bash
# Load from tar archive
podman load -i my-webserver.tar

# Load OCI format archive
podman load --input my-webserver.tar.oci

# Verify loaded image
podman images
```

## Pushing Images to a Registry

### Overview
Upload local images to a registry for sharing or deployment.

### Key Concepts
- Mirrors the pull operation in reverse
- Requires registry write permissions

### Commands
```bash
# Push to default configured registry
podman push my-webserver:latest

# Push to specific registry
podman push my-webserver:latest registry.example.com/my-webserver:latest
```

> [!WARNING]
> Private registries may require certificates and specific permissions.

## Verifying Image Signatures

### Overview
Ensure images come from trusted sources by checking cryptographic signatures.

### Key Concepts
- Uses RPM-style signature verification
- Protects against tampering

### Commands
```bash
# Enable signature verification
podman image trust set --type signedBy registry.example.com/openshift3/ose-pod

# Verify during pull operation
podman pull registry.example.com/trusted-image:latest
```

⚠️ **Security Note**: Always verify signatures in production environments.

## Removing Images

### Overview
Clean up local images to free disk space.

### Key Concepts
- Remove images by name or ID
- Ensure containers using the image are stopped

### Commands
```bash
# List all containers (check for running ones)
podman ps -a

# Stop running containers
podman stop <container_id>

# Remove specific image
podman rmi nginx:latest

# Remove all unused images
podman rmi --all

# Force remove (if needed)
podman rmi -f <image_id>
```

> [!WARNING]
> Double-check image names to avoid removing required images.

## Summary

### Key Takeaways
```diff
+ Podman is a powerful tool for managing container images across registries and local systems
+ Always verify image origins and signatures in production environments  
- Never expose credentials in scripts or logs
- Image operations can consume significant disk space and network bandwidth
```

### Quick Reference
- **Inspect**: `podman inspect [image]`
- **Pull**: `podman pull [source]`
- **Copy**: `podman copy [source] [destination]`  
- **Tag**: `podman tag [image] [new-tag]`
- **Save**: `podman save -o [file] [image]`
- **Load**: `podman load -i [file]`
- **Push**: `podman push [image]`
- **Remove**: `podman rmi [image]`

### Expert Insight

#### Real-world Application
In enterprise environments, these operations are scripted for CI/CD pipelines, where images are built, tagged, pushed to staging registries, and promoted to production based on testing results. Signature verification ensures supply chain security.

#### Expert Path
Master repository management by setting up private registries and implementing image scanning. Learn about image optimization techniques like multi-stage builds to reduce attack surfaces.

#### Common Pitfalls
- Forgetting to login leads to authentication errors
- Pushing to wrong registries breaks deployments  
- Removing active containers causes runtime failures

</details>
