<details open>
<summary><b>04-Introduction-to-Jq-Command (KK-CS45-script-v3-Inst-v1)</b></summary>

# Session 4: Introduction to JQ Command

## Table of Contents

- [Overview](#overview)
- [What is JQ Command](#what-is-jq-command)
- [Why Parse JSON Data](#why-parse-json-data)
- [Real-World Use Cases](#real-world-use-cases)
- [Installation](#installation)
- [Summary](#summary)

## Overview

This introductory session defines what the `jq` command is, explains its purpose as a JSON parser in shell scripting, demonstrates why parsing JSON matters in modern DevOps workflows, and covers installation across major operating systems. The session uses a practical example of fetching remote server credentials via a REST API and parsing the JSON response with `jq` to avoid hardcoding secrets in shell scripts.

## What is JQ Command

**JQ** is a lightweight and flexible command-line JSON processor. It functions like other standard Unix commands (`date`, `grep`, `sed`) but is specialized for reading and writing JSON data.

### Key Distinctions

| Aspect | Traditional Tools (`sed`, `awk`) | JQ Command |
|--------|----------------------------------|------------|
| Primary Use | Text stream processing | Structured JSON manipulation |
| Data Model | Line-based text | JSON objects, arrays, primitives |
| Query Language | Regex patterns | Path expressions (`.key`, `.[index]`) |
| Output | Raw text | Formatted/structured JSON or values |
| Complexity | Simple text transforms | Deep nested data extraction |

**Parsing JSON** means programmatically reading and extracting specific values from structured JSON data. In Python this is done with the `json` module; in shell scripting, `jq` provides equivalent (and often more powerful) capabilities.

```diff
+ Positive/Key Point: jq treats JSON as a first-class data structure rather than plain text
- Negative/Warning: Using sed/awk on JSON often breaks when formatting or escaping changes
```

## Why Parse JSON Data

Modern infrastructure and tooling increasingly output JSON:

- **REST APIs** return JSON responses by default
- **AWS CLI** supports `--output json` for machine-readable results  
- **Docker**, **Kubernetes**, **Terraform**, and most DevOps tools expose JSON APIs

The practical problem demonstrated: extracting credentials from a REST API response without hardcoding them in a shell script.

### Demo Scenario – Remote Filesystem Check

**Original insecure approach** (hardcoded credentials):

```bash
#!/bin/bash
USERNAME="admin"
PASSWORD="secret123"
sshpass -p "$PASSWORD" ssh "$USERNAME"@remote-server "df -h"
```

**Secure approach** using REST API + `jq`:

```bash
#!/bin/bash
# Fetch credentials from internal REST API
CREDENTIALS=$(curl -s http://localhost:5000/credentials)

# Parse JSON with jq
USERNAME=$(echo "$CREDENTIALS" | jq -r '.secret.remote_server.username')
PASSWORD=$(echo "$CREDENTIALS" | jq -r '.secret.remote_server.password')

# Use credentials
sshpass -p "$PASSWORD" ssh "$USERNAME"@remote-server "df -h"
```

### AWS CLI Example

```bash
# List IAM users (JSON output)
aws iam list-users

# Extract only usernames using jq
aws iam list-users | jq -r '.Users[].UserName'
```

## Real-World Use Cases

> [!IMPORTANT]
> Almost every DevOps workflow now produces or consumes JSON. `jq` is the universal tool to manipulate that data from the command line.

Common scenarios:

1. **CI/CD Pipelines** – Extract build metadata, artifact URLs, or deployment status from API responses
2. **Cloud Automation** – Parse AWS/GCP/Azure CLI JSON output to drive conditional logic
3. **Kubernetes** – Query `kubectl get` JSON output for pod status, labels, or resource usage
4. **Log Analysis** – Filter structured JSON logs without writing custom parsers
5. **Configuration Management** – Transform or validate JSON configuration files

## Installation

### Linux (CentOS/RHEL)

```bash
sudo yum update -y
sudo yum install -y jq
```

### Linux (Debian/Ubuntu)

```bash
sudo apt update -y
sudo apt install -y jq
```

### macOS

```bash
brew update
brew install jq
```

> [!NOTE]
> The most common and efficient usage of `jq` is inside shell scripts rather than interactive terminal sessions.

## Summary

### Key Takeaways

```diff
+ jq is the standard command-line JSON processor, analogous to grep/sed for text
+ Modern DevOps tools (REST APIs, AWS, Docker, K8s) output JSON — jq extracts needed values
+ Avoid hardcoding secrets in scripts; fetch via API and parse with jq instead
+ Installation is a single package-manager command on all major platforms
- Never parse JSON with regex or line-based tools in production scripts
```

### Quick Reference

| Task | Command |
|------|---------|
| Install on RHEL/CentOS | `yum install jq` |
| Install on Ubuntu/Debian | `apt install jq` |
| Install on macOS | `brew install jq` |
| Extract field from JSON | `jq -r '.key.subkey'` |
| Extract array element | `jq -r '.array[0].field'` |

### Expert Insight

**Real-world Application**  
In production, store credentials in a secrets manager or internal API. Scripts call the API once, parse the JSON response with `jq`, and continue without ever writing secrets to disk or source control.

**Expert Path**  
Master `jq` filters, pipes, and functions (`.[]`, `select()`, `map()`, `length`). Combine with `curl`, `aws`, and `kubectl` to build powerful one-liners that replace hundreds of lines of parsing code.

**Common Pitfalls**  
- Forgetting `-r` (raw output) produces quoted strings instead of plain values  
- Assuming JSON keys are always present (missing keys return `null`)  
- Using line-oriented tools (`sed`, `awk`) on JSON that may contain newlines or escaped quotes inside strings

</details>
