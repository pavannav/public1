# Section 14: Introduction to Expressions

<details open>
<summary><b>Section 14: Introduction to Expressions (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [14.1 Introduction to Expressions](#141-introduction-to-expressions)
- [14.2 The Splat Expression](#142-the-splat-expression)
- [14.3 Introduction to Functions](#143-introduction-to-functions)
- [14.4 Example Functions](#144-example-functions)
- [14.5 Terraform Console](#145-terraform-console)
- [14.6 The Count Meta-Argument](#146-the-count-meta-argument)
- [14.7 The For_Each Meta-Argument](#147-the-for_each-meta-argument)
- [14.8 The Lifecycle Meta-Argument](#148-the-lifecycle-meta-argument)
- [14.9 The Depends_On Meta-Argument](#149-the-depends_on-meta-argument)
- [14.10 Quiz](#1410-quiz)
- [Summary](#summary)

---

## 14.1 Introduction to Expressions

### Overview
Expressions enable working with values in Terraform configurations, ranging from elementary simple values to advanced complex operations including data references, arithmetic, loops, conditions, and dynamic blocks. Understanding expressions is fundamental to mastering Terraform's declarative configuration language.

### Key Concepts

#### Expression Fundamentals
- Expressions process values within Terraform configurations
- Can be elementary (simple values) or advanced (complex data transformations)
- Named Terraform expressions include `for` and `splat`
- Values work similarly to variable types in Terraform

#### Terraform Value Types

**String**
- Sequence of Unicode characters representing text
- Example: `"hello world"` or `"HashiCorp/aws"`
- Used for text-based arguments and values

**Number**
- Numeric values representing quantities
- Supports whole numbers (15, 20, 42) and fractional values (6.28, 3.14)
- Distinguishes from string representation of the same digits

**Bool**
- Boolean values: `true` or `false`
- Used in conditional logic and decision-making expressions

**List (Tuple)**
- Sequence of values enclosed in square brackets `[]`
- Elements identified by consecutive whole numbers starting from zero
- Example: `["us-east-1", "us-east-2", "us-west-1", "us-west-2"]`
- Ordering is preserved and significant

**Map (Object)**
- Group of values identified by named labels (key-value pairs)
- Enclosed in curly braces `{}`
- Example:
  ```hcl
  {
    name = "user1"
    department = "DevOps"
  }
  ```

**Null**
- Special value representing absence or omission
- Setting an argument to `null` makes Terraform behave as if the argument was omitted
- Useful in conditional expressions for dynamic argument omission
- Falls back to default values or raises errors for mandatory arguments

#### Operators

**Arithmetic Operators**
- `+` Addition
- `-` Subtraction
- `*` Multiplication
- `/` Division

**Comparison Operators**
- `>` Greater than
- `<` Less than
- `>=` Greater than or equal to
- `<=` Less than or equal to

**Version Constraint Operator**
- `~>` Pessimistic constraint operator
- Allows rightmost version component to increment
- Example: `~> 1.5` allows 1.5 through 1.9 but not 2.0
- Restricts updates to minor/patch versions within specified constraints

#### For Expression Basics

**Syntax and Usage**
```hcl
variable "computers" {
  type = list(string)
  default = ["ws01", "ws02", "admin01", "admin02"]
}
```

**For Loop Example**
```hcl
[for s in var.computers : upper(s)]
```
- Iterates across entire list one element at a time
- Applies transformation (uppercase) to each item
- Returns transformed collection

#### Index Notation for Access
- List/tuple elements accessed using square bracket notation: `local.list[0]`
- Must use whole numbers for list indexing
- Maps/objects require string keys: `local.map["key_name"]`

---

## 14.2 The Splat Expression

### Overview
The splat expression provides a wildcard mechanism to iterate over and reference multiple elements from collections created by the count meta-argument, enabling consolidated output of multiple resource attributes without individual references.

### Key Concepts

#### Splat Expression Fundamentals
- Essentially a wildcard expression (`*`)
- Alternative to creating multiple individual outputs
- Works specifically with resources created using the `count` meta-argument
- Consolidated approach to accessing multiple resource attributes

#### Lab Implementation: Multiple EBS Block Devices

**Infrastructure Setup**
- Created single EC2 instance with two EBS block devices
- Block devices: `sda1` and `sda2` (16GB each)
- Demonstrates consolidated output using splat wildcard

**Main Configuration (main.tf)**
```hcl
resource "aws_instance" "splat_lab" {
  ami           = "ami-debian13"
  instance_type = "t2.micro"

  ebs_block_device {
    device_name = "sda1"
    volume_size = 16
  }

  ebs_block_device {
    device_name = "sda2"
    volume_size = 16
  }
}
```

**Output Configuration (outputs.tf)**
```hcl
output "ebs_block_device" {
  description = "Block device volume IDs"
  value       = aws_instance.splat_lab[*].ebs_block_device[*].volume_id
}
```

#### Splat Syntax Patterns

**Modern Syntax (Preferred)**
```hcl
aws_instance.splat_lab[*].ebs_block_device[*].volume_id
```

**Legacy Syntax (Deprecated)**
```hcl
aws_instance.splat_lab.ebs_block_device[*].volume_id
```

#### Working with Aliases for Efficiency
```bash
# Create aliases in .bash_aliases file
alias ti="terraform init"
alias ta="terraform apply -auto-approve"
alias td="terraform destroy"
alias tf="terraform fmt"
alias tv="terraform validate"

# Source the aliases
source .bash_aliases
```

#### Output Results
- Creates TO list (typed object list) containing multiple items
- Example output:
  ```
  ebs_block_device = [
    "vol-0abc123def456789",
    "vol-098765fedcba3210"
  ]
  ```
- Each volume ID corresponds to `sda1` and `sda2` respectively

#### AWS Console Verification
- EC2 instances show standard `xvda` storage (8GB default)
- Additional EBS volumes visible under instance storage
- Volume mapping: `sda1` → one volume ID, `sda2` → second volume ID

#### Important Notes
- Requires newer AWS provider plugin (v6.2.6+) for WSL/container environments
- Full virtual machines recommended for consistent behavior
- Splat expression specifically designed for count-created resources

---

## 14.3 Introduction to Functions

### Overview
Terraform functions provide built-in capabilities to transform, combine, and manipulate values within expressions. Unlike imperative programming languages, Terraform supports only built-in functions (approximately 100 available), not user-defined functions, maintaining its declarative nature.

### Key Concepts

#### Function Fundamentals
- Simplified compared to traditional programming languages
- Used to add functionality or transform/combine values
- Called from within expressions and arguments
- Always include parentheses after function name

**Basic Function Syntax**
```hcl
timestamp()  # Returns UTC timestamp in RFC3339 format
```

#### Function Categories

**Date and Time Functions**
- `timestamp()` - Returns current UTC timestamp in RFC3339 format
- Used for tracking resource creation times and audit trails

**Numeric Functions**
- `max()` - Returns greatest number from a set
- `min()` - Returns smallest number from a set
- `floor()`, `ceil()`, `log()` - Mathematical operations

**String Functions**
- `chomp()` - Removes newline characters from end of string
- `upper()`, `lower()` - Case transformation
- `format()` - String formatting with placeholders

**File System Functions**
- `file()` - Reads content from specified file
- Useful for cloud-init scripts and configuration templates

#### Function Usage Example
```hcl
resource "aws_iam_user" "test_user" {
  name = "test-user"

  tags = {
    Department  = "DevOps"
    TimeCreated = timestamp()
  }
}
```

#### Count Meta-Argument Integration (Preview)
- Functions often used alongside the `count` meta-argument
- Enables creation of multiple similar resources with function-generated attributes
- Creates three users from single resource block using count

#### Critical Exam Alert
- **Terraform supports only built-in functions**
- No user-defined function capability
- HCL is a declarative language, not imperative
- Function definitions must come from Terraform's built-in library

#### Meta-Argument Categories (Preview)
- count
- for_each
- depends_on
- lifecycle
- provider
- providers

---

## 14.4 Example Functions

### Overview
Practical demonstration of Terraform functions through real-world examples, including timestamp formatting, nested function calls, and integration with AWS resources for testing and validation.

### Key Concepts

#### Lab Environment Setup
- Working in `lab18/functions` directory
- Creating IAM users with function-generated attributes
- Testing various function types and combinations

#### Basic Timestamp Function Implementation

**Resource Configuration**
```hcl
resource "aws_iam_user" "function_user" {
  name = "function-user"

  tags = {
    Department  = "ops"
    TimeCreated = timestamp()
  }
}
```

**Build Process**
```bash
ti  # terraform init
tf  # terraform fmt
tv  # terraform validate
ta  # terraform apply -auto-approve
```

#### Format Date Function with Nested Calls

**Advanced Timestamp Formatting**
```hcl
resource "aws_iam_user" "function_user" {
  name = "function-user"

  tags = {
    Department  = "ops"
    TimeCreated = timestamp()
    TimeTwo     = formatdate("MM DD YYYY hh:mm zzz", timestamp())
  }
}
```

**Format Date Parameters**
- `MM` - Month (numeric)
- `DD` - Day (numeric)
- `YYYY` - Year (four digits)
- `hh:mm` - Hour:Minute (24-hour format)
- `zzz` - Timezone abbreviation

#### Function Nesting Concept
- Functions can be nested within other functions
- `formatdate()` calls `timestamp()` as a parameter
- Enables complex data transformations through function composition

#### Testing Results
**Initial Timestamp Output**
```
TimeCreated = "2026-01-,28T15:30:45Z"
```

**Formatted Timestamp Output**
```
TimeTwo = "01 28 2026 15:30 UTC"
```

#### Best Practices for Function Testing
- IAM users provide fast, cost-effective testing environment
- Users created instantly on AWS
- Test Users directory available in repository for experimentation
- Modify and iterate quickly without infrastructure costs

#### Additional Function Resources
- Terraform documentation contains ~100 built-in functions
- Categories include: numeric, string, date/time, file system, networking, cryptographic
- Regular reference to HashiCorp documentation recommended

---

## 14.5 Terraform Console

### Overview
The Terraform console provides an interactive command-line environment for testing built-in functions, evaluating expressions, and debugging configurations without requiring full infrastructure deployment.

### Key Concepts

#### Console Fundamentals
**Exam Alert**: Terraform console creates temporary state file for testing
- Requires initialized directory with working Terraform files
- Interactive REPL (Read-Eval-Print Loop) environment
- Exit with `exit` command or `Ctrl+D`

#### Numeric Function Testing
```bash
> max(1, 2, 3)
3

> min(10, 5, 8)
5
```

#### String Function Testing
```bash
> chomp("hello\n")
"hello"

> upper("terraform")
"TERRAFORM"
```

#### Date/Time Function Testing
```bash
> timestamp()
"2026-01-28T15:30:45Z"

> formatdate("MM DD YYYY hh:mm zzz", timestamp())
"01 28 2026 15:30 UTC"
```

#### Networking Functions
**CIDR Netmask Calculation**
```bash
> cidrnetmask("10.0.0.0/12")
"255.240.0.0"

> cidrnetmask("172.16.0.0/16")
"255.255.0.0"
```

**Additional Networking Functions**
- `cidrhost()` - Calculate host addresses within CIDR blocks
- `cidrsubnet()` - Calculate subnet addresses
- `cidrsubnets()` - Generate multiple subnet addresses

#### Cryptographic Functions

**SHA256 Hashing**
```bash
> sha256("dpro")
"a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3"
```

**Base64 Encoding**
```bash
> base64encode("terraform")
"dGVycmFmb3Jt"
```

**Combined Cryptographic Operations**
```bash
> base64sha512("dpro")
[Base64-encoded SHA512 hash result]
```

#### Error Handling in Console
```bash
> base54encode("test")
Error: Call to unknown function
│ There is no function named "base54encode".
│ Did you mean "base64encode"?
```

#### File Function Usage
```bash
> file("cloud-init.sh")
[Contents of the specified file]
```

#### Documentation Access
- Direct access to HashiCorp documentation: `developer.hashicorp.com/terraform/language/functions`
- Categories include: numeric, string, collection, date/time, filesystem, network, type conversion, cryptographic, UUID, encoding
- Approximately 100 functions available for reference

#### Console Session Management
- History preserved during session (use up arrow)
- `Ctrl+L` clears terminal display
- Always exit properly to return to regular shell

---

## 14.6 The Count Meta-Argument

### Overview
The count meta-argument enables creation of multiple resource instances from a single resource block, providing efficient scaling capabilities while maintaining consistent configuration across all instances.

### Key Concepts

#### Count Meta-Argument Fundamentals
- Built into Terraform Configuration Language (HCL)
- Controls how Terraform creates and manages infrastructure
- Allows scaling resources by simply increasing the count number
- Requires proper indexing for unique resource identification

#### Lab Implementation: Multiple EC2 Instances

**Basic Count Implementation**
```hcl
resource "aws_instance" "count_lab" {
  count         = 2
  ami           = "ami-debian13"
  instance_type = "t2.micro"

  tags = {
    Name = "count-lab-${count.index + 1}"
  }
}
```

**Count Index Mechanics**
- `count.index` starts at 0 by default
- Add `+ 1` to start indexing from 1
- Creates instances: "count-lab-1", "count-lab-2"
- Each instance gets unique identifier while maintaining consistent base configuration

#### Output Configuration with Splat Expression
```hcl
output "publicips" {
  description = "Public IP addresses"
  value       = aws_instance.count_lab[*].public_ip
}
```

#### Build Process
```bash
ti  # terraform init
tv  # terraform validate
ta  # terraform apply -auto-approve
```

**Build Results**
- Creates 2 resources from single block
- Each instance receives unique public IP
- Naming convention properly applied via count.index

#### State File Analysis
- Each resource instance tracked separately in state
- Count-generated instances identified by index notation
- `terraform state list` shows all generated instances

#### AWS Verification
- EC2 console shows properly named instances
- Instance naming: "count-lab-1" and "count-lab-2"
- Each instance operates independently while maintaining configuration consistency

#### Documentation Reference
- HashiCorp documentation covers all meta-arguments
- Count examples show server naming patterns
- Integration with other meta-arguments covered in subsequent lessons

#### Exam Preparation Points
- Count creates multiple instances efficiently
- Index values start at 0, adjustable with `+ 1`
- Splat expressions work with count-created resources
- State tracking maintains individual instance identity

---

## 14.7 The For_Each Meta-Argument

### Overview
The for_each meta-argument provides advanced resource creation capabilities by iterating over sets or maps of values, offering more flexibility than count by enabling creation based on actual data structures rather than simple numeric counts.

### Key Concepts

#### For_Each Fundamentals
- Creates multiple instances based on map or set of values
- More powerful than count for complex scenarios
- Uses actual data values for resource identification
- Iterates using `each.key` and `each.value` references

#### To_Set Function Integration
- Converts lists to sets for for_each compatibility
- Syntax: `toset(["item1", "item2", "item3"])`
- Removes duplicates and provides set-based iteration
- Required when working with list-style data in for_each

#### Lab Implementation: Multiple IAM Users

**For_Each Resource Configuration**
```hcl
resource "aws_iam_user" "accounts" {
  for_each = toset(["Alice", "Bob", "Charlie", "Denise"])
  name     = each.key

  tags = {
    TimeCreated = timestamp()
    Department  = "ops"
  }
}
```

**Key Implementation Details**
- `toset()` converts list to set for iteration
- `each.key` provides current item from set during iteration
- Single resource block creates 4 separate IAM users
- Each user gets unique name from set values

#### Build Process and Troubleshooting
```bash
ti  # terraform init
tf  # terraform fmt
tv  # terraform validate  # May reveal syntax issues
ta  # terraform apply -auto-approve
```

**Common Issues**
- Missing quotes around string values in tags
- Validate catches syntax errors not visible in IDE
- Disk space warnings from accumulated Terraform directories

#### Verification Methods
**Terraform State Verification**
```bash
terraform state list
# Shows: aws_iam_user.accounts["Alice"], aws_iam_user.accounts["Bob"], etc.
```

**AWS Console Verification**
- IAM users: Alice, Bob, Charlie, Denise
- All created from single resource block
- Tags properly applied to each user

#### For_Each vs Count Comparison
**For_Each Advantages**
- Works with actual data values, not just numeric counts
- More flexible for complex naming schemes
- Handles sets and maps natively
- Resource addressing uses meaningful keys

**Count Limitations**
- Limited to numeric indexing
- Requires additional logic for meaningful names
- Splat expressions compatible for outputs

#### Documentation Reference
- HashiCorp meta-arguments documentation
- For_each examples show name and location configurations
- `each.value` usage for map-based scenarios

#### Critical Points
- `toset()` function often required for list-to-set conversion
- `each.key` and `each.value` provide iteration context
- Single resource block scales to multiple instances
- Better suited for data-driven infrastructure patterns

---

## 14.8 The Lifecycle Meta-Argument

### Overview
The lifecycle meta-argument provides fine-grained control over Terraform's resource creation, update, and deletion behavior, including the critical `prevent_destroy` functionality that protects essential resources from accidental deletion.

### Key Concepts

#### Lifecycle Meta-Argument Overview
- Controls Terraform's behavior during resource lifecycle events
- Extends beyond basic create/update/delete operations
- Includes precondition/postcondition checks (previously demonstrated)
- Focus on `prevent_destroy` for resource protection

#### Prevent_Destroy Implementation

**Basic Configuration**
```hcl
resource "aws_iam_user" "protected_users" {
  for_each = toset(["Ernie", "Frank", "Gina", "Harry"])
  name     = each.key

  lifecycle {
    prevent_destroy = true
  }
}
```

**Boolean Configuration**
- `prevent_destroy = true` (boolean) blocks all destruction attempts
- Prevents accidental deletion of critical resources
- Applies to entire resource block and all instances

#### Protection Mechanism Testing

**Expected Destruction Behavior**
```bash
td  # terraform destroy
# Error: Instance cannot be destroyed
# │ Resource: aws_iam_user.protected_users (main.tf:20)
# │ prevent_destroy is set to true
```

**Resolution Methods**
1. Set `prevent_destroy = false`
2. Comment out the lifecycle block entirely
3. Remove the lifecycle block completely

#### Implementation Workflow
```bash
ti  # terraform init
tv  # terraform validate
ta  # terraform apply -auto-approve
td  # terraform destroy (blocked)
# Modify prevent_destroy setting
td  # terraform destroy (allowed after modification)
```

#### Use Cases for Prevent_Destroy
- **Production databases** requiring explicit protection
- **Critical infrastructure components** with high impact if deleted
- **Compliance requirements** mandating resource preservation
- **Cost-sensitive resources** where accidental deletion has financial impact

#### Integration with Other Concepts
- Works alongside for_each and count meta-arguments
- Applies to all instances created by the resource block
- Complements other lifecycle controls like preconditions
- Part of comprehensive resource management strategy

#### Exam Preparation
- `prevent_destroy = true` prevents resource destruction
- Applied within lifecycle block inside resource definition
- Common interview question topic
- Must modify or remove to allow destruction
- Boolean value required (true/false)

#### Best Practices
- Use selectively for truly critical resources
- Document reason for protection in configuration comments
- Combine with proper access controls and approval processes
- Regular review of protected resources for necessity

---

## 14.9 The Depends_On Meta-Argument

### Overview
The depends_on meta-argument enables explicit definition of dependencies between resources when Terraform's automatic detection cannot identify the required creation order, ensuring proper resource provisioning sequence across complex infrastructure setups.

### Key Concepts

#### Dependency Types

**Implicit Dependencies**
- Automatically detected by Terraform
- Based on provider plugin criteria and resource relationships
- Example: EC2 instances require VPC and subnet (networking infrastructure first)
- No manual configuration required

**Explicit Dependencies**
- Manually defined using `depends_on` meta-argument
- Required when Terraform cannot automatically detect relationships
- Cross-resource dependencies that provider limitations prevent detecting
- Dependencies across different cloud providers (AWS + Azure)

#### Lab Implementation: Instance-User Dependency

**Resource Configuration**
```hcl
resource "aws_instance" "computer_1" {
  ami           = "ami-debian13"
  instance_type = "t2.micro"
  # Standard instance configuration
}

resource "aws_iam_user" "service_accounts" {
  for_each = toset(["Indigo", "Violet"])
  name     = each.key

  depends_on = [aws_instance.computer_1]
}
```

**Dependency Behavior**
- IAM users created only after EC2 instance fully deployed
- Forces sequential creation: instance → users
- Even without implicit dependency, explicit declaration ensures order

#### Creation Order Verification
**Apply Process Observation**
1. Plan shows 3 resources to add (2 users + 1 instance)
2. Instance creation begins first: `aws_instance.computer_1`
3. Instance must complete before user creation starts
4. Users created only after instance fully operational

#### Destruction Order Reversal
**Destroy Process Behavior**
- Destruction occurs in reverse order of creation
- Users destroyed first, then instance
- Maintains logical cleanup sequence

#### Cross-Provider Dependencies
- `depends_on` essential for multi-cloud deployments
- AWS resources depending on Azure resources (or vice versa)
- Provider plugins may have limited implicit dependency detection
- Manual dependency declaration ensures proper orchestration

#### Business Logic Applications
- **Database dependencies**: Applications requiring database availability first
- **Security group ordering**: Resources needing specific security configurations
- **Module dependencies**: Inter-module resource relationships
- **Workflow requirements**: Business processes requiring specific creation sequences

#### Documentation Reference
- HashiCorp meta-arguments documentation
- Database, security group, and module dependency examples
- Cross-provider scenarios demonstrate practical applications

#### Critical Implementation Points
- Use square brackets for resource references: `depends_on = [aws_instance.example]`
- Explicit dependencies override Terraform's automatic detection
- Destruction always reverses creation order
- Essential for complex, multi-resource deployments

#### Exam Preparation
- `depends_on` creates explicit dependencies
- Required when implicit detection fails
- Works across different providers and modules
- Destruction order reverses creation dependencies
- Differentiate from implicit (automatic) dependencies

---

## 14.10 Quiz

### Question 1: Splat Expression with For_Each
**Question**: True or False: It is possible to reference a resource created with for_each using a splat expression.

**Answer**: **False**

**Explanation**:
- Splat expressions work specifically with resources created using the `count` meta-argument
- For_each and splat are separate concepts that serve different purposes
- For_each-created resources must be referenced using their specific keys, not splat wildcards
- Example splat usage: `var.list[*].interfaces[0].name` - works with count-generated lists

### Question 2: Count Meta-Argument Scaling
**Question**: True or False: If you use the count argument in a terraform resource block, you can scale the resources by increasing the number.

**Answer**: **True**

**Explanation**:
- Count meta-argument enables efficient scaling of identical resources
- Increase count value to create additional instances: `count = 2` → `count = 4`
- Additional instances integrate with existing infrastructure
- Use `count.index` for unique naming: `"server-${count.index + 1}"`
- Existing instances remain unchanged when count increases

### Question 3: Testing Built-in Functions
**Question**: Which command enables testing of Terraform built-in functions?
- A) Terraform PowerShell
- B) Terraform init
- C) Terraform console
- D) Terraform validate
- E) Terraform env

**Answer**: **C) Terraform console**

**Explanation**:
- **Terraform console**: Interactive environment for testing built-in functions directly
  - Test functions like `max()`, `chomp()`, `cidrnetmask()`
  - Exit with `exit` or `Ctrl+D`
- **Incorrect Options**:
  - Terraform PowerShell: Does not exist (PowerShell is Windows-specific)
  - Terraform init: Initializes working directory and downloads providers
  - Terraform validate: Checks syntax correctness of configuration code
  - Terraform env: Deprecated command replaced by `terraform workspace`

---

## Summary

### Key Takeaways

```diff
+ Expressions work with values in configurations using types: string, number, bool, list, map, null
+ Splat expressions provide wildcard functionality for count-created resources
+ Terraform supports ~100 built-in functions but no user-defined functions
+ Terraform console provides interactive testing environment for functions and expressions
+ Count meta-argument creates multiple identical resources with numeric indexing
+ For_each meta-argument iterates over sets/maps for data-driven resource creation
+ Lifecycle meta-argument with prevent_destroy protects critical resources
+ Depends_on creates explicit dependencies when implicit detection fails
+ Splat works with count but not for_each - they are separate concepts
```

### Quick Reference

**Expression Types**
```hcl
# Value types in expressions
type = string    # "hello world"
type = number    # 42, 3.14
type = bool      # true, false
type = list      # ["item1", "item2"]
type = map       # {key = "value"}
type = null      # absence/omission
```

**Splat Expression**
```hcl
# Modern syntax (preferred)
aws_instance.example[*].public_ip

# Output multiple resources
output "ips" { value = aws_instance.example[*].public_ip }
```

**Function Examples**
```hcl
timestamp()                                    # Current UTC time
formatdate("MM DD YYYY", timestamp())         # Formatted date
max(1, 2, 3)                                  # Numeric operations
chomp("hello\n")                             # String operations
cidrnetmask("10.0.0.0/16")                   # Network functions
sha256("input")                              # Cryptographic functions
```

**Meta-Arguments**
```hcl
# Count - numeric scaling
count = 3
name  = "server-${count.index + 1}"

# For_each - data-driven creation
for_each = toset(["user1", "user2"])
name     = each.key

# Lifecycle - resource protection
lifecycle {
  prevent_destroy = true
}

# Depends_on - explicit dependencies
depends_on = [aws_instance.prerequisite]
```

### Expert Insight

#### Real-world Application
In production environments, these concepts enable sophisticated infrastructure automation:
- Use `count` for simple scaling of identical resources (web servers, databases)
- Implement `for_each` for complex, data-driven deployments (user accounts, environments)
- Protect critical infrastructure with `prevent_destroy` on production databases and core services
- Orchestrate multi-cloud deployments using `depends_on` across AWS, Azure, and GCP
- Leverage functions for dynamic configuration generation and compliance timestamping

#### Expert Path
To master these concepts:
1. Practice extensively with Terraform console for function testing
2. Build complex labs combining multiple meta-arguments
3. Experiment with nested functions and expression combinations
4. Create multi-resource workflows that demonstrate dependency management
5. Study HashiCorp documentation for advanced function usage patterns
6. Implement production-like scenarios with proper resource protection

#### Common Pitfalls
- **Splat/For_Each Confusion**: Remember splat works only with count, not for_each
- **Index Starting Point**: `count.index` starts at 0; use `+ 1` for human-readable numbering
- **Missing Quotes**: Always quote string values in tags and configurations
- **Function Nesting Errors**: Ensure proper parentheses closure for nested functions
- **Dependency Cycles**: Avoid circular dependencies when using explicit depends_on
- **Resource Protection Oversight**: Forgetting to disable prevent_destroy during planned maintenance

#### Lesser-Known Facts
- Terraform console creates temporary state files that don't affect your main infrastructure
- The pessimistic constraint operator `~>` is commonly used in provider version constraints
- For_each can handle both sets (using `each.key`) and maps (using `each.key` and `each.value`)
- Lifecycle blocks can contain multiple controls: preconditions, postconditions, and prevent_destroy
- Null values in expressions enable conditional argument omission for optional configurations
- Working with ~100 built-in functions requires regular reference to current documentation as new functions are added

</details>