# Section 9: Introduction to Terraform Logging

<details open>
<summary><b>Section 9: Introduction to Terraform Logging (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [9.1 Introduction to Terraform Logging](#91-introduction-to-terraform-logging)
- [9.2 Working with TF_LOG](#92-working-with-tf_log)
- [9.3 Working with TF_LOG_PATH](#93-working-with-tf_log_path)
- [9.4 Troubleshooting Techniques](#94-troubleshooting-techniques)
- [9.5 Terraform Support](#95-terraform-support)
- [9.6 Terraform Test](#96-terraform-test)
- [9.7 Check Blocks, Preconditions, and Postconditions](#97-check-blocks-preconditions-and-postconditions)
- [9.8 Quiz](#98-quiz)
- [Summary](#summary)

## 9.1 Introduction to Terraform Logging

### Overview
Terraform logging provides visibility into the execution of Terraform commands, helping identify current and potential issues. Two primary methods exist for capturing logs: immediate terminal logging and persistent file logging.

### Key Concepts

#### Logging Methods

**Terminal Logging (One-time):**
```bash
TF_LOG=trace terraform apply
```

**File Logging (Persistent):**
```bash
export TF_LOG_PATH=logs.txt
```

**Session-wide Logging:**
```bash
export TF_LOG=trace
```
This enables logging for the entire terminal session without prefixing each command.

#### Logging Levels

Terraform provides five logging levels in decreasing order of verbosity:

| Level | Verbosity | Description |
|-------|-----------|-------------|
| trace | Maximum | Most detailed information for deep debugging |
| debug | High | Debugging information including provider interactions |
| info | Medium | General operational information |
| warn | Low | Warning messages only |
| error | Minimum | Error messages only |

> [!IMPORTANT]
> Trace or Debug logs are recommended when sharing logs with HashiCorp support.

## 9.2 Working with TF_LOG

### Overview
TF_LOG enables immediate logging in the terminal, allowing real-time monitoring of Terraform operations at various verbosity levels.

### Key Concepts

#### Demonstrating Logging Levels

Starting with the least verbose level:

```bash
TF_LOG=error terraform init
```
- Shows only errors
- Minimal output during successful operations

Progressive testing through levels:

1. **ERROR Level**: Shows only critical failures
2. **WARN Level**: Includes warnings (displayed in yellow) plus errors
3. **INFO Level**: Adds operational details:
   ```
   [INFO] Terraform version: 1.14.3
   [INFO] Go runtime version: 1.25.5
   [INFO] CLI args: []string{"terraform", "apply"}
   ```
4. **DEBUG Level**: Includes provider plugin searches and GitHub dependencies
5. **TRACE Level**: Maximum detail including:
   - Terminal information
   - Backend metadata
   - Filesystem operations
   - Provider plugin interactions

#### Session Logging

To enable logging for the entire session:
```bash
export TF_LOG=trace
```

This persists until the terminal session ends or the variable is unset:
```bash
export TF_LOG=
# or
export TF_LOG=off
```

#### Subset Logging Options

For targeted debugging:

```bash
# Core Terraform only
export TF_LOG=core=trace

# Provider plugins only
export TF_LOG=provider=trace
```

## 9.3 Working with TF_LOG_PATH

### Overview
TF_LOG_PATH redirects logging output to a file, enabling persistent storage and easier analysis of large log outputs.

### Key Concepts

#### Setting Up File Logging

```bash
export TF_LOG_PATH=logs.txt
export TF_LOG=trace
```

Logs are automatically appended to the file with each Terraform command.

#### Log File Analysis

File logging is essential for:
- Sharing logs with support teams
- Analyzing large outputs (can exceed 30,000+ lines)
- Preserving debugging information across sessions

#### Important Log Files to Monitor

After operations like `terraform apply`:
- Provider registry interactions
- Resource creation/update sequences
- State file operations

#### Cleanup Commands

When finished with file logging:
```bash
unset TF_LOG_PATH
unset TF_LOG
```

#### Advanced Techniques

**Using Search Tools:**
- `Ctrl+F` / `Cmd+F` for quick searching
- `grep`, `awk`, `sed` for filtering

**Hidden Log Files:**
```bash
export TF_LOG_PATH=.terraform.log
```

## 9.4 Troubleshooting Techniques

### Overview
Effective Terraform troubleshooting involves systematic error identification, resolution, and prevention strategies.

### Key Concepts

#### Common Errors and Fixes

1. **Missing Double Quotes:**
   ```hcl
   # Incorrect
   name = user1

   # Correct
   name = "user1"
   ```
   Error: "Invalid character" and "Invalid expression"

2. **Count Index Syntax:**
   ```hcl
   # Correct syntax
   name = "user-${count.index}"

   # Common mistake
   name = "user-$count.index"  # Missing curly braces
   ```

3. **Version Constraints:**
   ```hcl
   # Problematic
   required_version = ">= 40.40"

   # Best practice for stability
   required_version = "= 1.14.2"
   ```

#### Directory Reset Process

To return to a non-initialized state:
```bash
rm -rf .terraform terraform.tfstate* .terraform.lock.hcl
```

#### Persistent Logging Configuration

For long-term troubleshooting across reboots:

1. Create log directory:
   ```bash
   mkdir -p ~/logs/terraform
   ```

2. Edit `~/.bashrc`:
   ```bash
   export TF_LOG=trace
   export TF_LOG_PATH=~/logs/terraform/terraform.log
   ```

3. Apply changes:
   ```bash
   source ~/.bashrc
   ```

#### VS Code Indicators

- Red underlines indicate syntax errors
- White text for strings (should be blue for valid strings)
- Problem count indicator in status bar

## 9.5 Terraform Support

### Overview
When self-troubleshooting isn't sufficient, Terraform provides multiple support channels for community assistance and official bug reporting.

### Key Concepts

#### Discussion Forum

**discuss.hashicorp.com**:
- Best for usage questions and best practices
- Community-driven Q&A
- Requires proper logs (trace/debug recommended)

#### GitHub Issues

**HashiCorp/Terraform repository**:
- For reporting bugs and crashes
- "Terraform crash" messages should be reported here
- Requires GitHub account

#### Version Management Strategy

Best practices for organizations:
- Standardize on specific Terraform versions
- Test thoroughly before upgrading
- Use exact version constraints:
  ```hcl
  required_version = "= 1.14.2"
  ```

#### Troubleshooting Process

Recommended approach:
1. Start with discussion forums
2. Review GitHub issues if bug suspected
3. Consider third-party resources:
   - Stack Exchange
   - Splunk
   - Terraform-specific tools

## 9.6 Terraform Test

### Overview
Terraform Test, introduced in version 1.6, provides automated testing capabilities beyond basic validation commands.

### Key Concepts

#### Test File Structure

Tests must be placed in a `tests/` subdirectory with `.tftest.hcl` extension.

#### Pre-apply Testing

Test files contain `run` blocks with assertions:

```hcl
run "check_instance_type" {
  assert {
    condition     = aws_instance.test.instance_type == var.expected_type
    error_message = "Expected instance type t2.micro, got ${aws_instance.test.instance_type}"
  }
}
```

#### Running Tests

```bash
# Run all tests
terraform test

# Filter specific tests
terraform test -filter=tests/unit_basic.tftest.hcl

# Verbose output
terraform test -verbose
```

#### Test Results

- Successes shown without detailed messages
- Error messages only appear on failures
- Shows passed/failed/skipped counts

#### Post-apply Testing

Alternative approaches:
- `terraform plan -refresh-only`
- `terraform apply -refresh-only`
- Dedicated post-apply test files (use carefully to avoid unintended infrastructure creation)

## 9.7 Check Blocks, Preconditions, and Postconditions

### Overview
These validation mechanisms ensure infrastructure health and configuration compliance before and after deployments.

### Key Concepts

#### Check Blocks

Top-level constructs for infrastructure validation (introduced in v1.5):

```hcl
check "instance_health" {
  data "aws_instance" "example" {
    instance_id = aws_instance.web.id
  }

  assert {
    condition     = data.aws_instance.example.instance_state == "running"
    error_message = "Instance is not running"
  }
}
```

#### Lifecycle Block

Required container for preconditions and postconditions (one per file):

```hcl
resource "aws_instance" "example" {
  # ... configuration ...

  lifecycle {
    precondition {
      condition     = var.region == "us-east-2"
      error_message = "Region must be us-east-2"
    }

    postcondition {
      condition     = self.public_dns != ""
      error_message = "Instance must have public DNS"
    }

    postcondition {
      condition     = self.instance_state == "running"
      error_message = "Instance is not running"
    }
  }
}
```

#### Precondition vs Postcondition

| Type | Timing | Purpose |
|------|--------|---------|
| precondition | Before apply | Validate inputs and code |
| postcondition | After apply | Validate deployed resources |

#### Variable Validation

```hcl
variable "region" {
  default = "us-east-2"

  validation {
    condition     = var.region == "us-east-2"
    error_message = "Only us-east-2 is supported for this demo"
  }
}
```

#### Force Testing Failures

To test validation logic:
```bash
echo 'aws_region = "us-east-1"' > terraform.tfvars
terraform plan  # Should fail precondition
```

#### Additional Validation Commands

- `terraform show`: Display all resources and test outputs
- AWS CLI integration for external state changes:
  ```bash
  aws ec2 stop-instances --instance-ids $(terraform output -raw instance_id)
  ```

## 9.8 Quiz

### Question 1
**Which environment variable sends detailed logs to HashiCorp?**
- Answer: `TF_LOG`
- Levels (decreasing verbosity): trace, debug, info, warn, error
- Trace provides maximum detail for support requests

### Question 2
**Where do TF_LOG outputs appear?**
- Answer: stderr (standard error)
- Displayed in terminal/PowerShell
- Use `TF_LOG_PATH` to redirect to files

### Question 3
**Which block verifies AWS instance is running after deployment?**
- Answer: postcondition
- Located within lifecycle block
- Executes after infrastructure is created

## Summary

### Key Takeaways
```diff
+ Logging is essential for troubleshooting and support interactions
+ Five log levels from trace (most verbose) to error (least verbose)
+ TF_LOG enables terminal logging; TF_LOG_PATH enables file logging
+ Terraform Test provides automated validation (requires v1.6+)
+ Check blocks validate infrastructure health
+ Preconditions validate before apply; Postconditions validate after
+ Export TF_LOG and TF_LOG_PATH for session persistence
+ Use exact version constraints for stability in production
```

### Quick Reference

```bash
# Enable logging
export TF_LOG=trace
export TF_LOG_PATH=logs.txt

# Disable logging
export TF_LOG=
unset TF_LOG_PATH

# Run tests
terraform test
terraform test -filter=tests/example.tftest.hcl

# Validation commands
terraform validate
terraform plan -refresh-only
terraform apply -refresh-only
```

### Expert Insight

**Real-world Application:**
- Always enable trace logging when working with HashiCorp support
- Use file logging for persistent debugging sessions
- Implement automated tests in CI/CD pipelines
- Use preconditions to catch configuration errors early

**Expert Path:**
- Master log analysis with grep/awk/sed
- Create comprehensive test suites for all modules
- Implement custom check blocks for critical infrastructure
- Develop organization-wide logging and testing standards

**Common Pitfalls:**
- Forgetting to unset logging variables
- Using overly verbose logging in production
- Placing dollar signs outside quotes for variable interpolation
- Not testing preconditions thoroughly before deployment

**Lesser-Known Facts:**
- Trace logs can exceed 30,000+ lines for complex operations
- Postconditions cannot validate resources that don't exist yet
- Variable validation blocks provide early error detection
- `terraform show` displays both resources and test outputs

</details>