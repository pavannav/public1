# Session 1: How to Implement an Auto Expiry Service Account Key in GCP

## Table of Contents
- [Introduction](#introduction)
- [Accessing GCP Documentation](#accessing-gcp-documentation)
- [Generating Keys with OpenSSL](#generating-keys-with-openssl)
- [Uploading Public Key to GCP Console](#uploading-public-key-to-gcp-console)
- [Creating JSON Service Account Key](#creating-json-service-account-key)
- [Testing the Auto Expiry Feature](#testing-the-auto-expiry-feature)
- [Summary](#summary)

## Introduction

### Overview
Service account keys in Google Cloud Platform (GCP) are commonly used for programmatic access to GCP resources. However, standard service account keys do not have built-in expiration mechanisms, which can pose security risks if keys are compromised. This session demonstrates how to implement an auto-expiry feature for service account keys using public key upload functionality, allowing keys to automatically expire without manual deletion. This approach retains the service account for audit purposes and does not incur additional costs.

### Key Concepts / Deep Dive
- **Service Account Key Expiry Challenge**: Traditional service account keys remain valid indefinitely unless manually deleted, creating potential security vulnerabilities.
- **Auto Expiry Solution**: By uploading public keys with a validity period, you can create service account keys that automatically expire at a specified date/time.
- **Audit Benefits**: Expired keys remain visible in the console with their expiry timestamps, providing a historical log for auditing purposes.
- **Cost Implications**: Expired keys do not generate additional costs, making long-term retention feasible.
- **Preview Feature**: The native expiry functionality is currently in preview and requires organizational access via a Google form. The demonstrated approach uses alternative methods to achieve similar results.

## Accessing GCP Documentation

### Overview
The official GCP documentation provides information about service account key management features, including upcoming native expiry capabilities.

### Key Concepts / Deep Dive
- **Preview Features**: GCP is developing native expiry functionality for service accounts, currently available through a preview program.
- **Access Requirements**: To participate in the preview, users must be part of an organization and submit a Google form request.
- **Alternative Approach**: Since the presenter lacks organizational access, we use the "upload public keys" feature as a workaround.

> [!NOTE]
> The official documentation link showcases the upcoming preview feature for native service account key expiry.

> [!IMPORTANT]
> The preview feature requires organizational approval, so the manual public key upload method provides an immediate alternative implementation.

## Generating Keys with OpenSSL

### Overview
OpenSSL is used to generate private and public key pairs with a specified validity period. This creates the foundation for the auto-expiry service account key.

### Key Concepts / Deep Dive
- **Key Pair Generation**: OpenSSL generates both private and public keys that can be used for authentication.
- **Validity Period**: Specifying a duration (e.g., 1 day) ensures the key automatically expires after the set time.
- **File Outputs**: The process creates two files - a private key and a public key.

### Lab Demos
1. Access GCP Cloud Shell
2. Execute the OpenSSL command to generate keys:
   ```bash
   openssl req -x509 -newkey rsa:2048 -keyout private.pem -out public.pem -days 1 -nodes
   ```
   - **Key Parameters**:
     - `-x509`: Creates a self-signed certificate (public key)
     - `-newkey rsa:2048`: Generates a 2048-bit RSA private key
     - `-keyout private.pem`: Output file for private key
     - `-out public.pem`: Output file for public key
     - `-days 1`: Sets key validity to 1 day
     - `-nodes`: No passphrase on private key

3. Verify the generated files exist with two key files: `private.pem` and `public.pem`.

> [!WARNING]
> The `-days 1` parameter sets the key to expire after one day. Adjust this value according to your security requirements.

> [!NOTE]
> The generated keys follow standard X.509 certificate format and can be used for GCP service account authentication.

## Uploading Public Key to GCP Console

### Overview
The public key is uploaded to the GCP IAM console, which creates a service account key entry with the specified expiry date.

### Key Concepts / Deep Dive
- **Service Account Section**: Navigate to IAM & Admin > Service Accounts in the GCP console.
- **Upload Method**: Use "Upload an existing key" instead of "Create new key" for expiry functionality.
- **Key ID Generation**: GCP assigns a unique key ID upon successful upload.

### Lab Demos
1. Navigate to GCP Console > IAM & Admin > Service Accounts
2. Select an existing service account or create a new one
3. Click "Keys" tab > "Add Key" > "Upload an existing key"
4. Choose "Upload public key certificate" option
5. Copy and paste the content from the `public.pem` file into the certificate field
6. Click "Upload" to complete the process
7. Note the generated Key ID (e.g., displayed as the expiry date in the keys list)

> [!IMPORTANT]
> The key will appear in the service account keys list with its expiry date automatically calculated based on the uploaded certificate's validity period.

## Creating JSON Service Account Key

### Overview
The private key must be formatted into the standard GCP service account JSON key format, incorporating project and service account details.

### Key Concepts / Deep Dive
- **JSON Structure**: Service account keys follow a specific JSON schema with required fields.
- **Required Fields**: 
  - `type`: "service_account"
  - `project_id`: GCP project identifier
  - `private_key_id`: Unique key identifier from console
  - `private_key`: RSA private key in PEM format (single line)
  - `client_email`: Service account email address
  - `client_id`: Numeric service account identifier
- **Private Key Formatting**: The PEM private key must be converted from multi-line to single-line format.

### Lab Demos
1. Open the `private.pem` file and copy its contents
2. Format the private key for single-line usage:
   - Method 1: Use Notepad++ or text editor
   - Find/Replace: Replace `\n` (newlines) with empty string
   - Method 2: Use command line: `tr -d '\n' < private.pem`
3. Create JSON key structure:
   ```json
   {
     "type": "service_account",
     "project_id": "your-project-id",
     "private_key_id": "your-key-id-from-console",
     "private_key": "-----BEGIN PRIVATE KEY-----\n[BASE64_ENCODED_PRIVATE_KEY_CONTENT]\n-----END PRIVATE KEY-----",
     "client_email": "your-service-account@project.iam.gserviceaccount.com",
     "client_id": "numeric-service-account-id",
     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
     "token_uri": "https://oauth2.googleapis.com/token",
     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-service-account%40project.iam.gserviceaccount.com"
   }
   ```
4. Populate fields from GCP console:
   - `project_id`: Extract from console URL
   - `private_key_id`: From service account keys list
   - `client_email`: Service account email
   - `client_id`: Numeric identifier from service account details

5. Save the JSON file (e.g., `live-demo-key.json`)

> [!WARNING]
> Ensure the private key is copied between the `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----` markers only, excluding the markers themselves.

> [!NOTE]
> The JSON structure matches the format of keys generated through the standard GCP console method.

## Testing the Auto Expiry Feature

### Overview
The auto-expiry functionality is tested by activating the service account and observing its behavior after the expiry time.

### Key Concepts / Deep Dive
- **Validation**: Test that the key functions correctly during its validity period.
- **Expiry Behavior**: Keys become unusable after expiry but remain visible for auditing.
- **Audit Trail**: Expired keys provide historical records of creation and expiry dates.

### Lab Demos
1. Activate the service account using the generated JSON key:
   ```bash
   gcloud auth activate-service-account --key-file=live-demo-key.json
   ```
2. Verify activation:
   ```bash
   gcloud auth list
   ```
   - Confirm the service account appears as active
3. Monitor the expiry: After the validity period (1 day), the key will automatically expire
4. Observe console behavior: The expired key remains listed with its expiry timestamp
5. Attempt usage after expiry: The key will be non-functional for new authentications

> [!IMPORTANT]
> While the key expires automatically, no active sessions are forcibly terminated; only new authentication attempts will fail.

## Summary

### Key Takeaways
```diff
+ Auto-expiry allows service account keys to expire automatically without manual deletion
+ Public key upload method provides immediate expiry functionality without waiting for preview features
+ Expired keys remain for audit purposes with no additional cost
- OpenSSL key generation requires careful handling of expiry dates
- JSON key formatting must follow exact GCP schema requirements
! Regular key rotation should still be practiced for optimal security
```

### Quick Reference
**OpenSSL Key Generation (1-day expiry):**
```bash
openssl req -x509 -newkey rsa:2048 -keyout private.pem -out public.pem -days 1 -nodes
```

**Service Account Activation:**
```bash
gcloud auth activate-service-account --key-file=key.json
gcloud auth list
```

**JSON Key Structure:**
```json
{
  "type": "service_account",
  "project_id": "PROJECT_ID",
  "private_key_id": "KEY_ID",
  "private_key": "PRIVATE_KEY_CONTENT_SINGLE_LINE",
  "client_email": "SERVICE_ACCOUNT_EMAIL",
  "client_id": "CLIENT_ID"
}
```

### Expert Insight

**Real-world Application**: Use auto-expiry keys in development environments or temporary access scenarios to automatically limit credential lifespan without manual management overhead. Critical for environments with strict security policies requiring regular credential rotation.

**Expert Path**: Master certificate management with tools like OpenSSL and learn advanced GCP IAM policies to combine auto-expiry with conditional access. Study X.509 certificate standards and RSA key generation best practices for enterprise deployments.

**Common Pitfalls**: 
- Avoid hardcoding expiry dates in automation without considering timezone differences
- Prevent accidental key deletion during active sessions by understanding that expiry doesn't terminate existing auth
- Mistake of using expired keys in critical production scripts - always validate key status before deployment

**Lesser-Known Facts**: Service account keys can be associated with external identities, allowing expiry behavior to apply to federated authentication scenarios. GCP maintains key metadata even after expiry, enabling detailed audit trails for compliance reporting.

**Advantages and Disadvantages**:
```diff
+ Advantages: Automatic security enforcement, audit trail preservation, no manual cleanup required, flexible validity periods
- Disadvantages: Requires manual tooling (OpenSSL), not integrated with all GCP services seamlessly, preview feature dependency for native implementation, potential migration challenges when native feature becomes GA
```
