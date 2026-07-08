<details open>
<summary><b> Session 07: Configuring Git on Your Computer</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Basic Git Configuration
**Objective**: Configure Git with your identity for commit signing

**Tasks**:
1. Configure your global Git username using `git config --global user.name`
2. Configure your global Git email address using `git config --global user.email`
3. Verify the configuration by viewing the `.gitconfig` file

**Commands**:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
cat ~/.gitconfig
```

**Deliverable**: Screenshot or output showing your configured name and email in `.gitconfig`

---

## Exercise 1.2: Email Address Alignment
**Objective**: Ensure Git configuration matches your GitHub/GitLab/Bitbucket account

**Tasks**:
1. Check which email address you used to create your Git hosting account
2. Verify your Git configuration uses the exact same email
3. If they don't match, update your Git configuration to match

**Commands**:
```bash
git config --global user.email
# Check your GitHub profile settings for registered email
```

**Deliverable**: Confirmation that your Git email matches your hosting service email

---

## Exercise 1.3: Configuration Verification
**Objective**: Demonstrate proper Git configuration setup

**Tasks**:
1. Document your current Git configuration settings
2. Explain the purpose of each configured value
3. Identify the location of your global Git configuration file

**Deliverable**: Written explanation of your Git configuration and its purpose

</details>

</details>