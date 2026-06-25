<details open>
<summary><b>Section 01: Pre-test Assessment & Environment Setup (KK-CS45-script-v2-Inst-v1)</b></summary>

## 1. Pre-test Assessment

### Purpose and Structure
- The pre-test assessment evaluates current Terraform knowledge before beginning the structured learning path
- Contains questions covering all exam domains with varying difficulty levels
- Serves as a diagnostic tool to identify knowledge gaps and strengths

### Taking the Assessment
**Process:**
1. Navigate to the course platform assessment section
2. Complete all questions without external reference materials
3. Questions cover Terraform fundamentals, state management, providers, modules, and best practices
4. Time limit applies similar to actual certification exam conditions
5. Review results to understand weak areas before proceeding

**Assessment Coverage:**
- Infrastructure as Code concepts
- Terraform workflow (init, plan, apply)
- State file management and security
- Provider configuration and authentication
- Resource lifecycle and dependencies
- Module development and versioning
- Remote state backends
- Terraform Cloud/Enterprise features

## 2. Environment Setup Requirements

### Linux Virtual Machine Setup

**VM Configuration:**
- Recommended: Ubuntu 20.04 LTS or 22.04 LTS
- Minimum 2 CPU cores, 4GB RAM
- 20GB+ disk space for tools and dependencies
- VirtualBox, VMware, or cloud-based instances acceptable

**Access Methods:**
- SSH access configured for remote management
- Key-based authentication recommended over passwords
- Port 22 open for SSH connections
- Hostname configuration for easy identification

### Visual Studio Code Installation

**Installation Process:**
1. Download VS Code for Linux from official sources
2. Install via package manager or direct download
3. Launch and complete initial setup wizard
4. Configure user settings and preferences

**Essential Extensions:**
- HashiCorp Terraform extension for syntax highlighting and IntelliSense
- Auto-completion for Terraform resources and data sources
- Built-in HCL language support
- Validation and linting capabilities

### Git Repository Access

**Repository Setup:**
- Clone the course repository using git clone command
- Repository contains exercise files, configurations, and examples
- Navigate to cloned directory structure
- Review README for course-specific instructions

**Repository Contents:**
- Pre-configured Terraform examples
- Practice exercise files
- Configuration templates
- Documentation and guides

### Terraform Installation

**Installation Methods:**
1. Download from official HashiCorp releases page
2. Use package managers (apt, yum, brew)
3. Install specific version matching course requirements
4. Verify installation with `terraform version`

**Verification Steps:**
- Confirm binary is in system PATH
- Check version matches expected release
- Test basic commands execute without errors
- Ensure plugins can download successfully

### Terraform Autocomplete Configuration

**Shell Integration:**
- Add autocomplete support to bash/zsh configuration
- Source the Terraform autocomplete script
- Test tab completion functionality
- Restart shell session to activate changes

**Benefits:**
- Faster command entry during exercises
- Reduced typing errors
- Improved workflow efficiency
- Professional development practices

## 3. AWS Environment Configuration

### AWS Account Setup

**Account Requirements:**
- Valid AWS account with billing configured
- Appropriate IAM permissions for resource creation
- Access keys generated for programmatic access
- Region selection for resource deployment

**Security Best Practices:**
- Never commit AWS credentials to version control
- Use IAM roles where possible over access keys
- Implement least-privilege access principles
- Regular credential rotation recommended

### AWS Credentials Configuration

**Configuration Methods:**
1. Environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
2. AWS credentials file (~/.aws/credentials)
3. IAM instance profiles for EC2 instances
4. Terraform variables with secure handling

**Provider Configuration:**
```hcl
provider "aws" {
  region = "us-east-1"
  # Credentials sourced from environment or config files
}
```

## 4. VS Code Configuration for Terraform

### Terraform Extension Features

**Syntax Support:**
- HCL syntax highlighting
- Resource and provider auto-completion
- Hover documentation for resource arguments
- Jump-to-definition for module sources

**Validation Capabilities:**
- Real-time syntax checking
- Provider schema validation
- Resource argument verification
- Module source validation

### Workspace Configuration

**Recommended Settings:**
- Format on save enabled for consistent formatting
- File associations for .tf and .tfvars files
- Integrated terminal for running Terraform commands
- Git integration for version control

**Useful Keyboard Shortcuts:**
- Terraform: Validate configuration
- Terraform: Format document
- Integrated terminal toggle
- File explorer navigation

## 5. Practice Exam Access

### Accessing Practice Assessments

**Platform Navigation:**
1. Log into the O'Reilly learning platform
2. Navigate to the Terraform Associate course section
3. Locate the Practice Exams module
4. Select appropriate practice assessment

**Exam Features:**
- Timed exam simulation matching certification format
- Randomized question selection
- Immediate feedback on answers
- Detailed explanations for correct responses
- Performance tracking across attempts

### Exam Preparation Strategy

**Study Approach:**
- Complete practice exams after finishing each major section
- Review incorrect answers thoroughly
- Retake exams until achieving consistent passing scores
- Focus additional study on weak domain areas
- Use exam results to guide final review priorities

**Exam Interface:**
- Mark questions for review functionality
- Navigate between questions freely
- Review marked questions before submission
- Time remaining indicator
- Progress tracking throughout exam

</details>
