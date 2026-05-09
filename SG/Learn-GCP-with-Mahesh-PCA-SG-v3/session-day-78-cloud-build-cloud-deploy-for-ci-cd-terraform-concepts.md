# Session 78: Cloud Build + Cloud Deploy for CI/CD & Terraform Concepts

## Table of Contents
- [Overview](#overview)
- [Cloud Build for CI/CD](#cloud-build-for-cicd)
  - [Key Concepts](#key-concepts)
  - [Lab Demos](#lab-demos)
- [Cloud Deploy for CD](#cloud-deploy-for-cd)
  - [Key Concepts](#key-concepts-1)
  - [Lab Demos](#lab-demos-1)
- [Terraform Concepts and Infrastructure as Code](#terraform-concepts-and-infrastructure-as-code)
  - [Key Concepts](#key-concepts-2)
  - [Lab Demos](#lab-demos-2)
- [Summary](#summary)

## Overview
This session explores advanced CI/CD practices using Google Cloud tools, transitioning from manual deployments to fully managed continuous delivery. It begins with enhancing Cloud Build for automated builds and approvals, introduces Cloud Deploy for multi-environment deployments, and covers Infrastructure as Code (IaC) with Terraform. The instructor demonstrates practical implementations, troubleshooting, and comparisons with other tools like Jenkins, emphasizing automation, security, and scalability for modern software delivery pipelines.

## Cloud Build for CI/CD

### Overview
Cloud Build provides a serverless build service that automates the process of building, testing, and pushing container images to Google Cloud services. This session focuses on extending basic CI pipelines with approval workflows to ensure quality gates before deployments, reducing risks in production releases.

### Key Concepts
- **Cloud Build Basics**: Uses containerized environments for builds, supporting Docker and various languages. Images are built via `gcloud builds submit` or triggered from GitHub pushes. Outputs include container images stored in Artifact Registry.
- **GitHub Integration**: Build logs can be sent back to GitHub for visibility, especially useful when developers lack direct GCP access. This is achieved by configuring triggers on GitHub repositories.
- **Approval Workflows**: Adds a quality gate where builds require approval from users with specific roles (e.g., Cloud Build Approver). Triggers can be configured to enforce approvals, preventing unauthorized deployments.
- **Role-Based Access**: Cloud Build Service Account needs appropriate IAM roles (e.g., Artifact Registry Reader/Writer, Cloud Run Deployer) to perform actions like building images and deploying services.
- **IM Roles Propagation**: Changes to IAM roles may take time to propagate; testing repeatedly can resolve intermittent permission errors.
- **Manual vs. Automated Deployments**: Cloud Run allows manual deployments via UI or CLI (`gcloud run deploy`), but integrating into Cloud Build automates the process, reducing manual effort.

### Lab Demos
1. **Fixing Image Build Failures**:
   - Added logging and removed unnecessary dedicated logging.
   - Command: `git commit -m "updated main.py" && git push`
   - Triggered build, which failed due to IAM role propagation. Resolved by granting Viewer role to service account.
   - Verified success by checking Artifact Registry and GitHub commit status.

2. **Adding Approval to Pre-Deployment**:
   - In Cloud Build trigger: Enable "Require approval for builds created by this trigger" with role Cloud Build Approver.
   - Assigned role to user account.
   - Pushed code change (e.g., added H1 tag).
   - Build queued for approval. Demonstrated approval/rejection process, showing rejections include rejection reason from approver.

3. **Automated Deployment to Single Environment**:
   - Integrates deployment step in cloudbuild.yaml:
     ```
     - name: 'gcr.io/cloud-builders/gcloud'
       args: ['run', 'deploy', 'my-app', '--region=us-central1', '--allow-unauthenticated', '--image=${_ARTIFACT_REGISTRY_IMAGE}']
     ```
   - Pushed changes, approved build: Built image, deployed to Cloud Run, verified in UI.
   - Demonstrates Cloud Build's capability for single-environment automation without Cloud Deploy.

4. **Parallel Execution and Workspace Sharing**:
   - Explained how multiple steps run in isolated containers unless configured otherwise.
   - Used `/workspace` mount for sharing data between steps, e.g., building an artifact in one step and using it in another.
   - Configured via `workingDir` and options in cloudbuild.yaml for complex pipelines.

## Cloud Deploy for CD

### Overview
Cloud Deploy is a managed service for continuous delivery, supporting serverless deployments to GKE and Cloud Run. It enables multi-environment pipelines with native approval and rollback capabilities, providing a visual dashboard for tracking deployments across stages like dev, QA, and production.

### Key Concepts
- **Pipeline Structure**: Uses serial or parallel pipelines defined in YAML. Includes stages (e.g., dev, QA, prod) with associated targets (environments).
- **Targets and Profiles**: Targets specify regions and services (e.g., Cloud Run in us-central1). Profiles customize configurations per stage (e.g., CPU/memory for production).
- **Approval Gates**: Prompts for manual approval between stages (e.g., QA to prod). Supports rollback to previous releases without rebuilding.
- **Rollback vs. Reversion**: Rollback uses Cloud Run's traffic management; reversion requires pipeline reruns, incurring re-build and re-deployment costs.
- **Multi-Environment Management**: Enables promotion through environments. Incomplete without Cloud Deploy for rollback/customizations.
- **Comparison to Cloud Build**: Cloud Build excels in single environments; Cloud Deploy adds multi-stage, approval, and rollback features.
- **Supported Targets**: Native for Cloud Run and GKE; custom targets for VMs/Kubernetes via additional YAML.
- **Private Environments**: For private Kubernetes, use private worker pools running in specified regions/networks.

### Lab Demos
1. **Setting Up Cloud Deploy Pipeline**:
   - Created delivery pipeline (delivery-pipeline.yaml) with serial stages (dev, QA, prod).
   - Defined targets (e.g., us-west1 for dev, us-central1 for QA).
   - Created scaffold files: targets/manifests/profiles.
   - Applied pipeline: `gcloud deploy apply --file=delivery-pipeline.yaml --region=global`
   - Released initial image via Cloud Build integrated with Cloud Deploy.

2. **Multi-Stage Deployment**:
   - Promoted from dev (automatic) to QA (manual promotion, automatic deployment).
   - Approved for prod (manual promotion and approval, automatic deployment).
   - Verified across Cloud Run services with environment variables (e.g., "dev", "qa", "prod").
   - Demonstrated customization (e.g., scaling production with 2vCPU).

3. **Rollback Demonstration**:
   - Rolled back prod release: Selected previous release ID, rolled back via UI.
   - Result: Switched traffic without creating new images, preserving resources.

4. **Troubleshooting Issues**:
   - Discussed glitchy behavior in Cloud Deploy (e.g., unexpected failures).
   - Alternative: Use Cloud Run UI for traffic management as a fallback.

## Terraform Concepts and Infrastructure as Code

### Overview
Terraform is an open-source IaC tool supporting multi-cloud provisioning. It uses HashiCorp Configuration Language (HCL) for declarative infrastructure definitions, enabling versioned, reproducible deployments. This session introduces core concepts with hands-on GCS bucket creation, covering initialization, planning, applying, and destruction.

### Key Concepts
- **IaC Fundamentals**: Code-based infrastructure management; supports versioning, repeatability, and multi-cloud (AWS, Azure, GCP via providers).
- **Terraform Workflow**: `init` (setup providers), `plan` (dry-run), `apply` (deploy), `destroy` (remove). Uses state files for tracking.
- **Providers**: Plugins for cloud providers (e.g., Google for GCP). Downloaded during `init`.
- **Resources and Blocks**: Define resources (e.g., `google_storage_bucket`) with attributes; support modifications (in-place or recreate).
- **State Management**: Local state file tracks actual infrastructure; sensitive data handled via variables/secrets.
- **Comparison**: Prefer Terraform over GCP-native Deployment Manager for multi-cloud, maturity; supports CI/CD via Cloud Build.
- **Common Errors**: Propagation delays, state mismatches; auto-labeling distinguishes Terraform-managed resources.
- **Advanced Features**: Variables, modules, remote state; supports rollback via applies.

### Lab Demos
1. **Basic GCS Bucket Creation**:
   - Created `gcs.tf` with `google_storage_bucket` resource.
   - `terraform init`: Initialized provider (version-locked).
   - `terraform plan`: Reviewed changes (creation shown).
   - `terraform apply`: Deployed bucket; updated state.
   - Demonstrated in-place update (changed storage class).

2. **Destructive Changes**:
   - Modified location (required recreation): `terraform plan/apply` destroyed and recreated.
   - Handled state glitching (manual sync via backup).

3. **Cleanup and Patterns**:
   - `terraform destroy`: Removed resources.
   - Explained reusable code, CI/CD integration (e.g., Cloud Build with community Terraform image), and `.tf` patterns.

## Summary

### Key Takeaways
```diff
+ Cloud Build enables automated CI with GitHub visibility and approval gates for secure deployments.
- Manual approvals prevent unauthorized changes but require proper IAM roles; delays due to propagation.
! Cloud Deploy provides visual, reusable CD pipelines with rollback, ideal for multi-environment workflows.
+ Terraform offers powerful, declarative IaC supporting Git versioning and multi-cloud deployments.
- Resource limits and state sensitivity require careful management; prefer over GCP Deployment Manager.
! Combine tools: Cloud Build + Cloud Deploy for full CI/CD, Terraform for infrastructure.
```

### Quick Reference
- **Cloud Build Commands**: `gcloud builds submit`, `gcloud build triggers create` (enable approvals).
- **Cloud Deploy Commands**: `gcloud deploy apply`, `gcloud deploy releases promote`.
- **Terraform Commands**: `terraform init`, `terraform plan`, `terraform apply`, `terraform destroy`.
- **IAM Roles**: Cloud Build Approver, Cloud Run Deployer, Cloud Deploy Releaser.
- **Configuration Files**: `cloudbuild.yaml`, `delivery-pipeline.yaml`, `.tf` files (Owen carriers for Terraform).
- **Common Issues**: IAM propagation delays, state file mismatches, Cloud Deploy glitches.

### Expert Insight

**Real-world Application**: Use Cloud Build + Cloud Deploy for microservices deployments (e.g., promoting containerized apps from dev to prod). Terraform manages underlying infrastructure (e.g., buckets, VMs) in multi-cloud setups, reducing manual errors in enterprise CI/CD pipelines.

**Expert Path**: Master HCL variables/modules for reusable Terraform configurations. Explore GCP Image Builder for custom Cloud Build environments. Implement progressive delivery (e.g., canary deploys) with Cloud Deploy extensions.

**Common Pitfalls**: 
- Neglect IAM role propagation; test repeatedly after changes.
- Rely on UI for rollbacks when Cloud Deploy fails; use Cloud Run traffic management as backup.
- State file corruption during demos; always version state for recovery. Ignore Terraform CI/CD without proper provider images, leading to build failures.

**Lesser-Known Facts**: Terraform auto-labels resources for tracking; Cloud Deploy supports pause/resume for incident response. GCP Deployment Manager is deprecated; Terraform supports 500+ providers for hybrid clouds.

**Advantages and Disadvantages**:
- Advantages: Serverless, cost-effective for sporadic deployments; comprehensive integrations; visual tracking in Cloud Deploy; Git-friendly with Terraform for code reviews.
- Disadvantages: Cloud Deploy occasional instability; learning curve for Terraform HCL; requires IAM expertise; no native Windows/VM support without customizations.
