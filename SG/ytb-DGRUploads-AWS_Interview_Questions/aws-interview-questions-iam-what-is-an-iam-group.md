# AWS Interview Questions: IAM - What is an IAM Group?

## Question: What is an IAM Group?

**Answer:**
In AWS Identity and Access Management (IAM), an IAM Group is a collection of IAM users that allows you to manage permissions for multiple users at once. Instead of assigning permissions individually to each user—which can become cumbersome when managing many users—you can create a group, add users to it, and attach policies to the group. All users in the group automatically inherit the permissions from the policies attached to the group.

This approach simplifies permission management by centralizing policy assignments. For example, if you have 10 users needing the same permissions, you can create a group (such as "CloudEngineer", "DevOps", or "AWSAdmins"), add the users to it, and manage permissions from one place.

It's a recommended best practice to add IAM users to groups rather than assigning permissions directly at the user level.

**Note:**
The explanation is accurate and aligns with AWS IAM best practices. IAM groups indeed allow attaching policies at the group level for easier management. However, note that users can still have individual policies attached directly if needed, and group permissions don't override explicit denies. Also, the transcript used "IM" (typo for "IAM") and referred to "I am users" which should read "IAM users".

<summary>CL-KK-Terminal</summary>
