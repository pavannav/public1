<details open>
<summary><b>049-Working-With-Cloud-Deploy-GCP-Part-2 (KK-CS45-script-v3)</b></summary>

# Session 49: Working with Cloud Deploy GCP - Part 2

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [What is Canary Deployment?](#what-is-canary-deployment)
  - [Manual Canary Deployment](#manual-canary-deployment)
  - [Cloud Deploy Automation](#cloud-deploy-automation)
  - [Promote vs Advance Rollout](#promote-vs-advance-rollout)
  - [Rollback Scenarios](#rollback-scenarios)
- [Lab Demos](#lab-demos)
  - [Creating a Canary Deployment Pipeline](#creating-a-canary-deployment-pipeline)
  - [Manual Traffic Shifting](#manual-traffic-shifting)
  - [Setting up Automation Pipeline](#setting-up-automation-pipeline)
  - [Rollback Demonstration](#rollback-demonstration)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview

This session continues from Part 1 of the Cloud Deploy series, focusing on advanced deployment strategies and automation. The session covers two main topics: **canary deployments** for gradual application rollouts and **automation** for seamless deployment pipelines across multiple environments. These strategies help minimize deployment risks while ensuring high availability and smooth user experience during application updates.

## Key Concepts/Deep Dive

### What is Canary Deployment?

Canary deployment is a deployment strategy that releases new application versions gradually to minimize risk. Instead of deploying all traffic to the new version at once, you deploy to a subset of users or infrastructure, test for stability, and progressively increase traffic as confidence grows.

**Key Benefits:**
- **Risk Mitigation**: Test new features with real traffic before full rollout
- **Zero-Downtime Deployment**: Old version continues running during rollout
- **Quick Rollback**: Easy reversion if issues are detected
- **User Experience**: Gradual rollout prevents all users from experiencing potential issues simultaneously

**How It Works:**
```
graph TD
    A[Deploy New Version] --> B[Test with Limited Traffic]
    B --> C{Verify Performance?}
    C -->|Issues Found| D[Rollback]
    C -->|Success| E[Increase Traffic %]
    E --> F{Desired Traffic Level?}
    F -->|No| E
    F -->|Yes| G[Full Rollout Complete]
    D --> H[Previous Version Restored]
```

### Manual Canary Deployment

Manual canary deployment gives you full control over traffic distribution and timing. You define percentages and manually advance through deployment phases.

**Configuration Elements:**
- **Delivery Pipeline**: Defines the deployment stages and strategies
- **Canary Strategy**: Specifies traffic percentages for each phase
- **Runtime Configuration**: Cloud-specific settings (Cloud Run, GKE)
- **Target Configuration**: Destination platform details

**Example Pipeline Configuration:**

```yaml
apiVersion: deploy.cloud.google.com/v1
kind: DeliveryPipeline
metadata:
  name: my-canary-pipeline
serialPipeline:
  stages:
  - targetId: prod-target
    strategy:
      canary:
        runtimeConfig:
          cloudRun:
            automaticTrafficControl: true
        canaryDeployment:
          percentages: [20, 50, 80]
```

### Cloud Deploy Automation

Automation removes manual intervention from deployment pipelines, automatically progressing through environments and traffic shifts based on predefined rules.

**Automation Types:**
1. **Promote Release**: Moving deployment from one environment to the next
2. **Advance Rollout**: Progressing through canary phases within an environment

**Automation Configuration:**

```yaml
apiVersion: deploy.cloud.google.com/v1
kind: Automation
metadata:
  name: auto-promote-example
automations:
- rules:
  - promoteRelease:
      targetId: staging-target
      wait: "60s"
serviceAccount: projects/[PROJECT_NUMBER]/serviceAccounts/[SERVICE_ACCOUNT]@gmail.com
```

### Promote vs Advance Rollout

**Promotion Rules:**
- Move entire release from one target to another
- Used for multi-environment pipelines (dev → staging → prod)
- Can be configured with wait periods between environments

**Advance Rollout Rules:**
- Progress through phases within a single target
- Configurable for canary strategies (25%, 50%, 100%)
- Includes wait periods between phase advancements

### Rollback Scenarios

**Supported Rollback Options:**
- **Individual Phase Rollback**: Return to specific canary percentage
- **Release Rollback**: Revert to previous working release
- **Abandon Release**: Cancel failing deployment

**Rollback Command Example:**
```bash
gcloud deploy releases rollouts retry [ROLLOUT_NAME] [TARGET_NAME] --project=[PROJECT]
```

## Lab Demos

### Creating a Canary Deployment Pipeline

**Steps:**
1. Create YAML configuration file defining pipeline structure
2. Apply configuration using `gcloud deploy apply --file=pipeline.yaml`
3. Verify pipeline creation in Cloud Deploy console

**Pipeline YAML Structure:**
```yaml
# Delivery Pipeline Configuration
apiVersion: deploy.cloud.google.com/v1
kind: DeliveryPipeline
metadata:
  name: canary-delivery-pipeline
serialPipeline:
  stages:
  - targetId: prod-target
    strategy:
      canary:
        runtimeConfig:
          cloudRun: {}
        canaryDeployment:
          percentages: [20, 50, 80]

# Target Configuration  
---
apiVersion: deploy.cloud.google.com/v1
kind: Target
metadata:
  name: prod-target
gke:
  cluster: projects/my-project/locations/us-central1/clusters/my-cluster
```

### Manual Traffic Shifting

**Demonstration Flow:**
```
graph TD
    subgraph "Deployment Phases"
    A[Deploy Release] --> B[Canary 20% - Manual Check]
    B --> C[Canary 50% - Verify]
    C --> D[ Stable 100%]
    end
    subgraph "Cloud Run Console"
    E[New Revision Created] --> F[Traffic Split: 20%/80%]
    F --> G[Increment to 50%/50%]
    G --> H[Full Traffic: 100%/0%]
    end
```

**Console Actions:**
1. Monitor deployment progress in Cloud Deploy
2. Verify service revisions in Cloud Run console
3. Manually click "Advance Rollout" buttons
4. Check logs and metrics at each phase

### Setting up Automation Pipeline

**Multi-Environment Automation:**

```yaml
# Two-environment pipeline with automation
apiVersion: deploy.cloud.google.com/v1
kind: DeliveryPipeline
metadata:
  name: automated-deployment
serialPipeline:
  stages:
  - targetId: dev-target
  - targetId: staging-target
    profiles: [staging]
    strategy:
      canary:
        canaryDeployment:
          percentages: [25, 50]

# Automation for promotion
---
apiVersion: deploy.cloud.google.com/v1beta1
kind: Automation
metadata:
  generateName: promotion-automation-
automations:
- rules:
  - promoteRelease:
      targetId: staging-target
      wait: "60s"
selector:
  targetId: dev-target

# Automation for rollout advancement
---
apiVersion: deploy.cloud.google.com/v1beta1
kind: Automation
metadata:
  generateName: advance-automation-
automations:
- rules:
  - advanceRollout:
      sourcePhases:
      - canary-25
      - canary-50
      wait: "60s"
      toTargetId: staging-target
```

### Rollback Demonstration

**Scenario:**
1. Deploy faulty image that causes service failure
2. Monitor automation rules triggering
3. Use Cloud Deploy console to initiate rollback
4. Verify service restoration to previous healthy version

**Rollback Procedure:**
1. Navigate to failed rollout in Cloud Deploy console
2. Select "Roll Back Release" option
3. Choose previous working release
4. Confirm rollback completes

## Summary

### Key Takeaways

```diff
+ Canary deployment enables gradual, risk-minimizing application rollouts
+ Automation reduces manual intervention while maintaining deployment safety
+ Cloud Deploy supports both Cloud Run and GKE target platforms
+ Promotion advances releases between environments; Advance controls canary phases
+ Rollback capabilities ensure quick recovery from deployment failures
- First-time deployments skip canary phases (no baseline version exists)
- Automation requires careful planning of wait periods and phases
- Manual verification should complement automated pipelines in production
```

### Quick Reference

**Common Commands:**

```bash
# Create delivery pipeline
gcloud deploy apply --file=pipeline.yaml --region=us-central1 --project=my-project

# Create release
gcloud deploy releases create my-release --delivery-pipeline=my-pipeline --region=us-central1 --project=my-project --source=./source --images=app-image=gcr.io/my-project/my-app:v1.0

# Check deployment status
gcloud deploy rollouts list --delivery-pipeline=my-pipeline --release=my-release --region=us-central1 --project=my-project
```

**Configuration Templates:**

- **Canary Percentages**: `[20, 50, 80]` for progressive rollout
- **Wait Periods**: `"60s"` between automation steps
- **Automation Rules**: `promoteRelease` and `advanceRollout` types

### Expert Insight

**Real-world Application:**
In production environments, combine manual oversight with automation. Start with canary deployments in staging with 5-10% traffic splits, gradually increasing while monitoring key metrics like response times, error rates, and resource utilization.

**Expert Path:**
- Master Skaffold integration for complex multi-service deployments
- Learn to integrate canary deployments with CI/CD pipelines using Cloud Build triggers
- Study blue-green deployment patterns for complete environment switching
- Implement automated rollback based on SLO/SLI violations using monitoring alerts

**Common Pitfalls:**
- **Insufficient Testing Periods**: Don't rush through canary phases - adequate soak time is crucial
- **Inadequate Monitoring**: Missing key metrics can lead to deploying flawed versions
- **Over-Complexity**: Avoid excessive automation rules that become hard to maintain
- **Environment Drift**: Ensure dev, staging, and production environments remain synchronized

</details>
