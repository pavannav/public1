<details open>
<summary><b>07-Basic-Understanding-of-Jq-Input-and-Outputs (KK-CS45-script-v3-Inst-v1)</b></summary>

# Session 7: Basic Understanding of JQ Input and Outputs

## Table of Contents

- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [JQ Command Structure](#jq-command-structure)
  - [Input Placement Semantics](#input-placement-semantics)
  - [Quotation Best Practices](#quotation-best-practices)
  - [Output Expression Logic](#output-expression-logic)
- [Code Examples](#code-examples)
- [Summary](#summary)

---

## Overview

This session introduces the fundamental syntax structure for the JQ command, focusing on how inputs, processing logic, and outputs interact. The instructor provides a memorable framework for understanding JQ syntax that applies whether processing JSON files, piped data, or variables.

**Key Learning Objective**: Understand the basic syntax pattern `jq 'expression' input` and the critical differences in input placement semantics.

---

## Key Concepts

### JQ Command Structure

JQ follows a universal command-line pattern: every command accepts input and produces output. The JQ command specifically processes JSON data and generates output based on the logic provided in the expression.

**Basic Syntax Pattern**:
```
jq '<logic>' [input]
```

Where:
- `jq` is the command
- `'<logic>'` is the processing expression (in single or double quotes)
- `[input]` is optional and can be a file, JSON data, or piped input

### Input Placement Semantics

The position of the input relative to the expression is semantically significant:

| Placement | Input Type | Example |
|-----------|-----------|---------|
| **Right side** of expression | File or inline JSON data | `jq '.name' data.json` |
| **Left side** of expression | Variable (from pipe or shell variable) | `echo "$json_var" \| jq '.name'` |

**Critical Distinction**:
- **Right-side input**: JQ reads from a file path or expects JSON data as an argument
- **Left-side input**: JQ receives data through stdin (pipes, redirection, or shell variables)

### Quotation Best Practices

JQ expressions require quoting to prevent shell interpretation:

```bash
# Recommended: Single quotes
jq '.users[]' data.json

# Acceptable: Double quotes (when variable expansion needed)
jq ".users[$index]" data.json

# Avoid: Unquoted expressions (will break on special characters)
jq .users[] data.json  # May fail or produce unexpected results
```

**Best Practice Rule**: Always use single quotes unless you need shell variable expansion, in which case double quotes are required.

### Output Expression Logic

The expression within quotes determines the output format and content. The logic can include:

- **Variables**: Store intermediate results
- **Functions**: Built-in JQ functions for data transformation
- **Filters**: Path expressions to select specific data
- **Conditions**: Conditional logic for dynamic processing
- **Combinations**: Multiple filters and functions chained together

---

## Code Examples

### Basic JQ Syntax Patterns

```bash
# Pattern 1: File input (right side)
jq '.name' users.json

# Pattern 2: Piped input (left side via pipe)
cat users.json | jq '.name'

# Pattern 3: Inline JSON
jq '.name' <<< '{"name": "John"}'

# Pattern 4: Shell variable input
echo "$json_data" | jq '.name'
```

### Expression with Logic Development

```bash
# Simple filter
jq '.users' data.json

# Filter with array access
jq '.users[0]' data.json

# Combining filters
jq '.users[] | .name' data.json

# Using functions
jq '.users | length' data.json
```

---

## Summary

### Key Takeaways

```diff
+ JQ syntax follows: jq '<expression>' [input]
+ Input position matters: right = file/JSON, left = variable/pipe
+ Single quotes are the best practice for expressions
+ Output depends entirely on the logic written in the expression
+ Expressions support variables, functions, filters, and conditions
```

### Quick Reference

| Element | Syntax | Purpose |
|---------|--------|---------|
| Basic command | `jq '<expr>'` | Process JSON through expression |
| File input | `jq '<expr>' file.json` | Read JSON from file |
| Piped input | `cat file.json \| jq '<expr>'` | Process piped JSON |
| Variable input | `echo "$var" \| jq '<expr>'` | Process shell variable |
| Quoted expression | `'<expr>'` or `"<expr>"` | Protect expression from shell |

### Expert Insight

> [!IMPORTANT]
> **Real-world Application**: Understanding input placement is critical when writing shell scripts. Right-side inputs work well for static files, while left-side piping enables dynamic data processing from APIs, logs, or other command outputs.

> [!NOTE]
> **Expert Path**: Master the pattern of chaining multiple JQ commands with pipes (`jq 'filter1' | jq 'filter2'`) for complex transformations. This modular approach improves readability and debugging.

> [!CAUTION]
> **Common Pitfalls**:
> - Forgetting quotes around expressions leads to shell glob expansion errors
> - Confusing file paths with inline JSON causes "No such file" errors
> - Using double quotes when single quotes are needed can cause variable expansion issues in scripts

</details>