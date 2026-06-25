# Section 8: Introduction to Terraform Modules

<details open>
<summary><b>Section 8: Introduction to Terraform Modules (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

1. [Introduction to Terraform Modules](#81-introduction-to-terraform-modules)
2. [Building a Shared Local Module – Part 1](#82-building-a-shared-local-module--part-1)
3. [Building a Shared Local Module – Part 2](#83-building-a-shared-local-module--part-2)
4. [Building a Shared Local Module – Part 3](#84-building-a-shared-local-module--part-3)
5. [Working with Public and Local Modules – Part 1](#85-working-with-public-and-local-modules--part-1)
6. [Working with Public and Local Modules – Part 2](#86-working-with-public-and-local-modules--part-2)
7. [Working with Public and Local Modules – Part 3](#87-working-with-public-and-local-modules--part-3)
8. [Working with Public and Local Modules – Part 4](#88-working-with-public-and-local-modules--part-4)
9. [Working with Public and Local Modules – Part 5](#89-working-with-public-and-local-modules--part-5)
10. [Quiz](#810-quiz)
11. [Summary](#summary)

---

## 8.1 Introduction to Terraform Modules

### Overview

As Terraform configurations become more complex, they become increasingly difficult to read and maintain. Modules provide a solution by offering reusable configurations that can be packaged and stored anywhere. The main goal is to avoid reinventing the wheel by reusing existing configurations.

### Key Concepts/Deep Dive

#### What are Terraform Modules?

Modules are containers where you can store multiple resources that work together. Examples include:
- Three web servers with specific network infrastructure requirements
- Different phases of software development
- Organizational departments or individual users

#### Module Structure

- Modules include multiple `.tf` files within a directory
- Common files include: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `providers.tf`
- Even a single `main.tf` file constitutes a module (the parent/root module)
- Child modules or submodules can be called from other directories

#### Why Use Modules?

- **Organize**: Structure complex configurations logically
- **Encapsulate**: Hide implementation details
- **Reuse**: Share configurations across projects and teams
- **Consistency**: Ensure standardized deployments
- **Self-service**: Allow team members to use configurations without modification

#### Module Storage Locations

**Valid Storage Locations:**
- **Local file system**: On your computer
- **Terraform Registry**: `registry.terraform.io` (tens of thousands of modules available)
  - Examples: AWS IAM (323 million downloads), Cloud Posse, S3 bucket, VPC modules
- **Terraform Cloud**: Private and secure storage
- **Terraform Enterprise**: On-premises server
- **Version Control Systems**: Git, GitHub, BitBucket, etc.
- **HTTP URLs**: Direct downloads
- **Archive files**: ZIP, TAR files
- **Cloud storage**: AWS S3 buckets, Google Cloud Storage (GCS) buckets

**Invalid Storage Locations:**
- BLOB storage (Binary Large Object)
- Databases (MySQL, PostgreSQL)
- SSH and FTP protocols
- Arbitrary HTTP servers without specific protocols
- The `.terraform` directory in your working project

### Exam Alerts

> [!IMPORTANT]
> Key exam points about module storage:
> - Modules CAN be stored in Terraform Registry, local file systems, VCS, HTTP URLs, and cloud storage
> - Modules CANNOT be stored in BLOB storage, databases, SSH, FTP, or arbitrary HTTP servers
> - The `.terraform` directory is for downloaded modules only, not for storing your own modules

### Code Examples

```hcl
# Basic module structure
# main.tf - contains resource definitions
# variables.tf - contains variable declarations
# outputs.tf - contains output values

# Example module call
module "web_server" {
  source = "./modules/web_server"

  vpc_id         = aws_vpc.main.id
  subnet_id      = aws_subnet.public.id
  instance_type  = "t2.micro"
}
```

### Lab Overview

This section includes multiple labs demonstrating:
- Building local modules
- Working with public modules from the Terraform Registry
- Module versioning and best practices

---

## 8.2 Building a Shared Local Module – Part 1

### Overview

This lab demonstrates building a reusable web server module that multiple users can utilize. The module will be shared between different user configurations while maintaining separation of concerns.

### Key Concepts/Deep Dive

#### Lab Structure

The lab creates a directory structure that separates:
- Module code (reusable components)
- User configurations (specific implementations)

#### Directory Setup

```bash
# Create directory structure
mkdir -p modules/webserver
mkdir -p dave-config
mkdir -p user2-config
```

#### Module File Creation

**Minimum Requirements:**
- `main.tf`: Contains the main infrastructure code
- `variables.tf`: Defines input variables
- `outputs.tf`: (Optional but recommended) Defines outputs

```bash
cd modules/webserver
touch main.tf variables.tf
```

#### Module Purpose

The web server module will:
- Create necessary network infrastructure (subnets)
- Deploy EC2 instances configured as web servers
- Accept user-specific parameters via variables
- Be reusable across multiple user configurations

### Directory Structure

```
lab-08/
├── modules/
│   └── webserver/
│       ├── main.tf
│       └── variables.tf
├── dave-config/
│   └── main.tf
└── user2-config/
    └── main.tf
```

---

## 8.3 Building a Shared Local Module – Part 2

### Overview

This part focuses on implementing the actual code for the shared module, including resource definitions and variable declarations.

### Key Concepts/Deep Dive

#### Main.tf Implementation

**Terraform Block:**

```hcl
terraform {
  required_version = ">= 1.4.2"
}
```

**Resource Definitions:**

1. **AWS Subnet Resource:**
```hcl
resource "aws_subnet" "websubnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidrblock
}
```

2. **AWS Instance Resource:**
```hcl
resource "aws_instance" "webserver" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.websubnet.id

  tags = {
    Name = "${var.webserver_name} web server"
  }
}
```

> [!NOTE]
> The provider block is intentionally omitted from the module to allow users to specify their own region and credentials.

#### Variables.tf Implementation

All variables are defined as string types:

```hcl
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cidrblock" {
  type        = string
  description = "CIDR block"
}

variable "ami" {
  type        = string
  description = "AMI for the web server instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "webserver_name" {
  type        = string
  description = "Name of the web server"
}
```

#### Important Syntax Note

When combining strings with variables, proper quoting is required:

```hcl
# Correct syntax
tags = {
  Name = "${var.webserver_name} web server"
}

# Incorrect - missing quotes
tags = {
  Name = ${var.webserver_name} web server  # Error!
}
```

#### Terraform Fmt Usage

```bash
terraform fmt
```

This command:
- Formats code according to Terraform standards
- Can identify syntax errors (like missing quotes)
- Should be run before terraform validate

### Best Practices

- Always use `terraform fmt` after writing code
- Ensure all variable references match between main.tf and variables.tf
- Keep modules region-agnostic by not hardcoding provider configurations
- Use descriptive variable descriptions

---

## 8.4 Building a Shared Local Module – Part 3

### Overview

This final part of the local module lab demonstrates how to consume the module from user directories, complete the Terraform workflow, and verify the deployment.

### Key Concepts/Deep Dive

#### User Configuration Setup

Each user directory contains its own `main.tf` that:

1. **Defines the provider** (region-specific)
2. **Creates a VPC** (each user gets their own VPC)
3. **Calls the module** with specific parameters

#### Provider and VPC Configuration

```hcl
provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

#### Module Block Implementation

```hcl
module "webserver_dave" {
  source = "../modules/webserver"

  vpc_id          = aws_vpc.main.id
  cidrblock       = "10.0.0.0/16"
  ami             = "ami-0c55b159cbfafe1f0"
  instance_type   = "t2.micro"
  webserver_name  = "Dave"
}
```

#### Module Path Resolution

- Source path uses relative paths: `../modules/webserver`
- Points to the module directory containing the Terraform files
- Module is referenced by its directory location

#### Terraform Workflow Execution

**Step 1: Format**
```bash
terraform fmt
```

**Step 2: Validate**
```bash
terraform validate
```
- May show error about module not installed until init is run

**Step 3: Initialize**
```bash
terraform init
```
- Creates `.terraform` directory
- Downloads provider plugins
- Creates module reference (JSON file pointing to module location)
- Generates `.terraform.lock.hcl`

**Step 4: Apply**
```bash
terraform apply
```
Creates three resources:
1. AWS VPC (in user directory)
2. Module resources (subnet and instance via module)

#### Resource Naming in Modules

When resources are created within modules, their full path includes:
- `module.<module_name>.<resource_type>.<resource_name>`

Example: `module.webserver_dave.aws_instance.webserver`

#### Verification Steps

1. Check AWS Console for running instance named "Dave web server"
2. Review `terraform.tfstate` to see resource hierarchy
3. Confirm proper resource dependencies

#### Cleanup
```bash
terraform destroy
```

#### Extending the Lab

For additional practice:
- Create `user2-config` directory
- Modify module name, webserver name
- Use different region (e.g., us-west-2) with appropriate AMI
- Ensure proper destruction of all resources

### Key Insights

> [!IMPORTANT]
> Variables and modules are the two most important Terraform concepts:
> - They work together seamlessly
> - Modules encapsulate reusable logic
> - Variables provide customization points
> - Essential for both field work and certification exam

---

## 8.5 Working with Public and Local Modules – Part 1

### Overview

This lab demonstrates working with publicly available modules from the Terraform Registry. Instead of writing modules from scratch, you'll learn to leverage pre-built, tested modules for common infrastructure patterns.

### Key Concepts/Deep Dive

#### Lab Objectives

- Use AWS VPC module for networking infrastructure
- Use AWS EC2 instance module for compute resources
- Build a three-server cluster with proper networking
- Understand module versioning and selection

#### Lab Warning

> [!IMPORTANT]
> This lab will incur AWS charges (estimated under $1). Do not apply if you don't want to be charged.

#### Directory Structure

```
lab-08b/
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform/
    └── modules/
        ├── vpc/
        └── ec2-instance/
```

#### Module Sources

Two primary modules from Terraform Registry:
1. **VPC Module**: `terraform-aws-modules/vpc/aws`
   - 161 million+ downloads
   - Handles all VPC networking components

2. **EC2 Instance Module**: `terraform-aws-modules/ec2-instance/aws`
   - 36 million+ downloads
   - Manages EC2 instance lifecycle

#### Lab Phases

1. Setup and main.tf analysis
2. Module download with `terraform get`
3. Full Terraform workflow execution
4. Variables and outputs analysis
5. Cleanup and destruction

### Important Considerations

- Public modules are open source and free to use
- Modules come with extensive inputs and outputs
- Select only the parameters you need
- Always pin module versions for reproducibility

---

## 8.6 Working with Public and Local Modules – Part 2

### Overview

This section provides detailed analysis of the main.tf file that orchestrates multiple public modules to create a complete infrastructure deployment.

### Key Concepts/Deep Dive

#### Main.tf Structure Analysis

**Terraform and Provider Blocks:**

```hcl
terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}
```

#### VPC Module Configuration

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.vpc_tags
}
```

**Key VPC Variables:**
- Network configuration: 10.0.0.0/16 CIDR
- Private subnets: 10.0.1.0/24
- Public subnets: 10.0.101.0/24 (not truly public-facing)

#### EC2 Instance Module Configuration

```hcl
module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  count = 3

  name = "cluster-a-${count.index}"

  ami           = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "testing"
  }
}
```

#### Meta Arguments

**Count Meta Argument:**
- Creates multiple instances of a resource
- `count = 3` creates three instances
- Access individual instances with `count.index`

**Naming Convention:**
- Uses `count.index` for unique naming
- Results in: cluster-a-0, cluster-a-1, cluster-a-2

#### Module Interdependencies

Resources in modules can reference each other:

```hcl
# Referencing VPC module outputs in EC2 module
vpc_security_group_ids = [module.vpc.default_security_group_id]
subnet_id              = module.vpc.public_subnets[0]
```

### Module Flexibility

- Modules provide hundreds of inputs and outputs
- Not all need to be used
- Select specific functionality as needed
- Version pinning ensures consistency

---

## 8.7 Working with Public and Local Modules – Part 3

### Overview

This section introduces the `terraform get` command for downloading remote modules and provides deep analysis of module structure and capabilities.

### Key Concepts/Deep Dive

#### Terraform Get Command

**Purpose:** Download modules without initializing the working directory

```bash
terraform get
```

**Features:**
- Downloads modules specified in configuration
- Stores in `.terraform/modules/` directory
- Use `-update` flag to refresh existing modules: `terraform get -update`

**Difference from Init:**
- `terraform init`: Gets modules + providers + initializes backend
- `terraform get`: Exclusively handles modules

#### Module Directory Structure

Downloaded modules contain complete codebases:

```
.terraform/
└── modules/
    ├── ec2-instance/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── versions.tf
    │   ├── docs/
    │   ├── examples/
    │   └── wrappers/
    └── vpc/
        └── [similar structure]
```

#### Module Content Analysis

**EC2 Instance Module:**
- Extensive `main.tf` with data sources and locals
- Dynamic blocks for flexible configuration
- 30+ output values available
- Comprehensive variable definitions

**VPC Module:**
- Complex locals blocks for IP management
- IPv4 and IPv6 support
- Security group management
- 119+ output values

#### Terraform Registry Exploration

**Module Registry Features:**
- Download statistics and popularity metrics
- Version history and changelogs
- Input/output documentation
- Usage examples
- Dependency information

**Example EC2 Module Usage:**
```hcl
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "single-instance"
  ami  = "ami-0c55b159cbfafe1f0"

  instance_type = "t2.micro"
  key_name      = "user_key"
  subnet_id     = "subnet-xxxxxxxxx"
}
```

#### Module Versioning

> [!NOTE]
> Module versions change over time. Always:
> - Pin specific versions in production
> - Test version updates in development
> - Review changelogs before updating

### Best Practices for Module Usage

1. Review module documentation thoroughly
2. Understand all inputs being passed
3. Verify output references match module definitions
4. Keep modules updated but version-controlled
5. Use specific versions, not latest

---

## 8.8 Working with Public and Local Modules – Part 4

### Overview

This section walks through the complete Terraform workflow execution, from initialization through infrastructure creation and verification.

### Key Concepts/Deep Dive

#### Terraform Workflow Execution

**Step 1: Initialize**
```bash
terraform init
```
- Verifies existing modules in `.terraform/modules/`
- Initializes provider plugins
- Creates lock file
- Confirms module readiness

**Step 2: Format**
```bash
terraform fmt
```
- Standardizes code formatting
- Reconciles any style inconsistencies

**Step 3: Validate**
```bash
terraform validate
```
- Checks configuration syntax
- Verifies module references
- Confirms variable definitions

**Step 4: Plan and Apply**
```bash
terraform apply
```
- Shows resource creation plan (35 resources in this lab)
- Includes networking, security, and compute resources

#### Resource Creation Breakdown

**Infrastructure Components Created:**
- 1 VPC with CIDR configuration
- Multiple subnets (public and private)
- Route tables and associations
- Internet Gateway
- NAT Gateway with Elastic IP
- Security Groups
- 3 EC2 instances
- Various supporting resources

#### Output Configuration

**Outputs.tf Implementation:**
```hcl
output "ec2_instance_private_ips" {
  value = module.ec2_instances[*].private_ip
}
```

**Key Concepts:**
- Wildcard/splat operator (`[*]`) for accessing all instances
- Single output collecting multiple values
- References output from child module

#### Deployment Verification

**AWS Console Verification:**
1. VPC Dashboard shows new VPC
2. Subnet configuration matches specifications
3. EC2 instances running with proper naming
4. All health checks passing

**Instance Details:**
- Names: cluster-a-0, cluster-a-1, cluster-a-2
- Network: All on 10.0.101.0/24 subnet
- Status: Running with 2/2 checks passed

#### Terraform State Analysis

State file tracks:
- All 35 created resources
- Module hierarchy and resource paths
- Resource attributes and dependencies

### Cost Considerations

- Three t2.micro instances running
- NAT Gateway incurs hourly charges
- Elastic IPs have associated costs
- Destroy resources promptly after testing

---

## 8.9 Working with Public and Local Modules – Part 5

### Overview

This final section provides detailed analysis of how variables and outputs flow between the root module and child modules, demonstrating the complete integration pattern.

### Key Concepts/Deep Dive

#### Variable Flow Analysis

**Three-Layer Variable System:**

1. **Module Input Definition** (in downloaded module):
```hcl
# In .terraform/modules/vpc/variables.tf
variable "public_subnets" {
  description = "List of public subnets inside the VPC"
  type        = list(string)
  default     = []
}
```

2. **Root Module Variable Declaration** (in root variables.tf):
```hcl
variable "vpc_public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}
```

3. **Module Call Assignment** (in root main.tf):
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  public_subnets = var.vpc_public_subnets
}
```

#### Output Flow Analysis

**Output Chain:**

1. **Module Output Definition** (in EC2 module):
```hcl
# In .terraform/modules/ec2-instance/outputs.tf
output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.this[*].private_ip
}
```

2. **Root Module Output Reference** (in root outputs.tf):
```hcl
output "ec2_instance_private_ips" {
  value = module.ec2_instances[*].private_ip
}
```

#### Variable Naming Conventions

**Important:** Variable names must match exactly between:
- Module definition (what the module expects)
- Module call (how you reference it)
- Local variable definition (your custom name)

Example mismatch would cause errors:
```hcl
# Module expects: public_subnets
# Your code uses: vpc_public_subnets (your local variable)
# Connection: public_subnets = var.vpc_public_subnets
```

#### Splat/Wildcard Operator

**Usage Pattern:**
```hcl
# Access all instance IPs
module.ec2_instances[*].private_ip

# Results in list: ["10.0.101.231", "10.0.101.48", "10.0.101.20"]
```

#### Complete Lab Review

**What Was Accomplished:**

1. **Root Module Setup:**
   - Prepared main.tf, variables.tf, outputs.tf
   - Configured module calls with specific parameters

2. **Module Integration:**
   - Downloaded VPC module (networking/security)
   - Downloaded EC2 module (compute instances)
   - Connected modules through input/output references

3. **Infrastructure Deployment:**
   - Created isolated VPC environment
   - Deployed three-instance cluster
   - Established proper networking

4. **Resource Management:**
   - Used count meta-argument for instance scaling
   - Implemented proper naming with count.index
   - Verified complete destruction of resources

### Module Best Practices Summary

1. **Always version pin modules and providers**
2. **Review module documentation before use**
3. **Use only needed inputs and outputs**
4. **Maintain consistent naming conventions**
5. **Test module updates in non-production first**
6. **Document module sources and versions**

---

## 8.10 Quiz

### Overview

This quiz tests understanding of module registries, the terraform get command, and module management concepts.

### Questions and Answers

#### Question 1: Private Module Registry Benefits

**Question:** Which of the following does the Terraform Cloud Private Module Registry offer over the public Terraform Module Registry?

**Options:**
- A) The ability to restrict modules to members of Terraform Cloud or Terraform Enterprise
- B) The ability to share modules with public Terraform users and with members of Terraform Enterprise organizations
- C) The ability to share modules publicly with any user of Terraform
- D) The ability to tag modules by version number or release number

**Correct Answer:** A

**Explanation:**
The key word "private" indicates restricted access. Terraform Cloud Private Module Registry allows organizations to keep modules internal to their Terraform Cloud or Enterprise users, unlike the public registry which is accessible to everyone.

**Why Other Options Are Wrong:**
- B & C: Public access contradicts the "private" nature of the registry
- D: Both public and private registries support version tagging

#### Question 2: Terraform Get Command

**Question:** You want to download modules from the Terraform Registry, but you do not want to initialize your working directory. Which command should you use?

**Options:**
- A) terraform init
- B) terraform apply
- C) terraform get
- D) terraform output

**Correct Answer:** C

**Explanation:**
The `terraform get` command exclusively downloads modules without initializing providers or the backend. This is useful when you need modules but want to handle other initialization separately.

**Command Details:**
```bash
# Download modules
terraform get

# Update existing modules
terraform get -update
```

**Why Other Options Are Wrong:**
- A) terraform init downloads modules AND initializes providers/backend
- B) terraform apply requires initialization first
- D) terraform output only displays output values

### Key Takeaways from Quiz

> [!IMPORTANT]
> - "Private" in Terraform Cloud means access control, not public availability
> - Use `terraform get` for module-only operations
> - Version tagging is available in all Terraform registries
> - Module initialization is part of the broader init process

---

## Summary

### Key Takeaways

```diff
+ Modules enable code reuse and consistency across Terraform projects
+ Every Terraform configuration is a module (root module)
+ Modules can be stored locally, in registries, VCS, or cloud storage
+ Public modules from Terraform Registry save development time
+ terraform get downloads modules without full initialization
+ Module inputs and outputs create reusable interfaces
+ Version pinning ensures reproducible deployments
+ Meta arguments like count enable resource scaling
- Never store modules in databases, BLOB storage, or via SSH/FTP
- The .terraform directory is managed by Terraform, not for custom modules
```

### Quick Reference

```bash
# Module Commands
terraform get              # Download modules only
terraform get -update      # Update existing modules
terraform init             # Initialize including modules

# Module Block Structure
module "name" {
  source  = "path/or/registry/source"
  version = "x.y.z"

  # Input variables
  input1 = value1
  input2 = value2
}

# Accessing Module Outputs
module.name.output_name

# Count Meta Argument
count = 3
name  = "instance-${count.index}"
```

### Expert Insight

#### Real-world Application

In production environments, modules form the backbone of infrastructure standardization:
- **Shared modules** ensure consistent security baselines across all deployments
- **Environment modules** (dev/staging/prod) maintain configuration parity
- **Team modules** enable self-service infrastructure for development teams
- **Compliance modules** enforce organizational policies automatically

#### Expert Path

To master Terraform modules:
1. Start with local modules to understand the pattern
2. Progress to consuming public modules effectively
3. Learn to publish your own modules to registries
4. Implement module testing with tools like `terratest`
5. Develop module versioning and release strategies
6. Create module documentation and examples

#### Common Pitfalls

1. **Hardcoding values** in modules instead of using variables
2. **Ignoring module versions** leading to unexpected changes
3. **Over-engineering modules** with unnecessary complexity
4. **Missing provider configurations** in multi-region setups
5. **Not destroying test infrastructure** leading to unexpected costs

#### Lesser-Known Facts

- Modules can use `for_each` meta argument for more flexible instantiation
- Module sources can include archive files (ZIP/TAR) directly
- The `terraform get` command respects module version constraints
- Modules can have their own `required_providers` blocks
- Module outputs can use `sensitive = true` for secret values
- Local modules can be developed and tested without publishing

</details>