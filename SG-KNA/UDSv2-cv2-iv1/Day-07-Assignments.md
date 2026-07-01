# Day-07 Assignments: String Methods, While Loops, Control Flow, and Functions

## Topics Covered
- **String Methods**: upper(), lower(), title(), capitalize(), swapcase(), strip(), split(), find(), join()
- **While Loops**: Syntax, condition-based iteration, infinite loops
- **Control Flow**: break, continue statements
- **Functions**: User-defined functions with def keyword, function definition vs execution

---

## Beginner Level

### Exercise 1: String Case Manipulation
Given the string: `text = "pYtHoN pRoGrAmMiNg"`
- Convert the entire string to uppercase
- Convert the entire string to lowercase
- Convert to title case (first letter of each word capitalized)
- Capitalize only the first character of the string

### Exercise 2: Basic While Loop
Write a while loop that:
- Prints numbers from 1 to 10
- Stops when the number reaches 10
- Use a counter variable that increments each iteration

### Exercise 3: Simple Function Creation
Create a function called `greet()` that:
- Takes no parameters
- Prints "Hello, Welcome to Python!"
- Call the function to execute it

---

## Intermediate Level

### Exercise 4: String Cleaning with Strip
Given strings with extra spaces:
```python
data1 = "   Hello World   "
data2 = "Python Programming   "
data3 = "   Data Science"
```
- Remove leading and trailing spaces from each
- Print the cleaned versions

### Exercise 5: Split and Process
Given: `sentence = "apple,banana,orange,grape,mango"`
- Split the string by comma to create a list
- Print each fruit on a new line
- Count the total number of fruits

### Exercise 6: Find Position
Given: `email = "student.name@university.edu"`
- Find the position of "@" symbol
- Find the position of ".edu"
- Extract and print the domain name (university.edu)

### Exercise 7: While Loop with Condition
Create a while loop that:
- Asks user to input a password
- Continues asking until user enters "python123"
- Print "Access Granted" when correct password is entered

### Exercise 8: Function with Parameters
Create a function called `calculate_area()` that:
- Takes two parameters: length and width
- Returns the area (length × width)
- Test with different values

### Exercise 9: Using Continue
Given the list: `numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`
- Use a for loop to iterate through numbers
- Skip printing even numbers using continue
- Print only odd numbers

### Exercise 10: Using Break
Write a while loop that:
- Generates random numbers between 1-100
- Stops when it generates the number 50
- Count how many attempts it took

---

## Advanced Level

### Exercise 11: Complex String Processing
Create a function `process_text()` that:
- Takes a string parameter
- Converts it to lowercase
- Removes leading/trailing spaces
- Splits into words
- Joins words with underscore (_)
- Returns the processed string

Test with: `"  Hello Python Programming  "`

### Exercise 12: Password Validator with While
Create a password validation system:
- Must be at least 8 characters
- Must contain at least one number
- Must contain at least one uppercase letter
- Keep asking until valid password is provided
- Use while loop with break when valid

### Exercise 13: Function with Multiple Operations
Create a function `analyze_string()` that:
- Takes a string parameter
- Returns a dictionary with:
  - 'length': length of string
  - 'uppercase_count': count of uppercase letters
  - 'lowercase_count': count of lowercase letters
  - 'digit_count': count of digits

### Exercise 14: Nested Control Flow
Given: `items = ["apple", "skip", "banana", "stop", "cherry", "date"]`
- Iterate through items
- Skip items that say "skip" using continue
- Stop iteration when you see "stop" using break
- Print remaining items in uppercase

### Exercise 15: Function with Default Parameters
Create a function `create_profile()` that:
- Takes parameters: name, age, city="Unknown"
- Prints a formatted profile
- Test with and without providing city

---

## Expert Level

### Exercise 16: Text Analyzer Application
Build a comprehensive text analyzer:
```python
def text_analyzer(text):
    # Count words, sentences, characters
    # Find most frequent word
    # Return statistics as dictionary
```
- Handle multiple spaces and punctuation
- Use string methods extensively
- Implement using functions and loops

### Exercise 17: Interactive Menu System
Create an interactive menu using while loop:
```
Menu:
1. Add item
2. Remove item
3. View items
4. Exit
```
- Use while True for continuous operation
- Use break to exit
- Store items in a list
- Implement each option as a function

### Exercise 18: Data Validation Functions
Create multiple validation functions:
```python
def validate_email(email):
    # Must contain @ and .
    # Return True/False

def validate_phone(phone):
    # Must be 10 digits
    # Return True/False

def validate_age(age):
    # Must be between 0-120
    # Return True/False
```
- Create a main function that uses all validators
- Use while loop until all inputs are valid

### Exercise 19: Pattern Generator with Functions
Create functions to generate patterns:
```python
def generate_triangle(rows):
    # Print right-angled triangle

def generate_pyramid(rows):
    # Print pyramid pattern
```
- Use nested loops
- Control with break/continue if needed

### Exercise 20: String Manipulation Pipeline
Build a text processing pipeline:
```python
def clean_text(text):
    # Remove extra spaces, convert to lowercase

def extract_keywords(text):
    # Split, remove common words, return list

def format_output(keywords):
    # Join with specific format, add numbering
```
- Chain multiple functions together
- Process sample paragraphs

---

## Challenge Problems

### Challenge 1: Number Guessing Game
Create a number guessing game:
- Computer picks random number (1-100)
- User has 7 attempts maximum
- Provide hints (too high/too low)
- Track attempts and provide feedback
- Use while loop, break, and functions

### Challenge 2: CSV Parser
Given CSV-like string:
```
name,age,city
John,25,New York
Jane,30,London
```
- Parse using split()
- Validate each field
- Store as list of dictionaries
- Create functions for each operation

### Challenge 3: Command Line Calculator
Build a calculator that:
- Takes continuous input until "exit"
- Supports +, -, *, /
- Handles errors gracefully
- Uses functions for each operation
- Implements using while loop with break

### Challenge 4: Word Frequency Counter
Analyze text for word frequency:
- Convert to lowercase
- Remove punctuation
- Count each word occurrence
- Sort by frequency
- Return top 10 words
- Implement entirely with functions

### Challenge 5: State Machine Simulator
Create a simple state machine:
- States: START, PROCESSING, PAUSED, END
- Use while loop to maintain state
- Functions to transition between states
- break/continue to control flow
- User input determines state changes

---

## Additional Practice

### Quick Reference - String Methods
```python
text.upper()        # Convert to uppercase
text.lower()        # Convert to lowercase
text.title()        # Title case
text.capitalize()   # First character capital
text.swapcase()     # Swap cases
text.strip()        # Remove whitespace
text.split(',')     # Split by delimiter
text.find('x')      # Find position (-1 if not found)
','.join(list)      # Join list elements
```

### Quick Reference - Control Flow
```python
while condition:    # Loop while true
    # code
    break           # Exit loop entirely
    continue        # Skip to next iteration

for item in list:
    if condition:
        break       # Stop iteration
    if condition:
        continue    # Skip current item
```

### Quick Reference - Functions
```python
def function_name(parameters):
    """Docstring"""
    # code
    return value    # Optional return

# Function definition vs call
def greet():        # Definition
    print("Hi")

greet()             # Call/Execution
```

### Tips
1. Always validate user input in while loops
2. Use meaningful function names that describe their purpose
3. Remember: break exits the loop, continue skips to next iteration
4. Functions should do one thing well
5. Test functions with different input types

Good luck with your assignments!