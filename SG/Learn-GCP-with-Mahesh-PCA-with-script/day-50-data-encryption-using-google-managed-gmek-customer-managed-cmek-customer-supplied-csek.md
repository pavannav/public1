Session 50: Data Encryption using Google Managed-GMEK, Customer Managed-CMEK, Customer Supplied - CSEK
===

#### Table of Contents
- [Introduction to Encryption at Rest in Google Cloud Storage](#introduction-to-encryption-at-rest-in-google-cloud-storage)
- [Cloud Key Management Service (KMS) Overview](#cloud-key-management-service-kms-overview)
- [Creating Key Rings and Keys in KMS](#creating-key-rings-and-keys-in-kms)
- [Symmetric vs Asymmetric Keys and Protection Levels](#symmetric-vs-asymmetric-keys-and-protection-levels)
- [Customer Managed Encryption Key (CMEK) Setup](#customer-managed-encryption-key-cmek-setup)
- [Google Managed Encryption Key (GMEK)](#google-managed-encryption-key-gmek)
- [Customer Supplied Encryption Key (CSEC)](#customer-supplied-encryption-key-csec)
- [Key Generation for CSEC](#key-generation-for-csec)
- [Using CSEC in Google Cloud Storage](#using-csec-in-google-cloud-storage)
- [Key Rotation for CSEC](#key-rotation-for-csec)
- [Signed URLs and External Access](#signed-urls-and-external-access)
- [Summary](#summary)

### Introduction to Encryption at Rest in Google Cloud Storage
Google Cloud Storage automatically encrypts data at rest using Google-managed encryption keys by default. This ensures data is protected without any user intervention. For regulation-restricted data, options include CMEK and CSEC for additional control over keys used for encryption and decryption.

All Google Cloud services, including Compute Engine, Cloud Run, BigQuery, and Big Data products like Cloud Storage, encrypt data by default. Data is split into granular chunks (256 KB to 8 MB) for encryption.

### Cloud Key Management Service (KMS) Overview
Google Cloud KMS allows users to create, rotate, manage, and destroy cryptographically backed keys. These keys encrypt and decrypt data, or support digital signatures. KMS is used for server-side encryption in Cloud Storage.

KMS manages encryption keys securely, where raw key material is never exported or viewed. Operations occur through cryptographic operations using authorized accounts.

### Creating Key Rings and Keys in KMS
Key rings organize cryptographic keys in collections. Keys are stored within key rings and perform encryption/decryption.

- **Steps to Create a Key Ring**:
  - Navigate to Cloud KMS in the Google Cloud Console.
  - Select a region (e.g., London for GDPR compliance).
  - Choose single-region for better latency.
  - Name the key ring (e.g., PCA GCS Key Ring).

- **Steps to Create a Key**:
  - Within the key ring, create a cryptographic key (e.g., GCS Key).
  - Purpose: Select "Encrypt/decrypt" for symmetric encryption.
  - Protection Level: Software (shared environment) or Hardware Security Module (HSM) for dedicated hardware.
  - Rotation Period: Default 90 days; customizable (e.g., 30 days for more control).
  - Destruction Window: 30 days after deletion for compliance.

### Symmetric vs Asymmetric Keys and Protection Levels
- **Symmetric vs Asymmetric**: Symmetric keys use the same key for encryption and decryption, ideal for data protection. Asymmetric keys have separate keys and are used for signatures.

- **Protection Levels**:
  - **Software**: Cryptographic operations run on shared virtual machines. Cost-effective but multi-tenant.
  - **HSM**: Operations run on dedicated hardware, providing isolation. More expensive, used for strict compliance.

Google-managed keys use software protection with 90-day rotation. CMEK allows customization of these parameters.

### Customer Managed Encryption Key (CMEK) Setup
CMEK uses KMS-managed keys for Cloud Storage encryption. Users control key lifecycle, but KMS protects the keys.

- **Attach CMEK to a Bucket**:
  - Create a regional bucket (must match KMS key region).
  - In bucket configuration, select "Customer-managed encryption key" > "Enter KMS key" > Provide full KMS key resource path (e.g., `projects/PROJECT_ID/locations/london/keyRings/KEY_RING/cryptoKeys/KEY`).
  - Service Account Grant: The Cloud Storage service account requires "Cloud KMS CryptoKey Encrypter/Decrypter" role. UI auto-grants when selecting keys.

- **Service Account and Roles**:
  - Cloud Storage uses a project-level service account (format: `storage@[PROJECT_NUM].gsprojectaccounts.com`) for encryption/decryption.
  - Grant "Cloud KMS CryptoKey Encrypter/Decrypter" at key or project level.
  - Users need standard IAM roles (e.g., Storage Object User) for object access; encryption/decryption happens transparently.
  
  > [!IMPORTANT]
  > Only service accounts have encryption roles; users accessing objects do not require special permission for CMEK-decrypted data.

- **Demonstration**:
  - Upload object to bucket.
  - Verify in UI: Shows "Customer managed encryption" with key version.
  - Command: Use `gsutil stat` or `gcloud storage objects describe` to view KMS key reference (gutil shows SHA; gcloud commandless detailed).
  - Decryption seamless for authorized users; fails if service account lacks role (Error: "AttributeError: add" or permission denied on KMS).

### Google Managed Encryption Key (GMEK)
Default encryption for all Cloud Storage buckets. Google manages the key lifecycle: 90-day rotation via software protection and automatic versioning.

- **Characteristics**:
  - No user action required.
  - Single-region buckets supported.
  - Transparent to users; encryption/decryption handled by Google.

- **Limitations**:
  - No rotation control; always 90 days.
  - Not customizable beyond Google defaults.

Objects show "Google managed encryption" if no custom key specified.

### Customer Supplied Encryption Key (CSEC)
CSEC allows users to supply their own encryption keys, generated outside Google Cloud. Keys must remain secure (not stored in GCP resources).

- **Key Characteristics**:
  - Symmetric AES-256 compatible keys (32 bytes).
  - Base64-encoded for 256-bit Advanced Encryption Standard (AES).
  - Must be managed by the user (rotation, secure storage).
  - Not tied to KMS; user supplies keys for each operation.

- **Use Cases**:
  - Strict compliance where keys must be generated/managed outside GCP.
  - High-control scenarios; requires secure key handling.

CSEC is not available in the UI; use commands only.

### Key Generation for CSEC
Generate keys using secure systems (not shared GCP resources).

- **JavaScript/Node.js Code Example** (from Google documentation):
  ```javascript
  const crypto = require('crypto');
  const key = crypto.randomBytes(32); // 256-bit AES key
  console.log(Buffer.from(key).toString('base64')); // Base64 encode
  ```

- **Python Equivalent**:
  ```python
  import base64
  import os
  key = os.urandom(32)  # 32 bytes for AES-256
  print(base64.b64encode(key).decode())
  ```

- **Requirements**:
  - Secure, patched systems.
  - Avoid storing keys in GCP.
  - Do not commit keys to version control.

Run on local machines or dedicated hardware; avoid Cloud Shell (shared environment).

### Using CSEC in Google Cloud Storage
CSEC requires explicit key provision per command.

- **Encryption/Decryption Commands**:
  - Upload File with Key: `gsutil cp -k [KEY] file.txt gs://bucket/filename`
  - Download File with Key: `gsutil cat -k [KEY] gs://bucket/filename`
  - Key must be Base64-encoded AES-256.

- **UI Limitations**:
  - Not supported; fails silently or shows permission errors.
  - Must use CLI.

- **Configuration (.boto File)**:
  - Set in `~/.boto` file (generated via `gsutil config` or `gcloud config`).
  - Sections for encryption/decryption keys (up to 100).
  ```ini
  [GSUtil]
  encryption_key = [BASE64_KEY]
  decryption_key1 = [BASE64_KEY1]
  decryption_key2 = [BASE64_KEY2]
  ```
  - Reload with `gsutil refresh`.

- **Multiple Decryption Keys**:
  - Allow up to 100 keys for rotation support (e.g., old and new keys).
  - Command: `gsutil cat --decryption-keys key1,key2 gs://bucket/file`

- **Object Verification**:
  - `gsutil stat`: Shows "Customer-supplied encryption" with SHA256 and algorithm (e.g., AES256).
  - Unlike CMEK, no KMS reference.

### Key Rotation for CSEC
Users manually rotate keys due to external management.

- **Process**:
  - Generate new key (Base64 AES-256).
  - Re-encrypt objects: `gsutil cp -k NEW_KEY existing_file new_file` (overwrites).
  - Update `.boto` file with old (decryption) and new (encryption) keys.
  - Delete old files if needed.

- **Challenges**:
  - Manual process; error-prone.
  - Requires updating access rules/keys.
  - Not automated like KMS.

### Signed URLs and External Access
For sharing with external users (e.g., auditors without Google accounts), use signed URLs.

- **Signed URL Basics**:
  - Time-bounded (max 7 days) URL for object access.
  - Uses service account key for cryptographic signing.
  - Access via impersonation (service account role).

- **Create Signed URL**:
  - `gsutil signurl -d 5d service-account-key.json gs://bucket/object`
  - Email link to externals; expires automatically.
  
  > [!NOTE]
  > Signed URLs support GET (download); extended methods (e.g., PUT for upload) via policy documents.

- Alternatives (if signed URLs insufficient):
  - Create temporary Google accounts.
  - Use IAM conditions (time-limited access).

### Summary
#### Key Takeaways
```diff
+ Customer data is encrypted by default at 256 KB-8 MB chunks.
+ GMEK: Google's default (software, 90-day rotation).
+ CMEK: User-managed via KMS (control rotation/protection; seamless).
+ CSEC: Full user control (manual keys; complex, secure external storage required).
- Avoid sharing keys; rotate CMEK/CMEK regularly.
! CSEC UI unsupported; CLI-only.
```

#### Expert Insight
- **Real-world Application**: Use CMEK for regulated data (HIPAA/GDPR) in regional buckets. Reserve CSEC for air-gapped environments with external key management.
- **Expert Path**: Master KMS API for automation; integrate with CI/CD for key rotation. Practice HSM vs. software comparisons in trial environments.
- **Common Pitfalls**: Region mismatches for CMEK; key version control for CSEC. Overlook service account roles leading to decryption failures. No unified key rotation for bucket-level CSEC.
- **Lesser Known Facts**: CMEK keys support versioning (auto/instant); global keys unsupported for single-region buckets. Billing increases with HSM/custom rotation. Use envelope encryption (DEK/Kek) for large data sets.
