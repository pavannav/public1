# Session 4: Introducing GitLab CI/CD

## Getting Started with GitLab SaaS

GitLab SaaS (Software as a Service) provides a cloud-based platform without requiring local installation. Users can leverage trial accounts for exploration and testing.

### Project Organization in GitLab

GitLab organizes resources using **namespaces** for project management:

- **Personal Namespace**: Automatically created using the user's username, containing all owned projects.
- **Groups**: Allow management of multiple related projects simultaneously, enabling collaborative features across projects.

> [!NOTE]
> Namespaces create hierarchical structures for organizing and accessing projects efficiently.

## Projects and Core Features

A **project** in GitLab is equivalent to a repository in other Git platforms (like GitHub). Projects serve as containers for:

- Hosting codebase
- Tracking issues
- Collaborating on code
- Implementing built-in CI/CD for automated building, testing, and deployment

### Future Exploration in Training

The training will cover advanced GitLab features:

- Environment dashboards for monitoring deployments
- Operation dashboards for system performance
- Security dashboards for vulnerability scanning
- CI/CD pipeline setup and execution

## Usage Quotas and Compute Units

Trial accounts include monthly limits to manage resource consumption:

- **Compute Units**: Limited to 400 units per month for trial accounts.
- **What are Compute Units?**: Measure resource consumption when running pipelines on GitLab Shared Virtual Machines.
- **Calculation Formula**: `Usage = Job Duration × Cost Factor`
- **Cost Factor Influences**:
  - Project visibility (private, internal, public)
  - Open source project status
  - Runner type (Linux, Windows, macOS, GPU-enabled)
  - Machine size

### Pricing and Management

- Detailed pricing information available via the usage quotas interface.
- Quotas can be configured at namespace, group, and project levels.
- Cost factors vary based on machine type and configuration.

### Exploring Factors Impacting Compute Costs

```diff
+ Cost factor increases for private projects (higher usage tracking)
! Internal/public projects may have reduced rates
- GPU-enabled machines typically have higher cost factors
+ Open source contributions may qualify for discounts
```

> [!IMPORTANT]
> Monitor usage closely during trials to avoid exceeding limits, as exceeding quotas may pause pipeline execution.

## Upcoming Topics in CI/CD Training

The next session will dive deeper into:

- GitLab CI/CD components and architecture
- Types of runners (shared vs. custom)
- Pipeline configuration and setup
- Runner management and optimization

> [!NOTE]
> Understanding compute units and quotas is crucial for cost-effective CI/CD implementation in larger projects. Focus on efficient pipeline design to minimize resource consumption.
