# Session 8: Types of Executors

## Key Concepts

### Introduction to Executors
✅ **What are Executors?** Executors are the hidden engines within GitLab CI/CD runners that actually execute pipeline jobs. They define the operating system, tools, and resources for job execution, ensuring consistent, isolated environments to prevent conflicts and unexpected behavior.

💡 **Why Use Executors?** Runners don't directly run jobs; executors handle the execution based on project needs. Choosing the right executor is crucial for efficient, secure, and reliable pipelines.

⚠️ **Total Executors Available:** GitLab offers around 10 different types. We'll cover the most widely used ones below.

### Shell Executor
📝 The Shell Executor runs jobs directly on the runner's operating system using its shell (e.g., Bash or PowerShell). It's simple and lightweight, ideal for quick scripts or basic functionality testing.

#### Advantages and Disadvantages
```diff
+ Simple and lightweight setup
+ Suitable for quick scripts and basic testing
- Shares runner's OS and resources, risking conflicts
- Results vary based on runner environment and tools
- Potential security risks with shared resources and access levels
```

> [!NOTE]  
> Best for simple, low-isolation jobs but avoid for production or sensitive environments.

### Docker Executor
📝 The Docker Executor provides greater isolation and reproducibility by running jobs inside Docker containers. Containers encapsulate OS, libraries, and tools, ensuring consistency across machines. Choose from countless pre-built images.

#### Advantages and Disadvantages
```diff
+ Guarantees isolation and consistency across environments
+ Access to vast library of pre-built Docker images
- Requires Docker knowledge and additional configuration
- Consumes more resources (multiple containers)
- Restricted access to runner's native resources
```

> [!IMPORTANT]  
> Recommended for most CI/CD pipelines due to portability and containerization benefits.

### Kubernetes Executor
📝 If your project uses a Kubernetes cluster, this executor runs jobs as pods within the cluster, leveraging resource management, scaling, and parallel processing capabilities.

#### Advantages and Disadvantages
```diff
+ Utilizes cluster's resource management and scaling for efficiency
+ Supports parallel processing
- Complex setup and maintenance required
- Requires Kubernetes expertise and dependency on existing cluster
- Steep learning curve for best practices and security
```

> [!WARNING]  
> Not feasible without a Kubernetes cluster; consider alternatives if infrastructure lacks this.

### VM (Virtual Machine) Executor
📝 The VM Executor creates a new virtual machine per job for complete isolation, eliminating contamination from previous jobs.

#### Advantages and Disadvantages
```diff
+ Provides perfect isolation with a "clean slate" per job
- High resource usage (disk, memory, CPU) increases costs
- Slower startup times compared to containers
- Requires VM management expertise
```

> [!NOTE]  
> Ideal for jobs needing absolute separation but costly for frequent executions.

### SSH Executor
📝 Allows running jobs remotely on another machine via SSH, useful for utilizing specific resources or integrating with pre-existing infrastructure.

#### Advantages and Disadvantages
```diff
+ Enables remote execution on specific machines
- Security concerns with SSH access and configurations
- Relies on reliable network connectivity
- Limited control and monitoring of remote jobs
```

> [!WARNING]  
> Prioritize secure SSH setups to avoid vulnerabilities.

### Custom Executor
📝 GitLab supports specialized executors like Parallel, Docker Machine, or user-developed custom ones for flexible workflows.

#### Advantages and Disadvantages
```diff
+ Highly flexible for specific needs and environments
- Overhead in development and complexity
- Increased resource usage
- Limited access to underlying systems
```

> [!IMPORTANT]  
> Custom executors offer deep customization but require significant development effort.

### Executor Comparison Table

| Executor Type    | Pros                                      | Cons                                      | Use Case Examples                  |
|------------------|------------------------------------------|------------------------------------------|------------------------------------|
| Shell           | Simple, lightweight, quick scripts      | Resource sharing risks, inconsistency   | Basic testing, simple automation   |
| Docker          | Isolation, consistency, pre-built images | Docker knowledge, resource intensive   | Most CI/CD pipelines             |
| Kubernetes      | Scaling, parallel processing            | Complex setup, Kubernetes required     | Cluster-based workflows          |
| VM              | Perfect isolation                       | High resources, slow startup           | Security-sensitive jobs          |
| SSH             | Remote resource access                  | Security risks, connectivity dependent | Legacy system integration        |
| Custom          | Adapted to specific needs              | Development overhead, limited access   | Specialized environments         |

> [!TIP]  
> Refer to GitLab's official documentation for detailed executor configurations and the full key facts table. Choose based on your project's isolation needs, infrastructure, and complexity tolerance.
