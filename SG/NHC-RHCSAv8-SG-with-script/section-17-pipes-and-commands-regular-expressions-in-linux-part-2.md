# Section 17: Stream Editor and Advanced Regular Expressions

<details open>
<summary><b>Section 17: Stream Editor and Advanced Regular Expressions (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Stream Editor (sed)](#introduction-to-stream-editor-sed)
- [Basic Text Replacement with sed](#basic-text-replacement-with-sed)
- [Interactive File Editing with sed](#interactive-file-editing-with-sed)
- [Back References for Text Repetition](#back-references-for-text-repetition)
- [Parentheses for Pattern Grouping](#parentheses-for-pattern-grouping)
- [Handling Special Characters and Whitespace](#handling-special-characters-and-whitespace)
- [Dot Character and Multiple Back References](#dot-character-and-multiple-back-references)
- [Quantifiers for Exact Occurrence Matching](#quantifiers-for-exact-occurrence-matching)
- [Range Quantifiers](#range-quantifiers)
- [Practical Examples](#practical-examples)
- [Summary](#summary)

## Introduction to Stream Editor (sed)
The Stream Editor (sed) is a powerful Unix utility used for parsing and transforming text in a pipeline. Unlike interactive editors like vi or nano, sed works as a non-interactive stream editor that can process text line by line. It's particularly useful for bulk text manipulation, filtering, and substitution operations.

### Key Features of sed:
- Works with streams of text (input from files or stdin)
- Uses regular expressions for pattern matching
- Can perform in-place editing or output to stdout
- Supports complex substitution, deletion, and insertion operations

### Basic sed Syntax:
```bash
sed 's/pattern/replacement/flags' input_file
```

**Common sed Options:**
- `-i`: Edit files in-place
- `-e`: Execute multiple commands
- `-n`: Suppress automatic output
- `-r`: Use extended regular expressions

## Basic Text Replacement with sed
Simple text replacement is one of sed's most common use cases. The basic syntax replaces the first occurrence of a pattern on each line.

**Example: Replace "Sunday" with "Monday"**
```bash
echo "Today is Sunday holiday" | sed 's/Sunday/Monday/'
# Output: Today is Monday holiday
```

**Syntax Breakdown:**
- `s/`: Substitution command
- `Sunday/`: Pattern to find
- `Monday/`: Replacement text
- `/`: Delimiter (can be any character)

### Using Different Delimiters:
```bash
# Using different delimiters for clarity
echo "Today/Sunday" | sed 's#Sunday#Monday#'
echo "Today|Sunday" | sed 's|Sunday|Monday|'
```

> [!NOTE]
> Different delimiters are useful when dealing with file paths containing forward slashes.

## Interactive File Editing with sed
By default, sed outputs to stdout without modifying the original file. The `-i` flag enables in-place editing, which modifies the file directly.

### Creating a Test File:
```bash
mkdir test_dir
cd test_dir
echo "Sunday" > today.txt
```

### Non-destructive Editing (Output only):
```bash
cat today.txt | sed 's/Sunday/Monday/'
# File remains unchanged, output shows Monday
```

### In-place Editing:
```bash
sed -i 's/Sunday/Monday/' today.txt
cat today.txt
# File now contains: Monday
```

> [!WARNING]
> `-i` modifies files directly. Always backup important files before using this option.

## Back References for Text Repetition
Back references allow you to reference captured groups from your regular expression pattern. This is useful for duplicating or rearranging text.

### Doubling Text with Back References:
```bash
echo "Sunday" | sed 's/Sunday/\1\1/'
# Creates a back reference to the matched pattern and repeats it
```

**Correct Syntax with Parentheses:**
```bash
echo "Sunday" | sed 's/\(Sunday\)/\1\1/'
# Output: SundaySunday
```

### Referencing Subgroups:
```bash
echo "Sunday holiday" | sed 's/\(Sunday\) \(holiday\)/\1 \1/'
# Output: Sunday Sunday holiday
```

> [!IMPORTANT]
> Parentheses create capture groups that can be referenced with `\1`, `\2`, etc.

## Parentheses for Pattern Grouping
Parentheses `()` are used to group patterns and capture them for back references. This enables complex text manipulation and rearrangement.

### Basic Grouping Example:
```bash
echo "First Second" | sed 's/\(First\) \(Second\)/\2 \1/'
# Output: Second First (swaps the words)
```

### Adding Text to Groups:
```bash
echo "Sunday" | sed 's/Sunday/\1 Holiday/'
# Must include \1 to reference the captured group
echo "Sunday" | sed 's/\(Sunday\)/\1 Holiday/'
# Output: Sunday Holiday
```

> [!NOTE]
> When using parentheses, always include the back reference `\1` in the replacement string to avoid losing the original text.

## Handling Special Characters and Whitespace
sed requires special handling for certain characters and whitespace. Backslashes are used to escape special regex characters.

### Escaping Special Characters:
```bash
# To match a literal dot (.)
echo "version 1.0" | sed 's/version \([0-9]\)\.\([0-9]\)/version \1_\2/'
# Output: version 1_0
```

### Handling Tabs and Spaces:
```bash
# Replace tabs with spaces
echo -e "Name\tAge\tCity" | sed 's/\t/ /g'
# Output: Name Age City

# Replace spaces with tabs
echo "Name Age City" | sed 's/ /\t/g'
```

### Converting Whitespace Types:
```bash
# Convert all tabs to spaces
sed 's/\t/    /g' file.txt

# Convert multiple spaces to single space
sed 's/  */ /g' file.txt
```

> [!TIP]
> Use `\t` for tabs and multiple spaces `\s*` for flexible whitespace matching in patterns.

## Dot Character and Multiple Back References
The dot `.` matches any single character, and combined with back references, enables sophisticated text transformations.

### Using Dot for Any Character:
```bash
# Replace any character between patterns
echo "D M Y" | sed 's/D.M.Y/DD-MM-YY/'
# Output: DD-MM-YY
```

### Multiple Capture Groups:
```bash
echo "D M Y" | sed 's/\(D\) \(M\) \(Y\)/Day: \1 Month: \2 Year: \3/'
# Output: Day: D Month: M Year: D
```

### Complex rearrangement:
```bash
echo "John Doe 25" | sed 's/\([^ ]*\) \([^ ]*\) \([^ ]*\)/Name: \1 \2 Age: \3/'
# Output: Name: John Doe Age: 25
```

> [!WARNING]
> The dot matches any character including spaces, which can lead to unexpected results if not used carefully.

## Quantifiers for Exact Occurrence Matching
Quantifiers specify exactly how many times a pattern should occur. Use curly braces `{}` to specify exact counts.

### Exact Number of Repetitions:
```bash
# Match exactly 3 consecutive letters
grep 'lll\{3\}l' file.txt
# Matches lllll but not lll or llllll

# Match exactly 2 occurrences of a line
sed -n '/pattern/{3}p' file.txt  # Print line containing exactly 3 repetitions
```

### Practical Example:
```bash
# Find lines with exactly 3 consecutive digits
grep '[0-9]\{3\}' numbers.txt

# Replace exactly 2 spaces with tab
sed 's/ \{2\}/\t/g' file.txt
```

> [!NOTE]
> `{n}` matches exactly n occurrences, while `{n,}` matches n or more.

## Range Quantifiers
Range quantifiers specify minimum and maximum occurrences using `{min,max}` syntax or open-ended ranges.

### Minimum and Maximum Range:
```bash
# Match between 2 and 3 consecutive letters
grep 'l\{2,3\}' file.txt
# Matches ll and lll, but not l or llll

# Match at least 2, at most 5 digits
grep '[0-9]\{2,5\}' file.txt
```

### Open-ended Ranges:
```bash
# Match at least 2 consecutive letters
grep 'l\{2,\}' file.txt

# Match at most 3 digits
grep '[0-9]\{,3\}' file.txt
```

### Real-world Example:
```bash
# Find words with 3 to 7 characters
grep '\b[a-zA-Z]\{3,7\}\b' text.txt

# Validate phone numbers with optional area code
grep '([0-9]\{3,\}\s?)?[0-9]\{3\}-[0-9]\{4\}' contacts.txt
```

> [!TIP]
> Range quantifiers are essential for validating input formats and finding patterns within specific length ranges.

## Practical Examples
Let's look at real-world scenarios where sed's advanced features shine.

### Trimming Leading/Trailing Whitespace:
```bash
# Remove leading spaces
sed 's/^[ \t]*//' file.txt

# Remove trailing spaces
sed 's/[ \t]*$//' file.txt

# Remove both
sed 's/^[ \t]*//;s/[ \t]*$//' file.txt
```

### Manipulating Date Formats:
```bash
# Convert DD/MM/YYYY to YYYY-MM-DD
echo "25/12/2024" | sed 's/\([0-9]\{1,2\}\)\/\([0-9]\{1,2\}\)\/\([0-9]\{4\}\)/\3-\2-\1/'

# Output: 2024-12-25
```

### System Administration Tasks:
```bash
# Update configuration values
sed -i 's/listen\s*80/listen 8080/' nginx.conf

# Clean up log files
sed '/^$/d' access.log > cleaned.log

# Extract specific data from CSV
sed -n 's/[^,]*,[^,]*,([^,]*),.*/\1/p' data.csv
```

### Command History Manipulation:
```bash
# Repeat commands
history | sed -n '335p' | bash

# Modify previous commands
history | sed 's/^ *[0-9]* *\(.*\)/\1/' > commands.txt
```

> [!IMPORTANT]
> Always test sed commands on sample data before applying to critical files, especially with `-i` flag.

## Summary

### Key Takeaways
```diff
+ sed is a stream editor for text processing and transformation
+ Basic syntax: sed 's/pattern/replacement/flags' input
+ Use -i for in-place editing (modifies files directly)
+ Parentheses () create capture groups for back references \1, \2, etc.
+ Dot (.) matches any single character
+ Quantifiers {n}, {min,max}, {n,} specify repetition counts
+ Back references enable text duplication and rearrangement
+ Special characters need escaping with backslashes
```

### Quick Reference
**Common sed Commands:**
```bash
# Basic substitution
sed 's/old/new/' file

# Global replacement
sed 's/old/new/g' file

# In-place editing
sed -i 's/old/new/' file

# Using back references
sed 's/\(pattern\)/\1_mod/' file

# Quantifiers
sed 's/l\{2,4\}/replacement/' file

# Delete empty lines
sed '/^$/d' file

# Print specific lines
sed -n '10,20p' file
```

**Special Characters in sed:**
- `$`: End of line
- `^`: Beginning of line  
- `\t`: Tab character
- `\s`: Whitespace
- `[0-9]`: Any digit
- `[a-z]`: Any lowercase letter
- `[A-Z]`: Any uppercase letter

> [!IMPORTANT]
> sed uses basic regular expressions by default. Use `-r` flag for extended regex, or escape special characters appropriately.

### Expert Insights

**Real-world Application:**
In production environments, sed is commonly used for:
- Configuration file updates across multiple servers
- Log file parsing and data extraction
- Automated text transformations in deployment scripts
- Batch processing of data files

**Expert Path:**
- Master regex patterns before advanced sed features
- Test sed commands on sample data using pipes before in-place editing
- Combine sed with other tools (grep, awk, cut) in pipeline operations
- Learn sed scripting for complex multi-line transformations

**Common Pitfalls:**
1. Forgetting to escape special regex characters like `.`, `*`, `+`
2. Using `-i` without backing up files first
3. Misunderstanding capture groups and back references
4. Not using global flag `g` when replacing all occurrences
5. Confusion between basic and extended regular expressions

> [!WARNING]
> Incorrect sed commands can corrupt configuration files or data. Always validate patterns on sample data first.

</details>
