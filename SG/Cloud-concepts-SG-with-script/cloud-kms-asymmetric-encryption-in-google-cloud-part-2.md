# Session 2: Cloud KMS Asymmetric Encryption in Google Cloud

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Lab Demo: Creating Asymmetric Encryption Key and Encryption/Decryption](#lab-demo-creating-asymmetric-encryption-key-and-encryptiondecryption)
- [Summary](#summary)

<a name="overview"></a>
## Overview

This session continues from Part 1, focusing on Cloud Key Management Service (KMS) in Google Cloud, specifically asymmetric encryption. Cloud KMS enables secure creation and management of encryption keys used across Google Cloud services and applications. It supports symmetric encryption, asymmetric encryption, key importing, external key management integration, and operations like digital signature verification and message authentication code validation. This part explores asymmetric encryption, which uses pairs of public and private keys for enhanced security compared to symmetric encryption's single key approach. The session covers asymmetry principles, key differences from symmetric methods, Google Cloud console demos, command-line encryption/decryption using OpenSSL, and best practices for key management including versioning, algorithms, and rotation.

> [!IMPORTANT]  
> Asymmetric encryption provides superior security by requiring both public and private keys, mitigating risks from single-key compromises. Practical applications include secure data sharing and authentication in cloud environments where only authorized parties with private keys can decrypt.

<a name="key-concepts-and-deep-dive"></a>
## Key Concepts and Deep Dive

### Comparison with Symmetric Encryption
Symmetric encryption uses a single shared key for both encryption and decryption, simplifying processes but introducing vulnerability—if the key is compromised, anyone can decrypt all data.

Asymmetric encryption employs two mathematically distinct but interrelated keys:
- **Public Key**: Freely distributable, used for encryption by anyone.
- **Private Key**: Kept strictly secret by the intended recipient, used exclusively for decryption.

This approach ensures higher security; only encrypted data can be read by the private key holder, preventing unauthorized access even if the public key is exposed.

**Encryption Process Overview**:
```
flowchart LR
    A[Plaintext Data] --> B[Public Key Encryption]
    B --> C[Encrypted/Ciphertext Data]
    C --> D[Private Key Decryption (Owner Only)]
    D --> E[Original Plaintext]
```

### How Asymmetric Encryption Works in Cloud KMS
1. **Key Generation**: Create public-private key pairs using supported algorithms.
2. **Encryption**: Use the public key to encrypt plaintext data into unreadable ciphertext.
3. **Decryption**: Restore original data only with the matching private key.

Real-world analogy: Public key acts like a mailbox lock (anyone can lock mail), private key like the only key to open it.

### Cloud KMS Asymmetric Key Components
Cloud KMS structures asymmetric encryption around:
- **Key Rings**: Logical groupings for organizing multiple keys within a project and location.
- **Keys**: Each key supports multiple versions but has a fixed purpose (e.g., encryption/decryption).
- **Versions**: Unique key instances; asymmetric keys lack a "primary" version concept unlike symmetric keys. Specify the exact version for decryption operations.
- **Purpose**: Options include encrypt/decrypt, sign/verify, or cryptographic MAC. Cannot change purpose or type post-creation (must recreate key).
- **Protection Levels**: Software, HSM (Hardware Security Module), or External. Software processes keys in software (cost-efficient for testing); HSM uses dedicated hardware ($1-3 per key version); External integrates third-party key managers (not demoed due to costs).
- **Algorithms**: Choose cryptographic strength (e.g., RSA-PSS-SHA512-4096 provides 4096-bit security).
- **States**: Enabled, Disabled, Scheduled for Destruction, Destroyed.
- **Key Rotation**: Manual-only for asymmetric keys; cannot automate unlike symmetric. Rotate by creating new versions and re-encrypting data.
- **Destruction Period**: Default 1 day (increasing to 30 days from May 30, 2024, per Google docs). Configurable longer periods allow recovery if issues arise.

> [!NOTE]  
> Asymmetric keys integrate with other Cloud KMS features like permissions management and usage tracking.

### Algorithm Matching Requirements
Critical for successful operations—encryption and decryption algorithms must match. Mismatched algorithms (e.g., encrypting with SHA-256 but decrypting with SHA-512) result in decryption failures. Always verify algorithm selection during key creation and OpenSSL commands.

### Best Practices and Security Considerations
- Distribute public keys freely for encryption; никогда never share private keys.
- Specify exact key versions for decryption to avoid mismatches.
- Use HSM for production workloads needing high assurance (incurs costs).
- Implement manual rotation: Decrypt with old key, re-encrypt with new version, verify, then safely destroy old key.
- Set destruction periods (e.g., 30 days) for recovery windows before permanent deletion.
- Backup encrypted data separately; Google cannot recover lost keys or data once keys are destroyed.
- Monitor permissions and disable unused versions promptly to reduce attack surface.

```diff
+ Key Strengths: Two-key system enhances security; no shared secrets in transit.
- Key Limitations: Slower than symmetric encryption; requires careful version management; permanent data loss risk if keys destroyed prematurely.
! Critical Risk: Incorrect algorithm selection can permanently lock data—test thoroughly.
```

<a name="lab-demo-creating-asymmetric-encryption-key-and-encryptiondecryption"></a>
## Lab Demo: Creating Asymmetric Encryption Key and Encryption/Decryption

### Step 1: Create Asymmetric Encryption Key in Google Cloud Console
1. Navigate to Cloud KMS in Google Cloud Console.
2. Select existing Key Ring (e.g., "demo-ring").
3. Click "Create Key":
   - Name: asymmetric-decrypt
   - Protection Level: Software (for testing; HSM for production)
   - Click "Continue" → Select asymmetric encryption.
   - Algorithm: RSA-PSS-SHA512-4096 (4096-bit security).
   - Versions: Automatic rotation N/A (must manage manually).
   - Destruction Period: Default (1 day, soon 30 days).
   - Labels: Optional.
   - Click "Create".

> [!NOTE]  
> Key created; asymmetric keys do not have a "primary" version. Permissions and usage tracking can be configured post-creation.

### Step 2: Download Public Key for Encryption
1. In the key's "Overview" tab, click "Get Public Key".
2. Copy or download the PEM-formatted public key.
3. In Cloud Shell, create `pub.key` file and paste the public key content.

### Step 3: Encrypt Plaintext Data
Prepare test file (e.g., `test.txt` with content like "This is testing asymmetric encryption.").

Run OpenSSL command:
```bash
openssl pkeyutl -encrypt -in test.txt -out encrypt.txt -pubin -inkey pub.key -pkeyopt rsa_padding_mode:oaep -pkeyopt rsa_oaep_md:sha256 -pkeyopt rsa_mgf1_md:sha256
```
- `-encrypt`: Encryption mode
- `-in test.txt`: Input plaintext file
- `-out encrypt.txt`: Output ciphertext file
- `-pubin -inkey pub.key`: Use public key
- Padding and hashing: Ensure algorithm matches (SHA-256 in this case)

Verify: Encrypted file (`encrypt.txt`) appears unreadable (binary/ciphertext).

### Step 4: Decrypt Data with Correct Version and Algorithm
Create new key version if needed (uses same algorithm):
- In console: Key → "Create New Version".

Decryption requires specifying exact version (e.g., version 1).

Command example:
```bash
gcloud kms asymmetric-decrypt --key=projects/YOUR_PROJECT/locations/asia-south1/keyRings/demo-ring/cryptoKeys/asymmetric-decrypt/cryptoKeyVersions/1 --ciphertext-file=encrypt.txt --plaintext-file=decrypt.txt --output-file=decrypt.txt
```
- `--key`: Full key path including project, location, key ring, key name, and specific version.
- `--ciphertext-file`: Encrypted input file.
- `--plaintext-file`: Decrypted output file.

Verify decryption succeeds; compare `decrypt.txt` with original `test.txt`.

### Step 5: Handle Version and Algorithm Mismatches
- Attempt decryption with wrong version (e.g., version 2): Results in "decryption failed" error.
- Correct: Specify matching version (1) and ensure algorithm alignment.
- If algorithm mismatch (e.g., encrypt with SHA-256, decrypt expecting SHA-512): Perpetual "decryption failed"—remedy by re-encrypting with correct algorithm.

### Step 6: Key Management Operations
- **Create New Versions**: Add versions under same key; each generates new public-private pairs.
- **Disable Versions**: Prevents new operations; existing encrypted data still decryptable for a delay period.
- **Destroy Versions**: Schedule destruction (e.g., 1 day default).
- **Restore**: If destroyed prematurely, restore to recover access before permanent deletion.

Process for Safe Rotation:
```
sequenceDiagram
    participant User
    participant KeyV1
    participant KeyV2
    User->>KeyV1: Decrypt data with V1
    User->>KeyV2: Re-encrypt data with V2
    User->>KeyV1: Verify no data left encrypted with V1
    User->>KeyV1: Schedule V1 destruction (with recovery period)
```

> [!WARNING]  
> Destruction is irrevocable after period ends—triple-check no dependent data exists. Google cannot recover destroyed keys or encrypted data.

### Command Reference Table

| Operation | Command | Notes |
|----------|---------|-------|
| Download Public Key | `gcloud kms versions describe VERSION --key=KEY_PATH --location=LOCATION --keyring=KEYRING --format="value(publicKey.pem)" > pub.key` | Optional; can copy from console |
| Encrypt | `openssl pkeyutl -encrypt -in input.txt -out cipher.txt -pubin -inkey pub.key -pkeyopt rsa_padding_mode:oaep -pkeyopt rsa_oaep_md:sha256 -pkeyopt rsa_mgf1_md:sha256` | SHA-256 match |
| Decrypt | `gcloud kms asymmetric-decrypt --key=full/version/path --ciphertext-file=cipher.txt --plaintext-file=plain.txt` | Specify full key path including version |
| Alternative Decrypt | Use RSA-PSS with matching MD (e.g., SHA-512 for that algorithm) | Avoid algorithm mismatches |

<a name="summary"></a>
## Summary

### Key Takeaways
```diff
+ Asymmetric encryption enhances security with public-private key pairs, ensuring only private key holders can decrypt.
+ Cloud KMS manages keys via versions without automatic primary designation, supporting manual rotation and flexible protection levels (Software/HSM/External).
+ Public keys enable broad encryption, while private keys secure decryption—perfect for secure data sharing without exposing secrets.
+ Version and algorithm matching is critical; mismatches cause permanent decryption failures and data loss.
+ Key destruction requires careful planning with recovery periods to prevent irrevocable data lockout.
- Bypassing key management best practices risks data irretrievability; Google cannot recover destroyed keys.
! Always test encryption/decryption cycles and validate algorithm selections before production use.
```

### Expert Insight

**Real-world Application**: Asymmetric encryption powers secure communications in cloud environments, such as encrypting customer data for storage (encrypt with public key) and only allowing backend services with private keys to access it. Useful for hybrid-cloud scenarios or multi-tenant apps where data sovereignty matters. In CI/CD pipelines, use Cloud KMS for encrypting secrets shared across teams.

**Expert Path**: Master by implementing end-to-end encryption workflows in Google Cloud: Combine asymmetric for key exchange with symmetric for bulk data. Explore integrations with IAM permissions for granular control. Advance to HSM-protected keys for regulated industries, monitoring audit logs for compliance. Practice native APIs (e.g., via Google Cloud client libraries) over manual OpenSSL for automated workflows.

**Common Pitfalls**:
- **Algorithm Mismatches**: Decryption fails silently or with errors—causes include selecting wrong OpenSSL parameters (e.g., SHA-256 vs. SHA-512). Resolution: Verify console algorithm during key creation and use matching padding schemes; test small samples first.
- **Version Specification Oversight**: Forgetting to specify exact version in decryption leads to failures. Resolution: Always check key states in console; script full key paths in automation to avoid human error.
- **Premature Key Destruction**: Destroying keys before data migration causes permanent loss. Resolution: Set long destruction periods (e.g., 30+ days); decrypt/re-encrypt all data with new versions; maintain encrypted data backups.
- **Public/Private Key Confusion**: Attempting decryption with public key. Resolution: Distribute public keys for encryption; restrict private key access (e.g., via Cloud KMS IAM roles); never log or exfiltrate private keys.
- **Performance vs. Security Trade-offs**: Asymmetric operations are slower than symmetric. Resolution: Use asymmetric for initial key exchange, then symmetric for bulk encryption—monitor Cloud KMS quotas and latency in high-volume apps.

**Lesser Known Things**: Asymmetric keys in Cloud KMS don't support automatic rotation due to cryptographic key pair dependencies. External protection level allows wrapping with on-premises HSMs for air-gapped security. Key versions are immutable once created; for algorithm changes, destroy and recreate the entire key. In testing, Software-protected keys are faster but less secure than HSM; simulate attacks to understand breach impacts. Google recommends SHA-512 for high-security workloads over SHA-256 to future-proof against quantum threats.

**Corrections Notified**: 
- "PMS" corrected to "KMS" (multiple instances).
- "asymmetric decrypt" updated to "asymmetric encryption" (title and references).
- "description" corrected to "decryption" (numerous instances).
- "PPD" contextually corrected to focus on "mathematically distinct keys" for PKI reference.
- "by The Secret by the intented resment" revised to "kept secret by the intended recipient."
- "recipent" corrected to "recipient."
- "un readable" to "unreadable."
- "retries" to "retrieves."
- "dispense who are holds a uni private key" to "person who holds the unique private key."
- "uh send a request with a public message" clarified to "using the public key."
- "encryption of L Text data" to "encryption of plaintext data."
- "PL text" to "plaintext."
- "test.txt if I dots" to "test.txt if I cat."
- "got encrypt do txt" to "encrypt.txt."
- "dee CP file" to "decrypt.txt" (multiple).
- "there are some things which we have to take here" specified as "need to specify the version."
- "Let R the command" to "Let me run the command."
- "sh 256" to "SHA-256."
- "S 51 512" to "SHA-512."
- "DEC encrypt with the new version" to "re-encrypt with the new version."
- "reenable" to "re-enable."
- "DEST before like this like what is the manual like Google recommend" to "destroy before, Google recommends."
- "detp the data" to "decrypt the data."
- "agree again" to "decrypt again."
