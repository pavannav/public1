<details open>
<summary><b> Session 33: Demonstration: SSH vs HTTPS Authentication in GitHub</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

### Exercise 1.1: Authentication Methods Analysis
**Objective**: Compare and contrast HTTPS and SSH authentication methods

**Tasks**:
1. Create a detailed comparison matrix covering:
   - Setup complexity
   - Security considerations
   - Usage frequency benefits
   - Network compatibility
   - Cross-platform support
2. Document the historical context of GitHub's authentication changes
3. Analyze security implications of each method
4. Research when to choose each authentication method

**Comparison matrix categories**:
- Initial setup requirements
- Ongoing usage experience
- Security model
- Corporate/network restrictions
- Automation compatibility

**Deliverable**: Authentication methods comparison document with decision framework

---

### Exercise 1.2: HTTPS Authentication Deep Dive
**Objective**: Master HTTPS authentication with personal access tokens

**Tasks**:
1. Document the complete HTTPS authentication flow:
   - Token generation process
   - Token usage in git commands
   - Credential caching options
   - Token rotation procedures
2. Research HTTPS authentication across different git clients
3. Create troubleshooting guide for common HTTPS issues
4. Document credential helper configurations

**HTTPS workflow documentation**:
- Token creation and management
- Git credential configuration
- Cross-platform considerations
- Security best practices

**Deliverable**: HTTPS authentication comprehensive guide with troubleshooting

---

### Exercise 1.3: SSH Key Cryptography Fundamentals
**Objective**: Understand the cryptographic principles behind SSH authentication

**Tasks**:
1. Research SSH key pair generation concepts:
   - Public/private key cryptography
   - Key algorithm options (RSA, Ed25519, ECDSA)
   - Key size recommendations
   - Passphrase protection benefits
2. Document the mathematical security model
3. Compare different key algorithms and their use cases
4. Research key management best practices

**Key algorithm comparison**:
- Ed25519 (modern, recommended)
- RSA (legacy, widely supported)
- ECDSA (elliptic curve options)
- Security vs. performance considerations

**Deliverable**: SSH cryptography fundamentals guide with algorithm recommendations

---

### Exercise 2.1: SSH Key Generation Workflow
**Objective**: Master SSH key pair generation across platforms

**Tasks**:
1. Practice SSH key generation with different parameters:
   - Key algorithm specification (`-t ed25519`)
   - Comment/label configuration (`-C email@domain.com`)
   - Custom file paths and names
   - Passphrase implementation
2. Document key generation across platforms:
   - Linux/macOS terminal
   - Windows Git Bash
   - Windows PowerShell
   - WSL environments
3. Create key naming conventions for multiple environments

**Key generation command analysis**:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

**Deliverable**: SSH key generation cross-platform guide with naming conventions

---

### Exercise 2.2: SSH Key Management and Security
**Objective**: Establish secure SSH key management practices

**Tasks**:
1. Document proper key file permissions and security:
   - Private key protection (600 permissions)
   - Public key sharing permissions
   - Directory security (`.ssh` folder)
   - Backup strategies
2. Create key rotation and renewal procedures
3. Research compromised key response procedures
4. Document multi-device key management strategies

**Security checklist**:
- File permission verification
- Passphrase implementation decisions
- Key backup procedures
- Rotation schedules

**Deliverable**: SSH key security management guide with operational procedures

---

### Exercise 2.3: GitHub SSH Key Integration
**Objective**: Master the process of adding SSH keys to GitHub

**Tasks**:
1. Document the complete key addition workflow:
   - GitHub settings navigation
   - SSH and GPG Keys section
   - Key type selection (Authentication Key)
   - Title/description best practices
2. Research key title naming conventions for multiple keys
3. Create procedures for managing multiple SSH keys
4. Document key verification and testing methods

**Key addition workflow**:
- Profile → Settings → SSH and GPG keys
- New SSH key creation
- Key content verification
- Title and description strategies

**Deliverable**: GitHub SSH key integration guide with multi-key management

---

### Exercise 3.1: SSH Connection Testing and Verification
**Objective**: Master SSH connection troubleshooting and verification

**Tasks**:
1. Practice the SSH connection test command: `ssh -T git@github.com`
2. Document the expected successful response
3. Create troubleshooting procedures for common issues:
   - Host verification prompts
   - Permission denied errors
   - Connection timeout issues
   - Key not recognized problems
4. Research SSH agent configuration for passphrase-protected keys

**Connection testing scenarios**:
- First-time host verification
- Successful authentication confirmation
- Common error diagnosis
- Agent forwarding configuration

**Deliverable**: SSH connection testing and troubleshooting guide

---

### Exercise 3.2: Repository URL Switching Strategies
**Objective**: Master switching between HTTPS and SSH repository URLs

**Tasks**:
1. Practice changing remote URLs between authentication methods:
   - `git remote set-url origin [new-url]`
   - Verifying URL changes with `git remote -v`
   - Testing push/pull operations after URL changes
2. Document URL format differences:
   - HTTPS format: `https://github.com/username/repo.git`
   - SSH format: `git@github.com:username/repo.git`
3. Create migration strategies for existing repositories
4. Research batch URL updating for multiple repositories

**URL format comparison**:
- HTTPS advantages and use cases
- SSH advantages and use cases
- Format conversion procedures
- Verification methods

**Deliverable**: Repository URL switching guide with format documentation

---

### Exercise 3.3: Authentication Method Decision Framework
**Objective**: Develop criteria for choosing authentication methods in different scenarios

**Tasks**:
1. Create decision criteria for authentication method selection:
   - Development frequency considerations
   - Security requirements analysis
   - Corporate environment constraints
   - Automation and CI/CD requirements
2. Document method switching procedures for evolving needs
3. Research hybrid approaches using both methods strategically
4. Create team policy recommendations for authentication standards

**Decision factors**:
- Usage patterns (daily vs. occasional)
- Security compliance requirements
- Network restrictions
- Team collaboration needs
- Automation requirements

**Deliverable**: Authentication method decision framework with team policy recommendations

</details>

</details>