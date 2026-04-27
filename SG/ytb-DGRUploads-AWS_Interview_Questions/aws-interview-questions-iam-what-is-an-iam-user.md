# AWS_Interview_questions _ IAM _ What is an IAM user

## Question 1: What is an IAM user?

**Answer:**  
IAM users are entities used to share an AWS account with multiple users within the same account (not separate AWS accounts). They allow multiple team members to access the same AWS account by defining specific permissions for each user, such as console or CLI access. 

When creating an IAM user, you can specify the type of access (console or CLI) and assign appropriate credentials that users can use to log into the AWS account. The primary purpose of IAM users is to enable secure sharing of an AWS account across an organization or team, granting tailored permissions to each user based on their role.

For example, in an enterprise setup with multiple people needing access, IAM users facilitate account sharing without creating separate accounts for each individual.

**Note:**  
The explanation is accurate and aligns with AWS IAM best practices. For better security, it's recommended to attach IAM policies instead of inline permissions for easier management. Additionally, AWS suggests using IAM roles over IAM users where possible for temporary credential access, especially in automated scenarios.

```bash
# Example CLI command to create an IAM user (for reference, not part of transcript)
aws iam create-user --user-name SampleUser
```

![IAM User Concept Diagram](images/iam-user-overview.png)  

*Figure 1: Visual representation of IAM users sharing a single AWS account, with defined permissions and access types.*  

## Additional Notes
- This covers basic IAM user concepts as discussed in interview preparation.
- Common follow-up questions might include differences between IAM users and roles, or best practices for managing IAM users in production environments.
