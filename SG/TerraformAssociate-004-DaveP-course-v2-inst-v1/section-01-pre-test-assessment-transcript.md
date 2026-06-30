# Section 1: Pre-test Assessment & Environment Setup

<details open>
<summary><b>Section 1: Pre-test Assessment & Environment Setup (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [1.1 Pre-test Assessment](#11-pre-test-assessment)
- [1.2 Setting up a Linux Virtual Machine - Part 1](#12-setting-up-a-linux-virtual-machine---part-1)
- [1.3 Setting up a Linux Virtual Machine - Part 2](#13-setting-up-a-linux-virtual-machine---part-2)
- [1.4 Installing Visual Studio Code](#14-installing-visual-studio-code)
- [1.5 Accessing the Git Repository](#15-accessing-the-git-repository)
- [1.6 Installing Terraform](#16-installing-terraform)
- [1.7 Installing Terraform Autocomplete](#17-installing-terraform-autocomplete)
- [1.8 Setting up AWS](#18-setting-up-aws)
- [1.9 Configuring VS Code](#19-configuring-vs-code)
- [1.10 How to Access the Practice Exams](#110-how-to-access-the-practice-exams)
- [Summary](#summary)

---

## 1.1 Pre-test Assessment

### Overview
A foundational assessment covering core Terraform concepts including what Terraform is, common use cases, and deployment capabilities across cloud providers.

### Key Concepts

#### What is Terraform?
Terraform is HashiCorp's Infrastructure as Code (IaC) tool:
- ✅ **Correct Answer**: HashiCorp's IaC tool
- ❌ Database for storing user accounts
- ❌ Imperative programming language
- ❌ HashiCorp's PaaS (Platform as a Service)

#### Key Distinctions:
1. **Not a Database**: While Terraform can interact with databases (MySQL, Postgres), it is not a database itself
2. **Declarative vs Imperative**: Uses HashiCorp Configuration Language (HCL), which is declarative
   - Declarative: Describe the desired end state
   - Imperative: Step-by-step instructions (Java, C, JavaScript)
3. **Not PaaS**: Can work with PaaS offerings (AWS Lambda, Heroku, SAP) but is not itself a PaaS

#### Common Use Cases for Terraform
✅ **Correct Use Case**: Deploy three web servers on AWS
- Infrastructure provisioning across multiple cloud providers

❌ **Not Terraform Use Cases**:
- Install NGINX web server → Use Configuration as Code (CaC) tools like Ansible or Cloud-Init
- Create golden images → Use HashiCorp Packer
- Build Database Management Systems (DBMS)

#### Terraform Deployment Capabilities
Terraform can deploy ALL of the following:
- IAM users on Amazon Web Services (AWS)
- Virtual machines on Microsoft Azure
- Compute instances on AWS
- Kubernetes clusters on Google Cloud

This demonstrates Terraform's multi-cloud, multi-resource provisioning capabilities.

---

## 1.2 Setting up a Linux Virtual Machine - Part 1

### Overview
Best practices and recommendations for setting up a Linux-based virtual machine environment for running Terraform labs, including virtualization software selection and VM specifications.

### Key Concepts

#### Why Use a Virtual Machine?
```diff
+ Best Practice: Isolates testing from main system
+ Fresh Environment: Clean slate for VS Code and configurations
+ Security: Prevents malicious programs and attacks from affecting host
+ Reusable: Easy to clone for additional testing
+ Repeatability: Accurate reproduction of labs
+ Free: Linux OS + VirtualBox = no cost
```

#### Recommended Specifications
| Component | Recommendation | Notes |
|-----------|---------------|-------|
| CPUs | 2 minimum | More enables better performance |
| RAM | 4GB minimum | VS Code requires 1GB alone |
| Storage | 10GB minimum, 20-30GB recommended | For OS and tools |

#### Supported Operating Systems
- **Primary**: Debian Linux (small footprint, functional)
- **Alternatives**: Ubuntu, Fedora, Linux Mint
- **Workarounds**: Windows or macOS feasible but Linux recommended

#### Recommended Virtualization Software
- **Primary Choice**: VirtualBox (free, cross-platform)
- **Advanced Options**: VMware, KVM
- **Note**: All labs work across virtualization platforms

#### Lab Environment Setup
⚙️ **Hands-on Lab Content**: This section includes guided setup instructions for:
1. Installing VirtualBox from virtualbox.org
2. Downloading Debian ISO from debian.org
3. Creating new virtual machine with proper specifications

#### Notes File Location
Repository contains `Lab01/virtualbox_notes` with useful links and tips for VirtualBox configuration.

---

## 1.3 Setting up a Linux Virtual Machine - Part 2

### Overview
Detailed walkthrough of VirtualBox installation, Debian VM creation, automated installation process, and important networking considerations for multi-VM environments.

### Lab Demonstration

#### VirtualBox Installation
- Download from: virtualbox.org/wiki/downloads
- Available for Windows, macOS, Linux
- Simple installation process

#### Debian ISO Download
- Source: debian.org/distrib/netinst
- Version used: Debian 13.2 (AMD64)
- Target: "Small CDs and USB sticks" section

#### VM Creation Process
1. **Machine → New** in VirtualBox
2. **Name**: "Debian Client"
3. **ISO Image**: Select downloaded Debian ISO
4. **Unattended Installation**: Enable for automated setup
5. **Credentials Configuration**:
   - Default: vboxuser / changeme
   - Custom: Set your preferred username/password
6. **Network Configuration**:
   - Hostname: Debian Client
   - Domain: example.local (required if Finish is grayed out)
7. **Hardware Specifications**:
   - Processors: 2
   - Base Memory: 4096 MB (4GB)
   - Hard Disk: 20GB

#### Installation Notes
- Automated installation takes ~10 minutes
- System reboots automatically after completion
- Skip the GNOME desktop tour if desired

#### Critical Networking Configuration

```bash
# For Multiple VMs Communication
# NAT Network (not default NAT)
Settings → Network → Adapter 1 → Attached to: NAT Network

# For SSH Access from Host
# Configure port forwarding in VM settings
# See Prowse Tech website for detailed SSH setup guides
```

#### Host System Note
Instructor actually uses:
- KVM virtualization on main Linux system
- Virtual Machine Manager for GUI
- VM name: "000terraform-debian"

#### General VM Setup Process
```
Virtualization System → Build VM → Configure NAT/NAT Network → Download ISO → Install OS → Update System
```

---

## 1.4 Installing Visual Studio Code

### Overview
Step-by-step guide for installing Visual Studio Code (VS Code) on Linux systems, highlighting platform-specific installation methods.

### Installation Process

#### Download Options
- **Website**: code.visualstudio.com/download
- **Supported Platforms**: Windows, Linux (Debian/Ubuntu, Red Hat/Fedora/SUSE), macOS

#### Linux Installation (Debian/Ubuntu)
```bash
# Navigate to Downloads directory
cd ~/Downloads

# Install with sudo permissions
sudo dpkg -i code_1.105.deb  # Use actual filename

# For Red Hat systems, use RPM:
sudo rpm -i code-1.105.rpm
```

#### Verification
```bash
# Open from terminal
code

# Or use GUI search (Super key → type "code")
```

#### Alternative Options
- **Open Source Alternative**: VS Codium
- **No IDE Requirement**: Terminal-based editors (Vim, Neovim) supported

#### System Requirements
- VS Code alone requires minimum 1GB RAM
- Factor into total VM memory allocation

---

## 1.5 Accessing the Git Repository

### Overview
Instructions for accessing and cloning the course's Git repository containing all lab files, scripts, and sample configurations.

### Repository Access Methods

#### Primary Repository
- **URL**: github.com/daveprowse/terraform004
- **Contents**: Labs, step-by-step files, scripts, sample files

#### Access Methods
1. **GitHub Web Interface**: View files and notes
2. **Git Clone (Recommended)**: `git clone https://github.com/daveprowse/terraform004`
3. **SSH/GitHub CLI**: Alternative cloning methods
4. **VS Code Integration**: Clone directly from IDE

#### Repository Structure
```
terraform004/
├── labs/
│   ├── lab01/
│   │   └── virtualbox_notes
│   └── [other lab directories]
└── [additional course files]
```

#### VS Code Integration
```bash
# Clone repository
git clone https://github.com/daveprowse/terraform004
cd terraform004

# Open in VS Code
code .
```

#### Trust Author Prompt
When opening folders in VS Code:
- Select "Trust the authors" for course repository
- Enables full functionality and extensions

#### Markdown Viewing
- Files written in Markdown format
- VS Code: Right-click → "Open Preview" for formatted view
- GitHub provides excellent rendered preview

---

## 1.6 Installing Terraform

### Overview
Complete guide to installing Terraform on Linux systems using HashiCorp's package repository, including verification and version requirements.

### Pre-Installation Requirements
```bash
# Update system before installation
sudo apt update && sudo apt upgrade -y
```

### Installation Methods

#### Package Manager Installation (Recommended for Learning)
- Uses HashiCorp's official repository
- Enables installation of other HashiCorp tools (Vault, Consul, Packer, Nomad)

#### Binary Installation (Production)
- Download from: releases.hashicorp.com/terraform
- Recommended for production environments
- Video guide available on Prowse Tech website

#### Platform-Specific Installation

```bash
# macOS (requires Homebrew)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Windows
# Binary download or Chocolatey package manager

# Linux (Debian/Ubuntu) - One-liner from developer.hashicorp.com
# Includes repository setup and keyring for security
```

#### Installation Verification
```bash
# Check Terraform version
terraform version
# or
terraform -v

# Expected output includes:
# - Version number (v1.6.0 or higher required)
# - Platform (linux_amd64 in this case)
```

#### Version Requirements
- **Minimum**: Terraform v1.6.0 or higher
- **Used in Course**: v1.14.0.3.1 (versions will vary as course ages)

#### Bash Autocompletion (Preview)
- Bash shell provides basic command autocompletion
- Type `ter` + Tab → completes to `terraform`
- Enhanced autocompletion covered in next section

---

## 1.7 Installing Terraform Autocomplete

### Overview
Setup of enhanced Terraform command autocompletion for bash and zsh shells, improving productivity by reducing keystrokes for subcommands.

### Prerequisites
- Bash or Zsh shell required
- `.bashrc` file must exist in home directory

### Setup Process

#### Create .bashrc if Missing
```bash
# Only if .bashrc doesn't exist
touch ~/.bashrc
```

#### Install Terraform Autocomplete
```bash
terraform -install-autocomplete
```

#### Verification Process
1. **Before**: Tab completion works for `terraform` command only
2. **After**: Tab completion works for all subcommands (`init`, `apply`, `plan`, etc.)

#### Testing Autocompletion
```bash
# Test primary command completion
ter[TAB] → terraform

# Test subcommand completion
terraform ver[TAB] → terraform version
```

#### File Modification
Autocomplete adds to `.bashrc`:
```bash
complete -C /usr/bin/terraform terraform
```

#### Shell Restart Required
- Close and reopen terminal, OR
- Log out and log back in
- Changes take effect on new shell session

#### Productivity Impact
```diff
! Over time, autocompletion saves millions of keystrokes
+ Reduces typing errors
+ Improves workflow speed
```

---

## 1.8 Setting up AWS

### Overview
Complete AWS CLI installation and configuration process, including IAM user creation, access key generation, and credential setup for Terraform AWS provider authentication.

### Prerequisites
- AWS account required
- Create dedicated IAM user with admin rights (NOT root account)
- Ensure console access for the IAM user

#### Security Best Practices
```diff
! NEVER share secret access keys
! Delete access keys when course completes
! Terminate all AWS instances after use
! Use dedicated testing IAM account
```

### AWS CLI Installation
```bash
# Linux installation (one-liner from AWS docs)
# Verify installation
aws --version
# Expected: AWS CLI 2.x or higher
```

### Access Key Creation Process

1. **AWS Console → User Account → Security Credentials**
2. **Access Keys Section → Create Access Key**
3. **Use Case**: Command Line Interface (CLI)
4. **Tag**: Optional identifier (e.g., "TF Course")
5. **Download/Save**: Access Key ID and Secret Access Key

### AWS Configuration
```bash
aws configure
# Prompts for:
# AWS Access Key ID: [paste access key]
# AWS Secret Access Key: [paste secret key]
# Default region name: [us-east-2 or leave blank]
# Default output format: [leave blank or specify]
```

### Credential Storage Location
```bash
~/.aws/
├── config      # Region and output format settings
└── credentials # Access keys stored here
```

### Multi-Account Support
AWS CLI supports multiple credential profiles for different users/departments/jobs.

### Course Completion Cleanup Checklist
- [ ] Delete access keys from AWS console
- [ ] Delete the temporary IAM account
- [ ] Terminate all running AWS instances
- [ ] Remove credential files from local machine

---

## 1.9 Configuring VS Code

### Overview
Comprehensive VS Code configuration for Terraform development, including workspace setup, essential extensions, indentation settings, and productivity enhancements.

### Workspace Configuration
```bash
# Create hidden workspace directory
mkdir .vscode

# Save as workspace
File → Save Workspace As → [project]/.vscode/[project].code-workspace
```

### Essential Terraform Extension
**HashiCorp Terraform Official Extension**:
- ✅ Syntax highlighting
- ✅ Auto-completion for blocks and arguments
- ✅ Built-in help system with hover documentation
- ✅ Error detection and validation

#### Extension Benefits
- Color-coded Terraform code (TF files)
- Real-time syntax validation
- Hover over elements for documentation
- Prevents common syntax errors (e.g., JSON commas in HCL)

### Indentation Standards
```diff
! HashiCorp Convention: 2-space indentation
! Important for Terraform Associate exam
```

**Configuration Methods**:
1. Status bar: Click "Spaces" → Select "2"
2. Keyboard: `Ctrl+,` → Search "indentation" → Set to 2
3. Settings JSON: `"editor.tabSize": 2`

### Additional Recommended Extensions
1. **Markdown Preview GitHub Styling**: GitHub-like markdown rendering
2. **Peacock**: Workspace color differentiation
   - Keyboard shortcut: `F1` → "Peacock: Change to a favorite color"

### Terminal Integration
```bash
# Open integrated terminal
Ctrl+`

# Toggle fullscreen terminal
Ctrl+Shift+[  # Custom shortcut example

# Settings location
File → Preferences → Keyboard Shortcuts
# or
Ctrl+K, Ctrl+S
```

### VS Code Shortcuts Resource
Comprehensive shortcut list available through VS Code help documentation.

---

## 1.10 How to Access the Practice Exams

### Overview
Information about accessing practice exams designed to test Terraform knowledge and prepare for the certification exam using the Pearson Test Prep Engine.

### Practice Exam Features
- ✅ Conceptually similar to real exam questions
- ✅ Tests Terraform knowledge and ability
- ✅ Uses Pearson Test Prep Engine for realistic testing environment
- ✅ Builds confidence for actual exam

### Access Methods
1. **Course Landing Page**: Direct link provided
2. **Search Query**: "Prowse HashiCorp Terraform Associate Pearson Practice Test"

### Study Recommendations
```diff
+ Practice concepts within actual Terraform program
+ Reinforces theoretical knowledge with hands-on experience
+ Prepares for real-world Terraform usage
```

### Support Resources
- **Website**: Prowse Tech
- **Community**: Discord server
- **Instructor Contact**: Available for questions

---

## Summary

### Key Takeaways
```diff
+ Terraform is HashiCorp's declarative IaC tool, not PaaS or database
+ Virtual machines provide isolated, secure, repeatable environments
+ VS Code with HashiCorp extension essential for Terraform development
+ Git repository cloning enables hands-on lab participation
+ Package manager installation recommended for learning, binary for production
+ AWS CLI configuration enables Terraform cloud provider integration
+ Autocompletion significantly improves development efficiency
+ Practice exams bridge theoretical knowledge with certification readiness
```

### Quick Reference Commands
```bash
# System Updates
sudo apt update && sudo apt upgrade -y

# Repository Access
git clone https://github.com/daveprowse/terraform004

# Terraform Installation Verification
terraform version
terraform -install-autocomplete

# AWS Configuration
aws configure
aws --version

# VS Code
code .
```

### Expert Insights

#### Real-world Application
- VM isolation prevents configuration conflicts in team environments
- Proper AWS IAM setup critical for production security
- Workspace configurations enable consistent team development environments

#### Expert Path
- Master both package manager and binary installation methods
- Learn multi-cloud provider configuration beyond AWS
- Develop proficiency with VS Code Terraform extension features
- Practice exam concepts thoroughly in actual Terraform environment

#### Common Pitfalls
- Using root AWS accounts instead of dedicated IAM users
- Forgetting to clean up AWS resources after labs
- Incorrect indentation causing syntax errors
- Not updating systems before installation
- Skipping autocompletion setup (reduces productivity significantly)

#### Lesser-Known Facts
- Terraform v1.6+ required for most modern features and labs
- VS Code workspace settings can override global preferences
- NAT Network configuration enables VM-to-VM communication
- HashiCorp maintains compatibility with older Terraform versions in most cases

</details>