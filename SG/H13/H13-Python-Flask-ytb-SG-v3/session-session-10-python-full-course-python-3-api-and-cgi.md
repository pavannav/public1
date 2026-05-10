# Session 10: Python API and CGI Programming

## Table of Contents
- [Introduction to CGI and API Programming](#introduction-to-cgi-and-api-programming)
  - [Overview](#overview)
  - [Key Concepts / Deep Dive](#key-concepts--deep-dive)
  - [Basic Python Concepts for Web Development](#basic-python-concepts-for-web-development)
  - [CGI Gateway Interface](#cgi-gateway-interface)
  - [API Fundamentals](#api-fundamentals)
  - [Lab Demos: Building a Simple CGI Script](#lab-demos-building-a-simple-cgi-script)
  - [String Interpolation in Python](#string-interpolation-in-python)
  - [Handling Web Inputs and Outputs](#handling-web-inputs-and-outputs)
  - [Code Examples](#code-examples)
- [Summary](#summary)

## Introduction to CGI and API Programming

### Overview
This session covers the fundamentals of Python programming for web development, specifically focusing on Common Gateway Interface (CGI) programming and Application Programming Interfaces (APIs). You'll learn how to create dynamic web applications using Python scripts that run on web servers, handle user inputs from browsers, and interact with external services through APIs. These technologies allow server-side processing of web requests, enabling interactive web applications beyond static HTML and CSS.

### Key Concepts / Deep Dive

#### Basic Python Concepts for Web Development
Python's simplicity and extensive libraries make it ideal for web development. Key concepts include:
- **Variables and Data Types**: Storing and manipulating user input from web forms
- **Functions**: Modular code blocks for processing requests and generating responses
- **String Operations**: Concatenating HTML with dynamic content
- **File I/O**: Reading from and writing to files for data persistence
- **Command Line Operations**: System-level tasks through subprocess module

Python's indentation-based structure ensures clean, readable code that's easily maintainable for web applications.

#### CGI Gateway Interface
<system-reminder>The CGI specification defines how web servers communicate with external programs for dynamic content generation.</system-reminder>

**How CGI Works:**
1. Client sends HTTP request to web server
2. Web server recognizes CGI resource (usually in `/cgi-bin/` directory)
3. Server executes the Python script
4. Script processes input, generates response
5. Response is sent back to client via server

**Environment Variables:**
- `REQUEST_METHOD`: GET, POST, PUT, DELETE
- `QUERY_STRING`: URL parameters for GET requests
- `CONTENT_TYPE`: MIME type of request body
- `CONTENT_LENGTH`: Size of request body in bytes

### Tables
| HTTP Method | Use Case | CGI Handling |
|-------------|----------|--------------|
| GET | Requesting data | Parameters in QUERY_STRING |
| POST | Submitting forms | Data in standard input |
| PUT | Updating resources | Custom handling required |
| DELETE | Removing resources | Custom handling required |

#### API Fundamentals
APIs enable applications to communicate and exchange data. In Python:
- **RESTful APIs**: Representational State Transfer design
- **JSON**: JavaScript Object Notation for data exchange
- **HTTP Status Codes**: 200 OK, 404 Not Found, 500 Internal Server Error

### Lab Demos: Building a Simple CGI Script

#### Demo 1: Basic CGI Hello World
1. **Create a Python CGI script** (`hello.py`):
   ```python
   #!/usr/bin/env python3
   import cgi

   print("Content-type: text/html\n")
   print("<html><body>")
   print("<h1>Hello, World!</h1>")
   print("</body></html>")
   ```

2. **Make executable**:
   ```bash
   chmod +x hello.py
   ```

3. **Configure web server** (Apache example):
   ```
   ScriptAlias /cgi-bin/ /var/www/cgi-bin/
   <Directory "/var/www/cgi-bin">
       AllowOverride None
       Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
       Require all granted
   </Directory>
   ```

4. **Access via browser**: `http://localhost/cgi-bin/hello.py`

#### Demo 2: Processing Form Data
```python
#!/usr/bin/env python3
import cgi

# Parse form data
form = cgi.FieldStorage()

# Generate HTML response
print("Content-type: text/html\n")
print("<html><body>")
print("<h1>Form Response</h1>")

if "name" in form:
    name = form["name"].value
    print(f"<p>Hello, {name}!</p>")
else:
    print("<p>No name provided</p>")

print("</body></html>")
```

#### Demo 3: API Interaction
```python
#!/usr/bin/env python3
import urllib.request
import json

def get_weather(city):
    api_key = "your_api_key_here"
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}"
    
    try:
        with urllib.request.urlopen(url) as response:
            data = json.loads(response.read().decode())
            return data
    except:
        return {"error": "Failed to fetch weather data"}

print("Content-type: application/json\n")
result = get_weather("London")
print(json.dumps(result))
```

### String Interpolation in Python
Python provides several ways to interpolate strings, crucial for dynamic HTML generation:

- **f-strings** (Python 3.6+): `f"My name is {name}"`
- **.format()** method: `"My age is {}".format(age)`
- **`%` operator**: `"Hello, %s" % name`

For web development:
```python
name = "World"
# Preferred in modern Python
greeting = f"<h1>Hello, {name}!</h1>"

# Older but still valid
greeting = "<h1>Hello, %s!</h1>" % name
```

### Handling Web Inputs and Outputs
- **Input Handling**: Via `cgi.FieldStorage()` for GET/POST parameters
- **Output Generation**: Always start with `print("Content-type: mime_type\n")`
- **Error Prevention**: Proper escaping, validation of user inputs
- **Security**: Avoid arbitrary command execution, validate all inputs

### Code Examples
```python
# Complete CGI form processor
#!/usr/bin/env python3
import cgi
import cgitb

cgitb.enable()  # Enable error reporting

print("Content-type: text/html\n")

print("""
<html>
<head><title>Form Example</title></head>
<body>
<h1>Contact Form</h1>
<form method="post" action="">
<p>Name: <input type="text" name="name"></p>
<p>Email: <input type="email" name="email"></p>
<p><input type="submit" value="Submit"></p>
</form>
""")

form = cgi.FieldStorage()

if "name" in form and "email" in form:
    name = form["name"].value
    email = form["email"].value
    print(f"<p>Thank you {name} ({email}) for contacting us!</p>")

print("</body></html>")
```

## Summary

### Key Takeaways
```diff
+ Python is excellent for CGI scripting due to its simplicity and extensive standard library
+ CGI scripts must output proper content-type headers before sending HTML
+ Always validate and sanitize user input to prevent security vulnerabilities
+ APIs enable modular application design and service integration
+ String interpolation in Python can be done via f-strings, .format(), or % operator
- CGI scripts have performance limitations for high-traffic sites
- CGI doesn't maintain state between requests
```

### Quick Reference
- **CGI Shebang**: `#!/usr/bin/env python3`
- **Content Type Header**: `print("Content-type: text/html\n")`
- **Form Parsing**: `form = cgi.FieldStorage()`
- **Value Retrieval**: `form["fieldname"].value`
- **Error Debugging**: `import cgitb; cgitb.enable()`

### Expert Insight

#### Real-world Application
Python CGI is used in:
- **Legacy Systems**: Maintaining existing web applications
- **Educational CMS**: Simple course management systems
- **Data Visualization Dashboards**: Quick prototyping
- **API Gateways**: Lightweight service orchestration

#### Expert Path
1. **Master Web Frameworks**: Graduate to Django/Flask for production apps
2. **API Security**: Implement OAuth2, JWT for authenticated requests
3. **Performance Optimization**: Cache frequently accessed data, use connection pooling
4. **Microservices**: Design APIs that follow REST principles and OpenAPI specs

#### Common Pitfalls
- **Header Issues**: Forgetting content-type or double newlines can cause browser confusion
- **Path Vulnerabilities**: Improper file path handling leads to directory traversal attacks
- **Unicode Problems**: Mishandling international character sets in forms

#### Lesser-Known Facts
- CGI was introduced in 1993 with the first web servers
- Modern frameworks like FastCGI improve upon CGI's process creation overhead
- Python's `wsgiref` module implements server interfaces similar to CGI

### Advantages and Disadvantages of CGI and API Programming

| Advantages | Disadvantages |
|------------|---------------|
| Simple to learn and implement | Process creation overhead |
| Platform-independent | No session/state management |
| Extensible with Python libraries | Limited scalability |
| Direct control over HTTP | Debugging can be challenging |
