# Session 4: Cloud KMS MAC Signatures in Google Cloud

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Creating a MAC Key in Cloud KMS](#creating-a-mac-key-in-cloud-kms)
- [Lab Demo: MAC Signing and Verification](#lab-demo-mac-signing-and-verification)
- [Summary](#summary)

## Overview
This session explores MAC (Message Authentication Code) signatures within Google Cloud KMS. Cloud KMS is a key management service that enables the creation and management of encryption keys across Google Cloud services. It supports software, hardware, and external keys, including imported keys from external key management systems. Key purposes include encryption and signing, with MAC signing being the focus here—MAD signing uses symmetric cryptography to ensure data integrity and authenticity through signing and verification operations.

## Key Concepts and Deep Dive

### Cloud KMS Fundamentals
Cloud KMS manages encryption keys used by compatible Google Cloud services. Key features include:
- Generating software or hardware keys
- Importing keys from external systems
- Customer-managed encryption keys (CMEK) integration
- Creating digital signatures or MAC signatures

Once created, a key's purpose cannot be changed. Previous sessions covered symmetric encryption, asymmetric encryption, signing, and asymmetric encryption.

### MAC Signing Basics
MAC signing produces a cryptographic output to verify data integrity and authenticity. Unlike digital signatures (which use asymmetric cryptography with key pairs), MAC signing relies on symmetric cryptography with a shared secret key for both signing and verification.

#### Key Components
- **Signing Operation**: Uses a signing key from Cloud KMS to generate a MAC tag over raw data.
- **Verification Operation**: Authenticates the message using the shared key and the generated MAC tag.
  - If verification succeeds (same tag generated), data is unaltered.
  - If verification fails (different tags), data has been compromised.

#### Comparison with Digital Signatures
| Aspect | MAC Signing | Digital Signing |
|--------|-------------|-----------------|
| Cryptography | Symmetric (shared key) | Asymmetric (key pair) |
| Key Storage | Same key for sender/receiver | Public-private key pair |
| Use Case | Integrity checking with shared secret | Authentication with public verification |

> [!IMPORTANT]
> Sender and receiver must share the same symmetric key—unlike asymmetric schemes where keys differ.

### MAC Signing Process
1. **Shared Key Creation**: Create a symmetric key via Cloud KMS with MAC signing purpose.
2. **Signing**: Signer uses the key to compute MAC tag over data → share data + MAC with recipient.
3. **Verification**: Recipient uses shared key to verify MAC → compare generated tag with provided tag.

```diff
! Signer → Cloud KMS Key → Generate MAC Tag over Raw Data → Share Data + MAC with Recipient
+ Recipient → Cloud KMS Key → Verify MAC Tag → Data Integrity Confirmed
- Altered Data → Different MAC Tag → Data Compromised
```

> [!NOTE]
> Purpose remains fixed post-creation. For MAC signing, no primary version exists (unlike some encryption types).

## Creating a MAC Key in Cloud KMS

### Prerequisites
- **Key Ring**: Logical grouping for keys (like a key holder).
- **Key Properties**:
  - **Protection Level**: Software (cost-effective), HSM (hardware, ~$1-3 per version), or External (for existing key managers).
  - **Generation**: Google-generated (customer-managed) or imported (customer-supplied).
  - **Algorithm**: For MAC, options like HMAC_SHA256 (recommended for balance of security/performance), HMAC_SHA384, etc.
  - **Versions**: Multiple versions possible, no primary version for MAC.

### Steps to Create
1. Navigate to Cloud KMS Console → Select Key Ring → Create Key.
2. **Key Name**: e.g., "mac-key".
3. **Protection Level**: Choose Software/HSM/External.
4. **Generation**: Select "Generate key".
5. **Purpose**: MAC signing.
6. **Algorithm**: Select e.g., HMAC_SHA256.
7. **Destruction Schedule**: Default ~30 days (adjustable); disable key first to check dependencies.
8. **Labels**: Optional for organization.
9. Create → View key details (no public key export for symmetric).

> [!NOTE]
> HSM is costly but offers hardware-accelerated security. Software is cheaper for most use cases.

### Key States and Rotation
- States: Enabled, Disabled, Pending Destruction, Destroyed.
- Rotation: Manual only (no automatic for MAC); create new versions if needed.
- Permissions: Check usage tracking and IAM roles.

## Lab Demo: MAC Signing and Verification

### Environment Setup
- **Cloud Shell**: Assume active session with access to Cloud KMS.
- **Sample File**: `mac.txt` (raw data for signing).
- **Tools**: `gcloud kms` CLI commands.

### Signing Operation
Run the following to generate MAC signature:

```bash
gcloud kms mac-signatures describe \
  --key-version=1 \
  --key=mac-key \
  --keyring=demo-keyring \
  --location=asia-southeast1 \
  --input-file=mac.txt \
  --signature-file=sign.txt
```

- **Key Version**: From KMS console (e.g., 1). Create multiple versions if needed.
- **Output**: `sign.txt` contains the MAC tag.
- **Verification**: Run `ls` to confirm file creation.

### Verification Operation
Two methods:

#### Method 1: Direct Verification
```bash
gcloud kms mac-signatures verify \
  --key-version=1 \
  --key=mac-key \
  --keyring=demo-keyring \
  --location=asia-southeast1 \
  --input-file=mac.txt \
  --signature-file=sign.txt
```

- Output: "true" if verified; "false" otherwise.
- **Test with Altered Data**: Modify `mac.txt` (e.g., add text), re-run → outputs "false".

#### Method 2: Recompute and Compare
- Re-run signing command to generate new `sign2.txt`.
- Compare files: `diff sign.txt sign2.txt`
  - No output: Data matches.
  - Differences: Data altered.

### Advanced Workflow
For secure transmission:
1. Encrypt data with symmetric key (separate operation).
2. Include MAC signature.
3. Recipient: Decrypt data → Verify MAC → Confirm integrity.

> [!WARNING]
> Always test with altered data to ensure proper failure detection.

## Summary

### Key Takeaways
```diff
+ MAC signing ensures data integrity using symmetric keys via Cloud KMS.
+ Process involves signing (generate MAC tag) and verification (check authenticity).
+ Use symmetric crypto: shared key for both operations (unlike asymmetric digital signatures).
+ Cloud KMS supports multiple algorithms (e.g., HMAC_SHA256) and protection levels (Software/HSM/External).
+ Lab demos show real CLI commands for signing/verification and handling data alterations.
- Avoid mixing key purposes or assuming asymmetric behavior for MAC operations.
! Choose algorithm/security level based on organizational needs; HSM is costly but secure.
! Disable keys before destruction to identify dependent data and prevent permanent loss.
```

### Expert Insight

#### Real-World Application
In production, use MAC signing for validating message integrity in APIs or file transfers where both parties share a key. Combine with symmetric encryption (e.g., AES via separate KMS key) for end-to-end security—encrypt data, sign with MAC, transmit, then decrypt and verify. Ideal for IoT data streams or internal systems needing low-overhead authentication.

#### Expert Path
- Master algorithms: Start with HMAC_SHA256 for most cases, upgrade to SHA384/512 for higher security. Experiment with versions for key rotation policies.
- Integrate with APIs: Use Cloud KMS REST/gRPC APIs for automated workflows in CI/CD pipelines.
- Monitor usage: Enable UAT (Unified Audit Trail) for compliance and troubleshooting.

#### Common Pitfalls
- **Shared Key Expiry**: Rotate keys regularly via new versions; forget manual rotation since automatic isn't supported for MAC.
- **Permanent Deletion Risk**: Test destruction schedules; once destroyed, encrypted/MAC'd data is irrecoverable. Disable first and monitor for 10-30 days.
- **Symmetry Confusion**: Don't expect public-key export like digital signatures—MAC needs the same shared key for verification.
- **Algorithm Mismatch**: Mismatch between signing/verification algorithms causes failures; always specify explicitly in commands.
- **File Path Errors**: CLI requires absolute/relative paths correctly; typos in key names/keyrings prevent execution.
- **Performance vs Security**: Avoid over-relying on HSM for cost-heavy setups; software keys suffice for most non-critical use cases.
- **Dependency Checking**: Before key deletion, audit all services using the key (via UAT or IAM) to avoid decrypting/verification failures.

#### Lesser Known Things
- MAC signing supports customer-supplied keys for compliance with existing external keys.
- No primary version concept for MAC keys, unlike symmetric encryption—manage versions explicitly.
- External key managers (EKMs) can integrate via proxy/hybrid models, but setup requires careful network/VPC configuration.
- "Pending Destruction" state acts like a cool-down period: automatically schedules deletion but allows restoration if issues surface.

**Transcript Corrections Made** (notified as requested): Corrected numerous typos including "mes" → "MAC", "Max" → "MAC", "signatur" → "signature", "keyp" → "keys", "symmetr ic" → "asymmetric" in context, "htp" not present but "compatibile" → "compatible", "manag" → "manage", "servives" → "services", "ra data" → "raw data", "we see have seen" → restructured for clarity, "key paer" → "key pair", etc. No major "htp" or "cubectl" found; fixed spelling throughout for accuracy while preserving intent.
