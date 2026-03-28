# Section 111: Passing Arguments in Shell Scripts

<details open>
<summary><b>Section 111: Passing Arguments in Shell Scripts (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to the Session](#introduction-to-the-session)
- [Using Positional Parameters](#using-positional-parameters)
- [Passing Arguments on Command Line](#passing-arguments-on-command-line)
- [Working with $0 - Script Name](#working-with-0---script-name)
- [Using $@ for All Arguments](#using--for-all-arguments)
- [Counting Arguments with $#](#counting-arguments-with-)
- [Advanced Argument Handling](#advanced-argument-handling)
- [Summary](#summary)

## Introduction to the Session
This section covers passing arguments to shell scripts in bash scripting. The instructor starts with channel updates about membership changes and then dives into the technical content about argument handling, which is fundamental for creating interactive and parameterized shell scripts. The session demonstrates practical examples of using positional parameters to make scripts more flexible and dynamic.

## Using Positional Parameters
Positional parameters are system-defined variables used to pass arguments to shell scripts. These are numbered starting from $1 (for the first argument), $2 for the second, and so on. Unlike user-defined variables, these cannot start with numbers, but when used as positional parameters, they have special meaning.

```bash
#!/bin/bash

# Example: Basic argument display
echo $1  # First argument
echo $2  # Second argument
echo $3  # Third argument
echo $4  # Fourth argument
```

> [!IMPORTANT]
> Remember that positional parameters are temporary and only available during script execution.

## Passing Arguments on Command Line
Arguments are passed to a script by simply typing them after the script name on the command line. The script can then access these arguments using the positional parameters.

```bash
# Running a script with arguments
./myscript.sh hi how are you

# Output:
# hi    # $1
# how   # $2
# are   # $3
# you   # $4
```

> [!NOTE]
> Arguments are separated by spaces on the command line. If you need to pass paths with spaces, you must quote them properly.

## Working with $0 - Script Name
The `$0` parameter contains the name of the script itself. This is useful for displaying the script name in usage messages or for error handling.

```bash
#!/bin/bash

# Example: Displaying script name along with arguments
echo "Script name: $0"
echo "Arguments: $1 $2 $3 $4"
```

When running `./myscript.sh hi how are you`, the output would be:
```
Script name: ./myscript.sh
Arguments: hi how are you
```

## Using $@ for All Arguments
The `$@` variable expands to all command-line arguments passed to the script. This is particularly useful when you don't know in advance how many arguments will be passed.

```bash
#!/bin/bash

# Method 1: Printing arguments individually (tedious for many args)
echo "$1 $2 $3 $4"

# Method 2: Using $@ to print all arguments at once (recommended)
echo "$@"
```

Both methods produce the same output, but `$@` is much more efficient, especially when dealing with varying numbers of arguments.

## Counting Arguments with $#
The `$#` parameter holds the total number of arguments passed to the script. This is useful for validation and conditional logic.

```bash
#!/bin/bash

echo "Total number of arguments: $#"

# Example usage: Check if required arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <arg1> <arg2>"
    exit 1
fi
```

## Advanced Argument Handling
You can combine multiple techniques for more sophisticated argument handling. This example shows using both individual parameters and the `$@` array.

```bash
#!/bin/bash

# Script demonstrating multiple argument handling techniques

# Check if we have any arguments
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

echo "Script name: $0"
echo "Total arguments: $#"
echo "All arguments: $@"
echo ""

# Process specific arguments if needed
if [ $# -ge 3 ]; then
    echo "First argument: $1"
    echo "Third argument: $3"
else
    echo "Need at least 3 arguments"
fi
```

## Summary

### Key Takeaways
```diff
+ Positional parameters ($1, $2, $3, etc.) are system-defined variables for script arguments
+ $0 contains the script name itself
+ $@ expands to all arguments passed to the script
+ $# gives the count of arguments passed
- Arguments are temporary and lose their values once the script ends
- Positional parameters can't be user-defined variable names in normal usage
```

### Quick Reference
```bash
#!/bin/bash
# Basic argument script template

echo "Script: $0"
echo "All args: $@"
echo "Arg count: $#"
echo "First arg: $1"
echo "Second arg: $2"
```

**Common argument patterns:**
- `./script.sh arg1 arg2 arg3` - Pass three arguments
- `$@` - Access all arguments as an array
- `$#` - Check argument count for validation

> [!IMPORTANT]
> Always validate argument count in production scripts to prevent errors.

### Expert Insight

#### Real-world Application
In production environments, argument handling enables dynamic configuration. For example, deployment scripts often accept environment names, target directories, or configuration files as arguments, allowing the same script to work across multiple deployment scenarios without code changes.

#### Expert Path
Master argument parsing by combining these basics with advanced techniques like `getopts` for flag-based arguments or `shift` for processing variable-length parameter lists. Consider implementing help functions that display usage when invalid arguments are provided.

#### Common Pitfalls
```diff
- Not quoting variables when dealing with paths containing spaces
- Assuming fixed number of arguments without validation
- Forgetting that $0 is the script name, not the first argument
! Using $1-$9 directly instead of $@ when processing multiple unknown arguments
```

</details>
