# Section 10: AWS Identity and Access Management (IAM)

<details open>
<summary><b>Section 10: AWS Identity and Access Management (IAM) (CL-KK-Terminal)</b></summary>

## Table of Contents

- [10.1 AWS Identity and Access Management (IAM)](#101-aws-identity-and-access-management-iam)
  - [Overview](#overview)
  - [Key Concepts/Deep Dive](#key-concepts-deep-dive)
  - [Lab Demo: Creating and Logging into an IAM User](#lab-demo-creating-and-logging-into-an-iam-user)
  - [Summary](#summary)

## 10.1 AWS Identity and Access Management (IAM)

### Overview

AWS Identity and Access Management (IAM) is a web service that enables secure control over access to AWS resources by managing users, permissions, and credentials. It is designed to replace the practice of sharing root user accounts, which poses significant security risks, as illustrated through a real-world scenario involving a company's migration to AWS. By creating individual user accounts with specific permissions, IAM allows organizations to assign granular access rights, ensuring that team members can only perform authorized actions on AWS services.

### Key Concepts/Deep Dive

#### Fundamentals of IAM
IAM addresses the need for secure access management in AWS environments. It solves the problem of shared root user accounts, which make it difficult to track actions and maintain accountability. Without IAM, multiple users accessing a single account can lead to unauthorized changes, such as terminating instances, with no clear audit trail.

#### Real-World Scenario: Global Tech Solutions
Consider Global Tech Solutions migrating their on-premises infrastructure to AWS. The Chief Tech Officer (CTO) creates the AWS account as the root user, granting unlimited access to all services, billing, and support. However, the CTO cannot manage thousands of servers alone and hires specialists: an EC2 Mastermind for EC2 instances and a VPC Visionary for networking components like Virtual Private Clouds (VPCs).

- **Problem with Shared Accounts**: Sharing the root user's credentials violates AWS security best practices. If multiple users access the same account, it's challenging to identify who performed actions like terminating instances.
- **IAM Solution**: IAM enables creating separate user accounts for each specialist with personalized usernames, passwords, and permissions. EC2 Mastermind accesses only EC2-related resources, while VPC Visionary handles VPC configurations, preventing cross-service interference.

#### Definition of IAM
IAM is a web service for securely controlling access to AWS resources through user management, permissions, and credentials. It supports creating users, groups, policies, and roles to tailor access without compromising security.

#### IAM Components (Introduced in the Demo)
- **Users**: Individual accounts for login (e.g., EC2 Mastermind).
- **Groups**: Collections of users sharing permissions (not covered in this video but mentioned as a way to assign permissions).
- **Policies**: Documents defining permissions (permissions discussed briefly as needing to be attached for user functionality).
- **Roles**: Temporary access mechanisms (not detailed here).

#### Security Considerations
- **Root User Protection**: The root user has unrestricted access and should be used cautiously, ideally via IAM users for daily operations.
- **Account Security**: AWS recommends enabling multi-factor authentication (MFA) and avoiding sharing credentials.
- **Compliance**: IAM helps meet regulatory requirements by ensuring least-privilege access.

### Lab Demo: Creating and Logging into an IAM User

This section provides step-by-step instructions for creating an IAM user and logging in, based on the demonstrated process.

1. **Log into AWS Console as Root User**:
   - Navigate to the AWS Sign-In page.
   - Select "Root user" and enter the email and password used for account creation.
   - ⚠ **Caution**: Root user access is unrestricted; handle credentials carefully.

2. **Access IAM Service**:
   - Search for "IAM" in the AWS Management Console.
   - Navigate to the IAM Dashboard.

3. **Create a New IAM User**:
   - Go to the "Users" section.
   - Click "Create user".
   - Enter a username (e.g., "ec2mastermind"; case-insensitive).
   - Select "Provide user access to the AWS Management Console" (skip Identity Center for now).
   - Set a custom password: Ensure it meets AWS requirements (minimum 8 characters, including uppercase, lowercase, numbers, and symbols).
   - Uncheck "User must create a new password at next sign-in" for this demo.
   - Click "Next".

4. **Assign Permissions** (Not Applied in Demo):
   - IAM users start with no permissions; you can add them via groups, copied permissions, or direct policy attachment.
   - For now, proceed without permissions to demonstrate login.
   - Click "Next" and then "Create User".

5. **Obtain Sign-In Information**:
   - After creation, note the sign-in URL (includes Account ID, e.g., `https://[Account-ID].signin.aws.amazon.com/console`).
   - Optionally, create an alias for the account (e.g., company name) to hide the Account ID and create a simplified URL like `https://[alias].signin.aws.amazon.com/console`.

6. **Log In as the IAM User**:
   - Open an incognito/window tab.
   - Paste the sign-in URL and enter the Account ID (if using default URL) or proceed with the alias URL.
   - Enter the username ("ec2mastermind") and the assigned password.
   - Upon first login, dismiss any on-screen instructions (e.g., click "Done").
   - Verify login: The console shows the username (e.g., "EC2 Mastermind @ CloudFox Hub").

7. **Verify Permissions (No Access)**:
   - Navigate to EC2 or VPC services.
   - Attempt actions like viewing instances or creating VPCs: You will receive "Unauthorized" or API errors, confirming the user lacks permissions.
   - This demonstrates IAM's security model – users have no default access.

8. **Sign Out**:
   - Use the dropdown in the top-right corner to sign out.
   - Return to the root user session for further administration.

💡 **Key Demo Insights**: The demo emphasizes that IAM users are distinct from root users and require explicit permissions to access AWS resources. In real scenarios, attach policies (covered in future videos) to enable functionality.

### Summary

#### Key Takeaways
```diff
+ IAM enables secure, granular access control to AWS resources, replacing insecure shared root accounts.
+ Root users have unlimited access and should limit usage to account setup; create IAM users for operational tasks.
+ IAM users start with no permissions, promoting the principle of least privilege.
+ Practical implementation includes setting up users, managing sign-in URLs, and verifying access.
- Avoid sharing root credentials, as it complicates audit trails and increases security risks.
- IAM users without attached policies cannot perform actions in AWS services like EC2 or VPC.
! Always create complex passwords and consider MFA for heightened security.
```

#### Quick Reference
- **Sign-In URLs**:
  - Default: `https://[12-digit-Account-ID].signin.aws.amazon.com/console`
  - With Alias: `https://[your-alias].signin.aws.amazon.com/console` (e.g., `https://globaltech.signin.aws.amazon.com/console`)
- **Key IAM Navigation**: AWS Console → Search "IAM" → Users → Create User.
- **Password Requirements**: Minimum 8 characters (uppercase, lowercase, numbers, symbols).
- **Common Error**: "Unauthorized" when accessing services without permissions.

#### Expert Insight
- **Real-World Application**: In enterprise environments, use IAM to onboard team members with role-based access (e.g., developers access only development environments). Integrate with AWS Organizations for multi-account setups and AWS SSO for seamless logins across accounts.
- **Expert Path**: Master IAM by studying AWS Managed Policies, custom policy creation using JSON, and integration with AWS IAM Access Analyzer for automated permission reviews. Practice building least-privilege models and automating user provisioning via Infrastructure as Code (IaC) tools like AWS CloudFormation or Terraform.
- **Common Pitfalls**: Granting excessive permissions upfront (e.g., AdministratorAccess to new users), neglecting MFA on root and IAM users, and exposing Account IDs in documentation or bookmarks. Always audit permissions using CloudTrail and avoid hardcoding credentials in scripts.

</details>
