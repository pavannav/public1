# Section 55: Disk Encryption Using LUKS in Linux

<details open>
<summary><b>Section 55: Disk Encryption Using LUKS in Linux (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Disk Encryption and LUKS](#introduction-to-disk-encryption-and-luks)
- [Understanding LUKS Versions (LUKS1 vs LUKS2)](#understanding-luks-versions-luks1-vs-luks2)
- [Prerequisites for LUKS Setup](#prerequisites-for-luks-setup)
- [Practical Demo: Encrypting a Disk Partition](#practical-demo-encrypting-a-disk-partition)
- [Opening and Mounting the Encrypted Partition](#opening-and-mounting-the-encrypted-partition)
- [Creating Filesystem and Working with Encrypted Data](#creating-filesystem-and-working-with-encrypted-data)
- [Closing the Encrypted Partition](#closing-the-encrypted-partition)
- [Reopening and Remounting](#reopening-and-remounting)
- [Changing Passphrase](#changing-passphrase)
- [Permanent Mounting via fstab and crypttab](#permanent-mounting-via-fstab-and-crypttab)
- [Removing Encryption](#removing-encryption)
- [Summary](#summary)

## Introduction to Disk Encryption and LUKS
Disk encryption transforms data into an unreadable format using a cryptographic key. Without the correct key, data appears as meaningless gibberish. LUKS (Linux Unified Key Setup) is the primary tool for implementing disk encryption on Linux systems.

- **Why Encryption Matters**: Protects sensitive data from unauthorized access
- **LUKS Overview**: Unifies key setup for dm-crypt, providing a standard on-disk format for encrypted partitions
- **Security Benefits**: Uses strong encryption algorithms (AES by default)
- **Real-world Application**: Essential for laptops, external drives, and server storage containing confidential data

## Understanding LUKS Versions (LUKS1 vs LUKS2)
LUKS has evolved through versions, each offering different features and security levels.

- **LUKS1**:
  - Allows formatting partitions even if they contain data
  - Less secure key management

- **LUKS2**:
  - Key stored directly in kernel memory
  - More secure and modern architecture
  - Recommended for production use
  - Cannot recover removed keys, unlike LUKS1

> [!IMPORTANT]
> Always back up your key/passphrase securely. Loss of the key means permanent data loss.

## Prerequisites for LUKS Setup
Before proceeding with LUKS encryption:

- **Package Installation**: Ensure `cryptsetup` package is installed
  ```
  dnf install cryptsetup  # On RHEL/CentOS
  apt install cryptsetup  # On Debian/Ubuntu
  ```

- **Repository Configuration**: Repositories must be properly configured
- **Target Device**: Identify the disk partition to encrypt (e.g., `/dev/sdb`)

> [!WARNING]
> Encryption is irreversible without the key. Ensure data backup before proceeding.

## Practical Demo: Encrypting a Disk Partition
This section demonstrates the complete encryption process for `/dev/sdb`.

### Step 1: Format the Partition with LUKS
```bash
sudo cryptsetup luksFormat /dev/sdb
```
- **Command Breakdown**:
  - `cryptsetup`: Main utility for LUKS operations
  - `luksFormat`: Initializes partition with LUKS header
- **Interactive Prompts**:
  - Confirm data overwrite (answer "YES")
  - Enter passphrase (twice for verification)

### Step 2: Verify Encryption
Check LUKS status:
```bash
sudo cryptsetup luksDump /dev/sdb
```

## Opening and Mounting the Encrypted Partition
Once encrypted, access the partition through LUKS mapping.

### Opening the Encrypted Device
```bash
sudo cryptsetup luksOpen /dev/sdb myfile
```

- **Parameters**:
  - `/dev/sdb`: Physical device
  - `myfile`: Mapping name (arbitrary, used for reference)
- **Passphrase**: Enter the passphrase set during formatting

### Creating a Mount Point and Mounting
```bash
sudo mkdir /mnt/myfile
sudo mkfs.ext4 /dev/mapper/myfile
sudo mount /dev/mapper/myfile /mnt/myfile
```

- **Verification**: The encrypted partition now appears as `/dev/mapper/myfile`
- **Device Status**: `lsblk` or `blkid` shows `crypt` type for the mapped device

## Creating Filesystem and Working with Encrypted Data
With the partition mounted, create and manage data.

### Create Test Data
```bash
cd /mnt/myfile
touch file1.txt file2.txt
echo "Encrypted test data" > test.txt
ls -la
```

### Access Control
- **Current Permissions**: Root user has access
- **Multi-user Access**: Modify permissions to allow other users access while partition is open
- **Critical Note**: Data is only encrypted when partition is closed; accessible when open

## Closing the Encrypted Partition
To protect data, close the encrypted device.

```bash
sudo umount /mnt/myfile
sudo cryptsetup luksClose myfile
```

- **Post-Close Status**: 
  - `/dev/mapper/myfile` disappears
  - Device appears as regular (unencrypted) block device
  - Data becomes unreadable without reopening with correct passphrase

## Reopening and Remounting
To access encrypted data again:

```bash
sudo cryptsetup luksOpen /dev/sdb myfile
sudo mount /dev/mapper/myfile /mnt/myfile
```

- **Verification**: Use `cryptsetup status myfile` to confirm active status
- **Device Listing**: Shows in `/dev/mapper/` when active

## Changing Passphrase
LUKS allows passphrase changes:

```bash
sudo cryptsetup luksChangeKey /dev/sdb
```

- **Process**: Enter old passphrase, then new passphrase twice
- **Security**: Multiple passphrases can be associated with a single LUKS device

## Permanent Mounting via fstab and crypttab
For automatic mounting on boot:

### Step 1: Create a Key File
```bash
dd if=/dev/urandom of=/root/keyfile bs=1024 count=4
chmod 600 /root/keyfile
```

### Step 2: Add to crypttab
Edit `/etc/crypttab`:
```
myfile /dev/sdb /root/keyfile luks
```

### Step 3: Update fstab
Edit `/etc/fstab`:
```
/dev/mapper/myfile /mnt/myfile ext4 defaults 0 0
```

### Step 4: Test Configuration
```bash
sudo mount -a
lsblk  # Verify mounting
```

> [!IMPORTANT]
> Key files must be properly secured. Store on separate, encrypted media for production use.

## Removing Encryption
To permanently remove LUKS encryption:

### Step 1: Unmount and Close
```bash
sudo umount /mnt/myfile
sudo cryptsetup luksClose myfile
```

### Step 2: Remove Key from Kernel
```bash
sudo cryptsetup luksRemoveKey /dev/sdb
```

### Step 3: Remove crypttab Entries
Comment out or remove entries from `/etc/crypttab` and `/etc/fstab`.

### Step 4: Format (Optional)
For new filesystem:
```bash
sudo mkfs.ext4 /dev/sdb
```

## Summary

### Key Takeaways
```diff
+ Disk encryption protects data using cryptographic transformation
+ LUKS provides Linux Unified Key Setup for dm-crypt
+ LUKS2 offers superior security with kernel-stored keys
+ Always backup keys/passphrases - permanent data loss occurs without them
+ cryptsetup is the primary utility for LUKS operations
- Data is only encrypted when the LUKS device is closed
- Improper key management can result in irreversible data loss
```

### Quick Reference
- **Format Device**: `cryptsetup luksFormat <device>`
- **Open Device**: `cryptsetup luksOpen <device> <name>`
- **Close Device**: `cryptsetup luksClose <name>`
- **Status Check**: `cryptsetup status <name>`
- **Change Key**: `cryptsetup luksChangeKey <device>`

### Expert Insight

**Real-world Application**: Use LUKS encryption for:
- Laptop storage protection
- External USB drives containing sensitive data
- Server volumes with confidential information
- Full disk encryption for compliance requirements (HIPAA, GDPR)

**Expert Path**: Master LUKS by:
- Understanding different cipher algorithms (`cryptsetup luksDump` output)
- Implementing key escrow for enterprise environments
- Combining with RAID for redundant encrypted storage
- Automating with scripts for consistent configurations

**Common Pitfalls**:
- Forgetting or losing passphrases/keys (no recovery possible with LUKS2)
- Insufficient testing of encryption/decryption processes
- Improper storage of key files (should be on separate encrypted media)
- Attempting to access closed encrypted volumes without proper procedures
- Not verifying crypttab/fstab configurations before rebooting

</details>
