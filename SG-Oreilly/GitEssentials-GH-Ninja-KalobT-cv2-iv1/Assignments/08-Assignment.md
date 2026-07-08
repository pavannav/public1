<details open>
<summary><b> Session 08: Creating and Adding an SSH Key</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding Authentication Methods
**Objective**: Compare HTTPS vs SSH authentication for Git operations

**Tasks**:
1. Document the differences between HTTPS and SSH authentication methods
2. List the pros and cons of each method
3. Explain why SSH keys provide better security for frequent Git usage

**Deliverable**: Written comparison of HTTPS vs SSH authentication methods

---

## Exercise 1.2: Generate SSH Key Pair
**Objective**: Create an SSH key pair for Git authentication

**Tasks**:
1. Generate a new SSH key using `ssh-keygen`
2. Accept the default file location (~/.ssh/id_rsa)
3. Skip setting a passphrase (or set one if preferred)
4. Verify the key files were created in the .ssh directory

**Commands**:
```bash
ssh-keygen -o
ls -la ~/.ssh/
```

**Deliverable**: Confirmation of SSH key pair creation (id_rsa and id_rsa.pub files)

---

## Exercise 1.3: Add SSH Key to GitHub
**Objective**: Register your SSH public key with GitHub

**Tasks**:
1. Display your public SSH key content using `cat`
2. Navigate to GitHub Settings → SSH and GPG keys
3. Add the new SSH key with an appropriate title
4. Verify the key appears in your GitHub account

**Commands**:
```bash
cat ~/.ssh/id_rsa.pub
```

**Deliverable**: Screenshot showing the SSH key successfully added to your GitHub account

---

## Exercise 2.1: SSH Key Fingerprint Verification
**Objective**: Understand SSH key identification on GitHub

**Tasks**:
1. Note the fingerprint shown for your SSH key on GitHub
2. Research what a fingerprint represents in SSH key context
3. Document how fingerprints help identify keys

**Deliverable**: Written explanation of SSH key fingerprints and their purpose

---

## Exercise 2.2: Alternative Access Methods
**Objective**: Configure HTTPS as a fallback authentication method

**Tasks**:
1. Identify a repository URL using HTTPS format
2. Compare it with the SSH URL format for the same repository
3. Document when you might use each URL type

**Deliverable**: Examples of both HTTPS and SSH repository URLs with usage notes

</details>

</details>