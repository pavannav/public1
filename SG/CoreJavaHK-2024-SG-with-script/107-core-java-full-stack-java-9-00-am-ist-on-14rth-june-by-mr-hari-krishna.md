# Session 107: Core Java Functional Programming

## Table of Contents
- [Functional Interfaces and Lambda Expressions](#functional-interfaces-and-lambda-expressions)
- [Generic Functional Interfaces](#generic-functional-interfaces)
- [Method References](#method-references)
- [Predefined Functional Interfaces](#predefined-functional-interfaces)

## Functional Interfaces and Lambda Expressions

### Overview
Functional interfaces are interfaces with a single abstract method that serve as the foundation for lambda expressions in Java 8. Lambda expressions provide a concise way to implement these interfaces without creating anonymous inner classes. This approach enables functional programming in Java, allowing methods to be treated as first-class citizens and passed as parameters.

### Key Concepts/Deep Dive

#### Traditional Approach vs Functional Programming
In traditional programming, implementing operations like addition, subtraction, multiplication, and division required separate classes and objects. Functional interfaces eliminate this overhead by allowing direct implementation through lambda expressions.

**Old Style Implementation:**
```java
interface Add {
    int add(int a, int b);
}

class Addition implements Add {
    public int add(int a, int b) {
        return a + b;
    }
}

// Usage
Addition obj = new Addition();
int result = obj.add(10, 20);
```

**New Functional Programming Style:**
```java
@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);
}

public class FunctionalDemo {
    public static void main(String[] args) {
        Calculator addition = (a, b) -> a + b;
        Calculator subtraction = (a, b) -> a - b;
        Calculator multiplication = (a, b) -> a * b;
        Calculator division = (a, b) -> a / b;
        
        System.out.println("Addition: " + addition.calculate(10, 20));
        System.out.println("Subtraction: " + subtraction.calculate(20, 10));
        System.out.println("Multiplication: " + multiplication.calculate(10, 20));
        System.out.println("Division: " + division.calculate(20, 10));
    }
}
```

#### Lambda Expression Syntax
Lambda expressions use the arrow operator (`->`) to separate parameters from the body:

```diff
! Lambda Expression Syntax: (parameters) -> expression or { statements }
+ Basic lambda: (int a, int b) -> a + b
+ Shortcut (type inference): (a, b) -> a + b
+ With multiple statements: (a, b) -> {
+     int result = a + b;
+     System.out.println("Result: " + result);
+     return result;
+ }
+ Void lambda: () -> System.out.println("Hello")
+ Single parameter: (x) -> x * x (or just x -> x * x)
```

## Generic Functional Interfaces

### Overview
Generic functional interfaces allow flexible implementation of operations on different data types using the same interface, eliminating the need for multiple specialized interfaces.

### Key Concepts/Deep Dive

#### Single Generic Interface for Multiple Operations
Instead of creating separate interfaces for each operation, use generics to make one interface serve multiple purposes:

```java
@FunctionalInterface
interface Arithmetic<T> {
    T operate(T a, T b);
}

public class GenericDemo {
    public static void main(String[] args) {
        // Integer operations
        Arithmetic<Integer> intAddition = (a, b) -> a + b;
        Arithmetic<Integer> intMultiplication = (a, b) -> a * b;
        
        System.out.println("Int Addition: " + intAddition.operate(10, 20));
        System.out.println("Int Multiplication: " + intMultiplication.operate(5, 6));
        
        // Double operations
        Arithmetic<Double> doubleAddition = (a, b) -> a + b;
        System.out.println("Double Addition: " + doubleAddition.operate(10.5, 20.7));
        
        // String operations
        Arithmetic<String> stringConcat = (a, b) -> a + b;
        System.out.println("String Concat: " + stringConcat.operate("Hello", " World"));
    }
}
```

#### Multiple Parameter Types
For operations requiring different input types:

```java
@FunctionalInterface
interface Transformer<T, U, R> {
    R transform(T input1, U input2);
}

public class TransformDemo {
    public static void main(String[] args) {
        Transformer<String, Integer, String> converter = (str, num) -> str + num;
        System.out.println(converter.transform("Age: ", 25)); // Output: Age: 25
    }
}
```

## Method References

### Overview
Method references provide a shorthand way to implement functional interfaces using existing methods, eliminating the need to write explicit lambda expressions when all you want to do is call an existing method.

### Key Concepts/Deep Dive

#### Static Method Reference
References a static method of a class:
```java
class MathUtils {
    static int square(int n) {
        return n * n;
    }
    
    static void printResult(int result) {
        System.out.println("Result: " + result);
    }
}

@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);
}

@FunctionalInterface
interface Printer {
    void print(int result);
}

public class StaticMethodRefDemo {
    public static void main(String[] args) {
        // Lambda expression
        Calculator lambdaCalc = (a, b) -> MathUtils.square(a);
        
        // Method reference (shorthand)
        Calculator methodRefCalc = MathUtils::square;
        
        // Using method reference for printing
        Printer printer = MathUtils::printResult;
        
        int result = methodRefCalc.calculate(5, 0); // Ignores second parameter
        printer.print(result); // Output: Result: 25
    }
}
```

#### Instance Method Reference
References an instance method through an object:
```java
class Calculator {
    public int add(int a, int b) {
        return a + b;
    }
    
    public int multiply(int a, int b) {
        return a * b;
    }
}

@FunctionalInterface
interface Operation {
    int perform(int a, int b);
}

public class InstanceMethodRefDemo {
    public static void main(String[] args) {
        Calculator calc = new Calculator();
        
        // Lambda expression
        Operation lambdaAdd = (a, b) -> calc.add(a, b);
        
        // Method reference
        Operation methodRefAdd = calc::add;
        Operation methodRefMultiply = calc::multiply;
        
        System.out.println("Addition: " + methodRefAdd.perform(10, 20));
        System.out.println("Multiplication: " + methodRefMultiply.perform(5, 6));
    }
}
```

#### Constructor Reference
References a constructor for object creation:
```java
class Employee {
    private String name;
    private int id;
    
    public Employee() {
        this.name = "Default";
        this.id = 0;
    }
    
    public Employee(String name, int id) {
        this.name = name;
        this.id = id;
    }
    
    // Getters...
}

@FunctionalInterface
interface EmployeeFactory {
    Employee create(String name, int id);
}

public class ConstructorRefDemo {
    public static void main(String[] args) {
        // Lambda expression for constructor
        EmployeeFactory lambdaFactory = (name, id) -> new Employee(name, id);
        
        // Constructor reference
        EmployeeFactory constructorRefFactory = Employee::new;
        
        Employee emp = constructorRefFactory.create("John Doe", 12345);
        System.out.println("Employee created: " + emp.getName());
    }
}
```

#### Method Reference with Built-in Methods
Using method references with existing Java methods:
```java
import java.util.Arrays;

public class BuiltinMethodRefDemo {
    public static void main(String[] args) {
        String[] names = {"Alice", "Bob", "Charlie", "David"};
        
        // Lambda expression
        Arrays.sort(names, (a, b) -> a.compareTo(b));
        
        // Method reference (equivalent)
        Arrays.sort(names, String::compareTo);
        
        // Printing with method reference
        Arrays.stream(names).forEach(System.out::println);
    }
}
```

## Predefined Functional Interfaces

### Overview
Java 8 provides 43+ predefined functional interfaces in the `java.util.function` package to support common functional programming patterns without requiring custom interface creation.

### Key Concepts/Deep Dive

#### Core Functional Interfaces
The four main categories of predefined functional interfaces:

1. **Consumer<T>** - Consumes a value, returns void
2. **Supplier<T>** - Supplies a value, no parameters
3. **Function<T, R>** - Takes input, returns output
4. **Predicate<T>** - Tests condition, returns boolean

**Consumer Examples:**
```java
import java.util.function.Consumer;

public class ConsumerDemo {
    public static void main(String[] args) {
        Consumer<String> printUpper = str -> System.out.println(str.toUpperCase());
        Consumer<String> printLower = str -> System.out.println(str.toLowerCase());
        
        // Method reference
        Consumer<String> methodRefPrint = System.out::println;
        
        printUpper.accept("hello");
        printLower.accept("WORLD");
        methodRefPrint.accept("Direct print");
    }
}
```

**Supplier Examples:**
```java
import java.util.function.Supplier;
import java.util.Random;

public class SupplierDemo {
    public static void main(String[] args) {
        Supplier<Double> randomValue = () -> Math.random();
        Supplier<String> currentTime = () -> java.time.LocalTime.now().toString();
        Supplier<Integer> randomInt = () -> new Random().nextInt(100);
        
        System.out.println("Random: " + randomValue.get());
        System.out.println("Time: " + currentTime.get());
        System.out.println("Random Int: " + randomInt.get());
    }
}
```

**Function Examples:**
```java
import java.util.function.Function;

public class FunctionDemo {
    public static void main(String[] args) {
        Function<String, Integer> stringLength = str -> str.length();
        Function<Integer, String> intToString = num -> String.valueOf(num);
        Function<String, String> toUpper = str -> str.toUpperCase();
        
        // Method reference
        Function<String, Integer> methodRefLength = String::length;
        
        System.out.println("Length: " + stringLength.apply("Hello"));
        System.out.println("Converted: " + intToString.apply(123));
        System.out.println("Upper: " + toUpper.apply("hello"));
    }
}
```

**Predicate Examples:**
```java
import java.util.function.Predicate;

public class PredicateDemo {
    public static void main(String[] args) {
        Predicate<String> isEmpty = str -> str.isEmpty();
        Predicate<String> startsWithH = str -> str.startsWith("H");
        Predicate<Integer> isEven = num -> num % 2 == 0;
        
        System.out.println("'Hello' starts with H: " + startsWithH.test("Hello"));
        System.out.println("'World' starts with H: " + startsWithH.test("World"));
        System.out.println("4 is even: " + isEven.test(4));
        System.out.println("5 is even: " + isEven.test(5));
    }
}
```

#### Special Functional Interfaces
Two-parameter versions and operator interfaces:

**BiConsumer, BiFunction, BiPredicate:**
```java
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.BiPredicate;

public class BiFunctionalDemo {
    public static void main(String[] args) {
        BiConsumer<String, String> concatAndPrint = (a, b) -> System.out.println(a + b);
        BiFunction<Integer, Integer, Double> divide = (a, b) -> (double) a / b;
        BiPredicate<String, String> areEqual = (a, b) -> a.equals(b);
        
        concatAndPrint.accept("Hello ", "World");
        System.out.println("Division result: " + divide.apply(10, 3));
        System.out.println("Are equal: " + areEqual.test("Java", "Java"));
    }
}
```

**UnaryOperator and BinaryOperator:**
```java
import java.util.function.UnaryOperator;
import java.util.function.BinaryOperator;

public class OperatorDemo {
    public static void main(String[] args) {
        UnaryOperator<String> toUpperCase = str -> str.toUpperCase();
        UnaryOperator<Integer> square = num -> num * num;
        
        BinaryOperator<Integer> sum = (a, b) -> a + b;
        BinaryOperator<String> concat = (a, b) -> a + b;
        
        System.out.println("Upper: " + toUpperCase.apply("hello"));
        System.out.println("Square: " + square.apply(5));
        System.out.println("Sum: " + sum.apply(10, 20));
        System.out.println("Concat: " + concat.apply("Hello ", "World"));
    }
}
```

## Summary

### Key Takeaways
```diff
+ Functional interfaces enable functional programming in Java by providing single abstract methods
+ Lambda expressions offer concise syntax for implementing functional interfaces
+ Generic functional interfaces support type-safe operations across different data types
+ Method references provide shorthand notation for existing method calls in lambda expressions
- Avoid creating multiple specialized interfaces when generics can unify them
- Method reference syntax requires careful attention to static vs instance methods and constructor references
```

### Expert Insight

#### Real-world Application
In modern Java enterprise applications, functional interfaces power the Stream API extensively. For example, filtering Collections:

```java
import java.util.List;
import java.util.stream.Collectors;

public class RealWorldExample {
    public static void main(String[] args) {
        List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "David");
        
        // Using Predicate to filter names starting with 'A'
        List<String> filteredNames = names.stream()
            .filter(name -> name.startsWith("A")) // Predicate implementation
            .collect(Collectors.toList());
            
        // Using Consumer to print results
        filteredNames.forEach(System.out::println); // Consumer implementation
    }
}
```

#### Expert Path
Master functional interfaces by understanding their contract-first design. Study the `java.util.function` package deeply, particularly how interfaces like `Comparator` now leverage generics and method references. Practice converting anonymous inner classes to lambda expressions, then to method references for maximum code readability.

#### Common Pitfalls
- **Type Inference Issues**: Lambda parameters may lose explicit types, causing compilation errors in complex expressions
- **Variable Capture Confusion**: Local variables referenced in lambdas must be effectively final
- **Method Reference Ambiguity**: When multiple overloaded methods exist, ensure parameter matching is exact
- **Performance Overhead**: Lambdas create objects; excessive use in tight loops can impact performance
- **Null Pointer Exceptions**: Method references on potentially null objects can cause runtime errors

#### Lesser Known Aspects
Java provides specialized functional interfaces for primitives like `IntConsumer`, `LongSupplier`, etc., avoiding autoboxing overhead in performance-critical code. The `@FunctionalInterface` annotation is optional but recommended for clarity and compile-time verification. Functional interfaces support default methods (Java 8) and private methods (Java 9+), enabling richer abstractions while maintaining the single abstract method contract for lambda compatibility.
