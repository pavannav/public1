# Day-08 Assignments: Variable Scope, Advanced Function Arguments, and File Operations

## Topics Covered
- **Variable Scope**: Global vs Local variables, `global` keyword, mutable object behavior
- **Function Arguments**: Default arguments, `*args` (dynamic arguments), `**kwargs` (keyword arguments)
- **File Operations**: Introduction to working with external files

---

## Beginner Level

### Exercise 1: Understanding Local Scope
Create a function that:
- Defines a local variable `x = 10` inside the function
- Tries to print `x` outside the function
- Observe and explain the error that occurs

### Exercise 2: Global Variable Access
Create a global variable `counter = 0` and:
- Create a function that tries to increment counter
- Explain why it fails without using `global` keyword
- Fix it by declaring the variable as global inside the function

### Exercise 3: Default Arguments Practice
Create a function `calculate_discount(price, discount=10)` that:
- Calculates discounted price
- Uses default 10% discount if not specified
- Test with and without providing discount parameter

### Exercise 4: Simple *args Usage
Create a function `sum_all(*numbers)` that:
- Accepts any number of arguments
- Returns their sum
- Test with 2, 3, and 5 arguments

### Exercise 5: File Creation
Create a Python script that:
- Creates a new text file named "greeting.txt"
- Writes "Hello, Python!" to it
- Closes the file properly

---

## Intermediate Level

### Exercise 6: Global vs Local Confusion
Analyze and fix this code:
```python
x = 5

def modify_x():
    x = x + 1  # Error here
    return x

print(modify_x())
```
- Explain the error
- Provide two different solutions

### Exercise 7: Mutable Global Objects
Create a global list `items = []` and:
- Create a function that appends items to the list
- Test without using `global` keyword
- Explain why it works for lists but not for integers

### Exercise 8: Mixed Arguments
Create a function with this signature:
```python
def create_profile(name, age, *hobbies, city="Unknown"):
```
- Test with different argument combinations
- Explain the order requirements

### Exercise 9: *args with Type Checking
Create `find_max(*numbers)` that:
- Accepts only numbers using *args
- Returns the maximum value
- Handles the case when no arguments provided

### Exercise 10: Basic File Writing
Write a program that:
- Creates "students.txt"
- Writes 3 student names, each on a new line
- Uses proper file handling with `with` statement

### Exercise 11: Reading File Content
Given a file "data.txt" with content:
```
Line 1: Python
Line 2: Programming
Line 3: Course
```
- Read and print all lines
- Count total lines
- Print only even-numbered lines

### Exercise 12: **kwargs Introduction
Create a function `build_query(**filters)` that:
- Accepts any keyword arguments
- Prints each key-value pair
- Test with different filter combinations

---

## Advanced Level

### Exercise 13: Scope Chain Challenge
Analyze this nested function scenario:
```python
x = "global"

def outer():
    x = "outer"
    def inner():
        # What happens in each case?
        print(x)  # Case 1
        # x = "inner"  # Case 2 - uncomment and test
    inner()

outer()
```
- Test all scenarios
- Explain the output for each case

### Exercise 14: Global Counter System
Create a system with:
- Global `call_count = 0`
- Multiple functions that increment this counter
- A reset function using `global`
- Track function calls across your program

### Exercise 15: Flexible Calculator with *args
Create `calculator(operation, *numbers)` that:
- Supports 'add', 'multiply', 'average'
- Uses *args for numbers
- Returns appropriate results
- Handles edge cases

### Exercise 16: Configuration with **kwargs
Create `connect_to_db(**config)` that:
- Accepts host, port, user, password via kwargs
- Provides default values
- Validates required parameters
- Returns connection string

### Exercise 17: Function Argument Order
Create a master function demonstrating:
```python
def master_func(a, b, c=3, *args, **kwargs):
```
- Experiment with different calling patterns
- Document which patterns work and which don't

### Exercise 18: File Logger
Create a logging system that:
- Writes function name, arguments, and timestamp to "log.txt"
- Uses *args and **kwargs to capture any function call
- Appends to existing file without overwriting

### Exercise 19: Student Database with Files
Create a system that:
- Stores student data in "students.json-like" format in a text file
- Reads student records
- Adds new students
- Searches by name or ID

### Exercise 20: Recursive Function with Global
Create a recursive counter that:
- Uses a global variable to track depth
- Prints indentation based on depth
- Resets properly after completion

---

## Expert Level

### Exercise 21: Scope Debugging Challenge
Debug this complex scope scenario:
```python
data = {"count": 0, "items": []}

def process_data(new_item, increment=True):
    if increment:
        data["count"] += 1
    data["items"].append(new_item)

    def validate():
        if len(data["items"]) > data["count"]:
            data["count"] = len(data["items"])

    validate()
    return data.copy()

# Analyze memory behavior
```
- Explain which operations affect global data
- Create test cases demonstrating the behavior

### Exercise 22: Dynamic Function Factory
Create `create_multiplier(*factors)` that:
- Returns a function that multiplies input by all factors
- Uses closure with *args
- Implements both global and local state options

### Exercise 23: Advanced File Operations
Build a CSV-like file handler that:
- Writes structured data using **kwargs
- Reads and parses back into dictionaries
- Handles missing fields with defaults
- Supports append mode

### Exercise 24: Configuration Manager
Create a configuration system using:
- Global config dictionary
- Functions to load/save from file
- *args for required settings
- **kwargs for optional settings
- Validation of all settings

### Exercise 25: Function Introspection Tool
Create a decorator-like function that:
- Accepts any function using *args, **kwargs
- Logs all arguments passed
- Counts function invocations globally
- Writes analysis to a file

---

## Challenge Problems

### Challenge 1: Variable Scope Analyzer
Write a program that:
- Parses Python code (as string)
- Identifies all variable scopes
- Reports global vs local variables
- Detects potential scope issues
- Outputs analysis to a file

### Challenge 2: Universal Function Wrapper
Create `universal_wrapper(*args, **kwargs)` that:
- Wraps any function call
- Tracks all invocations globally
- Logs to file with timestamps
- Provides statistics on demand

### Challenge 3: File-Based State Machine
Implement a state machine that:
- Stores state in a file
- Uses global variables for current state
- Supports multiple states via **kwargs
- Persists state between program runs

### Challenge 4: Dynamic Configuration System
Build a system that:
- Loads config from multiple files
- Merges configurations using *args
- Overrides with **kwargs
- Validates and writes final config
- Maintains audit log

### Challenge 5: Advanced Function Registry
Create a function registry that:
- Registers functions with metadata via **kwargs
- Stores registrations in a file
- Allows calling by name with *args
- Tracks usage statistics globally
- Generates usage report on demand

---

## Additional Practice

### Key Concepts Summary

**Variable Scope:**
```python
# Global
x = 10

def func():
    global x  # Required to modify
    x = 20    # Now modifies global

def func2():
    x = 30    # Creates local x
```

**Function Arguments Order:**
```python
def func(a, b, c=1, *args, **kwargs):
    pass
```

***args behavior:**
```python
def sum_all(*numbers):
    # numbers is a tuple
    return sum(numbers)

sum_all(1, 2, 3, 4, 5)  # Returns 15
```

***\*kwargs behavior:*
```python
def config(**settings):
    # settings is a dictionary
    for key, value in settings.items():
        print(f"{key}: {value}")

config(host='localhost', port=8080)
```

### File Operations Basics
```python
# Writing
with open('file.txt', 'w') as f:
    f.write('content')

# Reading
with open('file.txt', 'r') as f:
    content = f.read()

# Appending
with open('file.txt', 'a') as f:
    f.write('more content')
```

### Tips
1. Always use `global` keyword before modifying global variables
2. Remember argument order: positional → default → *args → **kwargs
3. Mutable global objects (lists, dicts) behave differently than immutable ones
4. Always use `with` statement for file operations
5. Test functions with various argument combinations

Good luck with your assignments!