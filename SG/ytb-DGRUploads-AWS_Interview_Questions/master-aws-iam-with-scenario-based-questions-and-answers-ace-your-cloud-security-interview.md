# Master AWS IAM with Scenario-Based Questions and Answers _ Ace Your Cloud Security Interview!

## **Question 1: Managing Multiple AWS Accounts and Granting Permissions to Users Across Them Securely**

You have multiple AWS accounts in your organization and need to grant permissions to your users across these accounts securely.

**Answer:** Use AWS Organizations service to centrally manage multiple AWS accounts. This provides consolidated billing and allows setting up cross-account IAM access. Create cross-account IAM roles that users can assume to access resources in other accounts within the organization.

**Note:** This approach is correct. AWS Organizations is the standard service for multi-account management. Ensure roles follow the principle of least privilege and use AWS Organizations Service Control Policies (SCPs) to define organizational-level permission boundaries for additional security.

## **Question 2: Providing Temporary Access to an S3 Bucket for a Developer to Troubleshoot an Issue**

A developer needs access to an S3 bucket for a limited time to troubleshoot an issue. How can you provide temporary access without sharing long-term credentials?

**Answer:** Create an IAM role with the necessary S3 permissions and use AWS Security Token Service (STS) to generate temporary credentials. Associate the role with the developer for a specific duration, and the credentials will automatically expire after the session ends.

**Note:** Correct. This follows AWS security best practices. Consider using AWS IAM Identity Center (formerly AWS SSO) for centralized temporary access management in larger organizations.

<!-- If applicable, insert image: images/q2_iam_sts_diagram.png showing IAM role, STS, and temporary credentials flow -->

## **Question 3: Enforcing MFA for All IAM Users**

You want to ensure that all IAM users in your AWS account have Multi-Factor Authentication (MFA) enabled.

**Answer:** Create an IAM policy that requires MFA and attach it to all IAM users. Additionally, require users to enable MFA when creating their accounts.

**Note:** Partially correct. The standard approach is to create IAM password policies that require MFA and attach MFA-checking condition policies (like `aws:MultiFactorAuthPresent`) to controlled resources. The root account should always have MFA enabled.

<!-- If applicable, insert image: images/q3_mfa_enforcement.png showing MFA policy structure in IAM console -->

## **Question 4: Reducing Administrative Overhead for Managing a Large Team of Developers**

You're managing a large team of developers and want to reduce the administrative overhead of managing IAM users individually.

**Answer:** Implement AWS Single Sign-On (SSO) service, specifically AWS IAM Identity Center, to centrally manage users and permissions. Integrate with your existing identity provider for simplified user management.

**Note:** Correct. AWS IAM Identity Center (successor to AWS SSO) provides centralized access management. This is particularly effective for managing access across multiple AWS accounts.

## **Question 5: Granting Permissions to a Lambda Function to Access an S3 Bucket**

A Lambda function needs access to resources in an S3 bucket. How can you grant these permissions securely?

**Answer:** Create an IAM role with the necessary S3 permissions and attach it to the Lambda function. By default, AWS services cannot communicate, so the role provides the required access without sharing credentials.

**Note:** Correct. This is the standard execution role pattern for Lambda. Ensure the role follows least privilege - grant only the minimum required S3 actions (e.g., s3:GetObject, s3:PutObject).

<!-- If applicable, insert image: images/q5_lambda_execution_role.png showing execution role attachment to Lambda -->

## **Question 6: Providing Temporary Access to an External Contractor**

You need to provide an external contractor with temporary access to your environment securely.

**Answer:** Create an IAM user with least privilege permissions and set an expiration date. Provide temporary credentials, and disable/delete the user once their work is complete.

**Note:** Correct for temporary user access. For better security, consider using AWS IAM Identity Center with temporary permissions or federated access instead of creating IAM users. Always monitor usage and revoke access promptly after work completion.

## **Question 7: Restricting Access to EC2 Instances Based on Tags**

You want to restrict access to certain EC2 instances based on specific tags (e.g., Environment=Production).

**Answer:** Create custom IAM policies with conditions that check EC2 instance tags before granting permissions. Attach these policies to users or roles to restrict access to only tagged instances.

**Note:** Correct. Use condition keys like `ec2:ResourceTag/Environment` in IAM policies. This implements Attribute-Based Access Control (ABAC). Combine with AWS Organizations SCPs for organizational-level enforcement.

<!-- If applicable, insert image: images/q7_tag_based_access_control.png showing policy conditions in IAM -->

## **Question 8: Implementing IAM Policies to Isolate Access Between Departments**

Your organization has multiple departments, each with its own AWS resources. How can you implement IAM policies to isolate access between departments?

**Answer:** Use AWS Organizations and Service Control Policies (SCPs) to restrict access between AWS accounts. Attach SCPs to Organizational Units (OUs) containing departmental accounts to control permissions at the organizational level.

**Note:** Correct. SCPs provide guardrails for permissions. Combine with cross-account IAM roles for necessary inter-departmental access, always following least privilege principles.

## **Question 9: Enforcing Instance Size Restrictions for Developers**

You want to enable developers to launch EC2 instances for development but prevent them from creating overly large instances (e.g., restrict to t2.medium only).

**Answer:** Create IAM policies with conditions that limit instance types based on the `ec2:InstanceType` condition key. Attach these policies to developer IAM users or roles.

**Note:** Correct. This prevents resource abuse. For more granular control, consider AWS Service Catalog or AWS Budgets to limit resource allocation costs.

<!-- If applicable, insert image: images/q9_instance_type_restriction.png showing policy with instance type conditions -->

## **Question 10: Securing RDS Database Credentials for an Application**

An application needs to access an RDS database securely, keeping credentials secret and rotating them regularly.

**Answer:** Use AWS Secrets Manager to store and manage RDS database credentials. Enable automatic rotation (e.g., every 30 days) and grant the application's IAM role permissions to access these secrets.

**Note:** Correct. Secrets Manager provides secure credential storage and rotation. Enable database credential rotation natively supported for RDS. This eliminates hardcoded credentials in application code.

<!-- If applicable, insert image: images/q10_secrets_manager_rotation.png showing Secrets Manager integration with RDS -->

## Images Folder

All referenced images (if created) would be placed in an `images/` folder at the root level of this Markdown file's directory. Image filenames follow the convention `q<number>_<brief_description>.png`.

<summary>CL-KK-Terminal</summary>
