<details open>
<summary><b>AWS IAM Introduction (KK-CS45-script-v2-Interview)</b></summary>

## What is AWS IAM?
**Authentication + Authorization service** that controls who can access which AWS resources.

### Example Scenario
- Company uses AWS with two applications: Email & Payroll
- Three users need different access levels:
  - **User A**: Regular employee - can access Email only
  - **User B**: HR - can access both Email and Payroll
  - **User C**: External person - access to neither

IAM authenticates users (verifies identity) and authorizes them (grants permissions) to specific applications.

### Quick Definition
AWS IAM is a **secure cloud-based service** that verifies users and controls access to AWS services and resources.

---

## What are Authentication and Authorization?

### Authentication (Who are you?)
Process of verifying user identity using credentials.

**Example Flow:**
1. Student opens school website
2. Website prompts for username/password
3. Student enters credentials
4. School database validates credentials
5. Returns: **Yes** or **No** access

**Definition:** Authentication is the process of verifying the identity of a user by validating their credentials (username and password).

### Authorization (What can you access?)
Process of allowing authenticated users access to specific resources based on their role.

**Example Flow:**
- After login to school website:
  - Student can view results but **cannot edit** them
  - Teacher can view **and edit** results
  - Student can pay fees but **cannot access** teacher payroll data

**Definition:** Authorization is the process of allowing the authenticated user only to access specific resources.

### Key Sequence
```
Authentication → Authorization
```
Authentication must succeed first; if it fails, authorization never happens.

---

## Key Difference: AWS IAM vs On-Premises Active Directory

| Aspect | AWS IAM | Active Directory (AD) |
|--------|---------|----------------------|
| **Type** | Cloud-native | On-premises |
| **Scope** | AWS resources only | Windows network machines/users |
| **Purpose** | Resource access control | Domain-based network management |
| **Focus** | Cloud permissions | Network policies, devices, users |

### Core Distinction
- **IAM**: Manages permissions for **AWS resources**, not physical machines
- **AD**: Manages users, devices, and policies in **Windows networks**

**Note:** Both serve similar identity management purposes (90% overlap), but IAM operates in the cloud while AD operates on-premises.

---

## Key Concepts Summary

1. **IAM provides**: Authentication + Authorization for AWS
2. **Authentication always precedes**: Authorization
3. **IAM is cloud-native**: Unlike on-premises Active Directory
4. **IAM focuses on**: Resource access, not machine/domain management

</details>