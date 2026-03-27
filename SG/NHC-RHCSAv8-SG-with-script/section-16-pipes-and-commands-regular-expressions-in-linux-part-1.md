# Section 16: Regular Expressions

<details open>
<summary><b>Section 16: Regular Expressions (CL-KK-Terminal)</b></summary>

## Table of Contents

- [Introduction](#introduction)
- [Types of Regular Expressions](#types-of-regular-expressions)
- [Basic Usage with grep](#basic-usage-with-grep)
- [Anchors for Start and End](#anchors-for-start-and-end)
- [Quantifiers](#quantifiers)
- [Word Boundaries](#word-boundaries)
- [Escaping Special Characters](#escaping-special-characters)
- [Examples and Labs](#examples-and-labs)
- [Summary](#summary)

## Introduction

Regular expressions (regex) in Linux are special characters that help search data and match complex patterns. They are used in various programs like grep, sed, and vim to search and manipulate text efficiently. Regex enables powerful pattern matching beyond simple string searches, allowing for nuanced queries like finding all email addresses or specific file formats.

## Types of Regular Expressions

Linux has three main types of regular expressions:

1. **Basic Regular Expressions (BRE)**: The default type in older tools like grep. Uses simple matching with limited features.
2. **Extended Regular Expressions (ERE)**: More advanced, supports additional metacharacters. Enabled with options like `-E` (or `-r` in newer versions).
3. **Advanced Regular Expressions (ARE)**: Used in modern tools like grep with `-P` option, supports Perl-compatible features.

To use ER in grep, use `grep -E`, or for BRE, `grep -G`. For ARE, `grep -P`.

## Basic Usage with grep

grep searches for patterns in files. Basic examples:

- `grep "a" names` - Finds lines with "a".
- `grep "an" names` - Finds "an" in sequence.
- `grep "ana" names` - Exact sequence match.
- For OR operations: In ERE, `grep -E "a|i" names`.

Positive matches are highlighted in red.

## Anchors for Start and End

- **Start of line**: Use `^` to match the beginning of a string/line.
  - Example: `grep "^V" names` matches lines starting with "V".
- **End of line**: Use `$` to match the end of a string/line.
  - Example: `grep "a$" names` matches lines ending with "a".

These are crucial for precise pattern matching.

## Quantifiers

Quantifiers specify how many times a character or group should appear:

- `*` : Zero or more occurrences.
  - Example: `grep -E "o*x" text` matches "ox", "ooox", etc., in sequence.
- `+`: One or more occurrences.
  - Example: `grep -E "o+x" text`.
- `?`: Zero or one occurrence (optional).

In BRE, special characters like `+` need escaping with backslash.

## Word Boundaries

To match whole words, use word boundaries:

- `<` or `\b` (depending on mode): Word start.
- `>` or `\b`: Word end.

Note: Syntax may vary by tool; always test.

Example: `grep -E "\bok\b" names`.

## Escaping Special Characters

Special characters like `$`, `^`, etc., are treated literally in regex. To search for them, escape with backslash `\`:

- Search for `$`: `\$`
- Variable expansion may occur in shell, so quote regex in single quotes: `'pattern'`.

Always escape regex in quotes to prevent shell interpretation.

## Examples and Labs

Create sample files for testing:

- `names` file: Tanya, Laura, Valentina, etc.
- `text` file: Sentences for pattern testing.

1. Lab: Match "a" repeated: `grep -E "a+" text`.
2. Lab: Word boundaries: Find "over" as a separate word: `grep -E "\\bover\\b" text`.
3. Lab: Anchors: Lines ending with vowel: `grep -E "[aeiou]$" names`.

Practice these commands interactively.

## Summary

### Key Takeaways
```diff
+ Regular expressions are powerful for pattern matching and searching in Linux tools like grep
+ Know the three types: BRE, ERE, ARE - use appropriate flags like -E or -P
+ Anchors (^ and $) control start/end matching for precision
+ Quantifiers (*, +, ?) handle repetition efficiently
+ Always escape special characters and use quotes to prevent shell expansion
+ Practice with sample files to master complex patterns
```

### Quick Reference
- Match start: `^pattern`
- Match end: `pattern$`
- One or more: `pattern+`
- Zero or more: `pattern*`
- Optional: `pattern?`
- Word boundary: `\b`
- OR in ERE: `pattern1|pattern2`

### Expert Insight

**Real-world Application**: Regex is essential for log analysis, text processing in scripts, and validation (e.g., emails: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`). In production, use tools like sed or awk with regex for automation.

**Expert Path**: Master ERE and ARE for advanced features. Learn regex in Python with `re` module for cross-platform scripting. Participate in regex challenges.

**Common Pitfalls**: Forgetting to escape special characters leads to shell interpretation. Using BRE when ERE is needed causes failures. Always test patterns in files before deployment.

</details>
