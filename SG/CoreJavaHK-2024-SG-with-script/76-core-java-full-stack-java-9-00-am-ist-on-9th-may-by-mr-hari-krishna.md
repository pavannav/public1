# Session 76: Core Java & Full Stack Java

## Table of Contents
- [Abstraction](#abstraction)
  - [Overview](#overview)
  - [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Developing Abstraction](#developing-abstraction)
  - [Rules for Developing Abstraction](#rules-for-developing-abstraction)
  - [Advantages of Abstraction](#advantages-of-abstraction)
  - [Real-life Examples](#real-life-examples)
  - [Code Examples](#code-examples)

## Summary
### Key Takeaways
```diff
+ Abstraction hides unnecessary implementation details and provides necessary information for accessing object operations.
+ Abstract methods end with a semicolon and must be declared with the 'abstract' keyword inside abstract classes or interfaces.
+ Abstract classes cannot be instantiated and serve as templates for subclasses to implement abstract methods.
+ Subclasses must override all abstract methods from the parent abstract class to ensure runtime polymorphism.
+ Abstraction ensures 100% strong encapsulation, loose coupling, and runtime polymorphism, making projects scalable and extensible.
! Ensure subclasses implement abstract methods with the same signature to avoid compile-time errors.
- Avoid declaring methods with implementation bodies in abstract classes if polymorphism is required, as this prevents dynamic binding.
```
### Expert Insight
**Real-world Application**: In enterprise applications like e-commerce platforms or banking systems, abstraction is used to model abstract entities such as "Payment" (with subclasses like "CreditCardPayment" or "PayPalPayment"). This allows for seamless integration of new payment methods without altering user-facing code, achieving runtime polymorphism for processing payments dynamically based on the payment type, while ensuring data security through encapsulation.

**Expert Path**: Master abstraction by practicing design patterns like Template Method, where abstract classes define the skeleton of an algorithm, delegating varying steps to subclasses. Study the JDK's AbstractCollection class to see abstraction in action, and experiment with mocking frameworks (e.g., Mockito) that rely on abstraction for testing interfaces. Aim to model real-world hierarchies (e.g., vehicle types, animal behaviors) and measure performance impacts of dynamic binding in large-scale applications.

**Common Pitfalls**: 
- Forgetting to declare a class as abstract when it contains abstract methods leads to compile-time errors like "missing method body or declare abstract." Always verify class declarations after adding abstract methods.
- Attempting to instantiate abstract classes directly results in errors; remember, abstract classes are blueprints for subclasses, and objects must be created from concrete subclasses (e.g., new Rectangle(), not new Shape()).
- Mismatching method signatures in subclasses violates polymorphism rules—use tools like IDE warnings to enforce overrides, and test for runtime behavior rather than just compilation.
- Lesser known things: Abstract classes can contain constructors (though not directly callable) to initialize inherited fields in subclasses. Protected constructors can further restrict instantiation, ensuring flexible yet controlled inheritance hierarchies.

## Abstraction

### Overview
Abstraction is a fundamental principle in object-oriented programming (OOP) that involves representing complex real-world problems simply by focusing on essential features while concealing unnecessary details. In the context of Java, abstraction allows programmers to define classes that declare operations without specifying their implementation, enabling subclasses to provide specific behaviors. This promotes modularity, security, and extensibility, forming the foundation for runtime polymorphism and loose coupling. By hiding implementation complexities, abstraction ensures that user programmers interact with objects through well-defined interfaces, mirroring real-world interactions where details like internal mechanisms are irrelevant to the user. For instance, a car's driver focuses on steering and acceleration without needing to understand engine combustion details.

### Key Concepts and Deep Dive
Abstraction stems from the need to manage software complexity by separating "what" an object does from "how" it does it. Core concepts include abstract methods (blueprints for operations) and abstract classes (templates enforcing structure). Unlike concrete classes, abstract classes cannot be instantiated directly; they require subclasses to implement abstract methods, ensuring consistent behavior across object hierarchies.

#### Developing Abstraction
Develop abstraction by declaring a class as `abstract` and including methods marked with the `abstract` keyword. Abstract methods define signatures (name, parameters, return type) but omit bodies, compelling subclasses to provide implementations.

#### Rules for Developing Abstraction
Follow these five rules strictly to implement abstraction correctly, avoiding compilation errors and ensuring proper inheritance:

1. **Rule 1**: An abstract method must not contain a body, ending with a semicolon. It must include the `abstract` keyword in its declaration. This declares the method's intent without providing implementation.
2. **Rule 2**: If a class contains at least one abstract method, the class must be declared as `abstract`. This signals to the compiler that the class enforces implementation in subclasses.
3. **Rule 3**: An abstract class cannot be instantiated (no `new` keyword allowed). Abstract classes represent concepts or types (e.g., "Shape") rather than concrete entities.
4. **Rule 4**: Create subclasses from abstract classes using the `extends` keyword. This establishes inheritance, allowing subclasses to inherit abstract methods.
5. **Rule 5**: Subclasses must override all abstract methods from the parent abstract class. Failure to do so results in compilation errors, ensuring mandatory implementation for runtime polymorphism.

#### Advantages of Abstraction
Abstraction provides significant benefits in software design:

- **Hiding Implementation Details**: User programmers see only operation declarations, promoting cleaner, maintainable code by reducing cognitive load.
- **100% Strong Encapsulation**: All fields and implementation logic are confined to subclasses, accessible only via declared methods in the abstract class.
- **100% Loose Coupling**: Storing subclass objects in superclass reference variables allows dynamic runtime connections without tight dependencies.
- **100% Runtime Polymorphism**: Dynamic method resolution enables the same method call to execute different implementations based on the runtime object type.
- **Scalability and Extensibility**: Projects using abstraction start with declarations, automatically incorporating inheritance, polymorphism, and encapsulation, making systems adaptable to future changes.

#### Real-life Examples
Real-life analogies illustrate abstraction effectively:

- **Shape Hierarchy**: "Shape" represents a concept, not a physical object. Subclasses like "Rectangle," "Square," and "Circle" provide specific implementations (e.g., area calculation), ensuring users call methods uniformly while hiding subclass details.
- **Vehicle Hierarchy**: "Vehicle" is abstract; subclasses like "Car," "Bike," or "Truck" define behaviors like "startEngine." Users manipulate vehicles generically, benefiting from polymorphism (e.g., changing SIM cards in a mobile dynamically).
- **Animal Behaviors**: "Animal" declares abstract methods like "eat" or "sleep." Subclasses (e.g., "Dog," "Cat") implement specifics, enabling dynamic behavior changes.

#### Code Examples
Below are practical Java implementations demonstrating abstraction. These examples build from basic concepts to hierarchical structures.

**Basic Abstract Class and Method Declaration**:
```java
abstract class Shape {
    // Abstract method: no body, ends with semicolon
    abstract double findArea();
    
    // Abstract class can have concrete methods too
    void display() {
        System.out.println("This is a shape.");
    }
}
```

**Subclasses Implementing Abstract Methods**:
```java
class Rectangle extends Shape {
    private double length;
    private double breadth;
    
    // Constructor to initialize subclass fields
    Rectangle(double length, double breadth) {
        this.length = length;
        this.breadth = breadth;
    }
    
    // Override and implement abstract method
    @Override
    double findArea() {
        return length * breadth;
    }
}

class Square extends Shape {
    private double side;
    
    Square(double side) {
        this.side = side;
    }
    
    @Override
    double findArea() {
        return side * side;
    }
}

class Circle extends Shape {
    private double radius;
    private final double PI = 3.14159;
    
    Circle(double radius) {
        this.radius = radius;
    }
    
    @Override
    double findArea() {
        return PI * radius * radius;
    }
}
```

**User Class Demonstrating Runtime Polymorphism (Painter Example)**:
```java
public class Painter {
    public static void main(String[] args) {
        Shape shape1 = new Rectangle(5, 3); // Upcasting: loose coupling
        shape1.findArea(); // Executes Rectangle's findArea (runtime polymorphism)
        
        // Changing object dynamically
        Shape shape2 = new Circle(2);
        shape2.findArea(); // Executes Circle's findArea
        
        // Benefits: same reference, different behaviors
    }
}
```

**Advanced Example with Constructor in Abstract Class**:
Abstract classes can include constructors to initialize inherited fields, ensuring subclass objects have proper state.

```java
abstract class Vehicle {
    private String brand;
    
    // Constructor in abstract class (initializes fields for subclasses)
    Vehicle(String brand) {
        this.brand = brand;
    }
    
    // Getter for encapsulation
    String getBrand() {
        return brand;
    }
    
    // Abstract method
    abstract void startEngine();
}

class Car extends Vehicle {
    Car(String brand) {
        super(brand); // Calls abstract class constructor
    }
    
    @Override
    void startEngine() {
        System.out.println(getBrand() + " car engine started.");
    }
}
```

> [!IMPORTANT]
> Abstract classes enforce implementation in subclasses, providing a blueprint for polymorphism. Attempting to instantiate them directly will result in compilation errors.

> [!NOTE]
> Use tools like Eclipse or IntelliJ IDEA to auto-generate overridden methods in subclasses, reducing manual errors in large hierarchies.
