# Session: SSH-GCP

<details open>
<summary><b>SSH-GCP (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
This session covers SSH (Secure Shell) concepts and configurations in Google Cloud Platform (GCP). SSH is a secure network protocol used for managing and accessing remote systems over unsecured networks. In GCP, SSH is primarily used for connecting to virtual machine instances running on Compute Engine.

> [!IMPORTANT]
> SSH in GCP is essential for secure remote administration of virtual machines without exposing other network ports.

## Key Concepts/Deep Dive

### SSH Fundamentals
SSH is a cryptographic network protocol that provides secure channel over unsecured network. It uses public-key cryptography for authentication and encryption.

**Key Components:**
- **Client**: The initiating machine (your local computer)
- **Server**: The target machine (GCP VM instance)
- **Key Pair**: Public and private key for authentication
- **Encrypted Tunnel**: All communication is encrypted

### SSH in GCP Context

#### GCP Compute Engine SSH
GCP provides built-in SSH support for Compute Engine instances through several methods:

1. **Browser-based SSH**: Direct access through GCP Console
2. **gcloud command-line tool**: Uses your local SSH client
3. **Custom SSH keys**: Manual key management
4. **OS Login**: GCP's identity management integration

#### SSH Key Authentication
SSH uses asymmetric cryptography where:
- **Private Key**: Stored securely on your local machine
- **Public Key**: Added to authorized keys on remote server
- **Authentication Flow**: Server challenges client with encrypted message

### Security Best Practices

#### Key Management
```yaml
# Recommended SSH key configuration
Host gcp-instance
    HostName [EXTERNAL_IP]
    User [USERNAME]
    IdentityFile ~/.ssh/gcp_key
    IdentitiesOnly yes
    StrictHostKeyChecking accept-new
    UserKnownHostsFile ~/.ssh/known_hosts
```

#### Permission Settings
- Private key: `chmod 600 ~/.ssh/private_key`
- Public key: `chmod 644 ~/.ssh/private_key.pub`
- `.ssh` directory: `chmod 700 ~/.ssh`

### GCP-Specific SSH Features

#### OS Login
GCP's OS Login integrates with Cloud Identity and Access Management (IAM):
- No need for manual SSH key distribution
- IAM roles control access levels
- Audit logging through Cloud Logging

#### Firewall Considerations
GCP firewall rules must allow TCP port 22 for SSH:
```yaml
# Sample GCP firewall rule for SSH
name: allow-ssh
direction: INGRESS
allowed:
  - protocol: tcp
    ports:
      - "22"
sourceRanges:
  - 0.0.0.0/0  # Restrict this in production
```

### SSH Configuration Files

#### ~/.ssh/config
```config
# SSH client configuration
Host *
    ForwardAgent no
    ForwardX11 no
    PasswordAuthentication no
    ChallengeResponseAuthentication no
    PubkeyAuthentication yes
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa
```

#### Authorized Keys on Server
```bash
# Format in ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EA... user@host
```

## Lab Demos

### Lab Demo 1: Setting up SSH Access to GCP VM

1. **Create SSH Key Pair** (Local Machine)
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your-email@example.com" -f ~/.ssh/gcp_key
   ```

2. **Add Public Key to GCP Instance**
   ```bash
   gcloud compute instances add-metadata INSTANCE_NAME \
     --metadata-from-file ssh-keys=<(echo "USERNAME:$(cat ~/.ssh/gcp_key.pub)")
   ```

3. **Connect Using SSH**
   ```bash
   ssh -i ~/.ssh/gcp_key USERNAME@EXTERNAL_IP
   ```

### Lab Demo 2: Configuring OS Login

1. **Enable OS Login on Instance**
   ```bash
   gcloud compute instances add-metadata INSTANCE_NAME \
     --metadata enable-oslogin=TRUE
   ```

2. **Grant IAM Role**
   ```bash
   gcloud projects add-iam-policy-binding PROJECT_ID \
     --member=user:USERNAME@DOMAIN.com \
     --role=roles/compute.osLogin
   ```

3. **Connect via gcloud**
   ```bash
   gcloud compute ssh INSTANCE_NAME --zone=ZONE
   ```

### Lab Demo 3: Setting up SSH Tunneling

1. **Local Port Forwarding** (Access remote service locally)
   ```bash
   ssh -L LOCAL_PORT:localhost:REMOTE_PORT USER@REMOTE_HOST
   ```

2. **Remote Port Forwarding** (Access local service from remote)
   ```bash
   ssh -R REMOTE_PORT:localhost:LOCAL_PORT USER@REMOTE_HOST
   ```

## Summary

### Key Takeaways
```diff
+ SSH is the standard for secure remote access in GCP
+ Use key-based authentication over passwords for better security
+ GCP OS Login integrates SSH access with IAM for centralized control
+ Always restrict firewall rules for SSH to trusted IP ranges
+ Rotate SSH keys regularly and monitor access logs
- Never share private SSH keys or use passwords
- Avoid exposing SSH port (22) to 0.0.0.0/0 in production
- Don't use weak cipher algorithms or deprecated protocols
```

### Quick Reference

#### Common SSH Commands for GCP
```bash
# Check SSH key fingerprint
ssh-keygen -l -f ~/.ssh/gcp_key

# Test SSH connection
ssh -i ~/.ssh/gcp_key USER@IP -o StrictHostKeyChecking=no

# Copy public key to remote host
ssh-copy-id -i ~/.ssh/gcp_key.pub USER@IP

# List GCP instances
gcloud compute instances list

# SSH into GCP instance via gcloud
gcloud compute ssh INSTANCE_NAME --zone=ZONE
```

#### Firewall Rule for SSH
```yaml
sourceRanges:
  - 192.168.1.0/24  # Your trusted network
allowed:
  - IPProtocol: TCP
    ports:
      - '22'
```

#### SSH Configuration Sample
```config
Host gcp-prod
    HostName 35.202.123.45
    User myuser
    IdentityFile ~/.ssh/prod_key
    ProxyCommand gcloud compute start-iap-tunnel %h %p --listen-on-stdin

Host gcp-dev
    HostName 34.102.67.89
    User devuser
    IdentityFile ~/.ssh/dev_key
    ForwardAgent yes
```

### Expert Insight

#### Real-world Application
In production environments, SSH is commonly used for:
- Application deployment via CI/CD pipelines
- Infrastructure automation with Ansible/Python scripts
- Database administration and configuration management
- Log analysis and troubleshooting
- Remote backup operations

Large-scale deployments often use bastion hosts (jump boxes) to centralize SSH access and reduce direct exposure of internal systems.

#### Expert Path
**Mastering SSH in GCP:**
1. **Study SSH internals**: Understand handshake, key exchange, encryption algorithms
2. **Master SSH configuration**: Learn advanced SSH client/server config options
3. **Implement Infrastructure as Code**: Use Terraform/Pulumi for SSH key management
4. **Monitor and audit**: Set up Cloud Logging for SSH access monitoring
5. **Advanced tunneling**: Master SSH tunneling patterns for complex network architectures
6. **Security hardening**: Implement SSH certificate authorities and bastion hosts

Recommended certifications: GCP Professional Cloud Architect, RHCE, or CompTIA Security+

#### Common Pitfalls
- **Weak key sizes**: Use minimum 3072-bit RSA or consider ed25519 keys
- **Key sharing**: Never share private keys between users or environments  
- **Wide-open firewalls**: SSH should never be exposed to 0.0.0.0/0
- **Ignoring known_hosts**: Skipping host key verification exposes man-in-the-middle attacks
- **Password fallback**: Disabling password authentication entirely
- **Root access**: Avoid direct root SSH login; use sudo after authentication

</details>
