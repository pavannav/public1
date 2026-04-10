# Session 70: Method Overriding, Overloading, and Hiding in Java

## Table of Contents

- [Polymorphism Recap](#polymorphism-recap)
- [Rules for Method Overriding](#rules-for-method-overriding)
- [Covariant Return Types](#covariant-return-types)
- [Execution Level Modifier Rules](#execution-level-modifier-rules)
- [Accessibility Modifier Rules](#accessibility-modifier-rules)
- [Private Methods and Overriding](#private-methods-and-overriding)
- [Method Hiding](#method-hiding)
- [Method Overloading](#method-overloading)
- [Code Examples and Execution Flow](#code-examples-and-execution-flow)
- [MCQs and Practice Questions](#mcqs-and-practice-questions)
- [@Override Annotation](#override-annotation)

## Polymorphism Recap

### Overview
Polymorphism in Java allows objects to be processed in different ways, typically through method overriding, method overloading, and method hiding. This session builds upon previous discussions, focusing on when and how to apply these concepts in inheritance hierarchies.

### Key Concepts/Deep Dive
- **Method Search Pattern**: Whenever a method call statement `obj.method()` is encountered:
  - Search for the method in the class of the object's reference variable
  - Execute based on the method type (static vs non-static)

- **Non-Static Overridden Methods**: Execute from the current object class
- **Static Methods (Hiding)**: Execute from the reference variable class
- **Non-Static Non-Overridden Methods**: Execute from the reference variable class

💡 **Key Rule**: The instructor emphasizes that failure to remember this execution flow leads to interview/exam failures.

## Rules for Method Overriding

### Overview
Method overriding occurs when a subclass redefines a method from its superclass with the same signature. Strict rules must be followed during overriding to ensure compile-time safety.

### Key Concepts/Deep Dive
- **What is Overriding?**
  - Creating a non-static method in superclass
  - Creating a method with the same signature in subclass
  - Purpose: Change superclass method logic per subclass requirements

- **Fundamental Condition**: Signature must match exactly for a method to be considered overriding

- **Four Rules Must be Applied**:
  1. Return type rules
  2. Execution level modifier rules
  3. Accessibility modifier rules
  4. Exception handling rules (covered in future sessions)

- **Code Example**:
  ```java
  class A {
      void m1() { // parent method
          System.out.println("Parent");
      }
  }
  
  class B extends A {
      void m1() { // overriding if rules followed
          System.out.println("Child");
      }
  }
  ```

## Covariant Return Types

### Overview
As of Java 5, the return type of an overridden method can be a subclass of the superclass method's return type, enabling more flexible inheritance designs.

### Key Concepts/Deep Dive
- **Rule**: Return type must be the same as superclass method or covariant

- **Covariance Definition**: Subclass types are considered covariant when used as return types

- **Primitive Types**: No covariance allowed (long cannot return int, etc.)

- **Reference Types**: Covariance applies between classes

- **Examples**:
  - ✅ Valid: Superclass returns `Animal`, subclass returns `Dog` (if `Dog` extends `Animal`)
  - ✅ Valid: Superclass returns `Object`, subclass returns any class type
  - ❌ Invalid: Superclass returns `String`, subclass returns `Object`
  - ❌ Invalid: Long → Int (downcast not permitted)

```java
class Super {
    Object getValue() { return new Object(); } // Parent method
}

class Sub extends Super {
    String getValue() { return "Hello"; } // Invalid - not covariant
    // Would be invalid pre-Java 5 even for supported cases
    Animal getValue() { return new Dog(); } // Valid in Java 5+ if Dog extends Animal
}
```

## Execution Level Modifier Rules

### Overview
The static keyword cannot be added or removed during method overriding. This maintains the fundamental nature of the method type.

### Key Concepts/Deep Dive
- **Static ↔ Non-Static Conversion**: Strictly prohibited

- **Examples**:
  ```java
  class A {
      void m1() {} // Non-static parent
  }
  
  class B extends A {
      // static void m1() {} // ❌ Compile error
      void m1() {} // ✅ Valid
  }
  
  class X {
      static void m1() {} // Static parent
  }
  
  class Y extends X {
      static void m1() {} // ✅ Valid
      // void m1() {} // ❌ Compile error
  }
  ```

- **Why This Rule?** Static methods are bound to classes, non-static methods are bound to objects. Changing this relationship breaks the inheritance contract.

## Accessibility Modifier Rules

### Overview
Accessibility modifiers (private, default, protected, public) can be increased but never decreased during overriding, ensuring subclass behavior is at least as accessible as parent behavior.

### Key Concepts/Deep Dive
- **Hierarchy**: Private < Default < Protected < Public

- **Valid Changes**:
  - Default → Protected/Public
  - Protected → Public
  - Same modifier allowed

- **Invalid Changes** (Compiler Errors):
  - Default → Private (weaker access)
  - Protected → Default/Private (weaker access)
  - Public → Any other (weaker access)

```java
class Parent {
    protected void display() {}
}

class Child extends Parent {
    public void display() {} // ✅ Increased access
    // private void display() {} // ❌ Compile error: weaker access
    protected void display() {} // ✅ Same access
}
```

> [!NOTE]
> Compiler error message: "attempting to assign weaker access privileges"

- **Default Access**: Refers to package-private access when no modifier is specified

## Private Methods and Overriding

### Overview
Private methods are not inherited by subclasses and therefore cannot be overridden, even if a method with identical signature exists in the subclass.

### Key Concepts/Deep Dive
- **Private Method Inheritance**: Private members are not inherited by subclasses

- **Non-Overridden Behavior**: A "matching" private method in superclass is considered a subclass's own method, not overridden

- **Rule Exemption**: When "overriding" private methods, none of the four overriding rules apply

- **Code Example**:
  ```java
  class Super {
      private void secret() {}
  }
  
  class Sub extends Super {
      private void secret() {} // ✅ This is Sub's own method, not overriding
      // Can change return type, add static, change access modifier freely
  }
  ```

- **Execution**: Always calls the class's own method regardless of object type

⚠️ **Warning**: Confusing private method "overriding" with actual overriding is a common mistake in interviews.

## Method Hiding

### Overview
Method hiding occurs when a static method in a subclass has the same signature as a static method in its superclass, allowing the subclass to define its own class-level behavior.

### Key Concepts/Deep Dive
- **Definition**: Creating a static method in superclass and subclass with same signature

- **Purpose**: Hide superclass static method logic for subclass-specific requirements

- **Execution Flow**:
  - Searched: Reference variable class
  - Executed: Reference variable class

- **Example**:
  ```java
  class A {
      static void show() {
          System.out.println("Class A");
      }
  }
  
  class B extends A {
      static void show() {
          System.out.println("Class B");
      }
  }
  
  class Test {
      public static void main(String[] args) {
          A a1 = new A(); // A reference, A object
          a1.show(); // Output: Class A
          
          A a2 = new B(); // A reference, B object  
          a2.show(); // Output: Class A (executes from reference class)
          
          B b1 = new B(); // B reference, B object
          b1.show(); // Output: Class B
      }
  }
  ```

## Method Overloading

### Overview
Method overloading enables multiple methods with the same name but different parameters in the same class, allowing polymorphic behavior without inheritance.

### Key Concepts/Deep Dive
- **Definition**: Multiple methods with same name but different parameter types/lists(or order

- **Purpose**: Perform same operation on different data types

- **One Key Rule**: Method name must be same, parameter types must differ

- **No Restrictions**: Unlike overriding, overloading has no rules regarding return types, accessibility modifiers, or static/non-static status

- **Examples**:
  ```java
  class Calculator {
      int add(int a, int b) { return a + b; } // No error
      
      double add(double a, double b) { return a + b; } // Parameter type different
      
      void add(int a) { return a + 10; } // Parameter count different
      
      // int add(int a, int b) { return a + b; } // ❌ Duplicate - same everything
      
      // String add(int a, int b) { return "" + (a + b); } // ❌ Just return type different (not allowed)
  }
  ```

- **Compiler Error for Invalid Overloading**: "Method already defined"

- **Parameter Matching**: Exact parameter count and type matching determines which method executes

## Code Examples and Execution Flow

### Overview
Practical examples demonstrate method overriding execution flow where searches occur in reference class but execution depends on object type for non-static overridden methods.

### Key Concepts/Deep Dive
- **Override Execution Pattern**:
  ```java
  class Parent {
      void display() {
          System.out.println("Parent");
      }
  }
  
  class Child extends Parent {
      void display() {
          System.out.println("Child");
      }
  }
  
  class Test {
      public static void main(String[] args) {
          Parent p = new Child(); // Reference: Parent, Object: Child
          
          p.display(); // Search: Parent class ✓ Found, Execute: Child class → "Child"
      }
  }
  ```

### Lab Demos
1. **Step 1**: Create superclass and subclass with matching method signatures
2. **Step 2**: Ensure all four overriding rules are satisfied
3. **Step 3**: Create reference variables of both parent and child types
4. **Step 4**: Assign different object instances and observe execution behavior
5. **Step 5**: Verify output matches predicted flow (search in reference class, execute from current object class for overridden non-static methods)

## MCQs and Practice Questions

### Overview
Interactive MCQs reinforce understanding of key concepts covered in the session.

### Key Concepts/Deep Dive
- **Which keyword prevents method overriding?** `final`

- **How to call superclass constructor in subclass?** `super()`

- **What prevents subclass from overriding?** `final` method modifier

- **Output of overridden method call?** Dependent on object type, not reference type

- **Can private methods be overridden?** No, they are not inherited

- **Required for method overloading?** Different parameter types (not just return type)

- **@Override annotation purpose?** Ensures method is actually overriding (Java 5+)

- **Overloading vs overriding?** 
  - Overloading: Same class, different parameters
  - Overriding: Different classes (inheritance), same signature

📝 **Practice Tip**: Work through online MCQ resources to reinforce these concepts.

## @Override Annotation

### Overview
Introduced in Java 5, the `@Override` annotation helps prevent accidental method creation instead of overriding by throwing compile-time errors for signature mismatches.

### Key Concepts/Deep Dive
- **Purpose**: Guarantee method is actually overriding, not accidentally creating a new method

- **Benefit**: Catches typos early
  ```java
  class Super {
      public void display() {}
  }
  
  class Sub extends Super {
      @Override
      public void display() {} // ✅ Guaranteed override
      
      @Override  
      public void diplay() {} // ❌ Compile error: not overriding
  }
  ```

- **Optional but Recommended**: Provides compile-time validation for correctness

## Summary

### Key Takeaways
```diff
+ Method overriding requires exact signature match and adherence to 4 rules
+ Private methods cannot be overridden - they create subclass methods instead
+ Method hiding only applies to static methods with same signatures
+ Method overloading requires only different parameter types (same name)
- Return type changes alone do not create overloading
- Accessibility modifiers cannot be weakened during overriding
! @Override annotation helps catch accidental non-overrides
```

### Expert Insight

**Real-world Application**: Method overriding enables polymorphism in frameworks like Spring and Hibernate, allowing custom behavior injection. Overloading supports flexible APIs like Java's `String#valueOf()` methods.

**Expert Path**: Master execution flow understanding through debugger practice. Study bytecode generation with `javap` to see how JVM handles virtual method calls.

**Common Pitfalls**: 
- Confusing overriding with overloading based on return types
- Forgetting that private methods bypass override rules
- Missing @Override annotation leading to undetected bugs
- Attempting to relax accessibility modifiers downward

Transcript corrections noted: "subass" → "subclass", "superass" → "superclass", "overloading" has occasional inconsistencies but appears to refer to the same concept.
