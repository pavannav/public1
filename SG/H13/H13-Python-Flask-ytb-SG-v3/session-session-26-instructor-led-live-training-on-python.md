# Session 26: Instructor-Led Live Training on Python

---

## Table of Contents
- [Object-Oriented Programming Advanced Concepts](#object-oriented-programming-advanced-concepts)
  - [Overview](#overview)
  - [Key Concepts / Deep Dive](#key-concepts--deep-dive)
    - [Revisiting Inheritance and Visitor/Employee Classes](#revisiting-inheritance-and-visitoremployee-classes)
    - [Adding Extra Properties in Subclasses](#adding-extra-properties-in-subclasses)
    - [Method Overriding and Using Super()](#method-overriding-and-using-super)
    - [Method Types: Instance, Class, and Static](#method-types-instance-class-and-static)
    - [Getters and Setters](#getters-and-setters)
  - [Lab Demos](#lab-demos)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

---

## Object-Oriented Programming Advanced Concepts

### Overview
Object-oriented programming (OOP) is a programming paradigm focused on organizing data and behavior into objects, classes, and inheritance hierarchies. In Python, OOP combines the structure of classes and instances with functional programming concepts like lambda functions for clean, efficient code. This session builds on basic OOP by exploring advanced features such as inheritance with `super()`, method overriding, and different types of methods (instance, class, and static). These concepts help manage code reusability, data encapsulation, and modularity, enabling scalable applications where data is organized into self-contained "spaces" or namespaces for individual objects.

### Key Concepts / Deep Dive

#### Revisiting Inheritance and Visitor/Employee Classes
Inheritance allows a subclass (child class) to inherit properties and methods from a superclass (parent class or base class), promoting code reuse and logical organization. For example, consider a `Visitor` class as a parent representing common attributes like `first_name`, `last_name`, and `mobile_number`. An `Employee` class can inherit these attributes while adding unique ones like `job_title`.

- **Purpose and Real-World Analogy**: Inheritance mimics real-world forms or hierarchies. A visitor fills a basic form; an employee fills an extended form without duplicating fields. This avoids repetition and ensures data consistency.
- **Namespace and Instance Concepts**: Each object (e.g., an instance named `jack`) gets its own memory space (namespace) for attributes. The class defines blueprints, but instances store actual data.
- **Help Function for Hierarchy Inspection**: Python's `help()` function reveals the method resolution order (MRO), showing inheritance chains. For an `Employee` subclass, it displays the hierarchy, confirming inherited methods and properties from `Visitor`.

#### Adding Extra Properties in Subclasses
Subclasses often extend parent classes by adding new attributes. This requires careful handling of constructors (`__init__`) to ensure inherited properties are initialized without overriding the parent's logic completely.

- **Challenge of Overriding**: If a subclass defines its own `__init__`, it overrides the parent's, potentially losing inherited properties. For `Employee`, defining only `job_title` in `__init__` would hide `first_name`, `last_name`, and `mobile_number`.
- **Mixing Functional and OOP Approaches**: Inside method bodies, functional programming (e.g., lambda for data transformation) can enhance OOP methods, creating concise, powerful logic for tasks like data cleaning or email generation.

#### Method Overriding and Using Super()
Method overriding occurs when a subclass redefines a parent method. To call the parent's version, use `super()` for controlled inheritance and extension.

- **Super() Keyword**: `super()` allows calling parent methods explicitly. In `__init__`, `super().__init__()` invokes the parent's constructor, inheriting attributes before adding subclass-specific ones.
- **Example Workflow**: For `Employee`, call `super().__init__(first_name, last_name, mobile_number)` to set inherited attributes, then add `self.job_title = title` locally.
- **When Not to Override**: If no new attributes are added, avoid overriding to prevent loss of functionality.

#### Method Types: Instance, Class, and Static
Methods in classes differ based on scope and purpose, affecting how they access data.

- **Instance Methods**: Most common; operate on individual object data. They require `self` (instance reference). Example: A getter like `get_full_name(self)` retrieves instance-specific attributes (e.g., concatenating `first_name` and `last_name`).
- **Class Methods**: Access class-level data shared across instances (e.g., region or company-wide settings). Use `@classmethod` decorator and `cls` as the first parameter. Example: `get_region(cls)` retrieves a class variable like company region.
- **Static Methods**: Utility methods unrelated to instance or class data. Use `@staticmethod` decorator; no `self` or `cls` needed. Example: A helper for current time that doesn't rely on object state.
- **Comparison Table**:

| Method Type | Decorator | First Parameter | Purpose | Access To |
|-------------|-----------|-----------------|---------|-----------|
| Instance   | None      | `self`         | Operate on object data | Instance variables |
| Class      | `@classmethod` | `cls`   | Manipulate class-wide data | Class variables |
| Static     | `@staticmethod` | None   | Perform utility tasks | No data access |

- **Decoupling Concepts**: OOP organizes data via instances/classes, while functional programming adds computation logic within methods.

#### Getters and Setters
Encapsulation involves controlling data access. Getters retrieve values; setters update them, often with validation.

- **Getter Methods**: Instance methods like `get_full_name(self)` or `get_region(cls)` that return formatted or specific data.
- **Setter Methods**: Update values, e.g., `set_title(self, new_title)` for instance data or `set_region(cls, new_region)` for class data.
- **Best Practices**: Use methods for access to enable logic (e.g., combining fields or validating inputs) rather than direct attribute changes, improving maintainability for applications like APIs or UI buttons.

### Lab Demos
This session uses interactive coding in Jupyter Notebook, demonstrating OOP concepts through live examples.

#### Demo 1: Basic Inheritance with Visitor and Employee Classes
1. Create the `Visitor` class with constructor, attributes, and a `get_full_name` method.

   ```python
   class Visitor:
       def __init__(self, first_name, last_name, mobile_number):
           self.first_name = first_name
           self.last_name = last_name
           self.mobile_number = mobile_number
       
       def get_full_name(self):
           return f"{self.first_name} {self.last_name}"
   ```

2. Create the `Employee` class inheriting from `Visitor`, using `super()` to call parent's `__init__` and add `job_title`.

   ```python
   class Employee(Visitor):
       def __init__(self, first_name, last_name, mobile_number, job_title):
           super().__init__(first_name, last_name, mobile_number)
           self.job_title = job_title
       
       def set_title(self, new_title):
           self.job_title = new_title
   ```

3. Instantiate and inspect properties.

   ```python
   jack = Employee("Jack", "XYZ", "111", "Manager")
   print(jack.get_full_name())  # Output: Jack XYZ
   print(jack.job_title)        # Output: Manager
   ```

4. Use `help(Employee)` to view MRO showing inheritance hierarchy.

#### Demo 2: Class and Static Methods
1. Add class and static methods to `Visitor`.

   ```python
   class Visitor:
       region = "India"  # Class variable
   
       # ... (existing code)
   
       @classmethod
       def get_region(cls):
           return cls.region
   
       @classmethod
       def set_region(cls, new_region):
           cls.region = new_region
   
       @staticmethod
       def current_time():
           return "Monday (example fixed time)"
   ```

2. Demonstrate class methods.

   ```python
   print(Visitor.get_region())  # Output: India
   Visitor.set_region("US")
   print(Visitor.get_region())  # Output: US
   ```

3. Demonstrate static method.

   ```python
   print(Visitor.current_time())  # Output: Monday (example fixed time)
   ```

4. Test on instances: `jack.current_time()  # Works without instance dependency`.

### Summary

#### Key Takeaways
```diff
+ Inheritance enables code reuse by inheriting properties from parent classes, using namespaces for isolated data management.
- Method overriding can accidentally hide parent functionality; always check with help() and use super() to extend behavior.
! Use super() in subclass __init__ to inherit parent attributes before adding new ones, ensuring full property access.
+ Instance methods manage object-specific data, class methods handle shared class data, and static methods provide utilities.
- Direct attribute access (e.g., obj.attribute = value) violates encapsulation; prefer getters/setters for controlled data handling.
```

#### Quick Reference
- **Inheritance & Super**: Subclass: `super().__init__(args)` to inherit, then add local attributes.
- **Method Types**:
  - Instance: `def method(self): ...`
  - Class: `@classmethod def method(cls): ...`
  - Static: `@staticmethod def method(): ...`
- **Getters/Setters**: `def get_something(self): return self.attr` / `def set_something(self, value): self.attr = value`.
- **Help Inspection**: `help(ClassName)` for MRO and available methods/properties.

#### Expert Insight
**Real-world Application**: In web frameworks like Flask (upcoming in this course), OOP organizes models (e.g., User/Employee classes) for database interactions, combining inheritance for user roles and static methods for utilities like data validation. Combine with functional programming for data pipelines in APIs.

**Expert Path**: Master method types by refactoring code to use decorators wisely. Study design patterns (e.g., Singleton with class methods). Experiment with multiple inheritance for complex hierarchies, ensuring MRO via `mro()` method.

**Common Pitfalls**: Forgetting `@classmethod`/`@staticmethod` decorators causes errors when calling without instances. Overriding `__init__` without `super()` loses inherited properties. Direct attribute changes bypass validation logic, leading to inconsistent data in production apps. Always test `help()` output for hierarchy issues.

**Lesser-Known Facts**: Python's `object` base class enables everything as inheriting from it; static methods can be called on instances but aren't tied to object state, unlike some languages. Decorator syntax (`@`) is syntactic sugar for function wrapping, enabling advanced metaprogramming.

**Advantages and Disadvantages**:
- **Advantages**: Better organization and reusability; easier debugging via isolated namespaces; functional+OOP hybrid creates concise, readable code for data-heavy apps.
- **Disadvantages**: Inheritance depth can complicate MRO; over-encapsulation adds overhead; debuggers may need deeper inspection for class/static methods.

>
[!NOTE]  
> This session emphasizes combining OOP with functional concepts for versatile programming. Practice by extending examples into simple apps.

>
[!WARNING]  
> Avoid deep inheritance chains without documentation, as they can break with Python version changes.

--- 

🤖 Generated with [Claude Code](https://claude.com/claude-code)  

Co-Authored-By: Claude <noreply@anthropic.com>
