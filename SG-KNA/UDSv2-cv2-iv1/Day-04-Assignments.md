# Day-04 Assignments: String Methods, Functions vs Methods, and Introduction to Control Flow

## Learning Objectives
- Master string methods and their applications
- Distinguish between functions and methods
- Understand class properties and their relationship to data types
- Apply advanced operators
- Begin control flow concepts

---

## Beginner Level

### Exercise 1: String Method Identification
**Objective:** Identify and categorize string methods
1. List 10 string methods available in Python
2. For each method, write:
   - Its purpose
   - Required parameters
   - Return type
   - Example usage
3. Create a table categorizing methods as:
   - Text manipulation
   - Search/Find
   - Formatting
   - Case conversion

### Exercise 2: Function vs Method Quiz
**Objective:** Distinguish between standalone functions and methods
Identify each as Function (F) or Method (M):
1. `print("Hello")`
2. `"hello".upper()`
3. `len("hello")`
4. `"hello".strip()`
5. `type(42)`
6. `[1,2,3].append(4)`
7. `str(42)`
8. `"hello".replace("h", "j")`

Explain your reasoning for 3 examples.

### Exercise 3: Basic Strip Operations
**Objective:** Practice strip methods
Given string: `"   Data Science with Python   "`
Perform and document results:
1. Apply `strip()`
2. Apply `lstrip()`
3. Apply `rstrip()`
4. Apply `strip()` then `upper()`
5. Apply multiple methods in sequence

---

## Intermediate Level

### Exercise 4: Method Chaining
**Objective:** Combine multiple string methods
Solve these problems using method chaining:
1. Clean and format: `"  HELLO world  "` → `"Hello World"`
2. Extract domain: `"  user@EMAIL.COM  "` → `"email.com"`
3. Normalize path: `"/Home/User/Docs/"` → `"/home/user/docs"`
4. Create URL slug: `"  Python Data Science Course!  "` → `"python-data-science-course"`

### Exercise 5: Understanding Class Properties
**Objective:** Explore how different data types have different methods
Create a comparison of available methods:
| Data Type | Method Count | Example Methods | Unique Characteristics |
|-----------|-------------|-----------------|----------------------|
| str       | ?           | ?               | ?                    |
| int       | ?           | ?               | ?                    |
| float     | ?           | ?               | ?                    |
| list      | ?           | ?               | ?                    |
| dict      | ?           | ?               | ?                    |

Document your findings with examples.

### Exercise 6: Error Analysis
**Objective:** Understand method applicability
Predict what happens and explain why:
1. `42.strip()`
2. `[1,2,3].upper()`
3. `"hello".append("world")`
4. `3.14.replace("3", "4")`
5. Create error scenarios and their fixes

---

## Advanced Level

### Exercise 7: Custom Method Behavior Analysis
**Objective:** Deep dive into string method internals
1. Implement your own versions of:
   - Custom strip function
   - Custom replace function
   - Custom split function
2. Compare performance with built-in methods
3. Document edge cases handled by built-in methods

### Exercise 8: String Method Applications
**Objective:** Solve real-world problems with string methods
1. **Email Validator**: Check if email is valid using string methods
2. **Password Strength Checker**: Analyze password requirements
3. **Log Parser**: Extract information from log entries
4. **CSV Cleaner**: Handle messy CSV data
5. **HTML Tag Remover**: Strip HTML tags from text

### Exercise 9: Method Discovery
**Objective:** Explore undocumented or lesser-known methods
1. Use `dir()` to explore string methods
2. Find 5 methods not commonly used
3. Research and document their purposes
4. Create practical use cases for each

---

## Expert Level

### Exercise 10: Method Implementation Challenge
**Objective:** Implement string methods from scratch
Implement these methods without using built-in equivalents:
```python
def custom_strip(s, chars=None):
    pass

def custom_replace(s, old, new, count=-1):
    pass

def custom_split(s, sep=None, maxsplit=-1):
    pass
```
Compare your implementations with built-in versions.

### Exercise 11: Performance Optimization
**Objective:** Analyze method performance patterns
1. Benchmark different approaches:
   - Multiple method calls vs chained calls
   - Regex vs string methods for complex patterns
   - Different methods for same task
2. Create performance comparison report
3. Recommend optimal approaches for different scenarios

### Exercise 12: Design a String Utility Class
**Objective:** Create comprehensive string processing tool
Design and implement a `StringUtils` class with:
- Common operations as methods
- Error handling
- Type checking
- Documentation
- Unit tests for each method

---

## Conceptual Understanding

### Exercise 13: Mental Model Building
**Objective:** Develop intuition for method selection
Create decision trees for:
1. When to use each strip variant
2. Choosing between similar methods
3. Method selection based on data characteristics

### Exercise 14: Documentation Analysis
**Objective:** Master Python documentation
1. Navigate Python official documentation
2. Find string method documentation
3. Create quick reference guide
4. Document version differences if any

---

## Practical Projects

### Project A: Text Analyzer
Create a program that:
1. Takes any text input
2. Analyzes using string methods
3. Provides statistics:
   - Word count
   - Character frequency
   - Line analysis
   - Pattern detection

### Project B: Data Cleaner
Build a data cleaning tool for:
1. CSV files with inconsistent formatting
2. Log files with varying formats
3. User input sanitization
4. Batch processing capabilities

### Project C: Method Explorer
Create an interactive tool that:
1. Lists all methods for any data type
2. Shows method signatures
3. Provides examples
4. Allows testing methods

---

## Review Questions

1. Why can't integers use string methods?
2. What's the relationship between a class and its methods?
3. How does Python know which methods belong to which types?
4. What happens in memory when you call a method?
5. Why do some methods return new objects while others modify in place?

## Success Criteria
- [ ] Can identify functions vs methods instantly
- [ ] Master string method chaining
- [ ] Understand class-property relationships
- [ ] Apply appropriate methods for tasks
- [ ] Debug method-related errors effectively

## Notes
- Practice method discovery using `dir()` and `help()`
- Always check method documentation for parameters
- Understand that methods are tightly coupled to their classes
- Focus on understanding "why" not just "how"