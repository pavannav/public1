# Session 27: Instructor-led Live Training on Python - Full Stack Development using Flask

## Table of Contents
- [Full Stack Development Using Flask](#full-stack-development-using-flask)
  - [Overview](#overview)
  - [Key Concepts / Deep Dive](#key-concepts--deep-dive)
  - [Code/Config Blocks](#codeconfig-blocks)
  - [Lab Demos](#lab-demos)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Full Stack Development Using Flask

### Overview
Full stack development using Flask involves building web applications with both frontend and backend components using Python. Flask is a lightweight framework that simplifies web development, allowing developers to create RESTful APIs, handle requests, and serve content. This session covers Python proficiency, Flask installation, creating web servers, forms, templates, classes, functions, and integration for production-ready apps. Key prerequisites include basic Python knowledge, focusing on production applications like social media, e-commerce, and data collection platforms. Applications include attendance systems, APIs, and microservices for scalable solutions.

### Key Concepts / Deep Dive
Flask enables full stack development by providing tools for web servers, routing, forms, and templates. Core concepts include:
- **Web Development Basics**: Building dynamic websites for user interaction, data collection, and API-based services.
- **RESTful APIs**: Implementing create, read, update, delete (CRUD) operations for microservices.
- **Full Stack Integration**: Combining frontend (HTML forms) and backend (Python logic) for end-to-end applications.
- **Microservices Architecture**: Breaking applications into smaller, independent services (e.g., authentication, notifications) using REST APIs.
- **Python Fundamentals**: Using functions, classes, and modules for code organization.
- **Deployment and Scaling**: Running apps on built-in servers or production environments like Apache.
- **Common Use Cases**: Social media logins, e-commerce carts, attendance systems, and data analytics platforms.

**Production Applications**:
- Social media platforms for user profiles and interactions.
- E-commerce systems for product management and payments.
- Attendance and machine learning integrations.
- APIs for data exchange between services.

**Framework Details**:
- Flask as a micro-framework for web development.
- Built-in web server for testing and development.
- Support for HTML, CSS, JavaScript on frontend.
- Backend logic in Python with ORM for databases.

> [!NOTE]
> Flask is beginner-friendly but requires understanding of HTTP methods, routing, and basic web protocols.

### Code/Config Blocks
Here are corrected examples based on transcript content (corrections: "htp" assumed to "http", garbled text clarified to standard Python/Flask syntax).

**Installing Flask** (Bash):
```bash
pip install flask
```

**Basic Flask App** (Python):
```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(debug=True)
```

**Creating a Form** (HTML):
```html
<form action="/submit" method="post">
    <input type="text" name="name" placeholder="Enter your name">
    <button type="submit">Submit</button>
</form>
```

**Flask Route with Template** (Python):
```python
from flask import render_template

@app.route('/form')
def show_form():
    return render_template('form.html')
```

**REST API Endpoint** (Python):
```python
from flask import jsonify

@app.route('/api/data', methods=['GET'])
def get_data():
    return jsonify({'message': 'Data retrieved successfully'})
```

**Class in Python** (Python):
```python
class User:
    def __init__(self, name):
        self.name = name

    def greet(self):
        return f'Hello, {self.name}!'
```

### Lab Demos
**Lab 1: Setting Up Flask and Creating a Basic Web Server**
1. Install Flask: Run `pip install flask`.
2. Create a new Python file (e.g., `app.py`).
3. Copy the basic Flask app code above.
4. Run the app: `python app.py`.
5. Open browser to `http://localhost:5000` to view "Hello, World!".

**Lab 2: Building a User Form with Templates**
1. Create a `templates` folder in your project directory.
2. Add `form.html` with the form code above.
3. Update `app.py` with the route and template code.
4. Add a POST route to handle form submission:
   ```python
   @app.route('/submit', methods=['POST'])
   def submit_form():
       name = request.form['name']
       return f'Hello, {name}!'
   ```
5. Run and access `/form` to test input and output.

**Lab 3: Creating a REST API for Data Handling**
1. Extend `app.py` with the API endpoint code.
2. Test with curl or browser: Access `/api/data` for JSON response.
3. Add POST endpoint for creating data (e.g., user profiles).
4. Use classes for data models and functions for processing.

**Lab 4: Full Stack Integration Example**
1. Combine frontend form with backend API.
2. Use JavaScript (e.g., fetch for API calls) in templates.
3. Deploy to a production server like Heroku or use Apache.
4. Add authentication with tokens for secure access.

> [!IMPORTANT]
> Ensure Flask is running on port 5000 by default; change with `app.run(port=5000)`.

## Summary

### Key Takeaways
```diff
+ Flask is a powerful micro-framework for full stack Python web development.
+ Use REST APIs for microservices in production apps like social platforms and e-commerce.
+ Built-in web server simplifies testing without third-party tools.
- Avoid common pitfalls like insecure deployment or unhandled form inputs.
! Master Python classes and functions before advanced Flask features.
```

### Quick Reference
- **Install Flask**: `pip install flask`
- **Run App**: `python app.py`
- **Default URL**: `http://localhost:5000`
- **Routes**: `@app.route('/')` for paths
- **Templates Folder**: `templates/` for HTML files
- **API Methods**: GET, POST, PUT, DELETE

**HTTP Methods Table**:
| Method | Purpose          | Use Case                 |
|--------|------------------|--------------------------|
| GET    | Retrieve data   | Fetch user profiles     |
| POST   | Create data     | Submit forms             |
| PUT    | Update data     | Edit records             |
| DELETE | Remove data     | Delete entries           |

### Expert Insight

#### Real-world Application
In production, Flask powers scalable apps like LinkedIn APIs or IoT data collection. For example, integrate with machine learning for predictive analytics in e-commerce carts, or build attendance systems for schools with POST APIs for check-ins.

#### Expert Path
- Start with basic CLI apps in Python (variables, loops, functions).
- Advance to classes and inheritance for object-oriented design.
- Learn Jinja2 templating deeply for dynamic frontends.
- Practice microservices by building one feature (e.g., user auth) in isolation.
- Deploy on platforms like AWS or DigitalOcean; integrate with databases (SQLAlchemy).

#### Common Pitfalls
- Forgetting to enable CSRF protection on forms leads to security vulnerabilities.
- Running on localhost only; expose ports properly but secure endpoints.
- Neglecting error handling causes app crashes on invalid inputs.
- Over-engineering with too many routes early; start minimal and iterate.

#### Lesser-Known Facts
- Flask's "development server" logs all requests, aiding debugging.
- Apps can run on Raspberry Pi for IoT projects without web server overhead.
- Python's arbitrary execution integrates well with Flask for custom logic.

#### Advantages and Disadvantages
**Advantages**:
- Lightweight and fast to prototype.
- Vast ecosystem: Templates, extensions for auth, DB.
- Beginner-friendly compared to Django.
- Built-in server for quick testing.

**Disadvantages**:
- Lack of built-in admin panel like Django.
- Security requires manual implementation (e.g., HTTPS).
- Scaling demands third-party tools for production.
- Less structure can lead to messy code if not organized. 

🤖 Generated with [Claude Code](https://claude.com/claude-code), <summary>KK-CS45-V3</summary> Co-Authored-By: Claude <noreply@anthropic.com>
