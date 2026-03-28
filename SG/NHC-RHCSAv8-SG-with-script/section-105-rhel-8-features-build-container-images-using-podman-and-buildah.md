<details open>
<summary><b>Section 105: Container Image Building (CL-KK-Terminal)</b></summary>

# Section 105: Container Image Building

**Table of Contents:**
- [Container Image Building Overview](#container-image-building-overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Building Images with Podman](#building-images-with-podman)
- [Building Images with Buildah](#building-images-with-buildah)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

---

## Container Image Building Overview

Container Image Building is the process of creating custom container images that encapsulate applications and their dependencies for consistent deployment across environments. This section covers how to build images using Podman and Buildah tools, which serve as alternatives to Docker in a rootless container environment. The instructor demonstrates practical steps to create images both interactively and through configuration files, emphasizing ease and flexibility for beginners.

---

## Key Concepts and Deep Dive

Container images are the blueprints for containers, including the application code, runtime, libraries, and configurations. Building images involves specifying base images, installing dependencies, setting up services, and defining entry points. Unlike pulling pre-built images from registries, building allows customization for specific use cases.

### Core Components:
- **Base Images**: Starting point, e.g., Fedora or RHEL distributions pulled from registries.
- **Instructions**: Commands to install packages, copy files, expose ports, and set CMD (entry points).
- **Tools**: Podman for unified container management, Buildah for image building without a daemon.

### Advantages:
- **Customization**: Tailor images for specific applications.
- **Reproducibility**: Ensure consistency across development, testing, and production.
- **Rootless Execution**: Safer than rootfull containers.

### Process Flow:
1. Prepare instructions (via Dockerfile/Containerfile or command-line).
2. Run build command to create image.
3. Push image to registry if needed.
4. Deploy via running containers.

### Common Tools and Commands:
- **Podman Build**: `podman build` to create images from Containerfiles.
- **Buildah**: Command-line tool for image construction.
- **Containerfile/Dockerfile**: Text file with build instructions.

### Security Considerations:
- Use trusted base images.
- Minimize image size by avoiding unnecessary packages.
- Expose only required ports.

> [!NOTE]
> Mistakes in transcript: "kubectl" was referred to as "cubectl", likely a typo for Kubernetes CLI tool, corrected here to proper spelling. "podman" is consistently spelled correctly.

---

## Building Images with Podman

Podman integrates container build capabilities similar to Docker. You can build images interactively using commands or via Containerfiles (Dockerfile equivalents).

### Using Podman Commands Interactively:
- Pull base image: `podman pull httpd:latest`.
- Create container: `podman create --name my-container httpd:latest`.
- Build and modify as needed, though for full builds, use instructed files.

### Via Containerfile:
Create a file named `Containerfile` (no extension).

Basic structure:
```bash
FROM fedora:latest
RUN dnf install -y httpd
RUN dnf install -y php
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
```

Build command:
```bash
podman build --tag my-web-server .
```

This creates an image with Apache installed, exposed on port 80, starting the httpd service.

### Building with Tags:
Tag for versioning:
```bash
podman build --tag my-web-server:v1.0 .
```

Verify:
```bash
podman images
```

### Pushing to Registry:
Once built, push to a registry (e.g., quay.io or local registry):
```bash
podman push my-web-server registry.example.com/my-web-server
```

---

## Building Images with Buildah

Buildah is a tool for building OCI-compliant images without requiring a container daemon. It's ideal for automation and provides more granular control over the build process.

### Key Commands:
- **Build from Scratch**:
  ```bash
  buildah from scratch
  buildah run <container> dnf install -y httpd
  buildah copy <container> /path/to/file /destination
  buildah config --cmd apachectl start
  buildah commit <container> my-custom-image
  ```

- **Using Instructions File**:
  Create a Dockerfile named `Dockerfile` (Buildah can use Dockerfiles).

  Example:
  ```bash
  FROM fedora:latest
  RUN dnf install -y httpd
  EXPOSE 8080
  CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
  ```

  Build command:
  ```bash
  buildah bud -t fedora-my-std .
  ```

- **Verify Build**:
  ```bash
  buildah containers
  buildah images
  ```

Buildah allows building images in stages, similar to multi-stage builds in Docker, for optimized images.

### Comparison: Podman vs Buildah

| Feature | Podman | Buildah |
|---------|--------|---------|
| Primary Use | Running and managing containers | Building images |
| Daemon Required | No (rootless) | No (rootless) |
| Build Method | Containerfile-focused | Command-line or Dockerfile |
| Integration | Full container lifecycle | Image construction only |
| Flexibility | Moderate | High (low-level control) |

---

## Lab Demos

### Demo 1: Building Apache Image with Podman Containerfile
1. Create `Containerfile`:
   ```bash
   FROM httpd:latest
   RUN apt-get update && apt-get install -y php curl  # Example additions
   EXPOSE 80
   CMD ["apache2-foreground"]
   ```
   
2. Build image:
   ```bash
   podman build --tag apache-demo .
   ```
   
3. Run container:
   ```bash
   podman run -d --name web-demo -p 8080:80 apache-demo
   ```
   
4. Access: Open browser at `http://localhost:8080` – should show Apache page.

5. Check: `podman ps` for running status.

6. Cleanup: `podman stop web-demo; podman rm web-demo; podman rmi apache-demo`

### Demo 2: Building Custom Image with Buildah
1. Install dependencies: Ensure Buildah is available via `dnf install buildah` or equivalent.

2. Create directory with index.html:
   ```bash
   mkdir fedora-container; cd fedora-container
   echo "<h1>Custom Container Page</h1>" > index.html
   ```

3. Build image:
   ```bash
   buildah bud -t fedora-demo .
   ```
   (Assumes Dockerfile in current dir as shown previously.)

4. Run container:
   ```bash
   podman run -d --name fedora-test -p 8090:80 fedora-demo
   ```

5. Access: Browser at `http://localhost:8090` – should display custom page.

6. Cleanup: `podman stop fedora-test; podman rm fedora-test; buildah rmi fedora-demo`

---

## Summary

### Key Takeaways
```diff
+ Container image building allows custom application packaging for consistency and portability.
+ Tools like Podman and Buildah provide rootless, secure alternatives to Docker.
+ Use Containerfiles or Dockerfiles to define build instructions for reproducibility.
! Always verify images after build and before deployment to avoid runtime issues.
- Avoid using untrusted base images to prevent security vulnerabilities.
! Images can be pushed to registries for sharing across teams or environments.
```

### Quick Reference
- **Build command (Podman)**: `podman build --tag <image-name> <context>`
- **Build command (Buildah)**: `buildah bud -t <image-name> .`
- **List images**: `podman images` or `buildah images`
- **Run container**: `podman run -d -p <host>:<container> <image>`
- **Push image**: `podman push <image> <registry>/<repo>`

### Expert Insight
**Real-world Application**: In production, build images in CI/CD pipelines (e.g., GitHub Actions or Jenkins) using Buildah for automated, secure builds. This ensures rapid deployments to Kubernetes or orchestrated environments.

**Expert Path**: Master multi-stage builds to reduce image size by segregating build-time dependencies. Learn OCI standards for compatibility across platforms and integrate with tools like Podman Compose for full-stack apps.

**Common Pitfalls**: Overlooking port exposure leading to inaccessible services; forgetting to install required dependencies in builds; not tagging images properly for version control, causing rollback issues.

</details>
