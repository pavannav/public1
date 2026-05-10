# Session 9: Python 3 API and CGI

## Table of Contents
- [Return to Course Summary](./00_Course_Summary_Tracker.md)
- [Introduction](#introduction)
- [Voice Control Systems](#voice-control-systems)
- [Programming Interaction Concepts](#programming-interaction-concepts)
- [Python Functions Deep Dive](#python-functions-deep-dive)
- [System Functions and Commands](#system-functions-and-commands)
- [Print Functions and Output](#print-functions-and-output)
- [Password Handling and Security](#password-handling-and-security)
- [Web Programming and CGI](#web-programming-and-cgi)
- [API Integration Basics](#api-integration-basics)
- [Summary](#summary)

## Introduction

### Overview
This session explores Python 3's capabilities for building APIs and CGI (Common Gateway Interface) applications. We'll cover fundamental concepts of web programming, server-side scripting, and creating interactive programs that handle user input and generate dynamic content.

### Key Concepts / Deep Dive
- **Session Flow**: Begins with a welcome back to the Python journey, focusing on practical applications for voice control and programming interactions.
- **Applications**: Discusses how Python can interact with systems like voice control (e.g., alternatives to Google Assistant) and build secured programs.
- **Target Audience**: Programming students and developers seeking to create interactive systems.
- **Environment Setup**: Working with Python modules for input/output operations.

### Connections
- Builds upon previous sessions on basic Python concepts.
- Bridges into advanced web development topics.

## Voice Control Systems

### Overview
Voice control systems in Python enable natural language processing and interaction without traditional input methods. This session demonstrates creating programs that respond to voice commands and integrate with speech recognition.

### Key Concepts / Deep Dive
- **Voice Interaction**: Programs listen to voice input and execute actions based on commands.
- **Integration Challenges**: Handling audio input, processing speech, and avoiding external dependency on commercial assistants.
- **Example Applications**: Custom voice controllers for home automation, educational tools, or accessibility features.
- **Python Libraries**: Using modules like `speech_recognition` for voice input processing.

### Code/Config Blocks
Basic structure for voice control:
```python
import speech_recognition as sr

# Initialize recognizer
recognizer = sr.Recognizer()

# Capture voice input
with sr.Microphone() as source:
    print("Listening...")
    audio = recognizer.listen(source)
    
try:
    command = recognizer.recognize_google(audio).lower()
    print(f"You said: {command}")
    # Process command here
except sr.UnknownValueError:
    print("Could not understand audio")
```

> [!NOTE]  
> Voice recognition requires microphone access and internet connectivity for cloud-based services like Google.

## Programming Interaction Concepts

### Overview
Interactive programming involves creating programs that accept user input, process it, and provide meaningful output. This session covers input methods beyond keyboard, including voice and system interactions.

### Key Concepts / Deep Dive
- **Input Types**: Keyboard, voice, file-based, and network inputs.
- **Processing Logic**: Validating user input, handling errors, and generating responses.
- **Visibility in Programming**: Understanding how programs display information and maintain security.
- **Real-world Use**: Building login systems, data entry forms, and command-line tools.

### Tables
| Input Method | Python Module | Use Case |
|--------------|---------------|----------|
| Keyboard | `input()` | User prompts |
| Voice | `speech_recognition` | Voice commands |
| File | `open()` | Data import |
| Network | `requests` | API calls |

## Python Functions Deep Dive

### Overview
Functions are core building blocks in Python. This session examines system functions, custom functions, and their role in API/CGI development for handling data processing and responses.

### Key Concepts / Deep Dive
- **System Functions**: Built-in functions like `print()`, `input()`, and `system()`.
- **Custom Functions**: User-defined functions for specific tasks, returning values or processing data.
- **Function Invocation**: Understanding how functions are called and how they interact with variables.
- **Error Handling**: Managing function outputs and preventing failures.

### Code/Config Blocks
Example of a custom function:
```python
def process_command(command):
    if "print" in command:
        print("Processing print command")
        return "Printed successfully"
    elif "exit" in command:
        return "Exiting program"
    else:
        return "Unknown command"

# Usage
result = process_command("print hello")
print(result)
```

- **Output**: `Printed successfully`

## System Functions and Commands

### Overview
System functions allow interaction with the operating system, executing commands and retrieving system information. Critical for CGI programming where server-side operations are needed.

### Key Concepts / Deep Dive
- **System Calls**: Using `os.system()` or `subprocess` for executing shell commands.
- **Command Differences**: Between system functions and user-defined functions (e.g., return values vs. execution).
- **Security Considerations**: Avoiding command injection in web applications.

### Code/Config Blocks
```bash
import os

# List files in directory
os.system("ls")
```

```bash
 import subprocess

# Safer alternative
result = subprocess.run(["ls"], capture_output=True, text=True)
print(result.stdout)
```

> [!WARNING]  
> Use `subprocess` over `os.system()` to prevent security vulnerabilities from command injection.

## Print Functions and Output

### Overview
Print functions handle output display and logging in programs. This session covers formatting, redirection, and integrating print operations in web responses.

### Key Concepts / Deep Dive
- **Print Variations**: Basic `print()`, formatted strings, and file writing.
- **Output Redirection**: Sending print output to files or web response streams.
- **CGI Context**: Using print to generate HTTP responses in web scripts.

### Code/Config Blocks
```python
# Basic print
print("Hello, World!")

# Formatted print
name = "User"
age = 25
print(f"Name: {name}, Age: {age}")

# Print to file
with open('output.txt', 'w') as f:
    print("Data logged", file=f)
```

## Password Handling and Security

### Overview
Secure password management is essential in APIs and CGI applications. This session discusses validation, encryption, and protecting user credentials.

### Key Concepts / Deep Dive
- **Password Input**: Handling user input securely without displaying characters.
- **Validation**: Checking password strength and matching against stored values.
- **Security Practices**: Hashing passwords, avoiding plain-text storage, and preventing unauthorized access.

### Tables
| Security Practice | Python Library | Purpose |
|-------------------|----------------|---------|
| Hashing | `hashlib` | Secure storage |
| Encryption | `cryptography` | Data protection |
| Validation | `getpass` | Hidden input |

### Code/Config Blocks
```python
import getpass
import hashlib

# Secure password input
password = getpass.getpass("Enter password: ")

# Hash the password
hashed = hashlib.sha256(password.encode()).hexdigest()
print(f"Hashed password: {hashed}")
```

> [!IMPORTANT]  
> Never store passwords in plain text. Use strong hashing algorithms like bcrypt for production.

## Web Programming and CGI

### Overview
CGI enables server-side execution of scripts to generate dynamic web content. This session covers setting up CGI scripts in Python for handling web requests and responses.

### Key Concepts / Deep Dive
- **CGI Basics**: Script execution on server, outputting HTML/HTTP headers.
- **Environment Variables**: Accessing request data via `os.environ`.
- **Response Generation**: Formatting proper HTTP responses with status codes.

### Code/Config Blocks
Sample CGI script (save as `script.py` in cgi-bin):
```python
#!/usr/bin/env python3
import cgi
import cgitb
cgitb.enable()

# HTML Header
print("Content-Type: text/html")
print()

# CGI Logic
form = cgi.FieldStorage()
if "name" in form:
    name = form["name"].value
else:
    name = "World"

print(f"<html><body>Hello, {name}!</body></html>")
```

- Configure server (e.g., Apache `.htaccess`):
```
Options +ExecCGI
AddHandler cgi-script .py
```

## API Integration Basics

### Overview
APIs allow communication between applications. This session introduces building simple APIs in Python and integrating with external services.

### Key Concepts / Deep Dive
- **API Types**: RESTful APIs, request/response patterns.
- **Python Frameworks**: Using libraries like Flask or FastAPI for API development.
- **CGI vs. Modern APIs**: CGI for legacy systems, modern frameworks for scalable APIs.

### Code/Config Blocks
Basic API with Flask:
```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/api/users/<user_id>', methods=['GET'])
def get_user(user_id):
    # Mock data
    users = {"1": {"name": "John", "age": 30}}
    user = users.get(user_id, {"error": "User not found"})
    return jsonify(user)

if __name__ == '__main__':
    app.run(debug=True)
```

> [!NOTE]  
> For production, replace mock data with database queries and implement authentication.

## Summary

### Key Takeaways
```diff
+ API development enables application interoperability
+ CGI allows server-side script execution for dynamic web content
+ Voice control interfaces enhance user interaction
+ Security is paramount in password handling and web scripts
! Always validate inputs and use secure communication
- Avoid storing credentials in plain text
```

### Quick Reference
- **Basic CGI Script Structure**:
  - Output headers first: `print("Content-Type: text/html\n")`
  - Process `cgi.FieldStorage()` for form data
  - Generate HTML response

- **Voice Command Processing**:
  - Install `speech_recognition`: `pip install speech_recognition`
  - Use `sr.Recognizer()` for audio capture

- **Password Security**:
  - Use `hashlib.sha256()` for hashing
  - `getpass.getpass()` for hidden input

### Expert Insight
**Real-world Application**: CGI suits simple web scripting; for complex APIs, migrate to frameworks like FastAPI for better performance and scalability. Use voice integration in IoT applications for hands-free control, but ensure fallback to text input for accessibility.

**Expert Path**: Master HTTP standards, study OAuth for authentication, and practice secure coding. Experiment with microservices architecture to scale API applications.

**Common Pitfalls**: Ignoring input sanitization leads to injection attacks; forgetting HTTP headers causes "500 Internal Server Error". Test CGI scripts thoroughly as they run in web environment.

**Lesser-Known Facts**: CGI scripts can process multipart forms directly; voice recognition works offline with libraries like `pocketsphinx`. APIs often use rate limiting to prevent abuse.

**Advantages and Disadvantages**:
- **CGI Advantages**: Simple setup, language-agnostic, direct server integration.
- **CGI Disadvantages**: Performance overhead per request, security risks if malformed.
- **API Advantages**: Structured data exchange, stateless operations, better scaling.
- **API Disadvantages**: Requires more infrastructure than CGI for full benefits.

---

**Transcript Corrections**:
- Multiple instances of "subsribe" corrected to "subscribe" throughout.
- "ஜ்கங்த" interpreted as "back" in context.
- "htp" patterns not found; assumed "http" in technical references but none explicit.
- Incomprehensible phrases like "झाल" translated to logical breaks based on context (welcome messages).
- No major factual errors detected; transcript appears as voice-to-text conversion with Hindi intrusions.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
