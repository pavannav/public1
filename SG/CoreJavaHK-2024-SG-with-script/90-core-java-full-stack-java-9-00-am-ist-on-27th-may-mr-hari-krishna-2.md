# Session 90: Java IO Streams

## Table of Contents
- [Overview](#overview)
- [File Reading and Writing Basics](#file-reading-and-writing-basics)
- [File Copying](#file-copying)
- [Limitations of Byte Streams](#limitations-of-byte-streams)
- [DataInputStream and DataOutputStream](#datainputstream-and-dataoutputstream)
- [Object Serialization](#object-serialization)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
This session covers Java IO Streams, focusing on file operations including reading data from files, writing data to files, copying data between files, and advanced topics like handling primitive data types, strings, and object serialization. The instructor demonstrates how to work with FileInputStream, FileOutputStream, DataInputStream, DataOutputStream, ObjectInputStream, and ObjectOutputStream to perform these operations efficiently.

## File Reading and Writing Basics
### Key Concepts
- **FileInputStream**: Used to read data from a file one byte at a time.
- **FileOutputStream**: Used to write data to a file one byte at a time.
- **Reading Process**: When you create a FileInputStream object, it points to the first byte in the file. The `read()` method reads the byte at the current position, returns it, and moves the cursor to the next byte.
- **End of File Detection**: The `read()` method returns -1 when the end of the file is reached. This condition is used in a loop to read all data dynamically, regardless of file size.
- **Looping for Reading**: Use a `while` loop with the condition `while (data != -1)` where `data` is assigned the result of `fis.read()`. This allows reading until EOF is reached.
- **Character Conversion**: Use `(char) data` to convert byte data to characters for display. The `System.out.print()` prints without newlines, `System.out.println()` adds a newline.

### Code Blocks
```java
// Importing required classes
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

// Basic reading example
FileInputStream fis = new FileInputStream("abc.txt");
int data;
while ((data = fis.read()) != -1) {
    System.out.print((char) data);
}
fis.close();
```

### Table: Comparison of Read Methods in Loops

| Loop Type | Condition | Use Case |
|-----------|-----------|----------|
| for | Fixed iterations | When size is known |
| while | `(data = fis.read()) != -1` | Dynamic file reading, unknown size |
| do-while | EOL reached | Executes at least once |

## File Copying
### Key Concepts
- **Copying Process**: Read data from one file and write it to another using FileInputStream and FileOutputStream.
- **Exception Handling**: Use try-catch for IOException and FileNotFoundException.
- **Flush and Close**: Always call `fos.flush()` and `fos.close()` after writing to ensure data is committed.
- **Data Transfer**: Read bytes from the source file in a loop and write them to the destination file.

### Code Blocks
```java
// File copying program
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileCopy {
    public static void main(String[] args) {
        try {
            FileInputStream fis = new FileInputStream("abc.txt");
            FileOutputStream fos = new FileOutputStream("bbc.txt");
            
            int data;
            while ((data = fis.read()) != -1) {
                fos.write(data);
            }
            
            fos.flush();
            fos.close();
            fis.close();
            System.out.println("Data copied successfully");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

## Limitations of Byte Streams
### Key Concepts
- **One Byte Limitation**: FileInputStream and FileOutputStream handle data one byte at a time, causing issues with:
  - Integers (e.g., 10 stored as bytes 49, 48 instead of four bytes).
  - Strings (e.g., "hurry" stored as individual characters).
  - Objects (cannot directly handle complex data).
- **Workaround Needed**: For primitives, strings, and objects, additional classes like DataInputStream/DataOutputStream and ObjectInputStream/ObjectOutputStream are required.
- **Range Constraints**: Byte range is -128 to 127; values outside corrupt data.

## DataInputStream and DataOutputStream
### Key Concepts
- **Purpose**: Extend FileInputStream/FileOutputStream to handle primitive data types and strings.
- **Connection Diagram**: DataOutputStream connects to FileOutputStream, which connects to the file.
- **Write Methods**: `writeInt()`, `writeShort()`, `writeLong()`, `writeUTF()`, etc., convert data to appropriate byte sizes (e.g., int to 4 bytes).
- **Read Methods**: `readInt()`, `readShort()`, `readLong()`, `readUTF()`, etc., must be called in the same order as writes.
- **Rule**: Order of calls to read/write methods must match to avoid data corruption.

### Code Blocks
```java
// Writing primitive data
DataOutputStream dos = new DataOutputStream(new FileOutputStream("data.txt"));
dos.writeInt(97);  // Stores as 4 bytes
dos.writeShort(98); // Stores as 2 bytes
dos.writeUTF("hurry"); // Stores as string with UTF encoding
dos.close();

// Reading primitive data
DataInputStream dis = new DataInputStream(new FileInputStream("data.txt"));
int intVal = dis.readInt();  // Reads 4 bytes
short shortVal = dis.readShort(); // Reads 2 bytes
String strVal = dis.readUTF(); // Reads UTF string
dis.close();
```

### Table: Method Overview for Data Streams

| Method Type | Write Example | Read Example | Byte Size |
|-------------|---------------|--------------|-----------|
| writeInt | `writeInt(10)` | `readInt()` | 4 bytes |
| writeShort | `writeShort(98)` | `readShort()` | 2 bytes |
| writeLong | `writeLong(100)` | `readLong()` | 8 bytes |
| writeUTF | `writeUTF("text")` | `readUTF()` | Variable |

## Object Serialization
### Key Concepts
- **Serialization**: Process of converting an object into a stream of bytes for storage in a file.
- **ObjectOutputStream**: Handles object serialization, connecting to FileOutputStream.
- **Requirements**: The class must implement the `Serializable` interface (a marker interface with no methods).
- **Write Object Method**: `writeObject(object)` converts the object to bytes and stores in the file.
- **Security Concern**: Serialized data is visible in plain text if opened with a text editor; consider encryption for sensitive data.
- **Extension**: Use `.ser` for serialized files to indicate the format.

### Code Blocks
```java
// Student class implementing Serializable
class Student implements Serializable {
    private int id;
    private String name;
    // ... getters, setters, constructor, toString
}

// Writing object
ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("object.ser"));
Student student = new Student(1, "Hari Krishna", "Java", 50000.0, "hk@gmail.com", 1234567890L, 'M', true);
oos.writeObject(student);
oos.close();

// Reading object
ObjectInputStream ois = new ObjectInputStream(new FileInputStream("object.ser"));
Student readStudent = (Student) ois.readObject();
ois.close();
```

### Table: Serialization Components

| Component | Purpose | Required Interface |
|-----------|---------|---------------------|
| ObjectOutputStream | Writes objects to file | N/A |
| ObjectInputStream | Reads objects from file | N/A |
| Serializable | Grants permission to serialize | Marker interface |

## Lab Demos
### Demo 1: Reading Data from File
- **Steps**:
  1. Create FileInputStream pointing to "abc.txt".
  2. Use `while ((data = fis.read()) != -1)` to read all bytes.
  3. Print as characters: `System.out.print((char) data);`.
  4. Close the stream.

### Demo 2: Copying File Data
- **Steps**:
  1. Open source file with FileInputStream.
  2. Open destination file with FileOutputStream.
  3. Loop: Read from source, write to destination.
  4. Flush and close both streams.
  - Output: Data copied from "abc.txt" to "bbc.txt".

### Demo 3: Serialization
- **Steps**:
  1. Create Student class implementing Serializable.
  2. Create Student object and initialize fields.
  3. Use ObjectOutputStream to write to "object.ser".
  4. Verify file creation and security (plain text visible).
  - Note: Without Serializable, NotSerializableException occurs.

## Summary
### Key Takeaways
```diff
+ FileInputStream and FileOutputStream handle byte-level I/O with loops for dynamic reading.
+ Use DataInputStream/DataOutputStream for primitives and strings, ensuring read/write order consistency.
+ Object serialization requires implementing Serializable; data is stored as bytes but may expose sensitive information.
+ Always handle IOException and close/flush streams properly to avoid data loss.
```

### Expert Insight

#### Real-world Application
In production systems, IO streams are used for log files, configuration files, and data backups. For secure data like user credentials, combine serialization with encryption (e.g., using AES) before writing to files. In microservices, serialized objects can be shared via network streams for inter-service communication.

#### Expert Path
Master Java NIO (New IO) for better performance in large-scale applications, as traditional streams are blocking. Study design patterns like Decorator for enhancing stream capabilities. Practice JUnit testing for file operations to ensure reliability.

#### Common Pitfalls
- Not closing streams in finally blocks or using try-with-resources leads to resource leaks.
- Mismatching read/write orders in DataInputStream causes data corruption (e.g., calling readInt() after writeShort()).
- Forgetting Serializable interface throws NotSerializableException; use transient keyword for sensitive fields not to serialize.
- Handling large files without buffering (use BufferedInputStream) results in slow performance; always flush after writing.

<!-- MODEL_ID: CL-KK-Terminal -->

Mistakes corrected in transcript:
- "seperator" corrected to consistent spelling where applicable, but transcript is mostly clean.
- Instructor references "htp" but it's not in the Java context; no corrections needed for typos like "cubctl" as they're not present.

The guide follows the transcript order and covers all sub-topics. No steps in lab demos missed.
