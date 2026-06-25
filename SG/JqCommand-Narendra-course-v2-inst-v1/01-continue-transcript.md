# Session 1: Continue - JQ Command in Shell Scripts

<details open>
<summary><b>Session 1: Continue (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Shell Scripting Fundamentals](#shell-scripting-fundamentals)
- [JQ Field Filter with Raw String Option](#jq-field-filter-with-raw-string-option)
- [REST API Integration for Credentials](#rest-api-integration-for-credentials)
- [Complete Shell Script Implementation](#complete-shell-script-implementation)
- [Performance Optimization](#performance-optimization)
- [Summary](#summary)

## Overview

This session demonstrates practical application of the JQ command within shell scripts. The focus is on building a script that retrieves remote server filesystem usage by fetching credentials from a REST API, using JQ to parse JSON responses, and implementing the results with SSH and SSHpass for automated remote command execution.

## Key Concepts

### Shell Command Substitution
Command substitution captures the output of a command and assigns it to a variable.

**Syntax:**
```bash
variable=$(command)
```

**Example:**
```bash
today=$(date)
echo $today
```

### JQ Field Filter
Extracts specific values from JSON objects using dot notation.

**Syntax:**
```bash
jq '.key1.key2.key3'
```

**Usage:** Navigate nested JSON structures by chaining field names with dots.

### Raw String Option (-r)
The `-r` flag outputs raw strings without JSON formatting (quotes removed).

**Syntax:**
```bash
jq -r '.key.path'
```

**Why Required:** Prevents quotation marks from appearing in output, essential when storing credentials for SSH authentication.

## Shell Scripting Fundamentals

### Storing Command Output in Variables
```bash
# Basic pattern
variable=$(command)

# Example with ls
files_info=$(ls)
echo $files_info
```

### REST API Response Handling
When calling APIs with curl, suppress progress bars using `-s` (silent) flag:
```bash
curl -s http://api-url/endpoint
```

## JQ Field Filter with Raw String Option

### Practical Example: Parsing Credentials from API

**Sample API Response Structure:**
```json
{
  "secrets": {
    "remote_server_creds": {
      "username": "easytozeeuser",
      "password": "password123"
    }
  }
}
```

**JQ Commands:**
```bash
# Get entire secrets object
curl -s http://localhost:5000/secrets | jq '.secrets'

# Navigate to credentials
curl -s http://localhost:5000/secrets | jq '.secrets.remote_server_creds'

# Extract username
curl -s http://localhost:5000/secrets | jq '.secrets.remote_server_creds.username'

# Extract raw username (no quotes)
curl -s http://localhost:5000/secrets | jq -r '.secrets.remote_server_creds.username'
```

### Command Substitution with JQ
```bash
username=$(curl -s http://localhost:5000/secrets | jq -r '.secrets.remote_server_creds.username')
password=$(curl -s http://localhost:5000/secrets | jq -r '.secrets.remote_server_creds.password')
```

## REST API Integration for Credentials

### REST API Server (Python/Flask)
The session uses a simple Flask REST API to store credentials:

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/secrets')
def get_secrets():
    return jsonify({
        "secrets": {
            "remote_server_creds": {
                "username": "your_username",
                "password": "your_password"
            }
        }
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**Important:** Replace hardcoded username/password with your actual credentials before running.

### API Endpoint Testing
```bash
curl -s http://localhost:5000/secrets
```

## Complete Shell Script Implementation

### Script: practice1.sh

```bash
#!/bin/bash

# Remote server configuration
hostname="your-remote-server-ip"

# Fetch credentials from REST API using JQ with raw string output
username=$(curl -s http://localhost:5000/secrets | jq -r '.secrets.remote_server_creds.username')
password=$(curl -s http://localhost:5000/secrets | jq -r '.secrets.remote_server_creds.password')

# Display credentials for verification (remove in production)
echo "Username: $username"
echo "Password: $password"

# Execute remote command using SSH with SSHpass
sshpass -p "$password" ssh "$username@$hostname" "df -h"
```

### Running the Script
```bash
chmod +x practice1.sh
./practice1.sh
```

### Common Error: Permission Denied
**Problem:** Script fails with "Permission denied, please try again"

**Cause:** JQ output includes quotation marks when `-r` flag is missing.

**Solution:** Add `-r` flag to all `jq` commands extracting credentials.

## Performance Optimization

### Problem: Multiple API Calls
Making separate curl calls for each credential wastes execution time.

### Solution 1: Store API Response in Variable
```bash
#!/bin/bash

hostname="your-remote-server-ip"

# Single API call - store entire response
response=$(curl -s http://localhost:5000/secrets)

# Parse multiple values from single response
username=$(echo "$response" | jq -r '.secrets.remote_server_creds.username')
password=$(echo "$response" | jq -r '.secrets.remote_server_creds.password')

echo "Username: $username"
echo "Password: $password"

sshpass -p "$password" ssh "$username@$hostname" "df -h"
```

### Solution 2: Alternative Syntax Using Here-String
```bash
username=$(jq -r '.secrets.remote_server_creds.username' <<< "$response")
password=$(jq -r '.secrets.remote_server_creds.password' <<< "$response")
```

### Here-String (`<<<`) vs Pipe (`|`)
- **Pipe:** `echo "$response" | jq '...'` — Creates subshell
- **Here-String:** `jq '...' <<< "$response"` — More efficient, avoids subshell

## Summary

### Key Takeaways
```diff
+ Store command output using $(command) syntax
+ Use jq -r for raw string output without quotes
+ Suppress curl progress with -s flag
+ Make single API call and parse multiple values from response
+ Use sshpass -p for password-based SSH automation
+ Apply here-string (<<<) for efficient variable piping
```

### Quick Reference

| Task | Command |
|------|---------|
| Store command output | `var=$(command)` |
| JQ raw string | `jq -r '.path.to.key'` |
| Silent curl | `curl -s URL` |
| SSH with password | `sshpass -p "$pass" ssh user@host "command"` |
| Here-string | `jq '...' <<< "$var"` |

### Expert Insight

> [!IMPORTANT]
> **Security Warning:** Never hardcode credentials in scripts. Always fetch from secure credential stores or environment variables in production.

> [!NOTE]
> **Real-World Application:** This pattern applies to DevOps automation where scripts need to authenticate against multiple remote servers without interactive password prompts.

**Expert Path:**
- Replace REST API credential fetching with HashiCorp Vault or AWS Secrets Manager
- Implement error handling for failed API calls and SSH connections
- Add logging for script execution tracking

**Common Pitfalls:**
- Forgetting `-r` flag results in quoted strings passed to SSH
- Multiple API calls increase latency and API rate limit risks
- Hardcoding credentials violates security best practices

</details>
