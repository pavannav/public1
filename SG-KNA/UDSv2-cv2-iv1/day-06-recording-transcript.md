<details open>
<summary><b>Day 06: Non-Primitive Data Types, List Methods & Dictionary Fundamentals (KK-CS45-script-v2-Inst-v1)</b></summary>

# Session 6: Non-Primitive Data Types, List Methods & Dictionary Fundamentals

## Table of Contents
1. [Overview](#overview)
2. [Class Resources & Course Organization](#class-resources--course-organization)
3. [Non-Primitive Data Types Introduction](#non-primitive-data-types-introduction)
4. [List Data Type Deep Dive](#list-data-type-deep-dive)
5. [Dictionary Data Type Fundamentals](#dictionary-data-type-fundamentals)
6. [Tuple & Mutable/Immutable Concepts](#tuple--mutableimmutable-concepts)
7. [Summary & Key Takeaways](#summary--key-takeaways)

## Overview

This comprehensive session focuses on non-primitive data types in Python, beginning with resource access training and then diving deep into Lists and Dictionaries - two critical data structures for any Python developer. The instructor emphasizes practical understanding, real-world analogies, and addresses common beginner misconceptions about data structures, indexing, and when to use each type.

**Key Focus Areas:**
- Resource navigation in the learning platform
- List properties, methods (append, pop, remove, insert), and indexing concepts
- Dictionary key-value pairs, access methods, and real-world applications
- Mutable vs immutable concepts introduction
- Practical problem-solving approaches for data structure selection

## Class Resources & Course Organization

### Learning Management System (LMS) Resource Access

The instructor demonstrates how to access course resources through the learning platform:

```bash
# Resource Access Path:
Courses → Krishna Academy → Batch 02 → [Your Course] → Resources Section
```

**Key Platform Features:**
- **Mentor 1 Reference**: Direct resource links maintained during live sessions
- **Announcement Section**: Important updates, holidays, and course information
- **FAQ Section**: Class timings, doubt session policies, curriculum details
- **Multiple Timezone Support**: UTC+5:30 (IST), EST, GMT, SDT timings documented

**Resource Format:**
```yaml
Class Date: [Date]
Topics: [Session Topics]
Drive Links: [Google Drive Resource Links]
```

> [!IMPORTANT]
> Resources are maintained only during the instructor's active teaching period. Always save locally.

## Non-Primitive Data Types Introduction

### Classification Overview

Python data types are categorized as:

| Primitive Types | Non-Primitive Types |
|-----------------|---------------------|
| Integer (int) | List |
| Float | Dictionary (dict) |
| String (str) | Tuple |
| Boolean (bool) | Set |

### Purpose of Non-Primitive Types

Non-primitive data types provide efficient ways to handle complex data scenarios:

```python
# Problem: Managing multiple related values efficiently
# Solution: Use appropriate data structures

# Instead of separate variables:
name1 = "Monal"
name2 = "Rohit"
name3 = "Preetam"

# Use lists for ordered collections
names = ["Monal", "Rohit", "Preetam"]
```

## List Data Type Deep Dive

### List Properties

Lists in Python have specific characteristics:

```python
# Property 1: Maintains insertion order
L = []
L.append(0)  # [0]
L.append(2)  # [0, 2] - Order preserved

# Property 2: Accepts any data type including duplicates
mixed_list = ["hello", 10, True, "hello", 10]  # Duplicates allowed
```

### List Methods

#### Essential Methods Table

| Method | Purpose | Syntax | Example |
|--------|---------|--------|---------|
| `append()` | Add element to end | `list.append(value)` | `L.append(5)` |
| `pop()` | Remove by index (default: last) | `list.pop([index])` | `L.pop()` or `L.pop(0)` |
| `remove()` | Remove first occurrence by value | `list.remove(value)` | `L.remove("hello")` |
| `insert()` | Insert at specific index | `list.insert(index, value)` | `L.insert(1, 4)` |

#### Practical Examples

```python
# List initialization and basic operations
L = ["hello", "hey", "Python", 10, False]

# Accessing elements
print(L[0])      # "hello" - First element
print(L[-1])     # False - Last element (reverse indexing)
print(L[-2])     # 10 - Second to last

# Length function
print(len(L))    # 5 - Number of elements
print(len("data"))  # 4 - Works with strings too

# Index validation
# final_index = len(L) - 1  # Always length - 1
```

### Indexing Deep Dive

#### Zero-Based Indexing System

```python
# Visual representation:
L = ["hello", "hey", "Python", 10, False]
#      0       1        2      3     4    <- Forward indexing
#     -5      -4       -3     -2    -1    <- Reverse indexing

# Key principle: Index starts from 0, not 1
```

#### Real-World Analogy: Queue System

The instructor uses a queue analogy to explain indexing:
- First person in queue gets token "1" in real world
- First element in list gets index "0" in programming
- Index = position identifier for accessing elements

### Common Indexing Errors

```python
L = ["hello", "hey", "Python", 10, False]

# Error: Index out of range
print(L[5])      # IndexError: list index out of range
print(L[len(L)]) # Error: len(L) = 5, but max index = 4

# Correct approach
print(L[len(L) - 1])  # False - Last element correctly
print(L[-1])          # False - Same result, cleaner syntax
```

## Dictionary Data Type Fundamentals

### Dictionary Concept & Real-World Analogy

Dictionaries store data with labels (keys) rather than positions:

```python
# Real-world register analogy:
# Instead of: ["Monal", "1990-01-01", "1234567890", "Delhi"]
# Use: {"name": "Monal", "dob": "1990-01-01", "phone": "1234567890", "city": "Delhi"}
```

### Dictionary Syntax & Structure

```python
# Basic syntax: {key: value, key: value, ...}
register = {
    "101": ["Monal", "1990-01-01", "1234567890", "Delhi"],
    "102": ["Rohit", "1992-05-15", "9876543210", "Mumbai"],
    "103": ["Preetam", "1988-12-25", "5555555555", "Bangalore"]
}

# Key requirements: Must be unique (string, number, or tuple)
# Value requirements: Can be anything (list, string, number, etc.)
```

### Dictionary Access Methods

#### Two Primary Access Approaches

```python
government_sys = {
    101: ["Monal", "address1", "phone1", "ID1"],
    102: ["Amit", "address2", "phone2", "ID2"],
    103: ["Surya", "address3", "phone3", "ID3"]
}

# Method 1: Direct key access (list-style)
print(government_sys[101])  # Returns value or KeyError if missing

# Method 2: Using .get() method (safer)
print(government_sys.get(101))           # Returns value or None
print(government_sys.get(105, "Value not present"))  # Custom default message
```

### Dictionary Methods

```python
# Essential dictionary methods
print(government_sys.keys())    # Returns all keys as dict_keys object
print(government_sys.values())  # Returns all values as dict_values object

# Type conversion for iteration
keys_list = list(government_sys.keys())      # Convert to list
values_list = list(government_sys.values())  # Convert to list
```

### Key Uniqueness & Hash Concept

```python
# Keys must be unique - duplicate keys overwrite previous values
register = {"Rohit": "data1", "Rohit": "data2"}  # Only keeps "data2"

# Real-world ID system approach:
government_sys = {
    "ID001": ["Monal", "details..."],
    "ID002": ["Rohit", "details..."],
    # Uses unique IDs instead of names to handle duplicates
}
```

## Tuple & Mutable/Immutable Concepts

### Mutable vs Immutable Classification

| Data Type | Mutable? | Can Modify? | Examples |
|-----------|----------|-------------|----------|
| List | Yes | append, pop, modify | `L.append(5)` |
| Dictionary | Yes | add/remove keys | `D["new"] = value` |
| Tuple | No | Cannot modify | Fixed collections |
| String | No | Cannot modify | Immutable sequences |

### Purpose of Immutable Types

```python
# When immutability is beneficial:
# 1. Data integrity - preventing accidental changes
# 2. Hash keys - only immutable types can be dictionary keys
# 3. Thread safety in concurrent programming

# Example: Tuple for coordinates (shouldn't change)
coordinates = (10.5, 20.3)  # Immutable - represents fixed location
```

## Summary & Key Takeaways

### Key Takeaways

```diff
+ Lists maintain insertion order and allow duplicates with zero-based indexing
+ Dictionaries use unique keys for labeled data access, ideal for structured records
+ Use lists for ordered collections, dictionaries for labeled/keyed data
+ .get() method provides safer dictionary access with custom default values
+ Always use unique identifiers (IDs) as dictionary keys for real-world data
+ len() works universally for counting elements in strings, lists, and other iterables
+ Index positions always range from 0 to len()-1, not the length value itself
```

### Quick Reference

```python
# List Operations
L = ["item1", "item2"]
L.append("new")        # Add to end
L.pop()               # Remove last (or by index)
L.remove("value")     # Remove by value
L.insert(1, "value")  # Insert at index
print(L[0], L[-1])    # Access first/last
print(len(L))         # Count elements

# Dictionary Operations
D = {"key": "value"}
D.get("key")          # Safe access (returns None if missing)
D.get("missing", "default")  # With custom default
D.keys()              # All keys
D.values()            # All values
list(D.keys())        # Convert keys to list

# Index Validation
last_index = len(L) - 1  # Always subtract 1 from length
```

### Expert Insights

**Real-world Application:**
- Use dictionaries for user profiles, configuration files, API responses
- Use lists for ordered processing, queues, historical data
- Government systems use unique IDs as dictionary keys to handle duplicate names

**Expert Path:**
- Master list comprehensions for efficient list operations
- Learn dictionary comprehensions and nested dictionaries
- Practice choosing appropriate data structures for specific problems

**Common Pitfalls:**
- Using length instead of length-1 for last index access
- Assuming dictionary keys can be duplicate (they cannot)
- Using mutable objects as dictionary keys (will cause errors)
- Forgetting that list.pop() and list.remove() permanently modify the list

</details>