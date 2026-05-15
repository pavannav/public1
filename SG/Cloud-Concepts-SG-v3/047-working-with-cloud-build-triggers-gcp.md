### Session 047: Working with Cloud Build Triggers in GCP

<details open>
<summary><b>Session 047: Working with Cloud Build Triggers in GCP (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Cloud Build Triggers Overview](#cloud-build-triggers-overview)
- [Trigger Types and Events](#trigger-types-and-events)
- [Manual Triggers](#manual-triggers)
- [Push to Branch Triggers](#push-to-branch-triggers)
- [Pull Request Triggers](#pull-request-triggers)
- [Tag Push Triggers](#tag-push-triggers)
- [Pub/Sub Message Triggers](#pubsub-message-triggers)
- [Webhook Triggers](#webhook-triggers)
- [Advanced Configuration Options](#advanced-configuration-options)
- [Build Configuration Options](#build-configuration-options)
- [Approval Workflows](#approval-workflows)
- [Scheduled Triggers](#scheduled-triggers)
- [Lab Demonstrations](#lab-demonstrations)
- [Best Practices](#best-practices)
- [Summary](#summary)

## Overview

This session covers Google Cloud Build triggers in detail, explaining how triggers enable continuous integration and deployment (CI/CD) automation. The training demonstrates various trigger types including manual, push-based, pull request, tag push, Pub/Sub message, and webhook triggers. Through hands-on demos, you'll learn trigger configuration, event handling, repository connections (GitHub, Bitbucket, Cloud Source Repositories), and approval workflows.

## Cloud Build Triggers Overview

Cloud Build triggers automate the build process by listening for specific events and automatically executing builds when those events occur. This enables CI/CD pipelines where code changes automatically trigger building and deployment processes.

> [!IMPORTANT]
> Triggers listen for incoming events like git commits, pull requests, or Pub/Sub messages, then execute builds automatically without manual intervention.

### Key Benefits

```diff
+ Automated CI/CD: Reduces manual build execution
+ Event-driven: Responds to repository changes immediately
+ Configurable conditions: Supports file inclusion/exclusion patterns
+ Multi-repository support: Works with GitHub, Bitbucket, Cloud Source Repositories
+ Manual override: Can be triggered manually when needed
```

### Supported Repository Types

Cloud Build supports multiple repository integrations:
- **GitHub**: Full support including pull requests
- **Bitbucket**: Full support including pull requests
- **Cloud Source Repositories**: Git-based but no pull request support
- **GitLab**: Through webhook integration

## Trigger Types and Events

Cloud Build triggers respond to various event types, each serving different automation needs.

### Event Types

| Event Type | Description | Use Case |
|------------|-------------|----------|
| Push to Branch | Code push to specific branch | Continuous integration |
| Pull Request | PR creation/updates | Code review automation |
| Tag Creation | New tag pushed | Release management |
| Pub/Sub Message | Message published to topic | External service integration |
| Manual | User-initiated | Testing, emergencies |
| Scheduled | Time-based | Nightly builds, maintenance |

### Repository Connection Methods

Cloud Build supports first and second generation repository connections:
- **First Generation**: Direct integration with GitHub/Bitbucket
- **Second Generation**: Enhanced security with service accounts, supports more repositories

## Manual Triggers

Manual triggers allow on-demand build execution without waiting for events.

### Configuration Steps

1. **Create Trigger**: Name the trigger (e.g., "manual-trigger")
2. **Select Region**: Choose appropriate region (e.g., us-central1)
3. **Event Selection**: Choose "Manual invocation"
4. **Repository Connection**: Connect GitHub/Bitbucket repository
5. **Branch/Tag Selection**: Specify branch (e.g., "main") or tag
6. **Build Configuration**: Choose Cloud Build config file, Dockerfile, or Buildpacks

### Manual Trigger Execution

```bash
# Navigate to Cloud Build Console
# Go to Triggers → Select trigger → Click "Run"
# Choose branch/commit hash if needed
```

## Push to Branch Triggers

These triggers automatically build when code is pushed to a specific branch.

### Configuration Steps

1. **Event Type**: "Push to a branch"
2. **Branch Selection**: Choose specific branch or all branches
3. **Repository**: Select connected repository
4. **Build Configuration**: Choose auto-detect or specific config file
5. **File Filters**: Optional include/exclude patterns

### Demonstration Example

The trainer creates a "push-trigger" for the "web-testing" branch:
- **Trigger Name**: push-trigger
- **Repository**: cloud-build-testing
- **Branch**: web-testing
- **Configuration**: Auto-detect (Cloud Build config file)

When code is pushed to the web-testing branch, the trigger automatically executes the build defined in `cloudbuild.yaml`.

## Pull Request Triggers

PR triggers enable automated testing and validation during code reviews.

### Pull Request Specifics

Pull requests are supported for GitHub and Bitbucket but not Cloud Source Repositories due to the pull request concept being specific to external Git hosting services.

### Configuration Options

- **Comment Control**: Require "/gcbrun" comment for security
- **Owner/Collaborator Exemption**: Bypasses comment requirement for repo owners
- **Branch Targeting**: Specify base branch for PRs

### Demonstration Steps

1. **Create PR Trigger**: Name "pull-request-trigger"
2. **Branch Selection**: Target "main" branch
3. **Comment Required**: Enable for security
4. **Build Configuration**: Cloud Build config file

To trigger PR builds:
```bash
# Create PR without /gcbrun comment → Build won't start
# Edit PR description to include /gcbrun
# Rerun failed checks
# Build triggers automatically
```

## Tag Push Triggers

Tag triggers respond to new tag creation for release management.

### Tag Trigger Configuration

- **Event Type**: "Push new tag"
- **Tag Pattern**: Choose "Any tag" or specific patterns
- **Repository**: Select connected repository
- **Build Configuration**: Choose appropriate build method

### Tag Creation Demonstration

```bash
# Create and push new tag
git tag v1.0
git push origin v1.0

# Trigger automatically executes build for tagged code
```

## Pub/Sub Message Triggers

Pub/Sub triggers respond to messages published to Google Cloud Pub/Sub topics.

### Configuration Steps

1. **Event Type**: "Pub/Sub message"
2. **Topic Selection**: Choose existing Pub/Sub topic
3. **Repository**: Select connected repository
4. **Branch**: Specify branch for build execution

### Demonstration

```bash
# Create Pub/Sub topic (if needed)
gcloud pubsub topics create my-build-topic

# Publish message to trigger build
gcloud pubsub topics publish my-build-topic --message "Build trigger"
```

## Webhook Triggers

Webhook triggers integrate with external systems through HTTP webhooks.

### Webhook Setup Process

1. **Create Secret**: Generate secret for webhook authentication
2. **Event Selection**: Choose webhook events (push, PR, tag creation, etc.)
3. **Repository**: Select connected repository
4. **GitHub Webhook Configuration**: Add webhook URL to GitHub repository

### Webhook Configuration Steps

```bash
# 1. Create webhook trigger in Cloud Build
# 2. Get webhook URL and secret from trigger details
# 3. In GitHub repository Settings → Webhooks:
#    - Add webhook URL
#    - Add secret from Secret Manager
#    - Select events (e.g., branch/tag creation)
# 4. Enable webhook trigger
```

The demonstration shows creating a new branch "new-test-branch" which automatically triggers the webhook build.

## Advanced Configuration Options

### Branch and File Filtering

```yaml
# Include specific branches
included_branches: ["main", "develop", "release/*"]

# Exclude specific branches  
excluded_branches: ["testing", "experimental"]

# Include specific file changes
included_files: ["src/**", "*.js", "!src/tests/**"]

# Exclude file changes
ignored_files: ["*.md", "docs/**", ".gitignore"]
```

### Comment Control in PR Triggers

- **Required for all**: Everyone must add "/gcbrun" comment
- **Required for collaborators only**: Repo owners/collaborators exempt
- **Not required**: Any PR triggers build (less secure)

## Build Configuration Options

### Cloud Build Configuration File

Standard method using `cloudbuild.yaml`:
```yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$PROJECT_ID/my-image:$TAG_NAME', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'gcr.io/$PROJECT_ID/my-image:$TAG_NAME']
```

### Dockerfile Configuration

- **Dockerfile Location**: Specify path to Dockerfile
- **Image Name**: Provide target container registry path
- **Auto-build**: Build image without explicit cloudbuild.yaml

### Buildpacks Configuration

**Zero-configuration builds**:
- Analyzes code automatically
- Detects language/runtime
- Generates appropriate container image
- No Dockerfile or cloudbuild.yaml required

Buildpacks work by examining your codebase and automatically determining:
- Programming language
- Dependencies  
- Required runtime
- Optimal container configuration

## Approval Workflows

### Build Approval Configuration

Enables human review before production deployments:

```yaml
# In trigger configuration
require_approval: true

# Builds wait for manual approval
# Available actions: Approve, Reject, Cancel
# Can rerun failed or cancelled builds
```

### Use Cases

- **Production deployments**: Code review before release
- **Critical infrastructure changes**: Additional verification
- **Regulatory compliance**: Audit trail requirements

## Scheduled Triggers

### Schedule Configuration

Enables time-based automated builds:

```yaml
# Schedule API must be enabled
schedule:
  frequency: "0 2 * * 1-5"  # Daily at 2 AM, weekdays
  time_zone: "America/New_York"
  service_account: "my-service-account@project.iam.gserviceaccount.com"
```

### Cron Expression Format

```
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
├ └──────── Hour (0-23)
└────────── Minute (0-59)
```

## Lab Demonstrations

### Demo 1: Manual Trigger Setup

**Repository Preparation:**
- Create GitHub repository "cloud-build-testing"
- Add files: `Dockerfile`, `cloudbuild.yaml`, `start.sh`
- Connect repository to Cloud Build

**Trigger Configuration:**
1. Name: "manual-trigger"
2. Event: Manual invocation
3. Repository: cloud-build-testing
4. Branch: main
5. Configuration: Cloud Build config file

**Execution:**
```bash
# Manual trigger execution
- Go to Cloud Build Console
- Select trigger
- Click "Run"
- Monitor build in History
```

### Demo 2: Push Trigger

**Trigger Setup:**
1. Name: "push-trigger"
2. Event: Push to branch
3. Branch: web-testing
4. Repository: cloud-build-testing

**Testing:**
```bash
# Push to trigger branch
git checkout web-testing
echo "# Update" >> README.md
git add .
git commit -m "Test push trigger"
git push origin web-testing
```

Build automatically starts within seconds.

### Demo 3: Pull Request Trigger

**Trigger Configuration:**
1. Name: "pull-request-trigger"
2. Event: Pull request
3. Branch: main
4. Comment required: Yes

**Testing Steps:**
```bash
# Create feature branch
git checkout -b feature/test-pr
echo "Test PR content" >> test.txt
git add test.txt
git commit -m "Test PR trigger"
git push origin feature/test-pr

# Create PR on GitHub
# Build won't start without /gcbrun comment
# Edit PR to add comment: /gcbrun
# Build triggers automatically
```

### Demo 4: Buildpacks with Approval

**Trigger Setup:**
1. Name: "buildpack-trigger"
2. Configuration: Buildpacks
3. Approval: Required

**Features Demonstrated:**
- Zero-configuration build detection
- Automatic image creation and push
- Manual approval workflow
- Build retry capabilities

## Best Practices

### Security Considerations

```diff
+ Use approval workflows for production
+ Require /gcbrun comments for PR triggers
+ Limit webhook secrets to specific events
+ Use service accounts with minimal permissions
- Avoid public repositories without comment requirements
- Don't use auto-approval for critical deployments
```

### Performance Optimization

- **File Filtering**: Use include/exclude patterns to avoid unnecessary builds
- **Branch Targeting**: Configure triggers only for relevant branches
- **Build Caching**: Leverage Cloud Build caching for faster builds
- **Resource Optimization**: Use appropriate machine types

### Monitoring and Troubleshooting

- **Build History**: Monitor all trigger executions
- **Logs Analysis**: Check build logs for failures
- **Trigger Management**: Regularly audit and update trigger configurations
- **Cost Monitoring**: Track build resource usage and costs

> [!NOTE]
> Always test triggers in non-production branches before enabling in production environments.

## Summary

### Key Takeaways

```diff
+ Cloud Build triggers enable CI/CD automation through event-driven builds
+ Support multiple repository types with varying feature sets
+ Manual triggers provide on-demand build execution
+ Push triggers respond to code changes immediately
+ PR triggers integrate with code review processes
+ Tag triggers support release management workflows  
+ Pub/Sub and webhook triggers enable external integrations
+ Approval workflows provide governance for production deployments
+ Buildpacks offer zero-configuration container builds
+ Proper configuration ensures security and prevents unauthorized builds

+ Real-world Application: Implement comprehensive CI/CD pipelines combining multiple trigger types for complete automation coverage
+ Expert Path: Master advanced filtering, approval workflows, and custom build configurations for complex deployment scenarios
- Common Pitfalls: Skipping comment requirements, overusing auto-approval, poor branch filtering leading to resource waste

Buildpacks automatically analyze source code and create optimal container images without requiring Dockerfile or build configuration files. They detect programming languages, frameworks, and dependencies to generate appropriate container environments - perfect for getting started quickly or when you don't need custom container configurations.
```

</details>

### Potential transcript corrections identified:
- "p p request" → "pull request"
- "giup" → "GitHub"
- "Giup" → "GitHub"
- "G gcb run" → "/gcbrun"
- "pops up" → "Pub/Sub"
- "us Central One" → "us-central1"
- "toer file" → "Docker file"
- "G start.sh" → "start.sh"
- "CK" → "my project ID"
- "KCK" → "project ID"
- "p request" → "pull request"
- "Invert" → "feature" (branch name context)
- "P" → "pull"
- "SL GCB run" → "/gcbrun"
- "drones" → "checks"
- "drone" → "failed"
- "G gcb" → "/gcbrun"
- "gcp run" → "/gcbrun"
- "pops up" → "Pub/Sub" (multiple instances)
- "us" → "us-central1"
- "webook" → "webhook" (multiple instances)
- "Webook" → "webhook"
- "urb" → "URL" (multiple instances)
- "urri" → "URL"
- "arb" → "branch"
- "Inver" → "feature"
- "webbook" → "webhook"
- "webook" → "webhook"
- "triggle" → "trigger"
- "inverted" → "ignored"
- "Auto detected" → "Auto-detect"
- "DML" → "yaml"
- "orms" → "from"
- "sim" → "in"
- "triple P" → "just commit"
- "uh so" → "just click on create so"
- "indi" → "India" (timezone)
- Various missing spaces and grammatical fixes
