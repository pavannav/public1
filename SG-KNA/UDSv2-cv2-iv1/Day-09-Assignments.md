# Day-09 Assignments: Advanced File Operations and Exception Handling

## Topics Covered
- **File Operations**: Context managers with statement, reading/writing modes, temporary files
- **Exception Handling**: try/except/finally blocks, specific exceptions (FileNotFoundError, TypeError, ValueError), general Exception class, exception objects

---

## Beginner Level

### Exercise 1: Basic Try-Except
Write code that attempts to divide two numbers and:
- Wraps the division in a try-except block
- Catches ZeroDivisionError
- Prints "Cannot divide by zero" when caught

### Exercise 2: File Reading with Error Handling
Create code that:
- Tries to open "nonexistent.txt" for reading
- Catches FileNotFoundError
- Prints "File does not exist" message

### Exercise 3: Context Manager Practice
Write a program that:
- Uses `with open()` to create "test.txt"
- Writes "Hello World" to it
- Explains why we don't need to close the file explicitly

### Exercise 4: Multiple Except Blocks
Create code that:
- Attempts `int("abc")`
- Catches both ValueError and TypeError
- Provides specific messages for each

### Exercise 5: Finally Block Basics
Write a function that:
- Has try-except-finally structure
- Prints "Starting operation" in try
- Prints "Error occurred" in except
- Prints "Operation completed" in finally
- Test both success and failure cases

---

## Intermediate Level

### Exercise 6: Safe File Reader
Create a function `safe_read(filename)` that:
- Attempts to read the file
- Returns file content if successful
- Returns None and prints error if file not found
- Always prints "File operation attempted" using finally

### Exercise 7: Input Validation with Exceptions
Write a program that:
- Asks for user age as input
- Converts to integer within try block
- Catches ValueError for non-numeric input
- Loops until valid age is provided

### Exercise 8: Nested File Operations
Create a program that:
- Opens "source.txt" and "destination.txt" using nested with statements
- Copies content from source to destination
- Handles FileNotFoundError for both files

### Exercise 9: Exception Information
Write code that:
- Attempts invalid list operation `my_list[100]` where list has 3 items
- Catches IndexError as 'e'
- Prints the exception type and message

### Exercise 10: Calculator with Error Handling
Create a simple calculator that:
- Takes two numbers and operation from user
- Handles division by zero
- Handles invalid operations
- Uses try-except for type conversion

### Exercise 11: Writing Multiple Files
Create a program that:
- Creates 3 files: "file1.txt", "file2.txt", "file3.txt"
- Writes unique content to each
- Uses context managers for all operations
- Handles any potential errors

### Exercise 12: Logging Errors to File
Write a function that:
- Attempts various operations that might fail
- Logs all errors to "error_log.txt"
- Continues execution after logging
- Uses append mode for the log file

---

## Advanced Level

### Exercise 13: Custom Exception Handler
Create a robust data processor that:
- Reads numbers from a file
- Converts strings to integers
- Handles multiple exception types
- Logs problematic lines to separate file
- Continues processing remaining lines

### Exercise 14: File Backup System
Build a backup utility that:
- Takes source and backup filenames
- Creates backup with timestamp
- Handles permission errors
- Uses try-except-finally for cleanup
- Verifies backup was created successfully

### Exercise 15: Configuration File Parser
Create a config parser that:
- Reads key=value pairs from file
- Handles missing config file (create default)
- Validates data types
- Catches and reports parsing errors
- Uses specific exception handling

### Exercise 16: Database Simulation
Simulate database operations with:
- "database.txt" as storage
- Add record function with error handling
- Search record function
- Delete record function
- Proper exception handling for each operation

### Exercise 17: Multi-File Data Merger
Write a program that:
- Reads from multiple data files
- Merges into single output file
- Handles missing files gracefully
- Reports which files failed to merge
- Uses comprehensive exception handling

### Exercise 18: Safe Type Converter
Create `safe_convert(value, target_type)` that:
- Attempts to convert value to target type
- Handles TypeError, ValueError, AttributeError
- Returns converted value or None
- Logs conversion attempts to file

### Exercise 19: Resource Manager
Build a resource manager that:
- Opens multiple files simultaneously
- Processes data across files
- Handles resource exhaustion
- Ensures all files are properly closed using finally
- Implements cleanup procedures

### Exercise 20: Exception Hierarchy Explorer
Write code demonstrating:
- Catching specific exceptions before general ones
- The order of exception matching
- Using Exception as fallback
- Accessing exception attributes (__class__, args)

---

## Expert Level

### Exercise 21: Transaction Manager
Create a file-based transaction system that:
- Supports begin, commit, rollback operations
- Uses temporary files for transaction safety
- Handles system crashes during transactions
- Implements proper exception recovery
- Maintains data integrity

### Exercise 22: API Response Handler
Build a robust API simulator that:
- Makes "requests" that might timeout or fail
- Implements retry logic with exponential backoff
- Logs all failures with context
- Handles different error types differently
- Provides fallback data when all attempts fail

### Exercise 23: Concurrent File Operations
Create a system handling:
- Multiple simultaneous file operations
- File locking mechanisms
- Conflict resolution
- Rollback on partial failures
- Comprehensive error reporting

### Exercise 24: Validation Framework
Design a validation framework that:
- Validates data against multiple rules
- Collects all validation errors (not just first)
- Supports custom validators
- Logs validation results
- Generates validation reports

### Exercise 25: Error Recovery System
Implement an error recovery system that:
- Detects different failure modes
- Attempts automatic recovery
- Escalates when recovery fails
- Maintains operation logs
- Provides diagnostic information

---

## Challenge Problems

### Challenge 1: Robust CSV Processor
Build a CSV processor that:
- Handles malformed CSV files
- Manages different encodings
- Deals with missing or corrupt data
- Validates each row
- Generates detailed error reports
- Recovers from errors to process remaining data

### Challenge 2: File Synchronization Tool
Create a file sync tool that:
- Compares two directories
- Handles permission issues
- Manages file conflicts
- Provides detailed operation logs
- Implements atomic operations
- Recovers from interruptions

### Challenge 3: Exception-Based State Machine
Design a state machine using exceptions:
- Each state transition can raise specific exceptions
- Implements retry and recovery logic
- Maintains state consistency
- Logs all state changes and errors
- Provides rollback capabilities

### Challenge 4: Distributed File Operations
Build a system for:
- Operations across multiple file systems
- Handling network interruptions
- Implementing circuit breakers
- Managing partial failures
- Ensuring consistency across operations

### Challenge 5: Comprehensive Error Analytics
Create an error analytics system that:
- Collects errors from various sources
- Categorizes by type and severity
- Generates statistical reports
- Identifies patterns in failures
- Provides recommendations for fixes
- Exports analysis to multiple formats

---

## Additional Practice

### Key Exception Types to Know
```python
FileNotFoundError    # File doesn't exist
PermissionError      # Access denied
ValueError           # Invalid value
TypeError            # Wrong data type
IndexError           # List index out of range
KeyError             # Dictionary key not found
ZeroDivisionError    # Division by zero
AttributeError       # Object has no attribute
ImportError          # Cannot import module
MemoryError          # Out of memory
```

### Exception Handling Patterns
```python
# Basic
try:
    risky_operation()
except SpecificError:
    handle_specific()

# With exception object
except Exception as e:
    print(e.args)
    print(type(e))

# Multiple exceptions
except (Error1, Error2) as e:
    handle_multiple()

# Full structure
try:
    operation()
except Error1:
    handle_error1()
except Error2:
    handle_error2()
else:
    no_exceptions()
finally:
    cleanup()
```

### Context Manager Benefits
```python
# Automatic resource cleanup
with open('file.txt', 'r') as f:
    content = f.read()
# File automatically closed

# Multiple files
with open('in.txt') as fin, open('out.txt', 'w') as fout:
    fout.write(fin.read())
```

### Tips
1. Always catch specific exceptions before general ones
2. Use context managers (`with` statement) for file operations
3. The `finally` block always executes, even after return statements
4. Log exceptions with context for debugging
5. Don't silently ignore exceptions without good reason

Good luck with your assignments!