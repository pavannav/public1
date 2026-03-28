# Section 118: Arithmetic Operations on Decimal Numbers

<details open>
<summary><b>Section 118: Arithmetic Operations on Decimal Numbers (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Performing Arithmetic Operations on Decimal Numbers](#introduction-to-performing-arithmetic-operations-on-decimal-numbers)
- [Using the bc Command](#using-the-bc-command)
- [Setting Decimal Places with Scale](#setting-decimal-places-with-scale)
- [Using bc in Shell Scripts with User Input and Variables](#using-bc-in-shell-scripts-with-user-input-and-variables)
- [Performing Operations with User Input](#performing-operations-with-user-input)
- [Advanced Mathematical Operations with bc](#advanced-mathematical-operations-with-bc)
- [Lab Demo: Creating a Calculator Script](#lab-demo-creating-a-calculator-script)
- [Summary](#summary)

## Introduction to Performing Arithmetic Operations on Decimal Numbers
### Overview
This section explores performing arithmetic operations on decimal numbers in shell scripts. Previously, we focused on integer operations using methods that only supported whole numbers. Now, we'll leverage the `bc` (basic calculator) command to handle both integers and decimals accurately, including advanced operations like square roots and exponentiation.

### Key Concepts
The `bc` command is a powerful tool for performing mathematical calculations in the shell. Key features include:
- **Precision Handling**: Unlike basic shell arithmetic, `bc` supports arbitrary precision with decimal numbers.
- **Expression Support**: Direct calculation of complex mathematical expressions.
- **Interactive and Non-Interactive Modes**: Can be used both interactively and in scripts via piping.

> [!NOTE]
> Install `bc` on your machine if not available: For most distributions, use `sudo apt install bc` (Ubuntu/Debian) or equivalent.

### Example Usage
Start `bc` interactively by running the command:
```bash
bc
```
Within `bc`, perform calculations directly:
```bash
5 + 3
8
2.5 * 4
10.0
```

To exit, type `quit` or press Ctrl+D.

## Using the bc Command
### Key Concepts
To use `bc` non-interactively (e.g., in scripts), pipe expressions to it:
- **Basic Syntax**: Echo the expression followed by `bc`.
- **Piping**: Send output from other commands (e.g., `echo`) as input to `bc`.

Example pipe operations:
```bash
echo "2.5 + 3.5" | bc
echo "2.5 - 4.8" | bc
echo "2.5 * 3" | bc
echo "8.5 / 2.5" | bc
echo "8 % 5" | bc  # Modulus operation
```

Bangalore > [!IMPORTANT]
This method integrates seamlessly with shell scripts for dynamic calculations.

### Variable Usage
In scripts, define variables for operations:
```bash
x=5.5
y=2.0
echo "$x + $y" | bc
echo "$x * $y" | bc
```

For advanced functions (e.g., square root), define them in `bc`:
```bash
define sqrt(x) { return(sqrt(x)); }
echo "sqrt(16)" | bc -l
```

## Setting Decimal Places with Scale
### Key Concepts
By default, division in `bc` may truncate decimals. Use the `scale` variable to control precision.

- **Scale Setting**: Defines the number of decimal places in results.
- **Syntax**: Set `scale` before the expression.

Example:
```bash
echo "scale=3; 22.58 / 8.5" | bc  # 3 decimal places
```
This produces accurate results with specified precision.

> [!TIP]
> Increase `scale` for higher accuracy: `scale=10` for 10 decimal places.

## Using bc in Shell Scripts with User Input and Variables
### Key Concepts
Combine `bc` with script variables and user input for interactive calculators.

- **User Input**: Use `read` for variable capture.
- **Echo and Pipe**: Feed variables into `bc`.

Basic structure:
```bash
#!/bin/bash
read -p "Enter first number: " num1
read -p "Enter second number: " num2
echo "scale=2; $num1 + $num2" | bc
```

### Supported Operations
- Addition: `+`
- Subtraction: `-`
- Multiplication: `*`
- Division: `/`
- Modulus: `%`

## Performing Operations with User Input
### Key Concepts
Enhance scripts for multiple operations and advanced math.

Example script with user input:
```bash
#!/bin/bash
read -p "Enter first number: " num1
read -p "Enter second number: " num2
echo "scale=2; $num1 + $num2" | bc  # Addition
echo "scale=2; $num1 - $num2" | bc  # Subtraction
echo "scale=2; $num1 * $num2" | bc  # Multiplication
echo "scale=2; $num1 / $num2" | bc  # Division
echo "scale=0; $num1 % $num2" | bc  # Modulus
```

> [!CAUTION]
> The modulus operation (`%`) typically works with integers; for decimals, it may behave unexpectedly.

## Advanced Mathematical Operations with bc
### Key Concepts
Use the `-l` flag to load the math library for functions like square root and exponentiation.

- **Square Root**: `sqrt()` function.
- **Exponentiation**: Use `^` operator or `p(x,y)` for x raised to power y.
- **Syntax**: Pipe with `-l` for library access.

Examples:
```bash
echo "scale=2; sqrt(16)" | bc -l  # Square root
echo "scale=2; 2 ^ 3" | bc        # Exponentiation (2^3=8)
echo "scale=2; 1000 ^ 3" | bc     # Larger exponents
```

Note: Very large exponents may cause overflow or slow performance due to calculator limitations.

> [!IMPORTANT]
> For decimals in user input, ensure `scale` is set appropriately to avoid precision issues. Errors like "non-scalar variable" may appear in edge cases with the math library.

## Lab Demo: Creating a Calculator Script
### Overview
Create a comprehensive arithmetic calculator script handling decimals, user input, and basic/advanced operations.

### Steps
1. **Create Script File**:
   ```bash
   touch arithmetic_calculator.sh
   chmod +x arithmetic_calculator.sh
   ```

2. **Write Script Content** (Edit with your editor):
   ```bash
   #!/bin/bash
   
   # Greeting
   echo "Arithmetic Calculator for Decimal Numbers"
   
   # User input
   read -p "Enter first number: " num1
   read -p "Enter second number: " num2
   
   # Set precision to 3 decimal places
   SCALE=3
   
   # Perform operations
   echo "Addition: $(echo "scale=$SCALE; $num1 + $num2" | bc)"
   echo "Subtraction: $(echo "scale=$SCALE; $num1 - $num2" | bc)"
   echo "Multiplication: $(echo "scale=$SCALE; $num1 * $num2" | bc)"
   echo "Division: $(echo "scale=$SCALE; $num1 / $num2" | bc)"
   echo "Modulus: $(echo "scale=0; $num1 / 1 % $num2 / 1" | bc)"  # Approximate for decimals
   echo "Square root of $num1: $(echo "scale=$SCALE; sqrt($num1)" | bc -l)"
   echo "$num2 raised to $num1: $(echo "scale=$SCALE; $num2 ^ $num1" | bc)"
   ```

3. **Run the Script**:
   ```bash
   ./arithmetic_calculator.sh
   ```
   Example Output (for inputs 11.9 and 1.65):
   ```
   Addition: 13.550
   Subtraction: 10.250
   Multiplication: 19.635
   Division: 7.212
   Modulus: 1 (approximate)
   Square root of 11.9: 3.450
   1.65 raised to 11.9: 11.861 (exact value may vary)
   ```

### Code Analysis
- `read` handles user input.
- `bc` with `-l` enables math functions.
- Variables ensure reusability.
- Scale prevents truncation.

## Summary
### Key Takeaways
```diff
+ bc enables precise arithmetic on integers and decimals in shell scripts.
+ Use scale to control decimal precision in results.
+ Pipe expressions to bc for non-interactive calculations.
+ Combine with read for user-interactive scripts.
+ Advanced functions require the -l flag for math library.
- Modulus operations are primarily integer-based; decimals may need special handling.
! Avoid overflow with very large exponents; set realistic scale values.
```

### Quick Reference
| Command/Operation | Syntax Example | Description |
|-------------------|----------------|-------------|
| Basic bc | `echo "2.5 + 3" \| bc` | Perform calculation |
| Scale setting | `echo "scale=2; 10 / 3" \| bc` | Set decimal places |
| Math functions | `echo "sqrt(16)" \| bc -l` | Square root with library |
| Script with input | `read -p "Var: " var; echo "$var * 2" \| bc` | User-driven calculation |
| Exponentiation | `echo "2 ^ 3" \| bc` | Power operation |

### Expert Insight
**Real-world Application**: In automation scripts (e.g., financial calculations, scientific data processing), `bc` handles floating-point arithmetic where shell built-ins fail. Use it for log parsing, network latency calculations, or CI/CD metric analysis.

**Expert Path**: Master `bc`'s built-in functions by exploring `man bc` and experimenting with loops for iterative calculations. Integrate with `awk` or `perl` for complex pipelines.

**Common Pitfalls**: Overlook scale for division leading to inaccurate results; use `bc -l` sparingly as it loads the math lib only when needed; handle user input validation to prevent non-numeric errors.

*Note on Transcription Corrections*: Spelling and terms like "बीसी" (corrected to `bc`), "8.5" (verbatim), and phonetics like "जो}))
" (interpreted as operations) were corrected for clarity without altering technical content.

</details>
