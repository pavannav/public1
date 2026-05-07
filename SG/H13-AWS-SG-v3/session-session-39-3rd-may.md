# Session 39: AWS Cognito Introduction

## Table of Contents
- [Review of Yesterday's Session (Lambda Edge)](session_39_AWS_Cognito_Introduction.md#review-of-yesterdays-session-lambda-edge)
- [Introduction to AWS Cognito](session_39_AWS_Cognito_Introduction.md#introduction-to-aws-cognito)
- [Understanding Identity and Access Management (IAM)](session_39_AWS_Cognito_Introduction.md#understanding-identity-and-access-management-iam)
- [Cognito User Pools vs AWS IAM](session_39_AWS_Cognito_Introduction.md#cognito-user-pools-vs-aws-iam)
- [Cognito User Pool Setup](session_39_AWS_Cognito_Introduction.md#cognito-user-pool-setup)
- [User Pool Authentication Flow](session_39_AWS_Cognito_Introduction.md#user-pool-authentication-flow)
- [Integration with API Gateway](session_39_AWS_Cognito_Introduction.md#integration-with-api-gateway)
- [Tokens and Authorization](session_39_AWS_Cognito_Introduction.md#tokens-and-authorization)
- [Demo: Cognito User Pool Creation](session_39_AWS_Cognito_Introduction.md#demo-cognito-user-pool-creation)
- [Demo: API Gateway Integration](session_39_AWS_Cognito_Introduction.md#demo-api-gateway-integration)
- [Summary](session_39_AWS_Cognito_Introduction.md#summary)

## Review of Yesterday's Session (Lambda Edge)

### Overview
In the previous session, you learned about AWS Lambda@Edge, a powerful service that allows running AWS Lambda functions at CloudFront edge locations to optimize content delivery and enhance web application performance.

### Key Concepts
Lambda@Edge enables developers to implement A/B testing by routing different user requests to different versions of applications. Lambda functions at the edge can check for cookies in request headers to determine which website version to serve.

### Demonstration Elements Covered
- Hosting two websites on S3 (new and old versions)
- Creating Lambda functions triggered by CloudFront events
- Using cookies for user choice persistence (cookie name: "website_choice" with values "new" or "old")
- Configuring S3 buckets with static website hosting
- Setting up CloudFront distributions with proper origins
- Lambda Edge deployment process
- Cache key settings and hit validation

## Introduction to AWS Cognito

### Overview
AWS Cognito is a fully managed identity and access management service for customer applications, providing user directory management, authentication, and authorization capabilities. It eliminates the need for developers to build custom authentication systems while ensuring security best practices.

### Key Concepts
- **Customer Identity Management**: Handles authentication and authorization for customer-facing applications
- **Serverless Service**: Fully managed by AWS with built-in scalability
- **Security Features**: Supports MFA, password policies, and federated identities
- **Integration Capabilities**: Works seamlessly with other AWS services like API Gateway, Lambda, and social identity providers

## Understanding Identity and Access Management (IAM)

### Overview
Identity and Access Management involves controlling who (authentication) can access what (authorization) resources. AWS provides IAM for internal AWS service access, while Cognito serves customer-facing applications.

### Authentication vs Authorization
- **Authentication**: Verifying user identity through credentials (username/password, tokens, etc.)
- **Authorization**: Determining what resources and actions authenticated users can access

### Real-world Example
Just as Zoom requires user authentication before granting access to meetings, video streaming, or webinars, web applications need secure user management systems.

## Cognito User Pools vs AWS IAM

### Key Differences

| Aspect | AWS IAM | AWS Cognito |
|--------|---------|-------------|
| **Primary Use Case** | AWS service access for IT/cloud teams | Customer application access management |
| **User Management** | Limited scalability (not designed for millions of users) | Highly scalable for millions of customers |
| **Authentication Methods** | AWS-specific credentials | Email, phone, social providers, MFA |
| **Token Management** | AWS access keys and session tokens | ID tokens, access tokens, refresh tokens |
| **Integration Scope** | AWS cloud infrastructure | Customer-facing applications |

### When to Use Each Service
- Use IAM for managing access to AWS services (EC2, S3, Lambda) by your organization's IT/admin teams
- Use Cognito for customer-facing applications where users need to sign up, sign in, and access application resources

## Cognito User Pool Setup

### User Pool Components

#### Identity Providers
- **Cognito User Pool**: AWS-hosted user database
- **Third-party Providers**: Google, Facebook, Apple, SAML, LDAP/Active Directory
- **Federated Identities**: Identity federation without storing credentials locally

#### Authentication Features
- **Sign-up/Sign-in Options**: Email, phone number, username
- **Password Policies**: Minimum length, complexity requirements, temporary password handling
- **Multi-Factor Authentication**: SMS-based or authenticator apps
- **Account Recovery**: Email or SMS-based password reset

#### User Attributes
- **Standard Attributes**: Email, phone number, name, birthdate, gender
- **Custom Attributes**: Additional user-specific data (up to 40 attributes total)
- **Verification Requirements**: Email or SMS verification for account creation

#### Messaging Configuration
- **Email Services**: AWS Simple Email Service (SES) for production
- **In-built Messaging**: Limited daily quota for testing

## User Pool Authentication Flow

### Sign-up Process
1. User provides required information (email, password, additional attributes)
2. Verification code sent via email/SMS
3. Account confirmation completes the sign-up

### Sign-in Process
1. User enters credentials (email/password)
2. Cognito validates against stored user pool
3. Successful authentication generates tokens

### Hosted UI Benefits
AWS provides pre-built, customizable login pages eliminating development time while maintaining security standards.

## Integration with API Gateway

### Authorization Setup
API Gateway can be configured to require authentication before allowing access to backend resources like Lambda functions.

### Cognito Authorizer Configuration
- **Authorizer Type**: Cognito User Pools
- **Token Source**: HTTP header containing access tokens (commonly `Authorization`)
- **User Pool Selection**: Specific Cognito user pool for validation
- **Scope Management**: Email-based or custom attribute-based user identification

## Tokens and Authorization

### Token Types

| Token Type | Purpose | Description |
|------------|---------|-------------|
| **ID Token** | Identity Proof | Contains user identity information and is meant for client applications |
| **Access Token** | Resource Access | Grants access to protected resources and APIs |
| **Refresh Token** | Token Renewal | Used to obtain new access tokens without re-authentication |

### Authorization Flow
1. User authenticates with Cognito
2. Cognito issues tokens (ID token, access token)
3. Client application includes access token in API requests
4. API Gateway validates token with Cognito
5. Valid requests proceed to backend services; invalid requests are denied

## Demo: Cognito User Pool Creation

### Step-by-Step Configuration

#### 1. User Pool Basics
```yaml
# Provider Type: Cognito User Pool
Sign-in Options:
  - Email
  - Phone
Password Policy:
  Minimum Length: 8 characters
  Complexity: Uppercase, lowercase, numbers, symbols
Multi-Factor Authentication: Disabled (for demo)
```

#### 2. Sign-up Experience
```yaml
# Enable Sign-up
Verification Method: Email
Required Attributes:
  - email
  - given_name
  - family_name
Additional Attributes:
  - gender
  - custom:reference (string, nullable)
```

#### 3. Messaging Setup
```yaml
# SES Configuration (Production)
# OR Cognito built-in (Testing - 50 emails/day limit)
From Email Address: no-reply@yourdomain.com
Reply-To: support@yourdomain.com
```

#### 4. App Client Configuration
```yaml
# App Client Name: my-app-client
# Generate client secret: No
# Access token and ID token settings
# OAuth 2.0 Grants: Authorization code, Implicit
Callback URLs:
  - https://your-api-gateway-url.amazonaws.com/prod/
Sign-out URLs:
  - https://your-application-signout-page.com
```

#### 5. Hosted UI Customization
```yaml
# Domain: Cognito domain (e.g., myapp-test.auth.region.amazoncognito.com)
# OR Custom domain with SSL certificate
```

### Key Implementation Steps
1. Navigate to AWS Cognito service
2. Create User Pool with appropriate settings
3. Configure authentication policies
4. Set up Hosted UI domain
5. Configure app client settings
6. Update callback URLs after creating API Gateway endpoints

## Demo: API Gateway Integration

### API Gateway Authorizer Creation
```yaml
# Authorizer Name: CognitoAuthorizer
# Type: Cognito
# Cognito User Pool: [Select your user pool]
# Token Source: Authorization (header)
```

### Resource Method Configuration
```yaml
# Method Request Settings
Authorization: CognitoAuthorizer
```

### Endpoint Security Implementation
```bash
# Before: Public API access
curl https://your-api-gateway-url.amazonaws.com/prod/hello
# Returns: Hello from Lambda

# After: Requires authentication
curl https://your-api-gateway-url.amazonaws.com/prod/hello
# Returns: {"message": "Unauthorized"}
```

### Token-Based Access
```bash
# Include access token in header
curl -H "Authorization: Bearer [ACCESS_TOKEN]" \
     https://your-api-gateway-url.amazonaws.com/prod/hello
# Returns: Hello from Lambda (authenticated)
```

### Testing Authentication Flow
1. Access Cognito Hosted UI
2. Complete sign-in process
3. Obtain access token
4. Make authenticated API request using token in header
5. Verify protected resource access

> [!NOTE]
> In production environments, implement automatic token handling using AWS Amplify or custom authentication middleware to avoid manual token extraction.

## Summary

### Key Takeaways
```diff
+ AWS Cognito provides secure, scalable user management for customer-facing applications
+ Eliminates the need for custom authentication code, reducing security risks
+ Integrates seamlessly with API Gateway for protecting backend services
+ Supports multiple authentication methods including social providers and MFA
+ Hosted UI simplifies implementation while maintaining security standards
- IAM and Cognito serve different purposes - don't confuse internal vs. customer identity management
- Token management is crucial for secure API access
- Production deployments require proper email service configuration (AWS SES)
```

### Quick Reference

**Common Cognito Commands:**
```bash
# User Pool Creation CLI (conceptual)
aws cognito-idp create-user-pool \
  --pool-name "MyUserPool" \
  --policies 'PasswordPolicy={MinimumLength=8,RequireUppercase=true}' \
  --auto-verified-attributes email

# List User Pools
aws cognito-idp list-user-pools --max-results 10

# Create User Pool Client
aws cognito-idp create-user-pool-client \
  --user-pool-id us-east-1_XXXXXXXXX \
  --client-name MyAppClient
```

**API Gateway Integration:**
- Authorizer Type: Cognito User Pools
- Token Source: `Authorization` header
- Expected Token Format: `Bearer <access_token>`

**Token Sources:**
- Hosted UI URL for authentication: `https://domain.auth.region.amazoncognito.com/login`
- Response types: `code` (standard), `token` (implicit grant)

### Expert Insight

#### Real-world Application
Cognito is ideal for mobile apps, web applications, and IoT solutions requiring user authentication. It's commonly used in e-commerce platforms, SaaS applications, and streaming services where secure user management is critical.

#### Expert Path
- Master OAuth 2.0 and OpenID Connect standards for advanced integration
- Learn Cognito Identity Pools (federated identities) for cross-service access
- Explore advanced security features like adaptive authentication
- Understand token validation and refresh strategies for long-lived sessions

#### Common Pitfalls
- Using IAM for customer authentication instead of Cognito
- Not implementing proper token validation in API Gateway
- Exceeding SES limits in production without proper configuration
- Improper callback URL setup leading to authentication failures
- Storing sensitive data in custom attributes without encryption

#### Lesser-Known Facts
- Cognito can handle up to 100 user pools per AWS account
- User pool data can be exported for backup and compliance purposes
- Cognito supports webhooks for custom authentication flows
- Identity pools extend user pools to grant temporary AWS credentials for service access

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
