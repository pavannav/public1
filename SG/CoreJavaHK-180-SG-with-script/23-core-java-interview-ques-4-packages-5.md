# Session 23: Core Java Interview Ques 4 + Packages 5

## Table of Contents
- [Overview](#overview)
- [Creating Sub Packages](#creating-sub-packages)
- [Compilation and Execution of Sub Packages](#compilation-and-execution-of-sub-packages)
- [Package Naming Conventions](#package-naming-conventions)
- [Accessing Classes from Another Package](#accessing-classes-from-another-package)
- [Entry Questions on Packages](#entry-questions-on-packages)
- [Summary](#summary)

## Overview
This session covers the fifth part of the Packages chapter in Core Java, focusing on creating sub packages, package naming conventions, and accessing classes across packages. The instructor reviews Amir style (programmatic compilation) and Eclipse style (manual folder creation), explains folder structures, and covers fully qualified names and import statements as a preview for the next session.

> [!NOTE]
> This session assumes knowledge from previous sessions (1-4) on Packages. It emphasizes interview preparation with 60+ entry questions and practical demonstrations.

## Creating Sub Packages
### Overview
A sub package is a package created inside another package. Sub packages help organize related classes into hierarchical structures within a main package for better modularity.

### Key Concepts
Packages support nested structures where a parent package contains child (sub) packages. This mirrors file system organization, like storing FDA images in `photos/rdc/` or `photos/ramoosi/` subfolders.

#### Folder Structure for Sub Packages
When creating a sub package like `package p1.p2;`, the compiler generates:
- **Parent Package Folder**: `p1/` (created first)
- **Sub Package Folder**: `p2/` (inside `p1/`)
- **Class Files**: `.class` files are stored in the sub package folder (`p1/p2/`)

> [!IMPORTANT]
> The `.class` file name is fully qualified (e.g., `p1.p2.A.class`), and the constructor name matches it (e.g., `p1.p2.A()`).

#### Creating Sub Packages Programmatically (Amir Style)
Use `javac -d` option to create packages automatically during compilation.

**Code Example**:
```java
package p1.p2;

public class A {
  public static void main(String[] args) {
    System.out.println("a");  // Output: a
  }
}
```

- **Compile**: `javac A.java`
  - Compiler creates folders: `p1/` then `p1/p2/`, stores `p1.p2.A.class`
- **Execute**: `java p1.p2.A`

> [!WARNING]
> If you forget the `-d` option, folders aren't created, and execution fails with "wrong name" error.

#### Creating Sub Packages Manually (Eclipse Style)
1. Create parent folder (e.g., `P1`) manually.
2. Create subfolder (e.g., `P2`) inside `P1`.
3. Place `.java` file in subfolder (e.g., `P1/P2/A.java`).
4. **Compile**: `javac P1/P2/A.java`
5. **Execute**: `java p1.p2.A`

> [!NOTE]
> Manual creation is tedious; programmatic is preferred.

#### Project Design with SRC and BIN Folders
For better organization:
- Save `.java` files in `src/` folder.
- Compile `.class` files to `bin/` using `javac -d`.
- Set classpath: `set classpath=.;bin` or `java -cp bin p1.p2.A`

**Code Example** (Project Structure):
```
packages/
├── src/
│   └── p1/
│       └── p2/
│           └── A.java  // Contains package p1.p2; class A
└── bin/
    └── p1/
        └── p2/
            └── A.class  // Compiled here
```

- **Compile**: `javac -d bin src/p1/p2/A.java`
- **Execute**: `java -cp bin p1.p2.A`

> [!TIP]
> Use `src/` for source separation; avoid mixing `.java` and `.class` to prevent sharing issues.

## Compilation and Execution of Sub Packages
### Overview
Compilation and execution require correct path handling for sub packages due to the dot-separated qualified names.

### Key Concepts
- **Compilation**:
  - Use `javac` with full qualified path (e.g., `javac -d bin src/P1/P2/A.java`).
  - `-d` creates folders if missing (from Java 9 onwards).
- **Execution**:
  - Set classpath to the folder containing the root package.
  - Use dot notation for qualified name (e.g., `java p1.p2.A`).
  - Always execute from the parent directory of the root package folder.

| Style | Compilation Command | Execution Command | Notes |
|-------|---------------------|-------------------|-------|
| Amir | `javac A.java` | `java p1.p2.A` | Packages created automatically |
| Manual | `javac P1/P2/A.java` | `java p1.p2.A` | Folders created manually |
| Project | `javac -d bin src/P1/P2/A.java` | `java -cp bin p1.p2.A` | SRC/BIN separation |

> [!IMPORTANT]
> Compilation with `-d` (`javac -d bin A.java`) attaches the qualified name to the class file, enabling execution from the specified directory.

#### Multiple Sub Packages (Depth)
You can create deep hierarchies (e.g., `package p1.p2.p3;` creates `p1/p2/p3/`).
- **Compile**: `javac -d bin src/p1/p2/p3/A.java`
- **Execute**: `java -cp bin p1.p2.p3.A`

> [!WARNING]
> Avoid placing package statements anywhere except the first line, as it causes "class or interface expected" errors.

## Package Naming Conventions
### Overview
Industry follows standard naming conventions beyond basic syntax rules. This ensures uniqueness and organization.

### Key Concepts
Standard convention: `{reverse web domain}.{main concept}.{sub concept}`

**Example**:
- Company: nit.com
- Reverse: com.nit
- Main Concept: client/student/controller
- Sub Concept: any relevant subdivision
- Full Name: com.nit.client or com.nit.controller.login

**Predefined Package Example**:
- Oracle JDBC: oracle.jdbc.driver
- Sun Micro: java.lang.reflect

> [!NOTE]
> Package names must reverse the web domain (e.g., com.oracle.jdbc.driver) to avoid conflicts and follow international standards.

#### Folder Structure Example
For `com.nit.client.blogic.controller`, the structure is:
```
com/
├── nit/
    ├── client/
    │   ├── BLogic.java
    ├── controller/
    │   ├── Controller.java
```

- `client/` contains client-specific classes.
- `controller/` contains controller classes.
- Sub-concepts within main packages allow deeper organization.

#### Identifier Rules for Package Names
- All characters: letters, digits, `$`, `_` (Java 9+ reserves single `_`)
- Cannot start with digits.
- No special characters except `.` (as separator) and `$`/`_`.
- Cannot use keywords (e.g., `static`) or reserved words (e.g., `true`).
- Predefined class names (e.g., `String`, `out`) can be reused (Java 8 allows; Java 9+ forbids JDK predefined names).
- Length: 0 to infinity; no length limit.

| Rule | Example | Allowed? | Notes |
|------|---------|---------|-------|
| Starts with digit | `1package` | ❌ | Compiler error: identifier expected |
| Contains space | `package name` | ❌ | Illegal character |
| Starts with `_` | `_pack` | ✅ | Allowed; single `_` forbidden in Java 9+ |
| Uses keyword | `package static;` | ❌ | Identifier expected |
| Uses predefined name | `package String;` | ❌ (Java 9+) | Package exists in another module |

> [!IMPORTANT]
> In Java 9+, changes include: no single `_`, no reuse of JDK predefined package names, and automatic package creation during `-d` compilation.

## Accessing Classes from Another Package
### Overview
Classes in sub packages can access others via fully qualified names or import statements.

### Fully Qualified Name
Use the complete dot-separated path: e.g., `com.nit.client.BLogic obj = new com.nit.client.BLogic();`

> [!NOTE]
> This avoids imports but is verbose for frequent use.

### Import Statement
Import classes: `import com.nit.client.BLogic;`
OR import all: `import com.nit.client.*;`

> [!TIP]
> Detailed differences between specific imports (e.g., `import p1.A;`) and wildcards (e.g., `import p1.*;`) will be covered in the next session.

## Entry Questions on Packages
### 60+ Key Interview Questions
1. What is a package? A folder linked to classes/interfaces.
2. What is a sub package? A package inside another package.
3. Folder structure for `package p1.p2.p3`? `p1/p2/p3/` folders with `.class` in deepest.
4. How to compile sub packages? Use `javac -d bin src/P1/P2/A.java`.
5. How to execute sub packages? `java -cp bin p1.p2.A` (set classpath if needed).
6. What is the use of `-d` in `javac`? Creates packages programmatically in specified directory.
7. Package naming convention? Reverse domain + main concept + sub concept.
8. Example predefined package: oracle.jdbc.driver.
9. Can package names start with digits? No.
10. Reserved words in package names? No.
11. Java 9 changes for packages: No single `_`, no JDK package reuse, auto folder creation.
12. Package statement position? Must be first line.
13. Multiple package statements allowed? No.
14. Difference: `javac A.java` vs. `javac p1.A.java`? First compiles to current dir, second to project structure.
15. Why doesn't `package` keyword create folders automatically? Compiler needs path specification to avoid conflicts.
... (Total 60 questions covered; focused on subpackages and conventions here.)

> [!NOTE]
> Practice all 60 points; they form the basis of interview questions on this topic.

## Summary

### Key Takeaways
```diff
+ Sub packages are created using dot notation (e.g., package p1.p2;)
+ Folder structure: Parent folders created first, then subfolders
+ Use javac -d for programmatic package creation
+ Naming: Reverse domain.main.sub (e.g., com.nit.client.controller)
+ Execution requires classpath set to root package directory
- Avoid manual folder creation; prefer -d option
- Package info must be first statement in .java file
! Java 9+ restrictions: No single _, no JDK package reuse
```

### Expert Insight

**Real-world Application**: In enterprise projects, sub packages organize code by layers (e.g., com.company.data.dao, com.company.ui.controller). Use IDE tools for automatic classpath management.

**Expert Path**: Master import nuances (next session), understand module system impacts (Java 9+), and practice building Maven/Gradle projects with complex package hierarchies.

**Common Pitfalls**: 
- Forgetting `-d` leads to missing folders and "wrong name" errors.
- Incorrect classpath causes "class not found" at runtime.
- Reusing JDK packages in Java 9+ throws compile errors.
- Deep sub packages confuse path mappings; test executions thoroughly.

**Lesser Known Things**: Package names are attached to class files, not folders; folders are just storage. Class loaders search classpath hierarchies, so order matters in JAR deployments.
