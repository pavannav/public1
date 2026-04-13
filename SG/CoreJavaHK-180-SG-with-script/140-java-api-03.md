# Session 140: Java API 03

## Table of Contents
- [IDE Shortcuts and Development Tips](#ide-shortcuts-and-development-tips)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
    - [Eclipse IDE Setup](#eclipse-ide-setup)
    - [Essential Keyboard Shortcuts](#essential-keyboard-shortcuts)
    - [Code Generation Features](#code-generation-features)
    - [Quick Fix and Refactoring](#quick-fix-and-refactoring)
    - [Project and Class Management](#project-and-class-management)
  - [Code Demos](#code-demos)
    - [Creating a Person Class with Eclipse Automation](#creating-a-person-class-with-eclipse-automation)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Expert Insight](#expert-insight)
    - [Real-world Application](#real-world-application)
    - [Expert Path](#expert-path)
    - [Common Pitfalls](#common-pitfalls)

## IDE Shortcuts and Development Tips

### Overview
This session covers advanced Eclipse IDE features and shortcuts for efficient Java development. The instructor demonstrates how to leverage Eclipse's automation capabilities to speed up coding tasks, including code generation, quick fixes, and project management. The session builds on previous API documentation concepts and prepares students for learning Java's Object class methods.

### Key Concepts

#### Eclipse IDE Setup
Eclipse provides powerful productivity features through its open-source platform:
- Enable "Tips of the Day" for daily learning: Help → Tips of the Day
- Customize font sizes and workspace setups per project
- Configure hotkeys and shortcuts through Window → Preferences → Keys

> [!IMPORTANT]
> Eclipse is designed for rapid development through automation, reducing boilerplate code writing significantly.

#### Essential Keyboard Shortcuts
Key shortcuts for efficient coding include:

```bash
# Quick help and content assist
Control + Space          # Content assist/Code completion
Control + Shift + L      # Show all shortcuts
Control + /              # Single line comment
Control + Shift + /      # Multi-line comment
Control + Shift + F      # Format code
Control + A              # Select all

# Code execution
Control + F11            # Run/debug application

# File navigation
F12                      # Activate current editor
Control + Shift + Tab    # Switch between editors

# Code manipulation
Alt + Shift + R          # Rename refactoring
Control + D              # Delete current line
Alt + Down Arrow         # Move line down
Alt + Up Arrow           # Move line up
Control + Alt + Down     # Duplicate line
```

#### Code Generation Features
Eclipse provides automated code generation through Source menu (Alt + Shift + S):

**Generating Constructors:**
- Alt + Shift + S → O (Generate Constructor using Fields)
- Select required fields from class properties
- Choose visibility (public/private/protected/package)

**Generating Getters and Setters:**
- Alt + Shift + S → R (Generate Getters and Setters)
- Select properties to generate accessors for
- Eclipse follows Java naming conventions automatically

**Generating toString():**
- Alt + Shift + S + S (Generate toString())
- Choose fields to include in string representation
- Customize template for formatting

#### Quick Fix and Refactoring
Control + 1 provides intelligent suggestions:

```
Control + 1 examples:
- Create missing classes/methods
- Fix import statements
- Generate variable/field declarations
- Convert between data types
- Implement abstract methods
```

#### Project and Class Management
**Package Naming Conventions:**
```java
// Company domain reverse + project structure
com.hk.nit.hk.object.methods  // Personal convention
com.company.product.module   // Company standard
```

**Class Creation Workflow:**
1. Right-click package → New → Class
2. Define class name and modifiers
3. Use Eclipse to generate boilerplate code

### Code Demos

#### Creating a Person Class with Eclipse Automation

Here's a complete demo of creating a Person class using Eclipse shortcuts:

```java
package com.hk.nit.hk.object.methods;

public class Person {
    // Static properties
    private static int eyes = 2;
    private static int ears = 2;
    private static int hands = 2;
    private static int legs = 2;
    
    // Instance properties (non-static)
    private String name;
    private double height;
    private double weight;
    private long mobile;
    private String email;
    private char gender;
    private boolean living;
    
    // Constructor generated using Alt + Shift + S → O
    public Person(String name, double height, double weight, 
                  char gender, boolean living) {
        this.name = name;
        this.height = height;
        this.weight = weight;
        this.gender = gender;
        this.living = living;
    }
    
    // Static getters/setters generated using Alt + Shift + S → R
    public static int getEyes() {
        return eyes;
    }
    
    public static void setEyes(int eyes) {
        Person.eyes = eyes;
    }
    
    // Non-static getters/setters
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public double getHeight() {
        return height;
    }
    
    public void setHeight(double height) {
        this.height = height;
    }
    
    // ... additional getters/setters for all properties
    
    // toString() generated using Alt + Shift + S → S
    @Override
    public String toString() {
        return "Person [name=" + name + ", height=" + height + ", weight=" + weight 
               + ", mobile=" + mobile + ", email=" + email + ", gender=" + gender 
               + ", living=" + living + "]";
    }
}
```

**Usage Example:**
```java
// Creating objects using Eclipse shortcuts
Person p1 = new Person("HK", 6.0, 200.0, 'M', true);
Person p2 = new Person("Balaji", 5.9, 150.0, 'M', true);

// Content assist (Control + Space) helps with method calls
System.out.println(p1);
System.out.println(p2);
```

**Lab: Practice Object Creation**
1. Create a new class called `BankAccount`
2. Define properties: accountNumber (String), balance (double), accountHolder (String), isActive (boolean)
3. Use Eclipse shortcuts to generate constructor with required fields
4. Generate getters/setters for all properties
5. Generate toString() method
6. Create 2-3 BankAccount objects and test the toString() output

## Summary

### Key Takeaways
```diff
+ Eclipse IDE shortcuts dramatically speed up Java development
+ Code generation features eliminate boilerplate code writing
+ Proper project structure and naming conventions are essential
+ Content assist (Ctrl+Space) is fundamental for efficient coding
+ Quick fixes (Ctrl+1) provide intelligent code suggestions
+ Automation tools help maintain consistent coding standards
- Manual code writing wastes development time
- Ignoring Eclipse features limits productivity
! Master keyboard shortcuts for professional Java development
```

### Expert Insight

#### Real-world Application
In enterprise Java development:
- Teams use Eclipse/shortcuts to maintain 100K+ LOC codebases efficiently
- Code generation ensures consistent API contracts across teams
- Refactoring tools enable safe code evolution during maintenance phases
- Productivity shortcuts reduce development time by 30-50%

#### Expert Path
- **Beginner → Intermediate**: Master basic shortcuts (Ctrl+Space, Ctrl+1, format)
- **Intermediate → Advanced**: Learn refactoring (Alt+Shift+R), custom code templates
- **Advanced → Expert**: Create custom Eclipse plugins, advanced debugging tools
- Practice daily: Spend 30 minutes exploring Eclipse menus/options
- Master test case generation using Eclipse JUnit integration

#### Common Pitfalls
**Static vs Instance Variables:**
```java
// Common mistake: Using instance access for static
private static int count;
public void increment() {
    this.count++; // Wrong! Uses 'this' with static
    Person.count++; // Correct for static access
}
```

**Getter/Setter Naming Convention:**
- Boolean properties use "is" prefix: `isActive()`, `setActive(boolean)`
- Regular properties use "get/set": `getName()`, `setName(String)`
- Eclipse auto-generates correct naming, but manual writing often fails this

**Package Naming Issues:**
- Using personal names instead of company standards
- Inconsistent casing (should be lowercase: `com.company.project.module`)
- Deep nesting without clear purpose

**Object Initialization:**
- Forgetting to initialize collections/arrays in constructors
- Not handling null parameters properly in setters
- Static blocks not used for complex static initialization

**Performance Issues:**
- Unnecessary object creation in frequently called methods
- String concatenation in loops instead of StringBuilder
- Large objects not implementing proper equals()/hashCode() for collections

**Eclipse-Specific Pitfalls:**
- Hotkey conflicts with OS (disable graphics hotkeys)
- Not enabling content assist options
- Ignoring compilation warnings/errors
- Manual formatting instead of using Ctrl+Shift+F

**Package vs Class Name Conflicts:**
When renaming classes, ensure both file name and class declaration match, or use Quick Fix (Ctrl+1) to resolve naming conflicts.
```diff
- File: Student.java, Class: Person (compilation error)
+ File: Person.java, Class: Person (resolves conflict)
```
