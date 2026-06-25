# Section 7: Introduction to Terraform Variables

<details open>
<summary><b>Section 7: Introduction to Terraform Variables (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

1. [7.1 Introduction to Terraform Variables](#71-introduction-to-terraform-variables)
2. [7.2 Define and Reference Variables](#72-define-and-reference-variables)
3. [7.3 Using -var to Specify Values](#73-using--var-to-specify-values)
4. [7.4 Specifying Values in the CLI](#74-specifying-values-in-the-cli)
5. [7.5 Types of Variables](#75-types-of-variables)
6. [7.6 Using .tfvars Files](#76-using-tfvars-files)
7. [7.7 Environment Variables](#77-environment-variables)
8. [7.8 Variables Precedence](#78-variables-precedence)
9. [7.9 Speeding up Terraform: Aliases in Bash and Fish](#79-speeding-up-terraform-aliases-in-bash-and-fish)
10. [7.10 Quiz](#710-quiz)
11. [Summary Section](#summary-section)

---

## 7.1 Introduction to Terraform Variables

### Overview

This module introduces Terraform variables as symbolic names associated with values, enabling flexible and reusable configurations. Variables follow the same concepts as in other programming languages, consisting of a variable block for definition and resource blocks for referencing.

### Key Concepts/Deep Dive

#### Variable Block Structure
The variable block contains three key components:

- **Description**: Optional documentation explaining the variable's purpose
- **Type**: Specifies the data type (defaults to string if omitted)
- **Default**: The actual value assigned to the symbolic name

```hcl
variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "Lab 07 variables"
}
```

#### Resource Block Variable Reference
To reference a variable within a resource, use the `var.` prefix followed by the symbolic name:

```hcl
resource "aws_instance" "lab_07" {
  ami           = "ami-12345"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
```

#### File Organization Best Practices
- Store variable definitions in `variables.tf`
- Keep resource definitions in `main.tf`
- This separation allows users to modify values without touching core infrastructure code
- Promotes reproducibility and team collaboration

#### Benefits of Using Variables
- ✅ Write more flexible configurations
- ✅ Create reusable infrastructure code
- ✅ Enable customization without modifying main configuration files
- ✅ Support different environments (dev, staging, prod)

---

## 7.2 Define and Reference Variables

### Overview

This hands-on lab demonstrates creating a `variables.tf` file, defining variable blocks with symbolic names, descriptions, types, and defaults, then referencing these variables from `main.tf` using proper syntax and color-coded validation.

### Key Concepts/Deep Dive

#### Lab Setup
- Working in Lab 07 directory with color-coded file management
- Files: `main.tf` (contains terraform, provider, and resource blocks)
- Need to create: `variables.tf` for variable declarations

#### Creating the Variables File
```hcl
variable "instance_name" {
  description = "The name tag for the EC2 instance"
  type        = string
  default     = "lab07 variables!"
}
```

#### Variable Reference Syntax
- Use `var.` prefix followed by the symbolic name
- Terraform extension auto-suggests available variables
- Press Tab to auto-complete variable references
- Ensure entire reference maintains consistent color coding

#### Validation and Error Detection
```hcl
# ❌ Incorrect - will show red underline and inconsistent colors
Name = var.instance_type

# ✅ Correct - consistent color and no underline
Name = var.instance_name
```

#### Terraform Commands Used
```bash
terraform init      # Initialize the directory
terraform validate  # Check configuration syntax
terraform apply     # Build the infrastructure
```

#### Important Notes
- Variable blocks must exist before referencing them
- Terraform validate will fail with incorrect variable references
- The entire variable reference should display as a single color when correct

---

## 7.3 Using -var to Specify Values

### Overview

This module demonstrates how to override variable default values using the `-var` command-line flag during `terraform apply`, allowing runtime value specification without modifying configuration files.

### Key Concepts/Deep Dive

#### Command Syntax
```bash
terraform apply -var "instance_name=new name"
```

#### Key Requirements
- Use `-var` flag to override defaults
- Entire argument must be enclosed in double quotes
- Format: `variable_name=value`
- Value must match the declared type

#### Process Flow
1. Default value exists in `variables.tf`
2. Command line `-var` flag overrides the default
3. Terraform detects configuration drift (1 to change)
4. Apply updates only the changed attribute
5. Verify changes in AWS console

#### Example Workflow
```bash
# Override the instance name
terraform apply -var "instance_name=new name"

# Expected output: "1 to change"
# Result: Instance renamed to "new name"
```

#### Use Cases
- Testing different configurations quickly
- Environment-specific deployments
- One-time value overrides
- CI/CD pipeline parameterization

---

## 7.4 Specifying Values in the CLI

### Overview

This module shows how to remove default values from variable blocks, causing Terraform to prompt for required values during `terraform apply` and `terraform destroy` operations, ensuring explicit value specification.

### Key Concepts/Deep Dive

#### Removing Default Values
```hcl
variable "instance_name" {
  description = "The name tag for the EC2 instance"
  type        = string
  # default removed - will prompt for value
}
```

#### CLI Prompting Behavior
When no default exists and no `-var` is provided:
- Terraform automatically detects missing required values
- Prompts user for input during apply
- Same value required for destroy to match state
- Ensures explicit configuration

#### Workflow Steps
```bash
# Apply without default - prompts for name
terraform apply
# Enter: server-A

# Destroy requires same value
terraform destroy
# Enter: server-A
```

#### Extra Credit Exercises
1. Create variable block for AMI in `variables.tf`
2. Reference AMI variable in `main.tf` resource
3. Explore different variable types (covered in next lesson)

#### Best Practices
- Always verify infrastructure destruction in both CLI and console
- Check for extra credit opportunities in lab materials
- Practice creating multiple variable blocks for different attributes

---

## 7.5 Types of Variables

### Overview

This comprehensive module covers Terraform's variable types: primitive types (string, number, bool), complex types (list, set, map, object), and the null type, with practical examples for each category.

### Key Concepts/Deep Dive

#### Primitive Types

**String**
- Sequence of alphanumeric characters
- Requires double quotes
- Example: `"Hello world"`

**Number**
- Numeric values without quotes
- Supports integers and floating-point
- Examples: `2`, `20`, `3.14`
- Use cases: instance counts, thresholds, percentages

**Bool**
- Boolean values: `true` or `false`
- Used for conditional logic and feature flags
- Example:
```hcl
variable "enable_feature_x" {
  description = "Controls whether feature X should be enabled"
  type        = bool
  default     = false
}
```

#### Complex Types

**List (Tuple)**
- Ordered collection of values
- Uses square brackets as delimiters
- Comma-separated values in double quotes
- Order is preserved
```hcl
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
```

**Set**
- Unordered collection of values
- Similar syntax to lists
- Order doesn't matter
- Can convert to list using `tolist()` function
```hcl
variable "security_groups" {
  type    = set(string)
  default = ["sg-12345", "sg-67890"]
}
```

**Map (Object)**
- Key-value pairs using curly braces
- Maps require single value type
- Objects can contain multiple types
```hcl
# Map example
variable "instance_types" {
  type = map(string)
  default = {
    dev  = "t2.micro"
    prod = "m5.large"
  }
}

# Object example
variable "server_config" {
  type = object({
    name      = string
    cpu_cores = number
    tags      = map(string)
    enabled   = bool
  })
}
```

#### Null Type
- Used to omit values
- Allows provider defaults or ignores arguments
- Example:
```hcl
variable "app_id" {
  description = "Optional application ID"
  type        = string
  default     = null  # Omits the argument
}
```

#### Practical Example - Advanced Variables
See `z_variables_advanced` solution file for complete examples of maps, objects, and null values in action.

---

## 7.6 Using .tfvars Files

### Overview

This module demonstrates using `.tfvars` files to separate variable values from variable declarations, providing a cleaner approach for managing configurations and protecting sensitive information.

### Key Concepts/Deep Dive

#### Simplified Variable Declaration
```hcl
# variables.tf - simplified
variable "instance_name" {}
```

#### Creating terraform.tfvars
```hcl
# terraform.tfvars
instance_name = "Virtual 7"
```

#### File Structure Flow
1. `main.tf` → references variable with `var.instance_name`
2. `variables.tf` → declares variable block (no default needed)
3. `terraform.tfvars` → provides actual values

#### Key Distinction
| File | Contains | Notes |
|------|----------|-------|
| `variables.tf` | Variable declarations + optional defaults | Full variable blocks |
| `terraform.tfvars` | Values only | No variable blocks allowed |

#### Advanced tfvars Options

**Auto-loading tfvars Files**
- Files ending in `auto.tfvars` load automatically
- Pattern: `<name>.auto.tfvars`
- Example: `prod.auto.tfvars`, `dev.auto.tfvars`

**Custom tfvars Files**
```bash
terraform apply -var-file=dev.auto.tfvars
terraform apply -var-file=prod.auto.tfvars
```

#### Security Considerations
- Add `terraform.tfvars` to `.gitignore`
- Prevents accidental credential exposure
- Create `terraform.tfvars.example` as template
- Rename example files to `terraform.tfvars` for use

#### JSON Alternative
- Terraform also supports `terraform.tfvars.json`
- Useful for programmatic generation

---

## 7.7 Environment Variables

### Overview

This module explains using operating system environment variables with the `TF_VAR_` prefix as another method for injecting values into Terraform configurations, particularly useful for credentials and sensitive data.

### Key Concepts/Deep Dive

#### Environment Variable Syntax
```bash
export TF_VAR_<variable_name>=<value>
```

#### AWS Credentials Example
```hcl
# variables.tf
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

# main.tf - provider configuration
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
```

#### Setting Environment Variables Securely
```bash
# Note the leading space to hide from history
 export TF_VAR_aws_access_key=your_access_key
 export TF_VAR_aws_secret_key=your_secret_key
```

#### Precedence Behavior
Environment variables have low precedence:
1. Checked after CLI flags and tfvars files
2. Only used if no other value source exists
3. AWS CLI credentials typically take precedence

#### Security Best Practices
- ⚠️ **Never hardcode credentials** in configuration files
- Use leading space before export commands to hide from bash history
- Prefer AWS CLI credential configuration over TF_VAR
- Unset credentials when finished:
```bash
export TF_VAR_aws_access_key=
export TF_VAR_aws_secret_key=
```

#### Naming Conventions
- AWS naming: `aws_access_key`, `aws_secret_key`
- Generic format: `TF_VAR_<your_variable_name>`
- Case-sensitive matching with variable declarations

---

## 7.8 Variables Precedence

### Overview

This critical exam-focused module presents the complete hierarchy of Terraform variable precedence, determining which value source takes priority when multiple options are available.

### Key Concepts/Deep Dive

#### Precedence Hierarchy (Highest to Lowest)

| Priority | Source | Description |
|----------|--------|-------------|
| 1 | `-var` and `-var-file` | Command line flags with `terraform apply` |
| 2 | `*.auto.tfvars` | Auto-loading tfvars files |
| 3 | `terraform.tfvars.json` | JSON format tfvars file |
| 4 | `terraform.tfvars` | Default tfvars file |
| 5 | Environment variables | `TF_VAR_*` variables |
| 6 | Default values | In `variables.tf` variable blocks |

#### Special Cases

**AWS Credentials**
- Stored in `~/.aws/credentials`
- Precedence: After `-var`/`-var-file`, before tfvars files

**Terraform Cloud Credentials**
- Similar precedence to AWS credentials
- Managed separately from variable precedence

**HashiCorp Vault**
- Not included in this precedence list
- Accessed via data sources
- External to Terraform's variable system

#### Exam Alert Points
- `-var` and `-var-file` always win
- Default values only used as last resort
- Auto.tfvars files load before regular tfvars
- Environment variables have low priority

#### Practical Implications
- Use CLI flags for one-time overrides
- Leverage auto.tfvars for environment-specific configs
- Keep terraform.tfvars for common defaults
- Use environment variables sparingly due to low precedence

---

## 7.9 Speeding up Terraform: Aliases in Bash and Fish

### Overview

This productivity module demonstrates creating shell aliases to reduce keystrokes when running common Terraform commands, applicable to both Bash and Fish shells.

### Key Concepts/Deep Dive

#### Bash Aliases

**Configuration File**
Edit `~/.bash_aliases` or `~/.bashrc`:

```bash
alias ta='terraform apply'
alias ti='terraform init'
alias tp='terraform plan'
alias taa='terraform apply -auto-approve'
```

**Enabling Aliases**
```bash
# Option 1: Source the configuration
source ~/.bashrc

# Option 2: Restart terminal session
# Option 3: Log out and back in
```

#### Fish Shell Aliases

**Configuration Directory**
`~/.config/fish/config.fish`:

```fish
abbr -a ta 'terraform apply'
abbr -a ti 'terraform init'
abbr -a tp 'terraform plan'
abbr -a taa 'terraform apply -auto-approve'
```

#### Recommended Terraform Aliases
| Alias | Command | Purpose |
|-------|---------|---------|
| `ta` | `terraform apply` | Quick apply |
| `taa` | `terraform apply -auto-approve` | Bypass confirmation |
| `ti` | `terraform init` | Initialize quickly |
| `tp` | `terraform plan` | Preview changes |
| `td` | `terraform destroy` | Quick destroy |

#### Benefits
- Reduces repetitive typing
- Minimizes errors from long commands
- Speeds up development workflow
- Particularly useful with `-auto-approve` for testing

#### Additional Resources
- Fish shell installation: See OPT 02 Fish Lab
- Fish features: Color coding, auto-completion
- Cross-platform: Works on Linux, macOS, WSL

---

## 7.10 Quiz

### Overview

This assessment module tests understanding of variable referencing syntax and tfvars file behavior through practical scenarios.

### Key Concepts/Deep Dive

#### Question 1: Variable Reference Syntax
**Scenario**: Variable block defined with `instance_name` symbolic name

**Question**: How to reference from `main.tf`?

**Options**:
- A) `name = var.instance_name` ✅
- B) `server = var.server`
- C) `resource = instance_name`
- D) `var.instance_name = default`

**Answer**: A - Use `var.` prefix with the symbolic name

#### Question 2: tfvars File Behavior
**Scenario**: Alice creates `terraform.tfvars` in the same directory as configuration

**Question**: Which commands work with `terraform plan`?

**Options**:
- A) `terraform plan`
- B) `terraform plan -var-file=terraform.tfvars`
- C) All of the above ✅
- D) None of the above

**Answer**: C - Both work because:
- Default filename is automatically detected
- `-var-file` flag explicitly specifies the file
- If file were in subdirectory, `-var-file` would be required with full path

#### Key Takeaways from Quiz
- Always use `var.` prefix for variable references
- Default tfvars filename enables auto-detection
- Path specification required for non-default locations
- Both implicit and explicit methods often valid

---

## Summary Section

### Key Takeaways

```diff
! Variables enable flexible, reusable Terraform configurations
! Use variables.tf for declarations, terraform.tfvars for values
! Multiple methods exist: defaults, CLI flags, tfvars, environment variables
! Precedence hierarchy determines which value source wins
! Never hardcode credentials - use secure injection methods
! Shell aliases improve productivity for common commands
```

### Quick Reference

#### Variable Declaration
```hcl
variable "example" {
  description = "Variable description"
  type        = string
  default     = "default_value"
}
```

#### Variable Types
| Type | Syntax | Example |
|------|--------|---------|
| string | `type = string` | `"value"` |
| number | `type = number` | `42` |
| bool | `type = bool` | `true` |
| list | `type = list(string)` | `["a", "b"]` |
| set | `type = set(string)` | `["a", "b"]` |
| map | `type = map(string)` | `{key = "value"}` |
| object | `type = object({...})` | Complex structure |
| null | `default = null` | Omit value |

#### Value Sources (by precedence)
1. `terraform apply -var "name=value"`
2. `terraform apply -var-file=custom.tfvars`
3. `*.auto.tfvars` files
4. `terraform.tfvars`
5. `TF_VAR_name` environment variables
6. Default in variable block

#### Common Commands
```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform apply -var "name=value"
terraform apply -var-file=dev.tfvars
terraform destroy
```

### Expert Insight

#### Real-world Application
In production environments, variables are essential for:
- Managing multi-environment deployments (dev/staging/prod)
- Handling sensitive credentials securely
- Enabling team collaboration with shared modules
- Supporting CI/CD pipelines with dynamic values
- Implementing infrastructure as code best practices

#### Expert Path
- Master `for_each` and `count` with complex variable types
- Implement validation rules for input variables
- Use Terraform workspaces with variable files
- Explore Terraform Cloud/Enterprise variable sets
- Create reusable modules with comprehensive variable documentation

#### Common Pitfalls
- ❌ Hardcoding sensitive values in configuration files
- ❌ Ignoring variable precedence leading to unexpected values
- ❌ Not using `.gitignore` for tfvars with credentials
- ❌ Creating overly complex variable structures
- ❌ Forgetting to validate configurations before apply

#### Lesser-Known Facts
- Variable validation blocks can enforce custom rules
- `nullable = false` prevents null value assignment
- Sensitive variables appear as `(sensitive value)` in outputs
- Variable descriptions support markdown formatting
- The `terraform console` command allows interactive variable testing

</details>