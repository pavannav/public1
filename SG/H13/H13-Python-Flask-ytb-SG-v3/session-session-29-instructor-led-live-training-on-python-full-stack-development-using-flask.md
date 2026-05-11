# Session 29: Instructor-led Live Training on Python - Full Stack Development using Flask

## Table of Contents
- [Full Stack Development using Flask](#full-stack-development-using-flask)
  - [Overview](#overview)
  - [Key Concepts / Deep Dive](#key-concepts--deep-dive)
    - [Data Collection and Persistence](#data-collection-and-persistence)
    - [Database Management Systems](#database-management-systems)
    - [Python Flask Framework](#python-flask-framework)
    - [Frontend and Backend Integration](#frontend-and-backend-integration)
    - [Creating Tables and Managing Data](#creating-tables-and-managing-data)
  - [Lab Demos](#lab-demos)
    - [Demo 1: Setting Up a Basic Flask App](#demo-1-setting-up-a-basic-flask-app)
    - [Demo 2: Creating Database Tables](#demo-2-creating-database-tables)
    - [Demo 3: Data Insertion and Retrieval](#demo-3-data-insertion-and-retrieval)
    - [Demo 4: Frontend Form Handling](#demo-4-frontend-form-handling)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Full Stack Development using Flask

### Overview
This session focuses on building full-stack web applications using Python's Flask framework. We'll explore how to collect user data through web forms, persist it in databases, and integrate frontend interfaces with backend logic. The instructor emphasizes the importance of data persistence, proper database design, and practical implementation of web applications using Flask for Python developers transitioning to web development.

### Key Concepts / Deep Dive

#### Data Collection and Persistence
Data collection is crucial for web applications, allowing users to input information like names, emails, and additional details through multiple input boxes. Persistence ensures data remains available even after system restarts or program termination. The session covers why data should be stored permanently and how to make it always accessible.

- **Why Data Persistence Matters** 💡
  - Prevents data loss from memory resets or program reboots
  - Allows retrieval and analysis of collected information
  - Enables data-driven decision making in applications

- **Data Flow in Web Apps**:
  `User Browser → Form Submission → Flask Backend → Database Storage → Retrieval for Display`

#### Database Management Systems
Databases are essential for organizing and storing user data. The session discusses different types of data storage and management approaches:

| Storage Type | Description | Advantages | Disadvantages |
|--------------|-------------|------------|--------------|
| File-based | Data stored in plain text or binary files | Simple, no additional setup | Limited scalability, concurrency issues |
| Database Systems | Structured storage with tables, queries | Efficient querying, data integrity, relationships | Requires setup and configuration |
| In-memory | Temporary storage in RAM | Fast access, no persistence | Data lost on restart |

- **Key Concepts in DBMS**:
  - **Fields and Records**: Individual data points (fields) form records (rows)
  - **Primary Keys**: Unique identifiers for records
  - **Operations**: Insert, update, delete, and query data

#### Python Flask Framework
Flask is a lightweight Python web framework perfect for building quick prototypes and full-scale applications. It provides routing, templating, and request handling capabilities.

- **Core Features**:
  - Route decorators for URL mapping
  - Request/response handling
  - Template rendering with Jinja2
  - Session management for user data

- **Advantages of Flask**:
  - Minimal boilerplate code
  - Extensible with various libraries
  - Python-native, easy to integrate

#### Frontend and Backend Integration
Full-stack development requires seamless communication between the user interface (frontend) and server-side logic (backend).

- **Frontend-Backend Interaction**:
  ```mermaid
  graph TD
      A[User Fills Form] --> B[Submit Button Click]
      B --> C[Frontend JavaScript/AJAX]
      C --> D[HTTP POST Request]
      D --> E[Flask Route Handler]
      E --> F[Data Processing]
      F --> G[Database Storage]
      G --> H[Response Sent Back]
      H --> I[Frontend Update/Display]
  ```

- **HTML Forms with Flask** 📝
  - Use Flask-WTF for form handling
  - CSRF protection for security
  - Validation of user inputs

#### Creating Tables and Managing Data
In database-driven applications, tables represent structured data with columns (fields) and rows (records).

- **Table Creation Example**:
  ```sql
  CREATE TABLE users (
      id INTEGER PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(120) UNIQUE NOT NULL,
      dob DATE,
      remarks TEXT
  );
  ```

- **Data Operations**:
  - **CRUD Operations**: Create, Read, Update, Delete
  - Querying with conditions: SELECT by name, filter by remarks
  - Relation management between tables (one-to-many, etc.)

### Lab Demos

#### Demo 1: Setting Up a Basic Flask App
1. Install Flask via pip: `pip install flask`
2. Create `app.py` with basic route:
   ```python
   from flask import Flask

   app = Flask(__name__)

   @app.route('/')
   def home():
       return 'Hello, Flask!'

   if __name__ == '__main__':
       app.run(debug=True)
   ```
3. Run the app: `python app.py`
4. Access via browser at `http://127.0.0.1:5000/`

#### Demo 2: Creating Database Tables
1. Use SQLite for simplicity (install sqlite3 if needed)
2. Create tables script:
   ```python
   import sqlite3

   conn = sqlite3.connect('userdata.db')
   cursor = conn.cursor()

   cursor.execute('''
   CREATE TABLE IF NOT EXISTS users (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT NOT NULL,
       email TEXT UNIQUE NOT NULL,
       dob TEXT,
       remarks TEXT
   )
   ''')

   conn.commit()
   conn.close()
   ```
3. Run the script to create the database and table

#### Demo 3: Data Insertion and Retrieval
1. Modify Flask app to insert and retrieve data:
   ```python
   from flask import Flask, request, jsonify
   import sqlite3

   app = Flask(__name__)

   def get_db():
       return sqlite3.connect('userdata.db')

   @app.route('/add_user', methods=['POST'])
   def add_user():
       conn = get_db()
       cursor = conn.cursor()
       data = request.json
       cursor.execute('INSERT INTO users (name, email, dob, remarks) VALUES (?, ?, ?, ?)',
                      (data['name'], data['email'], data['dob'], data['remarks']))
       conn.commit()
       conn.close()
       return jsonify({'message': 'User added successfully'})

   @app.route('/get_users')
   def get_users():
       conn = get_db()
       cursor = conn.cursor()
       cursor.execute('SELECT * FROM users')
       users = cursor.fetchall()
       conn.close()
       return jsonify(users)

   if __name__ == '__main__':
       app.run(debug=True)
   ```
2. Test via cURL or Postman
  
#### Demo 4: Frontend Form Handling
1. Create `templates/index.html`:
   ```html
   <!DOCTYPE html>
   <html>
   <head><title>Data Entry Form</title></head>
   <body>
       <h1>User Data Entry</h1>
       <form id="userForm">
           <input type="text" name="name" placeholder="Name" required><br>
           <input type="email" name="email" placeholder="Email" required><br>
           <input type="date" name="dob" placeholder="Date of Birth"><br>
           <textarea name="remarks" placeholder="Remarks"></textarea><br>
           <button type="submit">Submit</button>
       </form>
       <script>
           document.getElementById('userForm').addEventListener('submit', function(e) {
               e.preventDefault();
               const formData = new FormData(this);
               fetch('/add_user', {
                   method: 'POST',
                   body: JSON.stringify({name: formData.get('name'), email: formData.get('email'), dob: formData.get('dob'), remarks: formData.get('remarks')}),
                   headers: {'Content-Type': 'application/json'}
               }).then(response => response.json()).then(data => alert(data.message));
           });
       </script>
   </body>
   </html>
   ```
2. Add template rendering in Flask:
   ```python
   from flask import Flask, render_template

   app = Flask(__name__)

   @app.route('/')
   def index():
       return render_template('index.html')
   ```
3. Access the form, submit data, and verify persistence

## Summary

### Key Takeaways
```diff
+ Data persistence is crucial for maintaining information across sessions
+ Flask provides an easy entry point to full-stack Python development  
+ Databases like SQLite offer simple yet powerful data management
- Avoid storing sensitive data without proper security measures
! Always validate user inputs to prevent SQL injection and data corruption
+ Understanding CRUD operations forms the foundation of data-driven apps
- Don't rely solely on file-based storage for critical applications
```

### Quick Reference
- **Flask Route Structure**: `@app.route('/path', methods=['GET', 'POST'])`
- **Database Connection**: `conn = sqlite3.connect('db_name.db')`
- **Basic CRUD Query**: `SELECT * FROM table_name WHERE condition`
- **Frontend AJAX Call**: `fetch('/route', {method: 'POST', body: JSON.stringify(data)})`

### Expert Insight
**Real-world Application**: Flask apps can be deployed on platforms like Heroku or AWS Elastic Beanstalk for production use, managing user data for e-commerce, social platforms, or enterprise systems.

**Expert Path**: Start with Flask fundamentals, then advance to Flask-RESTful for APIs, Flask-SQLAlchemy for ORM, and authentication with Flask-Security. Practice building complete CRUD applications and study design patterns for scalable backends.

**Common Pitfalls**: 
- ❌ Forgetting to close database connections, leading to memory leaks
- ⚠️ Using client-side JavaScript without sanitizing inputs, risking XSS attacks  
- ❌ Not implementing CSRF protection on forms, vulnerable to cross-site request forgery

**Lesser-Known Facts**: Flask's request object automatically parses incoming data, making form handling seamless. The framework's minimalism encourages understanding web fundamentals deeply.

**Advantages and Disadvantages of Flask for Full-Stack Development**:
- **Advantages**: Lightweight, fast learning curve, extensive ecosystem, Python parallelism benefits
- **Disadvantages**: Less built-in features than Django, requires manual framework selections, community smaller than some alternatives
```python
# KK-CS45-V3
```
