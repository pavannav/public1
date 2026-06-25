<details open>
<summary><b>Session 9: Different Ways to Pass JSON Data as an Input to Jq Command (KK-CS45-script-v3-Inst-v1)</b></summary>

# Session 9: Different Ways to Pass JSON Data as an Input to Jq Command

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [JSON Input Methods Overview](#json-input-methods-overview)
  - [Working with Strings](#working-with-strings)
  - [Working with Files](#working-with-files)
  - [Working with REST API Responses](#working-with-rest-api-responses)
- [Lab Demonstrations](#lab-demonstrations)
- [Summary](#summary)

## Overview

This session demonstrates the three fundamental methods for providing JSON data as input to the `jq` command: using string literals, reading from files, and processing API responses. Using the identity filter (`.`) as the basic filter, learners will understand the syntax patterns that apply across all jq operations regardless of input source.

## Key Concepts

### JSON Input Methods Overview

The `jq` command requires JSON-formatted input, and understanding how to provide this input from different sources is essential for practical usage. There are three primary methods:

| Method | Description | Use Case |
|--------|-------------|----------|
| String literals | JSON data passed directly via command line | Quick testing, small data sets |
| File input | Reading JSON from `.json` files | Working with stored data |
| API responses | Processing HTTP response data | Real-time data processing |

### Working with Strings

When passing JSON data as a string literal, proper formatting with quotes is essential:

**Method 1: Using echo with piping**
```bash
echo '{"key": "value"}' | jq .
```

**Method 2: Using heredoc syntax**
```bash
jq . <<<'{"key": "value"}'
```

**Important Considerations:**
- Raw JSON objects cannot be passed directly to `jq` without proper string formatting
- Using `echo` without quotes strips quotation marks from the output
- The heredoc syntax (`<<<`) provides a standard, clean method for inline JSON

### Working with Files

The most straightforward method for processing stored JSON data:

**Method 1: Direct file input**
```bash
jq . demo.json
```

**Method 2: Using cat with piping**
```bash
cat demo.json | jq .
```

**Method 3: Using heredoc with cat**
```bash
jq . <<< $(cat demo.json)
```

**File Processing Notes:**
- Direct file specification is the simplest approach
- Piping with `cat` provides flexibility for preprocessing
- All methods produce identical results when the file contains valid JSON

### Working with REST API Responses

Processing live API data requires understanding curl integration:

**Method 1: Piping curl output**
```bash
curl -s https://api.example.com/data | jq .
```

**Method 2: Using heredoc with curl**
```bash
jq . <<< $(curl -s https://api.example.com/data)
```

**Curl Options for jq Integration:**
- `-s`: Silent mode - suppresses progress bars and download indicators
- `-X`: Specifies HTTP method (default is GET)

**Common Curl Flags:**
```bash
# Silent mode (suppress progress)
curl -s URL

# Specify HTTP method
curl -X GET URL
curl -X POST URL
```

## Lab Demonstrations

### Demo 1: String Input Methods
```bash
# Incorrect - missing quotes
echo {"key": "value"} | jq .

# Correct - properly quoted JSON string
echo '{"key": "value"}' | jq .

# Using heredoc
jq . <<<'{"key": "value"}'
```

### Demo 2: File Input Methods
```bash
# Direct file input
jq . demo.json

# Piping cat output
cat demo.json | jq .

# Heredoc with command substitution
jq . <<< $(cat demo.json)
```

### Demo 3: API Response Processing
```bash
# Basic API call with jq
curl https://jsonplaceholder.typicode.com/posts | jq .

# Silent mode (no progress bar)
curl -s https://jsonplaceholder.typicode.com/posts | jq .

# With explicit GET method
curl -s -X GET https://jsonplaceholder.typicode.com/posts | jq .
```

## Summary

```diff
+ Key Point: Three distinct methods exist for providing JSON input to jq: string literals, files, and API responses
+ Key Point: The heredoc syntax (<<<) provides a clean, standard approach for inline data
+ Key Point: Use -s flag with curl to suppress progress bars when piping to jq
- Warning: Always ensure JSON data is properly quoted when passing as strings
- Warning: Command output must be valid JSON when using heredoc with command substitution
```

### Quick Reference

| Input Source | Syntax Options |
|-------------|----------------|
| String | `echo 'json' \| jq .` or `jq . <<<'json'` |
| File | `jq . file.json` or `cat file.json \| jq .` |
| API | `curl -s URL \| jq .` or `jq . <<< $(curl -s URL)` |

### Expert Insight

**Real-world Application:**
In production environments, file-based input is most common for batch processing, while API responses are critical for real-time dashboards and monitoring systems. String literals are primarily used for testing and debugging specific jq expressions.

**Expert Path:**
- Master the heredoc syntax for complex inline JSON scenarios
- Learn to combine multiple input methods in shell scripts
- Understand how to handle large JSON files efficiently with streaming

**Common Pitfalls:**
- Forgetting quotes around JSON strings causes parsing failures
- Not using `-s` flag results in unwanted progress bar output in jq results
- Command substitution with heredoc can fail with complex JSON containing special characters

</details>