# Session 3: Cloud KMS Digital Signatures

## Table of Contents
- [Introduction to Cloud KMS](#introduction-to-cloud-kms)
- [What is a Digital Signature?](#what-is-a-digital-signature)
- [Key Concepts and Process](#key-concepts-and-process)
- [Resources and Components](#resources-and-components)
- [Lab Demo: Creating and Verifying Digital Signatures](#lab-demo-creating-and-verifying-digital-signatures)
- [Summary](#summary)

## Introduction to Cloud KMS

### Overview
Cloud Key Management Service (KMS) is a managed service in Google Cloud Platform (GCP) used for creating and managing encryption keys. This service supports various cryptographic operations, including symmetric encryption, asymmetric encryption, and digital signatures. We have previously covered symmetric and asymmetric encryption in prior sessions. This session focuses specifically on digital signatures using asymmetric signing keys in Cloud KMS.

Cloud KMS allows you to:
- Create new keys or import existing ones.
- Use different protection levels: Software, Hardware Security Module (HSM), or external key managers.
- Integrate with Google Cloud products for encryption tasks.
- Perform digital signing and verification operations.

### Key Concepts/Deep Dive
- **Key Types Supported**: Software keys (default, cost-effective), HSM keys (enhanced security), and external key management integration.
- **Use Cases**: Managing encryption keys for data at rest, in transit, and ensuring data integrity through digital signatures.

## What is a Digital Signature?

### Overview
A digital signature is a cryptographic mechanism used to verify the authenticity and integrity of data. It relies on asymmetric cryptography (public-key cryptography) and involves two main operations: signing and verification.

- **Signing Operation**: Uses a private key to generate a signature over raw data.
- **Verification Operation**: Uses the corresponding public key to verify the signature was created by the private key holder and that the data has not been altered.

Digital signatures ensure:
- **Authenticity**: Confirm the signer’s identity.
- **Integrity**: Detect if data has been tampered with during transmission.
- **Non-repudiation**: Prevent the signer from denying the signature.

### Key Concepts/Deep Dive
- **Cryptographic Basis**: Digital signatures use asymmetric key pairs (public and private keys). The private key signs the data, and the public key verifies it.
  - Private key: Kept secret, used for signing.
  - Public key: Shared publicly, used for verification.
- **Process Flow**:
  1. Signer applies a private key operation to the data to create a signature.
  2. Signer sends the original data and signature to the recipient.
  3. Recipient uses the public key to verify the signature.
- **Detection of Tampering**: If the data is altered (e.g., modified during transmission), verification fails, indicating compromise.
- **Benefits**: Provides secure verification without revealing the private key.

## Key Concepts and Process

### Overview
Digital signatures in Cloud KMS follow a structured process for creating and verifying signatures using asymmetric keys specifically designed for signing purposes.

### Key Concepts/Deep Dive
- **Steps for Digital Signing and Verification**:
  1. **Create Asymmetric Key Pair**: Generate an asymmetric key in Cloud KMS that supports digital signing (not encryption).
  2. **Signing Operation**: Use the private key to sign the data (e.g., a file).
  3. **Transmit Data and Signature**: Share the signed data and signature with the recipient.
  4. **Verification Operation**: Recipient uses the public key to verify the signature and data integrity.
- **Fallback for Security**: Digital signatures can be combined with encryption (e.g., encrypt data first, then sign) to provide confidentiality and integrity.

### Code/Config Blocks
Example workflow using bash commands for signing and verification:

```bash
# Signing command (gcloud kms asymmetric-sign)
gcloud kms asymmetric-sign --version 1 --key asymmetric-sign --keyring demo-keyring --location asia-south1 --digest-algorithm sha256 --input-file text.txt --signature-file sign.txt

# Verification command (openssl)
openssl dgst -sha256 -signature sign.txt -verify pub.key text.txt
```

## Resources and Components

### Overview
Before working with digital signatures in Cloud KMS, you need to understand the hierarchical structure: Key Rings, Keys, Versions, States, and Algorithms.

### Key Concepts/Deep Dive
- **Key Ring**: A grouping mechanism for keys, similar to a physical key ring. You need at least one key ring before creating keys.
- **Keys**: Individual cryptographic keys.
  - Can have multiple versions.
- **Key Types**:
  - **Symmetric**: Single key for encryption/decryption (not for signing).
  - **Asymmetric**: Key pair (public/private) supporting multiple purposes, including signing.
- **Purposes**:
  - Asymmetric signing: Used for digital signatures.
- **States**: Enabled, disabled, destruction scheduled, destroyed.
- **Primary Version**: Applicable only for symmetric keys; asymmetric keys require specifying the version in operations.
- **Algorithms**: Choose based on strength and organizational requirements (e.g., EC_SIGN_P256_SHA256 for ECDSA curves, RSA_SIGN_PSS_2048_SHA256 for PSS padding).
- **Cost Considerations**: HSM keys cost $1–$3 per version; software keys are cheaper.

| Component | Symmetric | Asymmetric (Signing) |
|-----------|-----------|----------------------|
| Key Type | Single shared key | Public/Private pair |
| Purpose | Encryption/Decryption | Signing/Verification |
| Primary Version | Yes | No, specify version per operation |
| Examples | AES-GCM | RSA_SIGN_PSS, EC_SIGN_P256_SHA256 |

## Lab Demo: Creating and Verifying Digital Signatures

### Overview
This demo demonstrates creating an asymmetric signing key in Cloud KMS, signing a file, and verifying the signature. It also shows how verification fails if the data is tampered with.

### Lab Demos
#### Step 1: Create Asymmetric Signing Key
1. Navigate to Cloud KMS in the Google Cloud Console.
2. Select your existing key ring (e.g., `demo-keyring`).
3. Click **Create Key**:
   - **Name**: `asymmetric-sign` (or any suitable name).
   - **Protection Level**: Software (choose HSM for higher security).
   - **Key Material**: Generated (by Cloud KMS).
   - **Purpose**: Asymmetric signing.
   - **Algorithm**: EC_SIGN_P256_SHA256 (or RSA_SIGN_PSS_2048_SHA256 for PSS).
   - **Rotation**: Not applicable for asymmetric signing.
   - **Destruction Schedule**: Default (30 days after disabling).
   - Add labels if needed.
4. Click **Create**.
5. Key is created with version 1.

#### Step 2: Sign a File
Use the following command to sign `text.txt`:

```bash
gcloud kms asymmetric-sign --version 1 --key asymmetric-sign --keyring demo-keyring --location asia-south1 --digest-algorithm sha256 --input-file text.txt --signature-file sign.txt
```

- **Parameters**:
  - `--version`: Version of the key (e.g., 1).
  - `--key`: Key name.
  - `--keyring`: Key ring name.
  - `--location`: Region (e.g., `asia-south1`).
  - `--digest-algorithm`: Based on algorithm (sha256 for EC_SIGN_P256_SHA256).
  - `--input-file`: File to sign (`text.txt`).
  - `--signature-file`: Output signature file (`sign.txt`).

Authorize if prompted. This creates `sign.txt` containing the signature.

#### Step 3: Retrieve Public Key
1. In the key details, click **Get Public Key**.
2. Copy the public key and save to a file (e.g., `pub.key` using `nano pub.key`).

#### Step 4: Verify Signature (Intact File)
Use OpenSSL to verify:

```bash
openssl dgst -sha256 -signature sign.txt -verify pub.key text.txt
```

- Output: "Verified OK" if the file is unaltered.

#### Step 5: Test Verification Failure (Tampered File)
1. Edit `text.txt` in nano (e.g., add "compromised").
2. Run the verification command again.
3. Output: "Verification failure" – data has been altered.

#### Additional Notes
- For RSA_SIGN_PSS algorithms, use similar commands but adjust the digest algorithm (e.g., sha256 for PSS_2048_SHA256).
- Combine with encryption for full security: Encrypt data first, then sign it.

> [!NOTE]
> This demo uses ECDSA curve (EC_SIGN_P256_SHA256). For RSA, adjust the algorithm and OpenSSL flags accordingly (e.g., `-rsa-pad-pss` for PSS padding).

## Summary

### Key Takeaways
```diff
+ Digital signatures provide authenticity, integrity, and non-repudiation using asymmetric cryptography.
+ Cloud KMS supports asymmetric signing keys for creating and verifying signatures.
+ Combine signing with encryption for end-to-end secure data transmission.
+ Always verify signatures before processing received data.
- Do not share private keys; only distribute public keys for verification.
- Disable keys before scheduling destruction to allow recovery if needed.
```

### Expert Insight
- **Real-world Application**: Digital signatures are crucial in software distribution, secure email (e.g., S/MIME), blockchain transactions, and SSL/TLS certificates. In production, integrate Cloud KMS signing with automated pipelines for code signing or document authentication.
- **Expert Path**: Master RSA vs. ECDSA algorithms – RSA is more versatile but slower; ECDSA is faster and lighter for mobile/resource-constrained environments. Experiment with HSM keys for FIPS compliance and use Cloud Audit Logs for tracking signature operations.
- **Common Pitfalls**: 
  - Mistaking symmetric keys for signing (they don't work for digital signatures). Always choose asymmetric keys for signing purposes.
  - Forgetting to specify key version in gcloud commands, leading to errors.
  - Exposing private keys – store them securely via Cloud KMS.
  - Errors in digest algorithms (e.g., using sha256 with PSS when the key uses a different hash).
- **Common Issues and Resolutions**:
  - **Verification failures on intact files**: Check if the correct public key and digest algorithm are used. Ensure file encoding matches (e.g., no BOM issues).
  - **Key destruction recovery**: Disable keys first; once destroyed, data is irrecoverable. Always backup data encrypted with recoverable keys.
- **Lesser-Known Things**: Asymmetric keys in Cloud KMS generate a full key pair internally, but for signing, only the private portion is used operationally. Public keys are exportable for verification outside GCP using OpenSSL or custom clients. PSS padding offers better security against certain attacks compared to PKCS#1 for RSA signatures.
