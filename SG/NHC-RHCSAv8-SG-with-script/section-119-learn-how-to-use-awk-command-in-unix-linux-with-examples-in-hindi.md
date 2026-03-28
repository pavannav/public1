# Section 119: AWK Command Part 1

<details open>
<summary><b>Section 119: AWK Command Part 1 (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Section 119 DevOps Interview Shell Scripting Chapter 16: AWK Command Part 1](#section-119-devops-interview-shell-scripting-chapter-16-awk-command-part-1)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
    - [Introduction to AWK](#introduction-to-awk)
    - [What is AWK and Why Use It](#what-is-awk-and-why-use-it)
    - [AWK Command Syntax](#awk-command-syntax)
    - [Built-in Variables](#built-in-variables)
    - [Basic Operations](#basic-operations)
    - [Field Processing](#field-processing)
    - [Pattern Matching and Searching](#pattern-matching-and-searching)
    - [Conditional and Logic Operations](#conditional-and-logic-operations)
    - [Arithmetic Operations](#arithmetic-operations)
    - [Advanced Techniques](#advanced-techniques)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Section 119 DevOps Interview Shell Scripting Chapter 16: AWK Command Part 1

### Overview
AWK is a powerful scripting language designed for text processing and data transformation. This section introduces AWK fundamentals, including pattern matching, field manipulation, and common operations used in shell scripting for processing text files, generating reports, and performing data analysis.

### Key Concepts

#### Introduction to AWK
AWK is a scripting language used for processing and analyzing text data. It reads input line by line and performs operations based on specified patterns.

#### What is AWK and Why Use It
- **Key Programming Language Features**: AWK supports variables, functions, system functions, and logical operators without requiring compilation
- **Utility**: Enables efficient text processing, report generation, and data transformation
- **Pattern Matching**: Scans files for text patterns and executes actions on matching lines
- **Origin**: Named after developers Aho, Weinberger, and Kernighan (AWK)
- **Use Cases**: Text scanning, file processing, multiple file comparisons, input line selection, and data transformation for formatted reports

#### AWK Command Syntax
The basic syntax for using AWK:

```bash
awk [options] 'pattern { action }' file
```

- `pattern`: Selection criteria (what to match)
- `action`: Operations to perform when pattern matches
- `file`: Input file to process
- For output redirection: `awk 'pattern { action }' file > output.txt`

#### Built-in Variables
AWK provides several built-in variables:

- **NR (Number of Records)**: Tracks total number of records processed
- **FNR (File Number of Records)**: Records per file in multi-file processing
- **NF (Number of Fields)**: Number of fields in current record
- **RS (Record Separator)**: Input record separator (default: newline)
- **FS (Field Separator)**: Input field separator (default: space/tab)

#### Basic Operations

##### Print Entire File
```bash
awk '{ print }' filename
```

Equivalent to `cat filename` command.

##### Print with Line Numbers
```bash
awk '{ print NR, $0 }' filename
```

Uses `NR` variable to display line numbers with content.

#### Field Processing

##### Print Specific Fields
Print first field (employee names):
```bash
awk '{ print $1 }' empdata.txt
```

Print name and salary (first and fourth fields):
```bash
awk '{ print $1, $4 }' empdata.txt
```

##### Print Fields with Custom Separators
```bash
awk 'BEGIN { OFS=";" } { print NR ": ", $1 }' filename
```

- `OFS`: Output Field Separator (set to semicolon)

#### Pattern Matching and Searching

##### Search for Specific Text
Find all managers:
```bash
awk '/Manager/ { print }' empdata.txt
```

Print lines not containing "Manager":
```bash
awk '!/Manager/ { print }' empdata.txt
```

##### Print Field from Matching Lines
```bash
awk '/Manager/ { print $1, $2 }' empdata.txt
```

#### Conditional and Logic Operations

##### Arithmetic Comparisons
Print lines with more than 10 characters:
```bash
awk 'length($0) > 10 { print }' filename
```

Print lines with specific character count:
```bash
awk 'length($0) >= 15 && length($0) <= 20 { print }' filename
```

##### Print Specific Line Ranges
Print lines 3 through 6:
```bash
awk 'NR >= 3 && NR <= 6 { print NR, $0 }' filename
```

#### Arithmetic Operations
Calculate squares of numbers 1 through 6:
```bash
awk 'BEGIN { for(i=1; i<=6; i++) print "Square of " i " is: ", i*i }'
```

Loop structure:
- `BEGIN`: Execute before file processing
- `for(i=start; i<=end; i++)`: Loop syntax
- Arithmetic operations: `+`, `-`, `*`, `/`, `%`

#### Advanced Techniques

##### Find Maximum Line Length
```bash
awk 'BEGIN { max=0 } { len=length($0); if(len > max) max=len } END { print "Maximum length:", max }' filename
```

##### Count Total Lines
```bash
awk 'END { print NR }' filename
```

##### Combine Operations
Print first column with line numbers and custom separator:
```bash
awk 'BEGIN { OFS="|" } { print NR ":", $1 }' filename
```

### Summary

#### Key Takeaways

```diff
+ AWK is a text processing language for pattern matching and data manipulation
+ Supports variables, functions, and logical operators without compilation
+ Perfect for extracting fields, filtering data, and generating reports
+ Built-in variables like NR, NF enable advanced processing
+ Syntax: awk 'pattern { action }' file supports flexible operations
+ Can perform arithmetic, conditional, and formatting operations
+ Essential for shell scripting in DevOps environments
+ Enables efficient processing of structured text data
```

#### Quick Reference

**Common AWK Variables:**
- `NR`: Current record number
- `NF`: Number of fields in current record
- `$0`: Entire current line
- `$1, $2, ...`: Individual fields (columns)
- `FS`: Field separator
- `OFS`: Output field separator

**Basic Syntax Patterns:**
```bash
# Print entire file
awk '{ print }' file

# Print specific field
awk '{ print $1 }' file

# Search pattern
awk '/pattern/ { print }' file

# Print with line numbers
awk '{ print NR ": ", $0 }' file

# Arithmetic operations
awk '{ print $1 * $1 }' file
```

#### Expert Insight

**Real-world Application**
AWK excels in log file analysis, CSV processing, and report generation in production environments. It's commonly used in ETL pipelines, monitoring scripts, and data transformation workflows where you need to extract specific fields or filter large datasets efficiently.

**Expert Path**
Master AWK by practicing with real log files and CSV data. Learn to combine it with other shell commands using pipes (`cat file | awk '...'`) and explore advanced features like arrays and user-defined functions. Understanding field separators and record processing is crucial for complex data scenarios.

**Common Pitfalls**
- Forgetting to properly escape special characters in patterns
- Mixing up field numbers ($1 vs $2) in complex files
- Not handling whitespace in field separators correctly
- Using NR when FNR is needed for multi-file processing
- Incorrectly assuming default field separator behavior with CSV files

</details>
