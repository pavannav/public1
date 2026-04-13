# Session 14: Core Java Essential Programming Elements 1

## Table of Contents
- [MVC and LCR(R)P Architecture](#mvc-and-lcrp-architecture)
- [Common Terminology Used in Programming Languages](#common-terminology-used-in-programming-languages)
- [Why Java and History](#why-java-and-history)
- [Features of Java](#features-of-java)
- [Platform Dependency and Independence](#platform-dependency-and-independence)
- [Important Facts about Java Program and Software](#important-facts-about-java-program-and-software)
- [Differences between JDK, JRE, and JVM](#differences-between-jdk-jre-and-jvm)
- [Java Versions and Editions History](#java-versions-and-editions-history)
- [Installing JDK and Folder Structure](#installing-jdk-and-folder-structure)
- [JDK Version Changes (JDK 9 to JDK 11)](#jdk-version-changes-jdk-9-to-jdk-11)
- [Setting Java Home Path, Class Path](#setting-java-home-path-class-path)
- [Module Concept from Java 9](#module-concept-from-java-9)
- [Softwares Required to Develop Java Programs](#softwares-required-to-develop-java-programs)
- [Basic Java Programming Elements and Their Purpose](#basic-java-programming-elements-and-their-purpose)
- [Comparison Between Java Elements and Speaking Language Constructs](#comparison-between-java-elements-and-speaking-language-constructs)
- [What is Programming](#what-is-programming)

## MVC and LCR(R)P Architecture

### Overview
MVC (Model-View-Controller) and LCRP (likely Layered or Comparable architecture patterns) are software design patterns that organize application code into distinct layers or components for better maintainability and separation of concerns. These were mentioned as pending topics from previous sessions.

### Key Concepts/Deep Dive
#### MVC Architecture
- **Model**: Represents the data and business logic. Handles data retrieval, manipulation, and validation.
- **View**: The user interface layer. Displays data to users and captures user input, but contains no business logic.
- **Controller**: Acts as an intermediary between Model and View. Processes user input, updates the Model, and instructs the View to render changes.
- **Usage**: Commonly used in web applications to separate presentation, business logic, and data handling.

#### LCRP Architecture
This appears to be a reference to layered architecture patterns or similar design principles in Java development, possibly referring to N-Tier or Layered Repository Pattern (LCRP could be a typo or acronym for Layered Repository Pattern). The exact acronym wasn't fully explained in this transcript, as it was marked as pending for discussion.

### Lab Demos
No specific lab demos were conducted in this session for these topics.

## Common Terminology Used in Programming Languages

### Overview
Programming languages share common conceptual elements with human communication, particularly speaking languages. This session draws parallels to help beginners understand programming constructs.

### Key Concepts/Deep Dive
#### Parallel with Speaking Languages
- Speaking languages have elements like letters (characters), words (reserved keywords), sentences (statements), grammar (syntax), paragraphs (logic), papers (programs), and books (projects or applications).
- In programming languages:
  - **Letters**: Characters forming the alphabet (e.g., a-z, A-Z, 0-9, symbols).
  - **Words**: Reserved words (keywords) with predefined meanings.
  - **Sentences**: Statements that perform actions.
  - **Grammar/Syntax**: Rules for writing correct code.
  - **Paragraphs**: Logical blocks of code.
  - **Programs/Papers**: Collection of code solving a problem.
  - **Projects/Applications/Books**: Large-scale software solutions.
- Java supports 64+ reserved words (keywords) for specific language features.

#### Finite vs. Infinite Elements in Languages
- Speaking languages: Infinite words and constructs, adaptable.
- Programming languages: Finite core elements; e.g., Java has 8 main programming elements compared to infinite possibilities in human languages, making it simpler.

> [!NOTE]
> Understanding this parallel helps demystify programming: it's not "magic" but structured communication with machines.

#### Count of Core Elements
- In English: ~26 letters, infinite words.
- In Java: 8 main programming elements, 64 keywords — making core learning manageable.

### Code/Config Blocks
- Example of a simple Java keyword usage:
  ```java
  public class HelloWorld {
      public static void main(String[] args) {
          System.out.println("Hello World!");
      }
  }
  ```

> [!IMPORTANT]
> True Java learning involves mastering these 8 elements and 64 keywords, not just memorizing code snippets.

## Why Java and History

### Overview
Java is a programming language developed by Sun Microsystems (now Oracle) to enable platform-independent, object-oriented programming. It was created in the 1990s to overcome limitations of languages like C++.

### Key Concepts/Deep Dive
- **Why Java?**: Designed for portability, security, and simplicity. It's "write once, run anywhere" (WORA) across multiple platforms.
- **Not Others**: Unlike C/C++ (platform-dependent), Java compiles to bytecode that runs on any JVM-installed machine.
- **History**: Started in 1991 as the Green Project for embedded systems. Released publicly in 1995. Versions evolved regularly to add features like modules and modern APIs.

### Tables
| Language | Platform Dependency | Reasoning |
|----------|---------------------|-----------|
| C/C++    | High                | Direct hardware access; no bytecode layer |
| Java     | Low                 | JVM interprets bytecode, enabling independence |

## Features of Java

### Overview
Java's core features make it versatile for developing robust, scalable applications across domains like web, mobile, and enterprise.

### Key Concepts/Deep Dive
- **Platform Independence**: Code runs on any OS with JVM.
- **Object-Oriented**: Everything is an object, promoting reusability.
- **Simple**: No pointers or multiple inheritance complexities.
- **Secure**: Sandboxed execution in JVM.
- **Multithreaded**: Supports concurrent processing.
- **Distributed**: Built-in networking support.
- Others: Automatic memory management (garbage collection), portability.

#### Real-World Application
Used in Android apps, enterprise software (e.g., banking systems), and web servers.

## Platform Dependency and Independence

### Overview
Platform dependency means code works only on specific OS/hardware. Java achieves independence via bytecode and JVM.

### Key Concepts/Deep Dive
- **Dependent (C/C++)**: Binaries tie to OS architecture; need recompilation for different systems.
- **Independent (Java)**: Source compiles to bytecode (.class), interpreted by JVM—an abstraction layer.
- Java just-in-time (JIT) compiler optimizes bytecode for the host platform dynamically.

### Diagrams
```mermaid
flowchart TD
    A[Source Code] --> B[Java Compiler]
    B --> C[Bytecode (.class)]
    C --> D[JVM Interpreter for Windows]
    C --> E[JVM Interpreter for Linux]
    C --> F[JVM Interpreter for Mac]
```

> [!EXPERT]
> Bytecode bridges platform gaps, but requires JVM installation—non-issue in modern environments.

## Important Facts about Java Program and Software

### Overview
Java distinguishes between programs (sources) and software (compiled/deployed), integrating with libraries via APIs.

### Key Concepts/Deep Dive
- **Java Program**: Human-readable source code (.java files).
- **Java Software**: Compiled bytecode, executed with JVM/JRE.
- **Predefined APIs**: "Library" of reusable code (classes/methods) included in JDK.
- **Sun Microsystems' Contribution**: Core API libraries bundled with JDK for developer productivity.

#### Differences
- Program: Editable source.
- Software: Deployable, including libraries.

## Differences between JDK, JRE, and JVM

### Overview
JDK (development kit), JRE (runtime environment), and JVM (virtual machine) are core components for Java development and execution.

### Key Concepts/Deep Dive
- **JDK**: Includes JRE, compiler (javac), and tools (javap, javadoc). For developers.
- **JRE**: Includes JVM and precompiled libraries. For end-users running Java apps.
- **JVM**: Executes bytecode; provides runtime environment (e.g., memory management, garbage collection).

### Tables
| Component | Purpose                  | Included Tools | Usage |
|-----------|--------------------------|----------------|-------|
| JDK       | Development              | javac, javap   | Code writing/compilation |
| JRE       | Deployment/Execution     | Libraries      | Running applications |
| JVM       | Bytecode Execution       | HotSpot, etc.  | Platform abstraction |

> [!TIP]
> Use JDK to build, JRE to run apps on target machines.

## Java Versions and Editions History

### Overview
Java evolved through Standard, Enterprise, Micro, and FX editions, with regular version releases adding features.

### Key Concepts/Deep Dive
- **Editions**: SE (Standard), EE (Enterprise for large-scale apps), ME (Micro for devices), FX (rich clients).
- **Version Progression**: 1.0 (1995) to 21+ currently. Each adds APIs, performance enhancements.
- **Key Milestones**: Generics (Java 5), Lambda (8), Modules (9).

#### Java 11 Changes
- Long-term support (LTS) release with improvements in performance and security.

## Installing JDK and Folder Structure

### Overview
Installing JDK sets up the environment for Java development, including essential folders for tools and runtime.

### Key Concepts/Deep Dive
- **Process**: Download from Oracle/AdoptOpenJDK, run installer.
- **Folder Structure**: /bin (tools like javac, java), /lib (libraries), /include (native headers), /jre (runtime subset).

### Lab Demos
1. Download JDK from Oracle site (e.g., JDK 11).
2. Install and verify: Open terminal, run `java -version` to confirm.
3. Explore bin folder: Command `dir` (Windows) or `ls` (Linux/Mac) in JDK/bin to list tools.

```bash
# Verify installation
java -version
```

## JDK Version Changes (JDK 9 to JDK 11)

### Overview
JDK 9-11 introduced modules, removed embedded JRE, and shifted to modular architecture for cleaner deployments.

### Key Concepts/Deep Dive
- **Version Number Change**: JDK 9, 10, 11 (no more 1.x, e.g., 1.8 dropped).
- **Folder Structure Change**: Modular JARs; runtime images.
- **64-bit Only**: 64-bit JVM from JDK 9+; no 32-bit support.
- **JRE Changes**: Public JRE removed; JDK contains runtime. Private JRE virtualized.

> [!IMPORTANT]
> Migration from JDK 8 requires module descriptor (module-info.java) for JDK 9+.

## Setting Java Home Path, Class Path

### Overview
Environment variables inform the OS where JDK tools and libraries reside, enabling cross-directory access.

### Key Concepts/Deep Dive
- **JAVA_HOME**: Points to JDK root (e.g., C:\Program Files\Java\jdk-11).
- **PATH**: Includes %JAVA_HOME%\bin for tool access anywhere.
- **CLASSPATH**: Directories/packages for custom JARs/libraries.

### Lab Demos
1. Locate JDK path (e.g., C:\Program Files\Java\jdk-11\bin).
2. Set permanently: Windows > Environment Variables > New > Paste bin path, restart CMD.
3. Test: `javac -version` and `java -version` from any directory.

```bash
# On Windows
set JAVA_HOME=C:\Program Files\Java\jdk-11
set PATH=%PATH%;%JAVA_HOME%\bin
```

> [!WARNING]
> Temp paths reset on CMD close; use System/Advanced Settings for permanence.

## Module Concept from Java 9

### Overview
Modules encapsulate related code, improving scalability and security by declaring dependencies explicitly.

### Key Concepts/Deep Dive
- **Module Descriptor**: module-info.java declares module name, exports, requires.
- **MODULEPATH**: Replaces/exists alongside classpath for modules.
- **Benefits**: Strong encapsulation, reduced JAR conflicts.

### Code/Config Blocks
Example module-info.java:
```java
module com.example.myapp {
    exports com.example.api;
    requires java.base;
}
```

## Softwares Required to Develop Java Programs

### Overview
Java development needs an editor (for writing), JDK (for compilation/execution), and command prompt (for running tools).

### Key Concepts/Deep Dive
- **Editor Software**: Notepad, Eclipse, IntelliJ—any text editor for .java files.
- **JDK**: Compiler (javac), JVM (java), APIs.
- **Command Prompt**: Shell for invoking tools (direct mode, not GUI).

#### Workflow
1. Edit: Type code in editor, save as Example.java.
2. Compile: `javac Example.java` (generates Example.class).
3. Run: `java Example`.

### Lab Demos
- Open Notepad, write simple class, save, compile via CMD, execute.

```bash
# Compile and run
javac HelloWorld.java
java HelloWorld
```

## Basic Java Programming Elements and Their Purpose

### Overview
Java has 8 core elements forming the building blocks of programs: module, package, class, variable, method, constructor, block, inner class. These enable object-oriented modeling of real-world entities.

### Key Concepts/Deep Dive
- **Module**: Groups packages for large projects.
- **Package**: Groups classes logically.
- **Class**: Blueprint for objects; groups variables/methods.
- **Variable**: Memory location for data storage.
- **Method**: Operations (behaviors) on objects.
- **Constructor**: Special method initializing objects.
- **Block**: Code groups (static/instance initialization).
- **Inner Class**: Nested classes representing sub-entities.

#### Purpose in OOP
- Represent real-world objects: Person, Animal, Bike, etc.
- Each element groups related code: Class binds data (variables) + behavior (methods).

### Tables
| Element      | Purpose                         | Grouping Level         |
|--------------|---------------------------------|------------------------|
| Module       | Package aggregator              | Highest                |
| Package      | Class organizer                 | Application level      |
| Class        | Object blueprint                | Instance level         |
| Variable     | Data representation             | Within classes         |
| Method       | Behavior                         | Within classes         |
| Constructor  | Initialization                  | Within classes         |
| Block        | Initialization blocks           | Within classes         |
| Inner Class  | Sub-object containers           | Within classes         |

## Comparison Between Java Elements and Speaking Language Constructs

### Overview
Drawing parallels between programming and human languages aids conceptualization: Java's elements map to language constructs.

### Key Concepts/Deep Dive
- **Letters**: Characters (8 elements: module..inner class).
- **Words**: Keywords (64 reserved words).
- **Sentences**: Statements (executable code).
- **Grammar**: Syntax (rules).
- **Paragraphs/Programs**: Logic grouped code.
- Java's finiteness (8 elements, 64 keywords) vs. infinite constructs in human languages makes it learnable.

> [!NOTE]
> Real-world visualization (e.g., person → hearing/operations) bridges the analogy.

## What is Programming

### Overview
Programming translates real-world objects into code, automating operations via object-oriented structures.

### Key Concepts/Deep Dive
- **Object-Oriented Paradigm**: Create objects (e.g., Person) with data (variables) and behaviors (methods).
- **Automation**: Bring real-world items into software for operations (deposit/withdraw for Bank objects).
- **Steps**: Identify objects → Create classes with variables/methods → Initialize via constructors/blocks.

#### Examples
- Person object: Variables (name, age), Methods (eat, sleep), Constructor (initialize).
- Bank: Variables (accountNo, balance), Methods (deposit, withdraw).

## Summary Section

### Key Takeaways
```diff
+ Java enables platform-independent programming through JVM and bytecode.
+ 8 core programming elements (module to inner class) form OOP foundation.
+ Parallels with speaking languages demystify coding.
+ JDK > JRE > JVM hierarchy: Develop with JDK, run with JRE via JVM.
+ Installation and paths enable environment-wide Java access.
- Avoid overthinking; visualize real-world objects in code.
! Security and memory management are JVM responsibilities.
+ Code: Follow structure - Module > Package > Class > Variables/Methods.
```

### Expert Insight
#### Real-world Application
Java powers Android apps, enterprise systems (e.g., banks using objects for accounts/transactions), and web services. OOP modeling ensures maintainable, scalable code—crucial for production deployments.

#### Expert Path
Master the 8 elements by coding daily; advanced topics build here (e.g., multithreading from JVM basics). Engage in projects: Start small (e.g., Person simulator) to large (e.g., modular e-commerce).

#### Common Pitfalls
- Confusing JDK/JRE usage; always use JDK for development.
- Forgetting CLASSPATH/modulePATH in Java 9+; leads to "ClassNotFoundException".
- Object mismatch: Ensure classes reflect real-world accurately.
- Lesser-known tip: Inner classes for tightly-coupled sub-objects improve encapsulation but can complicate debugging—use judiciously.

Mistakes and corrections in transcript: "hed Mohammad" → likely "Mr. Mohammad"; "Occpk bits" → "OCP bits"; "ujdk9" → "JDK 9"; "nadt" → "not"; "J Harper" → "Javadoc"; "strator" → "administrator". No major technical errors beyond typos.
