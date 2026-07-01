# Day-06 Assignments: Non-Primitive Data Types

## Topics Covered
- Lists: Properties, Methods (append, pop, remove, insert), Indexing (positive/negative), length()
- Dictionary: Key-value pairs, Access methods, keys()
- Sets: Unique elements, add(), unordered nature

---

## Beginner Level

### Exercise 1: Basic List Operations
Create a list called `shopping_list` with the following items: "milk", "bread", "eggs", "butter"
- Add "cheese" to the end of the list
- Remove the first item from the list
- Print the final list and its length

### Exercise 2: Dictionary Basics
Create a dictionary called `student` with keys: name, age, grade
- Add a new key "city" with value "Mumbai"
- Access and print the student's name
- Print all the keys in the dictionary

### Exercise 3: Set Creation
Create a set with the following elements: 1, 2, 2, 3, 3, 3, 4
- Add the number 5 to the set
- Print the set and observe what happens with duplicates

---

## Intermediate Level

### Exercise 4: List Indexing Challenge
Given the list: `numbers = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]`
- Access the 5th element using both positive and negative indexing
- Create a new list containing only the last 3 elements using negative indexing
- Replace the element at index 2 with 25

### Exercise 5: Dictionary Student Database
Create a dictionary to store information about 3 students:
```python
students = {
    "STU001": {"name": "Rahul", "marks": 85, "subject": "Math"},
    "STU002": {"name": "Priya", "marks": 92, "subject": "Science"},
    "STU003": {"name": "Amit", "marks": 78, "subject": "English"}
}
```
- Add a new student STU004
- Update Priya's marks to 95
- Print all student names using the keys() method

### Exercise 6: Set Operations Practice
Create two sets:
- `set_a = {1, 2, 3, 4, 5}`
- `set_b = {4, 5, 6, 7, 8}`
- Convert set_a to a sorted list
- Find the length of set_b after adding duplicate values

---

## Advanced Level

### Exercise 7: Complex List Manipulation
Create a nested list representing a 3x3 matrix:
```python
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
```
- Access the center element (5) using nested indexing
- Replace the last row with [10, 11, 12]
- Calculate the sum of all elements using list operations

### Exercise 8: Dictionary with List Values
Create a dictionary where each key represents a department and values are lists of employees:
```python
company = {
    "IT": ["John", "Sarah", "Mike"],
    "HR": ["Lisa", "David"],
    "Finance": ["Emma", "James", "Robert", "Anna"]
}
```
- Add a new employee "Tom" to the IT department
- Find which department has the most employees
- Create a new key "Marketing" with an empty list

### Exercise 9: Set for Unique Data Processing
Given a list with many duplicates:
```python
data = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5]
```
- Convert to set to remove duplicates
- Sort the unique elements
- Calculate how many duplicates were removed for each number

---

## Expert Level

### Exercise 10: Real-World Application - Contact Manager
Build a contact management system using dictionaries:
- Each contact should have: name, phone, email, tags (list)
- Implement functions to:
  - Add new contact
  - Search contact by name
  - Add tags to existing contacts
  - Get all unique tags across all contacts (using sets)

### Exercise 11: Data Structure Conversion
Given:
```python
raw_data = [
    ("apple", 5),
    ("banana", 3),
    ("apple", 2),
    ("orange", 4),
    ("banana", 1)
]
```
- Convert to a dictionary where keys are fruits and values are total quantities
- Create a set of unique fruits
- Sort fruits alphabetically and return as a list

### Exercise 12: Advanced List Processing
Create a list of dictionaries representing sales records:
```python
sales = [
    {"product": "Laptop", "quantity": 5, "price": 999},
    {"product": "Mouse", "quantity": 20, "price": 25},
    {"product": "Laptop", "quantity": 3, "price": 999},
    {"product": "Keyboard", "quantity": 10, "price": 75}
]
```
- Calculate total revenue for each product
- Find the product with highest total sales
- Return results as a sorted dictionary

### Exercise 13: Complex Set Operations
Given two datasets of user IDs:
```python
active_users = {101, 102, 103, 104, 105, 106}
premium_users = {103, 104, 107, 108}
```
- Find users who are both active and premium
- Find users who are active but not premium
- Create a combined sorted list of all unique users

### Exercise 14: Nested Dictionary with Lists
Design an inventory system:
```python
inventory = {
    "warehouse_A": {
        "electronics": ["laptop", "phone", "tablet"],
        "furniture": ["chair", "desk"]
    },
    "warehouse_B": {
        "electronics": ["phone", "watch"],
        "furniture": ["table", "bed", "chair"]
    }
}
```
- Find all unique items across all warehouses (using sets)
- Count total items per category per warehouse
- Add a new warehouse with items

---

## Challenge Problems

### Challenge 1: Merge and Clean Data
You have multiple data sources with inconsistencies:
```python
source1 = [{"id": 1, "name": "John"}, {"id": 2, "name": "Jane"}]
source2 = [{"id": 2, "name": "Jane"}, {"id": 3, "name": "Bob"}]
source3 = [{"id": 1, "name": "John"}, {"id": 4, "name": "Alice"}]
```
- Merge all sources into one list without duplicates
- Sort by ID
- Return unique names as a set

### Challenge 2: Frequency Analyzer
Analyze text frequency using appropriate data structures:
- Count word frequency (use dictionary)
- Find unique words (use set)
- Return top 3 most frequent words as a sorted list

### Challenge 3: Dynamic Data Structure
Create a system that:
- Stores user preferences as a dictionary with list values
- Tracks unique preferences across all users using sets
- Allows adding/removing preferences dynamically
- Provides a sorted view of all possible preferences

---

## Additional Practice

### Quick Reference - Key Methods
**Lists:**
- `append(x)` - Add to end
- `pop([i])` - Remove and return item at index
- `remove(x)` - Remove first occurrence of value
- `insert(i, x)` - Insert at position
- `len()` - Get length

**Dictionary:**
- `keys()` - Get all keys
- `values()` - Get all values
- Direct access: `dict[key]`

**Sets:**
- `add(x)` - Add element
- Auto-removes duplicates
- Unordered collection

### Tips for Solving
1. Always check the length before accessing indices
2. Remember negative indexing starts from -1
3. Dictionary keys must be immutable (strings, numbers, tuples)
4. Sets automatically handle uniqueness
5. Use appropriate data structures for the problem type

Good luck with your practice! Remember to test your code with different inputs.