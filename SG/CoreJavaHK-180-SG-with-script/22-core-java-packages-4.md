# Session 22: Core Java Packages 4

## Table of Contents
- [Review of Packages Basics](#review-of-packages-basics)
- [Use of Packages](#use-of-packages)
- [Class Accessibility and Public Modifiers](#class-accessibility-and-public-modifiers)
- [Creating Packages](#creating-packages)
- [Project Folder Structure](#project-folder-structure)
- [Compilation and Execution](#compilation-and-execution)
- [Eclipse Demonstration](#eclipse-demonstration)

## Review of Packages Basics
### Overview
In the previous session, we covered the fundamentals of packages in Java, including what a package is, its advantages, whether it is mandatory, and how to create one. A package acts as a folder that groups related classes and interfaces, enabling better organization, access control, and naming resolutions. Key points included using the `javac -d` option to create package folders programmatically, setting the classpath, and different methods for classpath configuration.

### Key Concepts/Deep Dive
- **Package Definition and Usage**:
  - A package is a folder used for organizing related classes and interfaces.
  - Advantages include avoiding naming conflicts, managing code structure, and providing access control.
  - Packages are optional for basic programs but essential for larger projects.

- **Package Creation**:
  - Packages can be created manually or programmatically.
  - Programmatic creation uses the `javac -d` option, while manual creation involves folder setup.

- **Classpath Management**:
  - Classpath tells JVM where to find class files.
  - Methods include `-cp`, `-classpath`, setting environment variables, and command prompts.

### Lab Demo: Basic Package Creation Example
1. Create a Java file named `M.java`:
   ```java
   class P {
       public static void main(String[] args) {
           System.out.println("High");
       }
   }
   ```

2. Compile using `javac M.java` – this creates `M.class` and another `P.class`.
3. Run with `java P` – outputs "High".

**Notes**: Saved as `M.java` with `P.java` content to demonstrate class-file naming based on class names, not file names.

### Lesser Known Fact
Packages were introduced in Java to handle large codebases where class names might clash, particularly important in enterprise applications where multiple teams contribute to the same project.

## Use of Packages
### Overview
Packages serve multiple purposes: organizing related classes into groups, and resolving naming conflicts by allowing classes with identical names in different packages (e.g., `java.awt.List` vs. `java.util.List`). This segregation helps in maintaining code logic separation and enhances readability. Without packages, all classes would reside in the default package, leading to potential overlaps and maintenance issues.

### Key Concepts/Deep Dive
- **Organizing Classes**:
  - Packages allow grouping related classes, such as model classes or utility classes.
  - Example: A project with client, controller, and logic packages keeps code modular.

- **Solving Naming Conflicts**:
  - Enables classes with the same name in different packages (e.g., `P` in package `P4` and `P` in package `P5`).
  - Without packages, only one `P.class` can exist in a directory.

| Purpose | Description | Example |
|---------|-------------|---------|
| Organization | Groups related classes | Client-related classes in `client` package |
| Naming Resolution | Separates identically-named classes | `P` in different folders |
| Access Control | Restricts class visibility | Non-public classes accessible only within package |

### Lab Demo: Creating Packages with Same Class Name
1. Create package `P4` manually (right-click > New Folder > Name "P4").
2. Create `p.java` in `P4`:
   ```java
   package P4;
   public class P {
       public static void main(String[] args) {
           System.out.println("Hi");
       }
   }
   ```
3. Compile: `javac -d . P4/p.java` (creates folder and links package).
4. Create package `P5` manually.
5. Create `p.java` in `P5`:
   ```java
   package P5;
   public class P {
       public static void main(String[] args) {
           System.out.println("Hello");
       }
   }
   ```
6. Compile: `javac -d . P5/p.java`.
7. Run: `java P4.P` → Outputs "Hi"; `java P5.P` → Outputs "Hello".

> [!NOTE]  
> Packages resolve the issue of naming conflicts and organize multiple related classes effectively.

## Class Accessibility and Public Modifiers
### Overview
Class accessibility determines where a class can be accessed from. Non-public classes (default access) are only visible within their package, akin to private resources. Public classes are accessible everywhere within the classpath but must have the same name as their file. This ensures encapsulation and controlled sharing of code.

### Key Concepts/Deep Dive
- **Public vs. Default Access**:
  - Default classes: Accessible only within the package.
  - Public classes: Accessible across packages and projects.

- **Rules for Public Classes**:
  - File names must match the class name exactly.
  - Compiler enforces this to prevent mismatches.

### Lab Demo: Demonstrating Accessibility
1. Create a non-public class `privateClass` in a package – it cannot be accessed from another package.
2. Modify to `public class privateClass` and save as `privateClass.java`.
3. Attempt to access from another package – succeeds.

| Modifier | Accessibility | File Name Rule |
|----------|---------------|----------------|
| Default  | Within package only | Flexible |
| Public   | Anywhere in classpath | Must match class name |

### Lesser Known Fact
The file naming rule for public classes prevents confusion in large codebases where auto-renaming tools might mismanage references, enforcing clarity from the compilation stage.

## Creating Packages
### Overview
Packages can be created manually (by making folders) or programmatically (using `javac -d`). Manual creation suits saving Java files in dedicated folders, while programmatic creation helps separate .class files from source files during compilation. In projects, both are combined for efficient structuring.

### Key Concepts/Deep Dive
- **Manual Creation**: Right-click > New Folder > Assign package name in Java file.
- **Programmatic Creation**: Use `javac -d bin src/package/file.java` – creates package folders in `bin`.
- **When to Use**:
  - Manual: For saving .java files in separate folders.
  - Programmatic: For generating .class files in another directory.

### Lab Demo: Combined Manual and Programmatic Creation
1. Create folder `Project` > `src` > `client` (manual).
2. Place `Login.java` in `client` with `package client;`.
3. Compile: `javac -d bin src/client/Login.java` (programmatic – creates `bin/client/`).
4. Folders `src/client/` (source) and `bin/client/` (.class) now separate organization.

> [!IMPORTANT]  
> Mixing both methods avoids conflicts and streamlines project maintenance.

## Project Folder Structure
### Overview
Effective project structures use `src` for source files and `bin` for compiled files. This separation prevents mixing .java and .class files, eases cleanup, and mimics industry standards. In companies, tools like Eclipse automate this, but manual understanding is crucial for debugging and custom builds.

### Key Concepts/Deep Dive
- **Standard Folders**:
  - `src`: Contains package folders with .java files.
  - `bin`: Contains compiled .class files in package structure.
- **Benefits**: Easy deletion of .class files (remove `bin`), clear organization.

| Folder | Contents | Purpose |
|--------|----------|---------|
| src    | .java files in packages | Source code organization |
| bin    | .class files in packages | Execution-ready files |

### Lab Demo: Setting Up HRMS Project Structure
1. Create `HRMS` folder > `src` folder > `client` subfolder.
2. Inside `src/client/`, place `Login.java`:
   ```java
   package client;
   public class Login {
       public static void main(String[] args) {
           System.out.println("Welcome to HRMS");
       }
   }
   ```
3. Create `bin` folder.
4. Compile: `javac -d bin src/client/Login.java`.
5. Structure: `src/client/Login.java` and `bin/client/Login.class`.

## Compilation and Execution
### Overview
Compilation involves specifying source paths and destination directories. Execution requires classpath setup to locate packages. In projects, this supports modular architecture without manual path management clutter.

### Key Concepts/Deep Dive
- **Compilation Command**: `javac -d bin src/package/*.java`.
- **Execution**: `java -cp bin package.ClassName` or `set classpath=bin; %classpath%`.
- **Batch Compilation**: Use `*.java` to compile multiple files from a package.

### Lab Demo: Full Cycle Compilation and Execution
1. In `HRMS` folder, run `javac -d bin src/client/Login.java`.
2. Execute: `java -cp bin client.Login` → Outputs "Welcome to HRMS".
3. For multiple files in `client`, use `javac -d bin src/client/*.java`.

> [!NOTE]  
> Always specify `-d` for .class file separation to maintain clean structures.

## Eclipse Demonstration
### Overview
IDE tools like Eclipse automate package and project management, internally using the commands taught manually. This visualization helps understand automation while reinforcing foundational concepts. Eclipse creates `src` and `bin` implicitly, handles compilation, and executes via GUI buttons.

### Key Concepts/Deep Dive
- **Eclipse Automation**: Creates `src` and `bin` on project setup.
- **Background Commands**: Eclipse runs `javac -d bin src/...` and `java -cp bin ...`.
- **Benefits**: Speeds up development but requires manual knowledge for troubleshooting.

### Lab Demo: Eclipse HRMS Project
1. Create Java project "HRMS" (Eclipse auto-creates `src` and `bin`).
2. Right-click `src` > New Package > "client".
3. Right-click `client` > New Class > "Login" with main method.
4. Edit code with `System.out.println("Welcome to Nar");`.
5. Click "Run" → Outputs without manual commands.

### Lesser Known Fact
Eclipse's "Run" feature uses classpath internally, but manual setup skills are vital for CI/CD pipelines or script-based deployments where IDEs aren't present.

## Summary

### Key Takeaways
```diff
+ Packages organize and group related classes for better maintainability.
- Without packages, naming conflicts occur, limiting scalability.
+ Public classes must have file names matching the class name.
- Non-public classes are inaccessible outside their package.
+ Manual package creation suits source organization; programmatic suits compilation.
! Use 'src' for .java and 'bin' for .class to separate concerns.
```

### Expert Insight

**Real-world Application**: In enterprise projects (e.g., using Spring or microservices), packages structure code by layers (controller, service, model), enabling modular deployments and easier testing. For example, separating UI logic from data access prevents cross-coupling issues in large teams.

**Expert Path**: Master manual setup first, then automate with build tools like Maven or Gradle. Dive into classpath nuances for external libraries execution – practice JAR creation and manifest files for distribution.

**Common Pitfalls**: 
- Mixing .java and .class in the same directory leads to accidental commitments or deletions – resolution: Always use `src` and `bin`; avoid with version control ignores (.gitignore for `bin/*`).
- Ignoring public class naming rules causes compiler errors – resolution: Rename files to match; automate with IDEs.
- Misusing `javac -d` without destination conflicts with existing packages – avoid by verifying folder structures first.

**Lesser Known Things**: Packages can include subpackages (e.g., `com.example.util`), aiding hierarchical organization; in modular Java (since Java 9), `module-info.java` enhances package isolation beyond simple folder separation.banner. Eclipse is open-source, allowing custom builds for scripted environments.
