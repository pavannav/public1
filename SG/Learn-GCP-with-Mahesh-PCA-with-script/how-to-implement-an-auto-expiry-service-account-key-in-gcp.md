Session: How to implement an Auto Expiry Service Account Key in GCP

Table of Contents
- [Introduction](#introduction)
- [Documentation Review](#documentation-review)
- [Generating Keys with Expiry](#generating-keys-with-expiry)
- [Uploading Public Key to Service Account](#uploading-public-key-to-service-account)
- [Manipulating Private Key](#manipulating-private-key)
- [Creating JSON Key Structure](#creating-json-key-structure)
- [Activating and Testing the Service Account](#activating-and-testing-the-service-account)
- [Summary](#summary)

## Introduction

### Overview
Service account keys in Google Cloud Platform (GCP) are essential for authentication in applications and scripts, but native expiration functionality for these keys has been limited. This session demonstrates a workaround to implement auto-expiry for service account keys using OpenSSL-generated keys with custom expiry dates. This approach ensures keys expire automatically without manual deletion while preserving the service account for auditing purposes. The benefit includes non-intrusive key management that retains historical records (e.g., creation and expiration dates) at no additional cost, supporting compliance and traceability in production environments.

### Key Concepts/Deep Dive
- **Service Account Fundamentals**: Service accounts in GCP are used for programmatic access to resources through keys (JSON or P12 format). Keys don't natively expire, requiring manual rotation or deletion to mitigate security risks.
- **Expiry Challenges**: Traditional keys lack expiration dates, leading to potential over-permissioning if forgotten. Deletion impacts auditing as logs of expired keys are lost.
- **Proposed Solution**: Use OpenSSL to generate keys with embedded expiry dates (via `-days` parameter), then upload the public key to GCP's service account management. This creates a key that GCP recognizes as expirable, activating auto-expiry.
- **Benefits for Auditing**: Expired keys remain visible in the GCP console, providing a log of when the key was active versus compliant (non-active after expiry).
- **Prerequisites**: Access to GCP console, Cloud Shell, OpenSSL for key generation, and a text editor (e.g., Notepad++ for key manipulation).

> [!NOTE]
> This method is a preview feature in GCP at the time of recording, accessible via an organization-linked Google form. For individual users, the OpenSSL approach provides a functional alternative.

## Documentation Review

### Overview
The official GCP documentation outlines a native expiry feature for service account keys in preview mode. However, accessing it requires organization membership via a Google form. This section reviews the documentation and introduces the OpenSSL-based implementation as a fallback for users without organizational access.

### Key Concepts/Deep Dive
- **Native GCP Expiry Feature**: Scheduled for general availability, this allows setting expiry times directly in the GCP console. Preview access is available through a form link (shared in video description).
- **Limitations of Native Feature**: Restricted to organizational accounts; non-organizational users cannot access it currently.
- **Alternative Approach**:
  - Use OpenSSL to create RSA keys with integrated validity periods.
  - Upload the public portion to GCP to enable expiry recognition.
  - Generate JSON keys manually for compatibility with GCP authentication.

  This approach leverages standard cryptographic tools to achieve similar results programmatically.

> [!IMPORTANT]
> Always verify the latest GCP IAM documentation for feature availability, as preview features may change or become generally available.

## Generating Keys with Expiry

### Overview
Key generation begins with OpenSSL to create RSA key pairs with a specified validity period. This ensures the keys have a built-in expiry date, which GCP can detect and enforce.

### Key Concepts/Deep Dive
- **OpenSSL Command Syntax**:
  - Generate keys with RSA algorithm and specify expiry in days.
  - The `-days` parameter sets the validity period from the generation time.
- **Example Implementation**:

  ```bash
  openssl req -x509 -newkey rsa:2048 -keyout private_key.pem -out certificate.pem -days 1 -nodes
  ```

  - `-x509`: Generates a self-signed certificate (public key).
  - `-newkey rsa:2048`: Creates a 2048-bit RSA private key.
  - `-keyout private_key.pem`: Saves private key to file.
  - `-out certificate.pem`: Saves public certificate.
  - `-days 1`: Sets expiry to 1 day from generation (adjust as needed).
  - `-nodes`: Avoids passphrase protection.

  Running this command produces two files: a private key (`private_key.pem`) and a public certificate (`certificate.pem`). The expiry occurs automatically at the specified date, rendering the key invalid.

> [!NOTE]
> Keys generated this way are PEM-formatted and compatible with GCP's key upload process.

## Uploading Public Key to Service Account

### Overview
With keys generated, upload the public certificate to the GCP service account to link it as an expirable key. This step integrates the custom expiry into GCP's management system.

### Key Concepts/Deep Dive
- **Service Account Key Management**:
  - In GCP Console, navigate to IAM & Admin > Service Accounts.
  - Select an existing service account or create a new one (e.g., for demo purposes).
- **Upload Process**:
  - Choose "Upload an existing key" option (avoid "Create new key" to enable expiry).
  - Paste or upload the public certificate content from `certificate.pem`.
  - GCP confirms the upload, assigning a unique key ID (e.g., in the format shown in console).

  Table: Key Upload Options Comparison

  | Method              | Expiry Support | Management Style | Cost |
  |---------------------|-----------------|------------------|------|
  | Upload Existing Key | Yes (if expiry set) | Manual integration | No  |
  | Create New Key      | No              | Automatic JSON download | No  |

- **Key ID Reference**: The assigned key ID is critical for constructing the JSON key later.

## Manipulating Private Key

### Overview
The private key file (`private_key.pem`) contains newline characters for readability. Convert it to a single-line format for inclusion in the JSON key structure.

### Key Concepts/Deep Dive
- **File Format Issues**: PEM files use base64-encoded content with line breaks, which must be removed for JSON compatibility.
- **Manipulation Steps**:
  - Open `private_key.pem` in a text editor (e.g., Notepad++).
  - Use find-and-replace: Replace line breaks (`\n` or `\r\n`) with nothing.
  - Remove header/footer markers (`-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----`) to isolate the raw key data.
- **Result**: A single-line string of the private key content, ready for JSON insertion.

  Example (before manipulation):
  ```
  -----BEGIN PRIVATE KEY-----
  MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...
  -----END PRIVATE KEY-----
  ```

  After manipulation: `MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...` (single line, no headers).

- **Best Practices**: Use a reliable editor to avoid accidental data corruption during string manipulation.

## Creating JSON Key Structure

### Overview
Construct a JSON key file matching GCP's standard format, incorporating the manipulated private key and service account metadata to enable authentication.

### Key Concepts/Deep Dive
- **JSON Structure Components**:
  - Project ID: Extract from GCP console URL or `gcloud config get-value project`.
  - Private Key: Insert the manipulated single-line private key.
  - Key ID: From the uploaded public key's ID.
  - Service Account Email: Full email (e.g., `account@project.iam.gserviceaccount.com`).
  - Client ID: Numeric ID visible in the service account details.
  - Additional Fields: Include `type: "service_account"`, `auth_uri`, etc., for full compatibility.

- **Example JSON Structure**:
  ```json
  {
    "type": "service_account",
    "project_id": "your-project-id",
    "private_key_id": "key-id-from-upload",
    "private_key": "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...",
    "client_email": "account@project.iam.gserviceaccount.com",
    "client_id": "123456789",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/account%40project.iam.gserviceaccount.com"
  }
  ```

- **Generation Steps**:
  - Create a new JSON file in Cloud Shell (e.g., `demo-key.json`).
  - Populate fields manually using console-extracted values.
  - Save and test activation.

> [!NOTE]
> This manual JSON creation replicates GCP's auto-generated keys, ensuring compatibility with tools like `gcloud auth activate-service-account`.

## Activating and Testing the Service Account

### Overview
Activate the custom JSON key and verify its functionality. Post-expiry, the key becomes invalid while retaining visibility for auditing.

### Key Concepts/Deep Dive
- **Activation Command**:
  ```bash
  gcloud auth activate-service-account --key-file=demo-key.json
  ```
  - This sets the service account as active, allowing resource access without switching users.

- **Verification**:
  - Run `gcloud auth list` to confirm the active account.
  - Check the GCP console for the key's status (active until expiry date).

- **Expiry Behavior**:
  - After the set days elapse, authentication fails automatically.
  - Key remains listed in GCP with an "expired" status, useful for audit trails.
  - No manual deletion needed; access is revoked.

- **Demo Outcome**:
  - Generated with 1-day expiry: Active initially, expired the next day.
  - Logging feature highlights creation/expiry dates for compliance.

> [!IMPORTANT]
> Test in non-production environments first to ensure correct expiry without disrupting services.

## Summary

### Key Takeaways
```diff
+ Auto-expiry service account keys improve security by enforcing temporary access limits without manual intervention.
- Avoid using non-expirable keys for High-privilege tasks in production to prevent undetected drifts.
! Regular audits of expired keys in GCP console ensure compliance and detect anomalies.
+ Combining OpenSSL key generation with GCP upload provides a reliable alternative to preview-only native features.
- Manual key manipulation introduces risks of errors; always validate JSON structure post-creation.
! Organization-linked accounts gain early access to native expiry via Google forms for streamlined management.
```

### Expert Insight

#### Real-world Application
In production GCP environments, deploy auto-expiry keys for CI/CD pipelines or temporary administrative access. Integrate with tools like Terraform to automate key regeneration, ensuring keys rotate before expiry while maintaining audit logs of access periods. This supports SOC2 compliance by eliminating permanent high-trust credentials.

#### Expert Path
Master GCP IAM by studying key lifecycle management in official documentation. Practice with `gcloud iam service-accounts` commands for programmatic handling, and explore custom Cloud Functions to monitor and rotate keys automatically. Deepen cryptography knowledge with OpenSSL for advanced key customizations (e.g., stronger algorithms).

#### Common Pitfalls
- **Incorrect Expiry Dates**: Double-check `-days` parameter; miscalculations lead to premature or excessive access.
- **Key Corruption During Manipulation**: Use editors with base64 validation; corrupted keys cause authentication failures without clear error logs.
- **Ignoring Organizational Preview**: For non-org users, stick to OpenSSL; attempting unauthorized features wastes time.

#### Common Issues with Resolution
- **Activation Fails**: Verify JSON fields (e.g., ensure `private_key_id` matches GCP console). Solution: Regenerate JSON with exact console values; test with `gcloud auth activate-service-account` before deployment.
- **Expiry Not Recognized**: Confirm public certificate upload succeeded (key appears "for upload"). Solution: Re-upload certificate if GCP shows errors; check expiry isn't in the past.
- **Audit Trail Loss**: If keys vanish post-expiry (unlikely with this method), implement external logging via Cloud Logging filters for activity.

#### Lesser Known Things
Auto-expiry keys in GCP support X.509 certificates, enabling integration with external CA systems for enterprise workflows. Expired keys don't consume quotas, making them ideal for low-cost monitoring setups. Experiment with longer expiry periods (e.g., 30 days) to balance security with operational ease, and use Cloud Monitoring alerts for impending expirations to automate renewals.

Note on corrections: The transcript contained "server's account" instead of "service account" (corrected in multiple instances). No other spelling errors (e.g., "htp", "cubectl") were present. "uh" and "um" filler words were removed for clarity. "gcp" was standardized to "GCP".
