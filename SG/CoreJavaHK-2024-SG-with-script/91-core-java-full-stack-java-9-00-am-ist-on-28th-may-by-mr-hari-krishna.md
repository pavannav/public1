# Session 91: Serialization, Deserialization, IO Streams, and Multi-Threading Introduction

## Table of Contents
- [Serialization Overview](#serialization-overview)
- [Deserialization](#deserialization)
- [Serialization Internals](#serialization-internals)
- [Serial Version UID](#serial-version-uid)
- [Transient Keyword](#transient-keyword)
- [File Class Operations](#file-class-operations)
- [File Creation and Management](#file-creation-and-management)
- [File and Directory Deletion](#file-and-directory-deletion)
- [Multi-Threading Introduction](#multi-threading-introduction)
- [Summary](#summary)

## Serialization Overview

### Overview
Serialization in Java refers to the process of converting an object into a byte stream, allowing it to be saved to a file, database, or transmitted over a network. Deserialization reverses this by reconstructing the object from the byte stream. This enables persistent storage and data exchange in distributed applications.

### Key Concepts/Deep Dive
Serialization transforms object states into a serializable format. The object must implement the `Serializable` interface, which marks it as serializable. Without this, attempting serialization will result in a `NotSerializableException`.

Core components include:
- **ObjectOutputStream**: Writes object data using methods like `writeObject().
- **ObjectInputStream**: Reads object data using methods like `readObject()`.

```bash
# Example of writing and reading serialized data
java.io.ObjectOutputStream oos = new java.io.ObjectOutputStream(new java.io.FileOutputStream("student.ser"));
oos.writeObject(studentObj);
oos.close();

java.io.ObjectInputStream ois = new java.io.ObjectInputStream(new java.io.FileInputStream("student.ser"));
Student s = (Student) ois.readObject();
ois.close();
```

### Lab Demos
1. Create a `Student` class implementing `Serializable`.
2. Serialize a `Student` object to a file named "objects.dat".
3. Deserialize the object and print its attributes.

Run the serialization code:
```bash
javac Student.java && java Student
```

Verify file contents (binary data, not readable text).

## Deserialization

### Overview
Deserialization reconstructs an object from a byte stream stored in a file, restoring its state including primitive and object fields. It reads data sequentially and reconstructs the object in memory.

### Key Concepts/Deep Dive
Deserialization uses `ObjectInputStream.readObject()`, which returns an `Object` reference. Type casting to the specific class is required. The class file must be available in the JVM during deserialization.

Key points:
- **Return Type**: `readObject()` returns `Object`, requiring explicit casting.
- **Class Loading**: The class must be loaded before reconstruction.
- **Object Construction**: Constructor is not called; fields are directly initialized from the stream.

```java
FileInputStream fis = new FileInputStream("objects.ser");
ObjectInputStream ois = new ObjectInputStream(fis);
Student s = (Student) ois.readObject(); // Type casting required
System.out.println("Student Name: " + s.getStudentName());
ois.close();
```

### Tables
| Method | Purpose | Return Type |
|--------|---------|-------------|
| readObject() | Reads and reconstructs object from stream | Object |
| readInt() | Reads primitive int from stream | int |
| readUTF() | Reads UTF-8 string from stream | String |

> [!NOTE]
> Deserialization does not invoke constructors, ensuring data integrity from the serialized state.

### Lab Demos
1. Ensure the serialized file "objects.dat" exists.
2. Run deserialization code to read and display student data.
3. Observe that transient fields are initialized to default values (e.g., null for Strings, 0 for ints).

Execution:
```bash
javac Deserializer.java && java Deserializer
# Output: Student data printed, transient fields show defaults
```

## Serialization Internals

### Overview
Internally, serialization transforms object data into a byte stream by flattening the object's state, including inheritance hierarchies. The JVM performs three key operations: read the byte stream, load the class, create the object instance, and initialize it with stream data.

### Key Concepts/Deep Dive
- **Byte Stream Generation**: Converts primitive/object data into portable bytes.
- **Class Loading**: Verifies and loads the class (e.g., `Student.class`).
- **Instance Creation**: Allocates memory without invoking constructors.
- **Field Initialization**: Populates fields from the stream.

For example:
```java
// JVM internals summary
// 1. Load class: Class.forName("Student")
// 2. Create instance: Unsafe.allocateInstance(Student.class)
// 3. Initialize fields: Reflection to set field values
```

Deserialization follows reverse: read bytes → load class → create instance → populate fields.

> [!TIP]
> Serialization uses reflection and byte manipulation for efficiency in large objects.

## Serial Version UID

### Overview
Serial Version UID (SVUID) is a unique identifier for serializable classes, used to verify version compatibility during deserialization. It prevents errors when class structures change.

### Key Concepts/Deep Dive
- **Generation**: Auto-generated based on class structure (fields, methods). Modification leads to different UID.
- **Purpose**: Communicates class version between serialization and deserialization.
- **Custom UID**: Override default by adding `private static final long serialVersionUID = 1L;` to force compatibility.

Without SVUID, deserializing after class changes throws `InvalidClassException` due to mismatched UIDs.

```java
private static final long serialVersionUID = 1L; // Add to class
```

### Tables
| Scenario | Behavior |
|----------|----------|
| SVUID matches | Deserialization succeeds |
| SVUID differs | Throws InvalidClassException |
| No SVUID defined | Auto-generates, may mismatch on changes |

> [!WARNING]
> Always declare SVUID for production to control compatibility.

### Lab Demos
1. Remove SVUID, modify class (add field), serialize/deserialize → Exception.
2. Add SVUID, repeat → Success.

```bash
# Try modifying Student class without SVUID
javac Student.java && java App # Expect InvalidClassException
```

## Transient Keyword

### Overview
The `transient` keyword prevents specific fields from being serialized, protecting sensitive or non-serializable data.

### Key Concepts/Deep Dive
- **Usage**: Declare fields as `transient` to skip serialization.
- **Deserialization Behavior**: Transient fields initialize to defaults (null, 0, false).
- **Common Use**: Exclude passwords, temporary states, or non-serializable references.

```java
public class Student implements Serializable {
    private String name;
    transient private String password; // Not serialized
}
```

In deserialization:
- `name`: Restored from file.
- `password`: Defaults to `null`.

> [!important]
> Transient fields are not saved to or read from the file; they reset to defaults.

### Lab Demos
1. Mark email and mobile as transient in Student class.
2. Serialize object.
3. Deserialize and observe defaults for transient fields.

```bash
javac SerializeTest.java && java SerializeTest
# Check file: email and mobile data absent
```

## File Class Operations

### Overview
The `File` class in Java abstracts file and directory paths, enabling creation, deletion, and existence checks without operating system specifics.

### Key Concepts/Deep Dive
- **Representation**: `File` objects represent paths, not physical files.
- **Key Methods**:
  - `exists()`: Checks if file/directory exists.
  - `createNewFile()`: Creates new file if not existing.
  - `mkdir()` or `mkdirs()`: Creates directories.

Two constructors: one-argument for single path, two-argument for parent/child.

> [!NOTE]
> `File` does not verify system existence until method calls like `exists()`.

## File Creation and Management

### Overview
Creating files and directories involves instantiating `File` objects and calling creation methods. `mkdirs()` handles nested directories recursively.

### Key Concepts/Deep Dive
- **File Creation**: Use `createNewFile()` for empty files.
- **Directory Creation**: `mkdir()` for single level, `mkdirs()` for hierarchy.

```java
File f1 = new File("xyz.txt");
f1.createNewFile(); // Creates file

File f2 = new File("pqr/abc/p.txt");
f2.getParentFile().mkdirs(); // Ensure parent directories
f2.createNewFile(); // Then create file
```

### Lab Demos
1. Create directory "IOStreams" in project.
2. Create file "test.dat" inside it.
3. Verify with `exists()`.

```bash
javac FileCreator.java && java FileCreator
# Output: File and directories created
```

## File and Directory Deletion

### Overview
Deletion removes files or directories using the `delete()` method. `deleteOnExit()` defers deletion until JVM shutdown.

### Key Concepts/Deep Dive
- **Immediate Deletion**: `delete()` removes instantly, returns success boolean.
- **Deferred Deletion**: `deleteOnExit()` schedules for JVM exit.
- **Directory Deletion**: Removes empty directories; non-empty ones fail unless recursive.

```java
File f = new File("xyz.txt");
f.delete(); // Immediate
f.deleteOnExit(); // On JVM exit
```

> [!WARNING]
> Attempting to delete non-existent files or non-empty directories fails silently.

### Lab Demos
1. Create and delete a test file.
2. Use `deleteOnExit()` and close JVM to verify.
3. Attempt deleting empty vs. non-empty directories.

```bash
# Test deletion
javac DeleteTest.java && java DeleteTest
# Manual JVM stop for deleteOnExit
```

## Multi-Threading Introduction

### Overview
Multi-threading allows concurrent execution of tasks, improving application responsiveness by preventing one task from blocking others.

### Key Concepts/Deep Dive
- **Thread Creation**: Instantiate `Thread` objects and call `start()` to launch execution.
- **Execution Flow**: By default, single-threaded (main thread). Multi-threading creates parallel paths.
- **Benefits**: Handles multiple tasks simultaneously, reduces idle time (e.g., waiting for I/O).

In single-threaded apps:
```java
public static void main(String[] args) {
    m1(); // Blocks if I/O-bound
    m2(); // Waits
}
```

With multi-threading:
```java
Thread t1 = new Thread(() -> m1());
t1.start(); // Parallel execution
m2(); // Can run concurrently
```

> [!TIP]
> Use `Thread` class for creating new threads, ensuring independent execution paths.

### Lab Demos
1. Create a program with sequential vs. concurrent method calls.
2. Measure execution time for single-threaded vs. multi-threaded.
3. Observe blocked I/O impact.

```java
// Basic multi-threading
Thread t1 = new Thread(() -> System.out.println("Thread 1"));
t1.start();
System.out.println("Main");
```

Run and compare timing.

## Summary

### Key Takeaways
```diff
+ Object output stream writes bytes; object input stream reconstructs objects.
+ Serialization requires Serializable interface; deserialization needs SVUID match.
+ Transient fields skip serialization, defaulting in deserialization.
+ File class manages files/directories without direct OS interaction.
+ Multi-threading creates parallel execution for faster, responsive apps.
- Mismatching SVUID causes InvalidClassException during deserialization.
- Transient data is lost and reinitialized to defaults.
```

### Expert Insight

**Real-world Application**: Serialization enables caching (e.g., session data in Java web apps) and RPC (e.g., RMI). Multi-threading powers server applications handling multiple client requests concurrently, like in Tomcat or custom APIs.

**Expert Path**: Master thread synchronization (locks, volatile) and pools (ExecutorService). For serialization, explore externalizable for custom control. Practice with NIO for advanced file operations.

**Common Pitfalls**: Forgetting Serializable leads to runtime exceptions; ignoring SVUID mismatches breaks compatibility. Threads without synchronization cause race conditions (e.g., data corruption). Transient for sensitive data is good, but overusing skips essential state.

Lesser known things: Serialization graphs handle cyclic references; multi-threading's executor framework simplifies pool management.
```
