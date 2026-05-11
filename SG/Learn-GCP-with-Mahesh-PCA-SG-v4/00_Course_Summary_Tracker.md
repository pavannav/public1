# Course Study Guide Tracker
**Course**: Learn GCP with Mahesh Professional Cloud Architect
**Last Updated**: 2024-05-11

---

## Session Progress

| Session | Topic | Status | Notes |
|---------|-------|--------|-------|
| 01 | Introduction to Google Cloud, Free Trial Activation, Six ways to interact with Google Cloud | [x] Completed | Complete GCP introduction with all six interaction methods |
| 02 | Cloud SDK, Rest API - Curl, Postman, Terraform, Quiz, Cloud IAM - Identity, Roles Concept | [x] Completed | IAM fundamentals with authentication patterns |
| 03 | Demo on Principal of least Privilege, IAM Policy Binding, What & Why Organization | [x] Completed | Real-world IAM implementation examples |
| 04 | Demo on Policy Inheritance, Deny Policy, Service Account Concept - Part 1 | [x] Completed | Advanced policy management and service account basics |
| 05 | Service Account Deep Dive Concept | [x] Completed | Comprehensive service account security and authentication |

---

## Session Summaries

### Session 1: Introduction to Google Cloud Platform
- **Topics Covered**: GCP overview, Free Trial activation, Six interaction methods (Web Console, Cloud Shell, gcloud CLI, REST APIs, Postman, Terraform)
- **Key Concepts**: GCP services, authentication flows, API interactions, IaC fundamentals
- **Notable Commands**: curl API calls, gcloud auth, terraform init/plan/apply
- **Lab**: Hands-on demonstration of all six interaction methods using Cloud Storage

### Session 2: Cloud SDK, REST API, Terraform, and IAM Fundamentals
- **Topics Covered**: Cloud SDK (gcloud CLI), REST API patterns, Infrastructure as Code with Terraform, Cloud IAM concepts
- **Key Concepts**: Authentication hierarchies, client libraries, API debugging, role-based access control, basic roles (Owner/Editor/Viewer)
- **Notable Commands**: gcloud iam roles describe, terraform apply --auto-approve, gcloud auth print-access-token
- **Lab**: Multi-method authentication testing, Terraform VM deployment, custom role creation

### Session 3: Principle of Least Privilege, IAM Policy Binding, and Organization Hierarchy
- **Topics Covered**: Least privilege implementation, IAM policy binding mechanisms, resource hierarchy, custom roles
- **Key Concepts**: Role assignment strategies, policy inheritance patterns, service account user roles, organization structure
- **Notable Commands**: gcloud iam roles create, gcloud projects add-iam-policy-binding, gcloud organizations add-iam-policy-binding
- **Lab**: Progressive role refinement (Basic → Predefined → Custom), granular VM permissions, storage access limitations

### Session 4: Policy Inheritance, Deny Policy, and Service Accounts (Part 1)
- **Topics Covered**: Resource hierarchy policy flow, deny policy implementation, service account fundamentals, cross-project access
- **Key Concepts**: Policy inheritance rules, deny vs allow precedence, service account types, token management, VM service account attachment
- **Notable Commands**: gcloud organizations get-iam-policy, gcloud iam service-accounts keys create, gsutil iam ch
- **Lab**: Organization-level access testing, deny policy enforcement, bucket-level permissions, service account key management

### Session 5: Service Accounts Deep Dive
- **Topics Covered**: Service account authentication methods, key management security, workload identity federation, token management
- **Key Concepts**: Service account identity structure, ADC vs service account keys, workload federation, JSON key rotation, metadata service authentication
- **Notable Commands**: gcloud iam service-accounts keys create/delete/disable, export GOOGLE_APPLICATION_CREDENTIALS, gcloud auth activate-service-account
- **Lab**: Key management workflow, VM service account attachment, cross-cloud federation setup, token refresh patterns