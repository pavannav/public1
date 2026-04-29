# Session 1: Course Introduction

## Course Introduction

This session provides an overview of a DevOps initiative at Dasher Technology, a software provider offering data connectivity solutions. We'll explore how the company is transitioning to cloud and container technologies for their NodeJS projects, while evaluating CI/CD tools to meet their requirements.

### Key Concepts

#### DevOps Prerequisites for Software Providers
Dasher Technology facilitates connectivity between data, applications, and devices across on-premises environments. Their R&D team is transitioning services to the cloud using container technologies, starting with a NodeJS-based project before expanding to Java and Python projects.

- **Infrastructure Transition**: Moving to multi-cloud setup with Docker for containerization and Kubernetes for orchestration.
- **DevOps Team Leadership**: Alice leads the initiative to establish pipelines from project inception, following best practices.

#### Assessment of Current Challenges
After evaluation, Alice identified several issues with the existing workflow:
- No version control system resulted in independent code writing and manual integration.
- Manual testing was slow and ineffective.
- Poor collaboration due to separate branches and infrequent integrations.
- High-risk releases due to inadequate testing.
- Manual deployments to development, staging, and production environments.

```diff
- Previous Approach (Manual Issues):
  - No version control → Code integration chaos
  - Manual testing → Slow and error-prone
  - Isolated branches → Collaboration breakdowns
  - Infrequent integration → High-risk releases
```

#### Proposed Pipeline Solution
To address these challenges, the team implemented a CI/CD pipeline with these steps:
- Adopt GitLab for version control and collaboration.
- Implement unit testing and code coverage to speed up testing and reduce bugs.
- Utilize Docker build and push processes for containerization.
- Deploy applications to Kubernetes clusters.
- Incorporate automated integration testing as the final step.

> [!IMPORTANT]
> This pipeline resolves existing issues by automating version control collaboration, testing, containerization, and deployment, significantly reducing risks and manual effort.

#### CI/CD Tool Selection Process
The market offers various CI/CD tools (Jenkins, Travis CI, Bamboo, Spinnaker, GitHub Actions, CircleCI, etc.). After exploration, the team initially selected Jenkins as a widely used open-source solution, but faced significant overheads:
- Configuring and maintaining VMs with specific CPU, memory, and disk requirements.
- Installing prerequisites: Java JDK, firewall rules, Jenkins plugins.
- For NodeJS projects: Installing multiple NodeJS/NPM versions for testing, Docker for containerization.
- For Kubernetes: Installing kubectl, Helm, and other binaries.
- Additional tools for integration testing and reporting.
- Scaling complexity for multiple projects (Java/Python) and clouds (AWS/Azure) requiring extra installations (Maven, Python, Azure/AWS CLIs).
- DevSecOps additions (e.g., Trivy, KubeSec) increase workload.

```diff
+ Jenkins Benefits:
  - Open-source and extensively used
- Jenkins Drawbacks:
  - Heavy infrastructure management
  - Numerous manual configurations
  - Complexity grows with project scale
  - Team lacks familiarity with tools
```

#### Choosing GitLab CI/CD
Given the new DevOps team's limited experience, Alice sought a tool offering:
- Simplified setup without extensive service configurations.
- Focus on pipeline building without infrastructure management or scalability concerns.

After evaluation, the team selected GitLab CI/CD, which provides a more streamlined approach.

> [!NOTE]
> Throughout this course, we'll implement GitLab CI/CD pipelines for a NodeJS application, demonstrating real-world cloud and container practices.

## Key Takeaways
- ❌ Manual processes in development introduce significant risks and inefficiencies.
- 💡 CI/CD pipelines automate integration, testing, and deployment to ensure rapid, reliable releases.
- ⚠️ Tool selection should prioritize simplicity over features when teams are inexperienced.
- 📝 GitLab CI/CD eliminates infrastructure overhead while supporting complex pipeline requirements.

---

# Course Summary Tracker

| Session | Topic | Status | Summary |
|---------|-------|--------|---------|
| 1 | Course Introduction | ✅ Completed | Overview of DevOps initiative at Dasher Technology; Identified manual workflow challenges and transition to CI/CD pipelines; Evaluated Jenkins vs. GitLab CI/CD tool selection; Course will focus on GitLab CI/CD for NodeJS application. |

**Last Updated**: 2026-04-28  
**Total Sessions Completed**: 1 / [Ongoing - Total sessions to be determined]  
**Next Session**: Session 2 (when ready)  

> Notable Commands/Labs: None (introduction session)  
> Key Concepts Covered: DevOps prerequisites, pipeline steps, tool evaluation (Jenkins limitations vs. GitLab CI/CD benefits)
