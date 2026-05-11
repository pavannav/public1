# Session 06: Python Full Course - Python 3 API and CGI

## Table of Contents
1. [Overview](#overview)
2. [Key Concepts](#key-concepts)
   - [Linux System Basics](#linux-system-basics)
   - [Python Programming Fundamentals](#python-programming-fundamentals)
   - [CGI and API Concepts](#cgi-and-api-concepts)
   - [HTML Form Elements](#html-form-elements)
   - [Web Development Integration](#web-development-integration)
3. [Lab Demos](#lab-demos)
4. [Summary](#summary)
   - [Key Takeaways](#key-takeaways)
   - [Quick Reference](#quick-reference)
   - [Expert Insight](#expert-insight)

## Overview

This session provides an introduction to Python 3 programming with a focus on API and CGI development. It covers essential concepts for building web applications using Python as the backend language, including system administration basics on Linux, fundamental Python constructs, and web interface integration through Common Gateway Interface (CGI) and Application Programming Interfaces (APIs). The session emphasizes practical application development for interactive web services.

## Key Concepts

### Linux System Basics

#### System Login and Navigation
- **Terminal Access**: After powering on a Linux system, users access the terminal using root or user accounts. This provides command-line interface for system operations.
- **Directory Structure**: The root directory is denoted `/`. The home directory for users contains personal files. Commands like `ls` list contents, `pwd` shows present location, and `cd` changes directories.

#### Basic Commands and Monitoring
```bash
# List files in current directory
ls

# Check system information
uname -a

# Monitor system processes
top

# Check memory usage
free -h

# View storage information
df -h
```

#### File Permissions
- File permissions control read, write, and execute access for owner, group, and others.
- Use `chmod` to modify permissions and `chown` to change ownership.

### Python Programming Fundamentals

#### Language Overview
Python serves as a high-level, interpreted programming language ideal for web development, data processing, and automation. It's widely used in professional environments for its simplicity and extensive libraries.

#### Memory Management and Algorithms
- **Time Complexity**: Understanding execution efficiency is crucial for scalable applications. Poor algorithms can lead to memory waste and slow performance.
- **Data Structures**: Proper use of variables, lists, and dictionaries optimizes memory usage.

### CGI and API Concepts

#### Common Gateway Interface (CGI)
CGI enables web servers to execute programs and generate dynamic content. Python CGI scripts process user input and produce HTML output for web browsers.

#### APIs and Web Services
APIs provide programmatic interfaces for application communication:
- **HTTP Methods**: GET (retrieve data), POST (send data), PUT (update), DELETE (remove)
- **Request/Response Cycle**: Client sends requests, server processes through CGI/API and returns responses

#### Web Forms and Data Handling
- Forms collect user input through HTML elements
- Backend processes this data, validates it, and stores/retrieves from databases
- Integration with database systems for persistent data storage

### HTML Form Elements

#### Input Types
- **Text Fields**: Single-line input for names, emails, etc.
```html
<input type="text" name="username" placeholder="Enter username">
```

- **Radio Buttons**: Single selection from multiple options
```html
<input type="radio" name="gender" value="male"> Male
<input type="radio" name="gender" value="female"> Female
```

- **Checkboxes**: Multiple selections allowed
```html
<input type="checkbox" name="interests" value="python"> Python
<input type="checkbox" name="interests" value="web"> Web Development
```

#### Form Submission
```html
<form action="/cgi-bin/process.py" method="post">
  <!-- form elements -->
  <input type="submit" value="Submit">
</form>
```

### Web Development Integration

#### Python-Web Frameworks
- Frameworks like Flask or Django bridge Python backend with HTML/CSS/JS frontend
- Enable creation of interactive web applications

#### Networking and Internet Protocols
- **IP Addresses and URLs**: Unique identifiers for network communication
- **Web Browsers and Servers**: Browsers render HTML, servers host CGI scripts and APIs

#### Database Integration
- Python connects to databases (MySQL, PostgreSQL) to store and retrieve data
- SQL queries executed through Python database connectors

#### Multimedia and Advanced Features
- Handling images, videos, and files in web applications
- Session management and user authentication

## Lab Demos

### CGI Script Example
```python
#!/usr/bin/env python3
import cgi

# CGI script header
print("Content-type: text/html\n")

# Process form data
form = cgi.FieldStorage()
name = form.getvalue('name', 'Anonymous')

# HTML output
print("""
<html>
<body>
<h1>Hello, {}</h1>
<p>Welcome to Python CGI!</p>
</body>
</html>
""".format(name))
```

### Simple Web API
```python
from flask import Flask, jsonify
import json

app = Flask(__name__)

@app.route('/api/data', methods=['GET'])
def get_data():
    return jsonify({'message': 'This is API data', 'status': 'success'})

if __name__ == '__main__':
    app.run(debug=True)
```

### HTML Form Integration
```html
<!DOCTYPE html>
<html>
<head>
    <title>Python CGI Form</title>
</head>
<body>
    <h2>User Registration</h2>
    <form action="/cgi-bin/register.py" method="post">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" required><br><br>
        
        <label for="email">Email:</label>
        <input type="email" name="email" id="email" required><br><br>
        
        <input type="radio" name="subscription" value="basic"> Basic
        <input type="radio" name="subscription" value="premium"> Premium<br><br>
        
        <input type="checkbox" name="newsletter" value="yes"> Subscribe to newsletter<br><br>
        
        <input type="submit" value="Register">
    </form>
</body>
</html>
```

## Summary

### Key Takeaways

```diff
+ Python 3 provides powerful capabilities for web development through CGI and API frameworks
- Avoid inefficient algorithms that waste memory and impact performance
! Mastering HTML form elements is essential for user interaction in web applications
+ System administration knowledge is crucial for deploying Python web applications on Linux servers
- Ensure proper file permissions when deploying CGI scripts for security
+ Integrate databases early in web application development for data persistence
```

### Quick Reference

**System Commands:**
- `ls`: List directory contents
- `cd`: Change directory  
- `pwd`: Show current directory
- `top`/`htop`: Monitor processes
- `chmod`: Change file permissions

**Python CGI Essentials:**
- Print `Content-type: text/html\n` first
- Use `cgi.FieldStorage()` for form data
- Output HTML through print statements

**Common HTTP Methods:**
- GET: Retrieve data
- POST: Send data (secure)
- PUT: Update data
- DELETE: Remove data

**Flask API Basics:**
```python
from flask import Flask, jsonify
app = Flask(__name__)
@app.route('/endpoint')
def function():
    return jsonify({'data': 'value'})
```

### Expert Insight

#### Real-world Application
Python CGI and APIs power modern web services like e-commerce platforms, social media, and IoT dashboards. Production deployments use frameworks like Django for scalability, with databases like PostgreSQL for data integrity. These technologies enable dynamic web experiences across industries from healthcare to finance.

#### Expert Path
Advance by studying Django/Flask frameworks, RESTful API design, and containerization with Docker. Practice building full-stack applications, implement authentication systems, and explore microservices architecture. Focus on performance optimization, security best practices, and unit testing.

#### Common Pitfalls
- Storing sensitive data (passwords, keys) in plain text instead of using environment variables
- Neglecting input validation leading to security vulnerabilities
- Improper error handling causing application crashes
- Overlooking session management resulting in security breaches

#### Lesser-Known Facts
- CGI scripts spawn new processes per request, making them resource-intensive compared to modern frameworks
- Python's `urllib` library enables API calls without external dependencies
- Many web servers pre-compile CGI scripts for better performance
- Python's WSGI standard bridged CGI limitations to modern web frameworks

#### Advantages and Disadvantages

**Advantages:**
- Rapid prototyping and development
- Extensive standard library
- Platform independence
- Strong community support

**Disadvantages:**
- CGI's process model can be slow for high traffic
- Global Interpreter Lock limits threading in some scenarios
- Version compatibility issues (Python 2.7 vs 3.x)
- Memory usage in long-running applications

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
