# Session 7: Create and Run a Basic Pipeline

## GitLab CI/CD Components: Focus on Runner

### Key Concepts 📝

Building on pipeline definition and execution, this session explores the three core components of GitLab CI/CD: the GitLab Server, Runner, and Executor. The focus is on the Runner, which acts as the execution engine for CI/CD jobs.

### Runner Overview 💡

Runners are external or virtual machines that handle job execution in GitLab CI/CD. They register with the GitLab Server to receive job instructions and process them.

```diff
! GitLab Server ← Runner Registration → Job Assignment → Execution Environment
```

> [!NOTE]
> Runners are responsible for translating job definitions into actual running processes.

### Runner Types: Shared vs. Self-Managed ⚖️

GitLab offers two primary Runner options, each with distinct advantages and challenges. The choice depends on your team's needs for control, scalability, and resource management.

#### Shared Runners
GitLab-managed Runners available to all projects on a SaaS instance. They operate on a first-come, first-served basis.

**Pros:**
```diff
+ Easy to use: No setup or maintenance required
+ Cost-effective: Included in GitLab subscription tiers
+ Scalable: Automatic scaling by GitLab based on demand
```

**Cons:**
```diff
- Limited control: No customization of configuration or environment
- Performance: Potential slowdowns from resource competition
- Security: Shared resources may increase risks from other projects
```

#### Self-Managed Runners  
Customer-installed and managed Runners on your own infrastructure.

**Pros:**
```diff
+ Full control: Complete authority over configuration, environment, and security
+ Performance: Generally faster and more reliable than shared
+ Isolation: Reduced security risks through project separation
```

**Cons:**
```diff
- Complex setup: Requires technical expertise for installation and maintenance
- Scaling challenges: Manual effort needed to grow with demand
- Additional costs: Hardware and software expenses for operation
```

### Comparison Table

| Aspect                | Shared Runners              | Self-Managed Runners         |
|-----------------------|-----------------------------|------------------------------|
| Management           | GitLab-maintained          | Self-hosting                 |
| Setup Complexity     | Minimal (zero-touch)       | High (requires expertise)    |
| Cost Model           | Included in subscription   | Additional HW/SW costs      |
| Scalability          | Auto-scaled by GitLab      | Manual scaling required     |
| Control Level        | Limited                    | Full control                |
| Security Isolation   | Multi-tenant (riskier)     | Project-isolated (safer)    |
| Performance         | Variable (contention)      | Consistent (dedicated)      |

### Implementation Considerations ⚠️

> [!IMPORTANT]
> Evaluate your control requirements, scalability needs, and security posture when selecting a Runner type. Shared Runners work well for small teams starting with CI/CD, while Self-Managed Runners fit larger organizations needing customization.

> [!WARNING]
> Self-Managed Runners demand ongoing maintenance and may incur costs beyond your GitLab subscription. Ensure you have the technical resources to manage them effectively.
