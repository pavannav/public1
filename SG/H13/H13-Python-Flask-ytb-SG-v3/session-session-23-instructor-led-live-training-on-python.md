# Session 23: Instructor-led Live Training on Python

## Table of Contents
- [Introduction to Functions](#introduction-to-functions)
- [Defining Functions](#defining-functions)
- [Function Arguments](#function-arguments)
- [Default Values in Functions](#default-values-in-functions)
- [Multiple Values and Lists](#multiple-values-and-lists)
- [Return Statements](#return-statements)
- [Advanced Function Concepts](#advanced-function-concepts)
- [Functional Programming Examples](#functional-programming-examples)
- [Filter and Map Functions](#filter-and-map-functions)
- [Practical Demos](#practical-demos)
- [Summary](#summary)

## Introduction to Functions
This session covers Python functions, a core concept in programming. Functions allow you to encapsulate code for reuse, making programs modular and easier to maintain. We'll explore function definitions, arguments, returns, and advanced functional programming techniques.

Functions in Python are first-class objects, meaning they can be passed as arguments, returned from other functions, and assigned to variables. This enables powerful patterns like higher-order functions and functional programming.

## Defining Functions
To define a function in Python, use the `def` keyword followed by the function name and parentheses.

```python
def function_name():
    # Function body
    pass
```

For example, to create a simple function that prints a message:

```python
def greet():
    print("Welcome to Python programming!")
```

Call the function with `greet()`.

Key points:
- Function names should be descriptive and follow snake_case convention.
- The function body must be indented.
- Functions can contain multiple statements.

## Function Arguments
Functions can accept parameters to make them more flexible. Parameters are defined in parentheses after the function name.

```python
def function_name(parameter1, parameter2):
    # Use parameters in function body
    pass
```

Example:

```python
def add_numbers(a, b):
    return a + b
```

You can pass arguments when calling the function:

```python
result = add_numbers(5, 3)  # result = 8
```

Multiple arguments allow processing different data types:

| Argument Type | Example Usage |
|---------------|---------------|
| Single value | `def square(x): return x * x` |
| Multiple values | `def greet(name, age): print(f"Hello {name}, you are {age} years old")` |
| Position-based | Arguments must be passed in order |

## Default Values in Functions
You can assign default values to parameters, making them optional.

```python
def function_name(param=default_value):
    pass
```

Example:

```python
def greet(name="Guest"):
    print(f"Hello, {name}!")
```

Default arguments must come after non-default ones. This prevents confusion in argument passing.

```python
def info(name, age=25, city="Unknown"):
    print(f"{name} is {age} years old in {city}")
```

## Multiple Values and Lists
Functions can handle multiple values using lists, tuples, or variable-length arguments (`*args`, `**kwargs`).

```python
def process_list(numbers):
    for num in numbers:
        print(num * 2)
```

For dynamic argument counts:

```python
def sum_all(*args):
    return sum(args)
```

Example usage:

```python
sum_all(1, 2, 3, 4)  # Returns 10
```

This approach is useful for functions needing to process variable data sets.

## Return Statements
Functions can return values using the `return` keyword. If no return is provided, the function returns `None`.

```python
def multiply(a, b):
    return a * b
```

Return multiple values as tuples:

```python
def get_coordinates():
    return (10, 20)
```

Returns enable chaining and data flow between functions.

## Advanced Function Concepts
We'll explore higher-order functions, which accept or return other functions.

Example: A function that adds a number:

```python
def add(x):
    def inner(y):
        return x + y
    return inner
```

This creates a closure, retaining the outer function's scope.

Decorators modify function behavior without changing code:

```python
def my_decorator(func):
    def wrapper():
        print("Something before")
        func()
        print("Something after")
    return wrapper

@my_decorator
def my_function():
    print("Hello!")
```

## Functional Programming Examples
Functional programming emphasizes immutable data and pure functions.

```python
def square(x):
    return x * x

numbers = [1, 2, 3, 4, 5]
squared = list(map(square, numbers))
print(squared)  # [1, 4, 9, 16, 25]
```

Python supports lambda functions for concise expressions:

```python
result = list(map(lambda x: x * x, numbers))
```

## Filter and Map Functions
`map()` applies a function to each item in a sequence.

```python
def double(x):
    return x * 2

numbers = [1, 2, 3, 4]
doubled = list(map(double, numbers))  # [2, 4, 6, 8]
```

`filter()` selects items based on a condition.

```python
def is_even(x):
    return x % 2 == 0

evens = list(filter(is_even, numbers))  # [2, 4]
```

Combining `map` and `filter` creates powerful data processing pipelines.

## Practical Demos
Demo 1: Creating a function with multiple arguments.

```python
def calculate_total(price, tax_rate=0.1):
    return price + (price * tax_rate)

total = calculate_total(100)  # 110.0
```

Demo 2: Using `*args` for flexible arguments.

```python
def concatenate(*string_list):
    return " ".join(string_list)

result = concatenate("Hello", "World", "Python")  # "Hello World Python"
```

Demo 3: Higher-order function with lambda.

```python
numbers = [1, 2, 3, 4, 5]
filtered = list(filter(lambda x: x > 3, numbers))  # [4, 5]
```

## Summary

### Key Takeaways
```diff
+ Functions encapsulate code for reuse and modularity
- Avoid mutable default arguments to prevent unexpected behavior
! Understanding closures and decorators opens advanced possibilities
+ Return statements enable data flow and composition
- Remember to handle variable arguments properly
```

### Quick Reference
- Define function: `def func_name(params): pass`
- Default args: `def func(param=default): pass`
- Variable args: `def func(*args, **kwargs): pass`
- Lambda: `lambda params: expression`
- Map usage: `list(map(func, iterable))`
- Filter usage: `list(filter(func, iterable))`

### Expert Insight

#### Real-world Application
Functions power web frameworks like Flask/Django for request handling. In data science, functional programming with Pandas enables efficient data pipelines. Video games use functions for physics simulations, while APIs rely on clean function interfaces for scalability.

#### Expert Path
Master closures by building decorators for logging and caching. Learn recursion for complex algorithms like tree traversals. Study functional libraries like `functools` for performance optimizations. Practice writing higher-order functions to think functionally.

#### Common Pitfalls
- Mutable default arguments cause shared state issues: Always use `None` and check inside.
- Name shadowing: Avoid reusing variable names in nested scopes.
- Return vs. print: Functions should return values, not just print, for composability.
- Infinite recursion: Ensure base cases in recursive functions.

#### Lesser-Known Facts
- Python functions support introspection via `__name__`, `__doc__`, and `inspect` module.
- Generator functions (`yield`) create iterators efficiently for large datasets.
- Python allows partial function application with `functools.partial`.
- Decorators enable aspect-oriented programming, injecting cross-cutting concerns like authentication.
