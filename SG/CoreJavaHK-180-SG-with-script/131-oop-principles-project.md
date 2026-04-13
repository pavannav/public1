# Session 131: OOP Principles PROJECT

**Table of Contents**
- [OOP Principles PROJECT](#oop-principles-project)
  - [Overview](#overview)
  - [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
    - [Interface and Implementation](#interface-and-implementation)
    - [Has-a Relationship and Aggregation](#has-a-relationship-and-aggregation)
    - [Reflection API for Dynamic Loading](#reflection-api-for-dynamic-loading)
    - [Runtime Polymorphism (LCRP Architecture)](#runtime-polymorphism-lcrp-architecture)
    - [Exception Handling](#exception-handling)
    - [Project Structure and Flow](#project-structure-and-flow)
  - [Code/Config Blocks](#codeconfig-blocks)
  - [Lab Demos](#lab-demos)

## OOP Principles PROJECT

### Overview

This session implements a comprehensive Object-Oriented Programming (OOP) project demonstrating core principles: Abstraction, Inheritance, Polymorphism, and Encapsulation. The project models a mobile phone with different SIM card types (AEL, BSNL, VI, GI) using an interface-based design. Key features include dynamic SIM loading via Reflection API, runtime polymorphism, and user interaction through a console-based mobile screen. The project showcases LCRP (Loose Coupling Runtime Polymorphism) architecture where mobile can use any SIM subtype at runtime without code changes.

### Key Concepts/Deep Dive

#### Interface and Implementation
- **Interface as Contract**: The `Sim` interface defines operations (call, SMS) that all SIM implementations must provide
- **Abstract Methods**: Interface methods are implicitly public and abstract, forcing subclasses to implement them
- **Multiple Inheritance**: Interfaces support multiple inheritance, unlike abstract classes
- **Access Modifiers**: All interface members are public by default

#### Has-a Relationship and Aggregation
- **Mobile-SIM Relationship**: Mobile contains SIM via composition ("has-a" relation)
- **Runtime SIM Insertion**: SIMs are inserted dynamically via method calls, not at compile time
- **Aggregation Benefits**: Allows component reuse and runtime flexibility

#### Reflection API for Dynamic Loading
- **Dynamic Class Loading**: `Class.forName()` loads classes at runtime by name
- **Instantiating Objects**: `newInstance()` creates objects from loaded classes
- **JVM Architecture Context**: Demonstrates method area, heap, and stack usage
- **Parent Delegation Model**: Class loaders follow hierarchy for security

#### Runtime Polymorphism (LCRP Architecture)
- **Loose Coupling**: Mobile works with any SIM implementation without modification
- **Dynamic Method Resolution**: JVM resolves method calls at runtime based on actual object type
- **Inheritance Hierarchy**: Interface → Concrete Classes (AEL, BSNL, VI, GI)
- **Method Overriding**: Each SIM provides unique implementation of call/SMS

#### Exception Handling
- **ClassNotFoundException**: Thrown when specified class file doesn't exist
- **InstantiationException**: Thrown when no-parameter constructor unavailable
- **IllegalAccessException**: Thrown when constructor/private access issues
- **IllegalArgumentException**: Application-level validation exceptions
- **Try-Catch Blocks**: Comprehensive error handling in reflection operations

#### Project Structure and Flow
- **Three-Tier Architecture**: Sim (interface) → Mobile (user) → MobileScreen (UI)
- **Infinite Loop**: MobileScreen provides continuous operation until exit
- **Scanner Input**: Handles user interaction for SIM selection and operations
- **Encapsulation**: Each class has single responsibility
- **High Cohesion**: Related operations grouped together

### Code/Config Blocks

#### Sim Interface
```java
interface Sim {
    String call(long mobileNumber);
    String sms(long mobileNumber, String message);
}
```

#### AEL Implementation
```java
class AEL implements Sim {
    @Override
    public String call(long mobileNumber) {
        return "AEL: The number you are calling is busy.";
    }

    @Override
    public String sms(long mobileNumber, String message) {
        return "AEL: Message sent successfully.";
    }
}
```

#### BSNL Implementation
```java
class BSNL implements Sim {
    @Override
    public String call(long mobileNumber) {
        return "BSNL: All lines are busy. Please try after some time.";
    }

    @Override
    public String sms(long mobileNumber, String message) {
        return "BSNL: Message sent successfully.";
    }
}
```

#### VI Implementation
```java
class VI implements Sim {
    @Override
    public String call(long mobileNumber) {
        return "VI: The number you are calling is unreachable.";
    }

    @Override
    public String sms(long mobileNumber, String message) {
        return "VI: Message sent successfully.";
    }
}
```

#### GI Implementation (Added as Enhancement)
```java
class GI implements Sim {
    @Override
    public String call(long mobileNumber) {
        return "GI: The number you are calling is switched off.";
    }

    @Override
    public String sms(long mobileNumber, String message) {
        return "GI: Message sent successfully.";
    }
}
```

#### Mobile Class
```java
class Mobile {
    private Sim sim;

    public void insertSim(String simName) throws ClassNotFoundException,
                                                  InstantiationException,
                                                  IllegalAccessException,
                                                  IllegalArgumentException {
        Class<?> cls = Class.forName(simName);
        Object obj = cls.newInstance();

        if (obj instanceof Sim) {
            this.sim = (Sim) obj;
        } else {
            throw new IllegalArgumentException(simName + " is not a SIM object.");
        }
    }

    public String call(long mobileNumber) {
        if (sim == null) {
            return "No SIM inserted";
        }
        return sim.call(mobileNumber);
    }

    public String sms(long mobileNumber, String message) {
        if (sim == null) {
            return "No SIM inserted";
        }
        return sim.sms(mobileNumber, message);
    }
}
```

#### MobileScreen (User Interface)
```java
import java.util.Scanner;

class MobileScreen {
    public static void main(String[] args) {
        Scanner scn = new Scanner(System.in);
        Mobile iPhone = new Mobile();

        while (true) {
            try {
                System.out.print("Enter SIM: ");
                String simName = scn.next();

                iPhone.insertSim(simName);
                System.out.println("SIM is successfully activated.");

                while (true) {
                    System.out.println("Choose one option:");
                    System.out.println("1. Call");
                    System.out.println("2. SMS");
                    System.out.println("3. Exit");
                    System.out.print("Enter option: ");

                    int option = scn.nextInt();

                    switch (option) {
                        case 1:
                            System.out.print("Enter mobile number: ");
                            long mobileNumber = scn.nextLong();
                            String callResponse = iPhone.call(mobileNumber);
                            System.out.println(callResponse);
                            break;
                        case 2:
                            System.out.print("Enter mobile number: ");
                            long smsMobileNumber = scn.nextLong();
                            scn.nextLine(); // Consume newline
                            System.out.print("Enter message: ");
                            String message = scn.nextLine();
                            String smsResponse = iPhone.sms(smsMobileNumber, message);
                            System.out.println(smsResponse);
                            break;
                        case 3:
                            System.out.println("Mobile shut down.");
                            System.exit(0);
                            break;
                        default:
                            System.out.println("Invalid option.");
                    }
                }

            } catch (ClassNotFoundException e) {
                System.out.println("Class not found: " + e.getMessage());
            } catch (InstantiationException e) {
                System.out.println("Instantiation failed: " + e.getMessage());
            } catch (IllegalAccessException e) {
                System.out.println("Illegal access: " + e.getMessage());
            } catch (IllegalArgumentException e) {
                System.out.println("Invalid SIM: " + e.getMessage());
            } catch (Exception e) {
                System.out.println("Error: " + e.getMessage());
            }
        }
    }
}
```

### Lab Demos

#### Lab 1: SIM Insertion and Validation
1. Compile all SIM classes (AEL.java, BSNL.java, VI.java, GI.java)
2. Compile Mobile.java and MobileScreen.java
3. Run MobileScreen
4. Input: "AEL"
5. Expected output: "SIM is successfully activated."
6. This demonstrates dynamic loading and instantiation using Reflection API

#### Lab 2: Runtime Polymorphism (Call Operation)
1. After SIM insertion, choose option 1
2. Input mobile number: 986979432 (example)
3. Expected output varies by SIM:
   - AEL: "AEL: The number you are calling is busy."
   - BSNL: "BSNL: All lines are busy. Please try after some time."
   - VI: "VI: The number you are calling is unreachable."
   - GI: "GI: The number you are calling is switched off."

#### Lab 3: SMS Operation with Runtime Polymorphism
1. After SIM insertion, choose option 2
2. Input mobile number: 986979432
3. Input message: "Hello"
4. Expected output: "[SIM_NAME]: Message sent successfully."
5. This shows polymorphism where the same method call invokes different implementations

#### Lab 4: Exception Handling Scenarios
1. Input a non-existent class like "InvalidSim"
   - Expected: "Class not found: InvalidSim"
2. Input "Student" (non-SIM class)
   - Expected: "Invalid SIM: Student is not a SIM object."
3. Add a parameterized constructor to a SIM class and try insertion
   - Expected: InstantiationException due to no no-arg constructor

#### Lab 5: Project Enhancement (Adding New SIM)
1. Create new class GI.java implementing Sim
2. Compile GI.java
3. Run MobileScreen
4. Input: "GI"
5. System works without modifying Mobile or MobileScreen classes
6. Demonstrates extensibility through interface design

## Summary

### Key Takeaways
+ Interface-based design enables loose coupling and runtime polymorphism
- Reflection API enables dynamic class loading and instantiation
! Constructor availability and access modifiers crucial for reflection operations
? Project demonstrates real-world mobile-SIM relationship through aggregation

### Expert Insight

#### Real-world Application
This architecture mirrors real-world scenarios like payment gateways (different payment processors), database drivers (different database connections), and plugin systems (dynamic component loading). Enterprises use similar patterns for microservices communication and extensible frameworks.

#### Expert Path
Master reflection API for advanced frameworks. Study design patterns like Strategy, Factory, and Adapter that build upon this foundation. Learn JVM internals for deeper understanding of class loading mechanisms.

#### Common Pitfalls
- Forgetting to compile individual classes before runtime loading
- Missing no-argument constructors in reflection scenarios
- Unhandled reflection exceptions can crash applications
- Instanceof checks crucial when downcasting from Object

#### Lesser Known Things
- Class.forName() triggers static blocks during class loading
- Reflection bypasses compiler type checking for runtime flexibility
- Mobile's call/sms methods create abstraction barrier between user and implementation
- Interface constants are implicitly public static final
- Checked exceptions in reflection API require explicit handlingUnlike dynamic languages, Java reflection requires class compilation beforehand for .class files to exist.

**Transcript Corrections:** "subass" corrected to "subclass", "Sima" to "SIM", "aclass" to "class", "ril" removed from "mobile", "activatro" to "activated", "Insert SIM" capitalized consistently, "streaming" to "string".
