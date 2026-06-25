# Section 5: AWS Configuration with SSH and Outputs

<details open>
<summary><b>Section 5: AWS Configuration with SSH and Outputs (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [5.1 Creating the Directory Structure](#51-creating-the-directory-structure)
- [5.2 Creating an SSH Key Pair](#52-creating-an-ssh-key-pair)
- [5.3 Coding the Terraform Files](#53-coding-the-terraform-files)
- [5.4 Terraform Outputs](#54-terraform-outputs)
- [5.5 Initializing, Validating, and Applying Infrastructure](#55-initializing-validating-and-applying-infrastructure)
- [5.6 Using SSH to Connect to the New Instance](#56-using-ssh-to-connect-to-the-new-instance)
- [5.7 Destroying the Infrastructure](#57-destroying-the-infrastructure)
- [5.8 Quiz](#58-quiz)
- [Summary](#summary)

---

## 5.1 Creating the Directory Structure

### Overview
This module introduces Lab 5, which focuses on AWS configuration with SSH and outputs. The lab builds upon previous work by adding proper SSH support and using Terraform outputs to retrieve instance information like IP address and DNS name.

### Lab Objectives
- Create proper directory structure for organized Terraform projects
- Build SSH key pairs for secure instance access
- Configure multiple Terraform files (versions, provider, main, outputs)
- Implement SSH connectivity to AWS instances
- Use Terraform outputs to retrieve instance metadata

### Directory Structure Setup
The lab requires a specific directory layout:

```
Lab 05/
├── instances/     # Working directory for Terraform files
│   ├── version.tf
│   ├── provider.tf
│   ├── main.tf
│   └── outputs.tf
├── keys/          # SSH keys location
│   ├── awskey
│   └── awskey.pub
└── solution/      # Reference solutions
```

### Creating Directories
Use the `mkdir` command with brace expansion for efficiency:

```bash
mkdir {instances,keys}
```

This creates both directories in a single command. The `instances` directory becomes the Terraform working directory where all `.tf` files are stored.

### Important Notes
- Always work within the `instances` directory when running Terraform commands
- Review the lab file before starting for a high-level overview
- The solution directory provides reference implementations if needed

---

## 5.2 Creating an SSH Key Pair

### Overview
This module demonstrates how to generate SSH key pairs locally for secure AWS instance access. Building keys locally provides better control and security compared to AWS-generated keys.

### SSH Key Generation Process

#### Prerequisites
- OpenSSH must be installed on your system
- Check version with: `ssh -V`
- Version 9.6+: Creates ED25519 keys
- Version 9.5 or lower: Creates RSA keys

#### Generating the Key Pair
```bash
ssh-keygen
```

Key generation steps:
1. Specify the output path: `../keys/awskey` (navigating from instances to keys directory)
2. Choose key algorithm (ED25519 preferred)
3. Optionally add a passphrase (skipped for this lab)
4. Keys created: `awskey` (private) and `awskey.pub` (public)

### Key Management Best Practices
- ✅ **Build keys locally** for better control
- ✅ **Keep private keys secure** - never share or expose
- ✅ **Use public keys** for AWS instance configuration
- ❌ **Avoid AWS-generated PEM files** when you want local key control

### Key Storage Strategy
For this lab, keys are compartmentalized within the Lab 05 directory structure:
- Private key (`awskey`): Used for SSH authentication
- Public key (`awskey.pub`): Copied to Terraform configuration and AWS

---

## 5.3 Coding the Terraform Files

### Overview
This module covers creating four separate Terraform files within the instances directory, each serving a specific purpose. This modular approach improves code organization and troubleshooting.

### File Structure
1. **version.tf** - Terraform version and provider requirements
2. **provider.tf** - AWS provider configuration
3. **main.tf** - Core infrastructure resources
4. **outputs.tf** - Output value definitions

### File Creation
```bash
touch {version.tf,provider.tf,main.tf,outputs.tf}
```

### Version Configuration
Copy the standard terraform block from previous labs:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

### Provider Configuration
AWS provider block configuration:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

### Main Configuration Features
The main.tf file includes several important components:

#### Key Pair Resource
```hcl
resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-ed25519 AAAAC3...your-public-key-here"
}
```

#### Security Groups
Four security groups are defined:
1. **allow_ssh** - Ingress on port 22
2. **allow_tls** - Ingress on port 443
3. **allow_http** - Ingress on port 80 (NEW)
4. **egress** - Open outbound access (NEW)

#### Instance Configuration
```hcl
resource "aws_instance" "lab05" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_tls.id,
    aws_security_group.allow_http.id,
    aws_security_group.egress.id
  ]

  tags = {
    Name = "Lab05"
    Owner = "Terraform"
    # Additional fun tags...
  }
}
```

### Key Differences from Lab 4
- Additional HTTP security group for port 80 access
- Egress security group properly linked
- Local SSH key pair integration via `aws_key_pair` resource
- Enhanced tagging for better resource management

---

## 5.4 Terraform Outputs

### Overview
This module introduces Terraform output blocks for extracting instance information after infrastructure creation. Outputs provide essential connection details like public IP and DNS names.

### Output Block Structure
```hcl
output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.lab05.public_dns
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.lab05.public_ip
}
```

### Output Components
- **Block identifier**: `output`
- **Terraform ID**: Unique name within quotes (e.g., `"public_dns"`)
- **Description**: Optional but recommended for clarity
- **Value**: Reference to resource attributes using dot notation

### Resource Reference Format
```
aws_instance.lab05.public_dns
aws_instance.lab05.public_ip
```

### Common Mistakes to Avoid
- ⚠️ Wrong instance name reference (e.g., `lab02` instead of `lab05`)
- ⚠️ Incorrect attribute names
- ⚠️ Missing quotes around output names

### Benefits of Separate Output Files
- Easier debugging and troubleshooting
- Clear separation of concerns
- Better code organization in larger projects

---

## 5.5 Initializing, Validating, and Applying Infrastructure

### Overview
This module walks through the complete Terraform workflow, including error handling and validation processes. A deliberate error is introduced to demonstrate debugging techniques.

### Terraform Workflow Commands

#### 1. Format Code
```bash
terraform fmt
```
- Ensures consistent code formatting
- No output indicates perfectly formatted files

#### 2. Initialize
```bash
terraform init
```
- Downloads AWS provider plugin
- Creates `.terraform.lock.hcl` file
- Initializes backend configuration

#### 3. Validate (with Error Handling)
```bash
terraform validate
```

**Common Error Example:**
```
Error: Reference to undeclared resource
on outputs.tf line 10:
  10: value = aws_instance.lab02.public_ip

The configuration is invalid because it references
a resource that doesn't exist: aws_instance.lab02
```

**Resolution:**
- Verify resource names match exactly
- Use VS Code Terraform extension for syntax highlighting
- Correct references to `aws_instance.lab05`

#### 4. Apply Infrastructure
```bash
terraform apply
```

Creation order:
1. Key pair deployer
2. Security groups (egress first, then ingress)
3. Security group rules
4. EC2 instance (takes longest)

### Output Results
After successful apply:
```
Outputs:

public_dns = "ec2-xx-xx-xx-xx.compute-1.amazonaws.com"
public_ip = "XX.XX.XX.XX"
```

### AWS Console Verification
- Instance appears with correct tags
- Security groups properly attached
- Network interface shows public IP and DNS
- Status checks pass (2/2 checks)

### State File Analysis
The `terraform.tfstate` file contains:
- Resource configurations
- Output values with actual AWS data
- Resource dependencies
- Creation metadata

---

## 5.6 Using SSH to Connect to the New Instance

### Overview
This module demonstrates connecting to AWS instances via SSH using locally generated keys. It covers both direct IP connection and dynamic connection using Terraform outputs.

### SSH Connection Methods

#### Method 1: Direct Connection with IP
```bash
ssh -i "../keys/awskey" ubuntu@XX.XX.XX.XX
```

#### Method 2: Using Terraform Output
```bash
ssh -i "../keys/awskey" ubuntu@$(terraform output -raw public_ip)
```

### SSH Options Explained
- `-i`: Identity file (private key path)
- `-raw`: Output format flag for clean IP address
- Username: `ubuntu` (default for Ubuntu AMIs on AWS)

### Post-Connection Verification
```bash
# Check OS version
cat /etc/os-release
# Output: Ubuntu 24.04.1 LTS

# Check for web server (not installed yet)
systemctl status apache2
# Unit apache2 could not be found
```

### Managing Outputs
If outputs disappear from terminal:
```bash
terraform output
```
Shows all configured outputs with values.

Individual output:
```bash
terraform output public_ip
terraform output public_dns
```

### Exam Alert: Output Commands
- `terraform output` - Shows all outputs
- `terraform output <name>` - Shows specific output
- Use outputs with SSH: `ssh -i key user@$(terraform output -raw public_ip)`

---

## 5.7 Destroying the Infrastructure

### Overview
This final module reinforces the importance of cleaning up infrastructure to avoid unnecessary AWS charges.

### Destruction Process
```bash
terraform destroy
```

Destruction plan shows:
- 9 resources to destroy
- Changes to outputs (will become null)
- Order of destruction (opposite of creation)

### Destruction Order
1. Security group rules
2. Security groups
3. Key pair
4. EC2 instance

### Post-Destruction Verification
- AWS Console shows "failed to describe volume"
- Instance no longer appears in console
- `terraform.tfstate.backup` created
- New state file contains null check results

### Critical Reminders
> [!IMPORTANT]
> Always destroy infrastructure when lab is complete
> Verify destruction in AWS Console
> Check for any lingering resources

---

## 5.8 Quiz

### Question 1
**You just ran a Terraform apply and a virtual machine was created on the cloud provider successfully. Which command can you use to find out the IP address of the virtual machine?**

Options:
- A) terraform validate
- B) terraform plan
- C) terraform destroy
- D) terraform output

**Answer: D) terraform output**

This assumes an outputs.tf file was created with the public IP specified as an output.

### Question 2
**How can you view a single output using the CLI?**

Given: `output "public_dns" { value = aws_instance.lab05.public_dns }`

Options:
- A) terraform show
- B) terraform output public_dns
- C) terraform show aws_instance.lab05.public_dns
- D) terraform output

**Answer: B) terraform output public_dns**

Must specify the output name (Terraform ID) that was defined in the output block.

### Best Practice Highlight
> [!NOTE]
> **Never imply what you want to apply. Be specific and leave nothing to chance.**
> - Always create explicit output blocks
> - Use separate outputs.tf files for clarity
> - Reference outputs by their defined names

---

## Summary

### Key Takeaways
```diff
+ Directory structure organization improves project management
+ Local SSH key generation provides better security control
+ Separate Terraform files enhance code organization and debugging
+ Output blocks extract essential instance information
+ Proper validation prevents deployment errors
+ Dynamic SSH connections using terraform output commands
+ Always destroy infrastructure to avoid charges
```

### Quick Reference

| Command | Purpose |
|---------|---------|
| `mkdir {instances,keys}` | Create lab directories |
| `ssh-keygen` | Generate SSH key pair |
| `terraform fmt` | Format Terraform files |
| `terraform init` | Initialize Terraform |
| `terraform validate` | Check configuration syntax |
| `terraform apply` | Deploy infrastructure |
| `terraform output` | Display all outputs |
| `terraform output <name>` | Display specific output |
| `terraform destroy` | Remove all resources |

### Expert Insight

**Real-world Application:**
- Use outputs to integrate Terraform with CI/CD pipelines
- Implement SSH key management in production environments
- Organize large infrastructure projects with multiple files
- Automate post-deployment verification using outputs

**Expert Path:**
- Master complex output expressions and data sources
- Implement dynamic key rotation strategies
- Create reusable modules with proper outputs
- Integrate with secrets management systems

**Common Pitfalls:**
- Mismatched resource names between files
- Forgetting to link security groups to instances
- Not verifying SSH connectivity before deployment
- Skipping infrastructure destruction

**Lesser-Known Facts:**
- Terraform outputs can use complex expressions and functions
- SSH key pairs can be imported from existing AWS resources
- The `-raw` flag strips quotes from output values
- State files contain all output historical values

</details>