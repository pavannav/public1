# AWS_Interview_Question _ IAM _ What are IAM policies

## Question 1: What are IAM policies?

**Answer:** IAM policies are JSON documents that define the permissions for IAM users or other entities in an AWS account. They specify what actions the users can take when they log into the AWS account. For example, when creating IAM users, policies control what they can do within the account, allowing administrators to manage access securely.

**Note:** The answer is correct and comprehensive. No better suggestions needed; it's well-explained.

## Question 2: What are the different types of IAM policies?

**Answer:** IAM policies are divided into two main types: managed policies and inline policies.

- **Managed Policies** are reusable policies that can be attached to multiple users, groups, or roles.
  - **AWS Managed Policies**: These are pre-built and maintained by AWS. They cover common use cases and are automatically updated by AWS.
  - **Customer Managed Policies**: These are created and managed by the customer (user). Customers are responsible for maintaining them.

- **Inline Policies** are policies that are embedded directly into a user, group, or role, making them unique to that specific resource. They cannot be reused.

![IAM_Policy_Types](images/iam_policy_types.png)

**Note:** The answer accurately describes the types. For clarity, managed policies are preferred over inline for reuse, while inline provides more granularity but less manageability. The diagram above illustrates the hierarchy.

## Summary
<summary>
Trainer explained IAM policies comprehensively, covering definitions and categorization.
MODEL ID: CL-KK-Terminal
</summary>
