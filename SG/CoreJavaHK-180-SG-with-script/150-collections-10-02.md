# Session 10: Collections - Operations on ArrayList (Part 2)

## Table of Contents

- [Storing Objects and Updating Data](#storing-objects-and-updating-data)
- [Searching for Objects](#searching-for-objects)  
- [Updating/Modifying Objects](#updatingmodifying-objects)
- [Removing Elements](#removing-elements)
- [Inserting Elements](#inserting-elements)
- [Replacing Elements](#replacing-elements)
- [Sorting Elements](#sorting-elements)

## Storing Objects and Updating Data

### Overview
This section demonstrates how to store student objects in an ArrayList and perform data updates, such as increasing fee values or adding new courses. The focus is on basic CRUD operations using the `add()` method for storage and combination of retrieval and setter methods for updates.

### Key Concepts

#### Storing Student Objects
Use the `add()` method to populate an ArrayList with student objects containing properties like student number, course, and fee:

```java
import java.util.ArrayList;

public class StudentManager {
    public static void main(String[] args) {
        ArrayList<Student> al1 = new ArrayList<>();
        
        // Add student objects
        al1.add(new Student("101", "Core Java", 5000.0));
        al1.add(new Student("102", "Advanced Java", 6000.0));
    }
}

// Student class definition would be implemented separately
class Student {
    private String studentNumber;
    private String course;
    private double fee;
    
    // Constructor, getters, setters
}
```

#### Updating Data
To update existing student data:
1. Store objects using `add()` method
2. For data updates, combine `indexOf()` to find the object and `set()` methods to modify

```java
// Store students
ArrayList<Student> al1 = new ArrayList<>();
al1.add(new Student("101", "Core Java", 5000.0));

// Search and update fee
int index = al1.indexOf(new Student("101", "Core Java", 0.0)); // Use partial object for search
if (index >= 0) {
    Student s = al1.get(index);
    s.setFee(s.getFee() + 1000.0); // Increase fee by 1000
    s.setCourse("Core Java Update"); // Update course
}
```

## Searching for Objects

### Overview  
Searching is crucial when you need to locate specific objects in a collection by their properties rather than position. ArrayList provides methods like `contains()`, `indexOf()`, and `lastIndexOf()` for efficient object searching.

### Key Concepts

#### Using indexOf() for Searching
The `indexOf()` method requires creating a "template" object with matching properties to search for:

```java
ArrayList<Student> al1 = new ArrayList<>();
al1.add(new Student("101", "Core Java", 5000.0));
al1.add(new Student("102", "Advanced Java", 6000.0));

// Search for student with ID 101 and Core Java course
Student searchKey = new Student("101", "Core Java", 0.0); // Fee not needed for search
int index = al1.indexOf(searchKey);

if (index >= 0) {
    Student found = al1.get(index);
    System.out.println("Found student: " + found.getStudentNumber());
} else {
    System.out.println("Student not found");
}
```

> [!IMPORTANT]
> The `equals()` method must be overridden in the Student class to compare relevant properties (student number and course). The `indexOf()` method internally uses `equals()` for matching.

#### Search Algorithm
```java
// Conceptual algorithm for indexOf()
public int indexOf(Object obj) {
    for (int i = 0; i < size; i++) {
        if (elementData[i].equals(obj)) {
            return i;
        }
    }
    return -1;
}
```

> [!NOTE]  
> Always check if `indexOf()` returns >= 0 before using `get()` to avoid IndexOutOfBoundsException.

## Updating/Modifying Objects

### Overview
Updating objects requires retrieving the existing object reference from the collection, then modifying it using setter methods. This ensures the changes are reflected in the collection since you're modifying the original object.

### Key Concepts

#### Safe Update Pattern
Always use the combination of `indexOf()` + `get()` + setters for reliable updates:

```java
ArrayList<A> al1 = new ArrayList<>();
// Assume al1 contains A objects with (x,y) coordinates

// Search and update object with data (7,8)
A searchKey = new A(7, 8);
int index = al1.indexOf(searchKey);

if (index >= 0) {
    A obj = al1.get(index); // Retrieve object reference
    obj.setX(obj.getX() + 5); // Increase x by 5  
    obj.setY(obj.getY() + 7); // Increase y by 7
    System.out.println("Updated: x=" + obj.getX() + ", y=" + obj.getY());
} else {
    System.out.println("Object not found, no update performed");
}
```

#### Memory Diagram Understanding
```
Collection: [obj1] [obj2] [obj3]
              ↓      ↓      ↓
           (5,6)   (7,8)   (9,10)
```

When you call `get(index)`, you get a reference to the object in the collection. Modifying this reference affects the object stored in the collection since they point to the same memory location.

> [!WARNING]
> Never blindly call `get()` with an index from `indexOf()` without checking if index >= 0. An unsuccessful search returns -1, causing IndexOutOfBoundsException.

### Lab Demo: Student Data Update

Update student fee and add course for student 101:

```java
ArrayList<Student> al1 = new ArrayList<>();
al1.add(new Student("101", "Core Java", 5000.0));

// Search and update
Student key = new Student("101", "Core Java", 0.0);
int index = al1.indexOf(key);

if (index >= 0) {
    Student s = al1.get(index);
    s.setFee(s.getFee() + 2000.0);
    s.setCourse("Core Java Advanced");
}
```

## Removing Elements

### Overview
ArrayList provides multiple methods for removing elements: single occurrence, all occurrences of specific elements, conditional removal, and clearing all elements. Understanding the difference between removing by index vs. by object is crucial.

### Key Concepts

#### Remove by Object
Removes first occurrence matching the provided object:

```java
ArrayList<String> al1 = new ArrayList<>();
al1.add("a"); al1.add("b"); al1.add("c"); al1.add("a");

// Remove first "a"
boolean removed = al1.remove("a"); // Returns true if found
// Result: ["b", "c", "a"]
```

#### Remove Multiple Elements with removeAll()
```java
ArrayList<String> al1 = new ArrayList<>();
al1.add("a"); al1.add("b"); al1.add("a"); al1.add("c");

// Create collection of elements to remove
ArrayList<String> toRemove = new ArrayList<>();
toRemove.add("a");

// Remove all occurrences
al1.removeAll(toRemove);
// Result: ["b", "c"]
```

#### Creating Removal Collections Efficiently
```java
// Java 9+ approach
al1.removeAll(List.of("a", "b"));

// Java 1.2+ approach  
al1.removeAll(Arrays.asList("a", "b"));

// Legacy approach
ArrayList<String> removeList = new ArrayList<>();
removeList.add("a");
removeList.add("b");
al1.removeAll(removeList);
```

#### Remove Elements Conditionally with removeIf()
```java
ArrayList<Student> al1 = new ArrayList<>();
// Populate students...

// Remove all students with fee > 10000
al1.removeIf(student -> student.getFee() > 10000);
```

### Remove Algorithm (Conceptual)
```java
// Simplified remove logic
public boolean remove(Object obj) {
    for (int i = 0; i < size; i++) {
        if (elementData[i].equals(obj)) {
            // Shift elements left to fill gap
            for (int j = i; j < size - 1; j++) {
                elementData[j] = elementData[j + 1];
            }
            elementData[size - 1] = null;
            size--;
            return true;
        }
    }
    return false;
}
```

### Lab Demo: Remove Operations

```java
ArrayList<Object> al1 = new ArrayList<>();
al1.add("a"); al1.add(5); al1.add("a"); al1.add(6.7);

// Remove first "a"
al1.remove("a");
// Result: [5, "a", 6.7]

// Remove all "a" elements
al1.removeAll(Arrays.asList("a"));
// Result: [5, 6.7]

// Remove integers conditionally
al1.removeIf(obj -> obj instanceof Integer);
// Result: [6.7]
```

## Inserting Elements

### Overview
Inserting adds elements at specific positions, shifting existing elements right. This differs from adding (appending) and replacing (overwriting). The `add(index, element)` method handles insertion logic.

### Key Concepts

#### Using add() for Insertion
```java
ArrayList<String> al1 = new ArrayList<>();
al1.add("a"); al1.add("b"); al1.add("c");
// al1: ["a", "b", "c"]

al1.add(1, "x"); // Insert "x" at index 1
// Result: ["a", "x", "b", "c"]
```

Index rules for insertion:
- Index must be ≥ 0 and ≤ size
- Index = size performs append operation (same as `add(element)`)
- Index > size throws IndexOutOfBoundsException

#### Insertion Algorithm (Conceptual)
```java
public void add(int index, Object element) {
    // Ensure capacity
    if (size == elementData.length) {
        grow();
    }
    
    // Shift elements right from insertion point
    for (int i = size; i > index; i--) {
        elementData[i] = elementData[i - 1];
    }
    
    // Insert new element
    elementData[index] = element;
    size++;
}
```

### Lab Demo: Insert Elements

```java
ArrayList<String> al1 = new ArrayList<>();
al1.add("first"); al1.add("third");
// Initial: ["first", "third"]

al1.add(1, "second"); // Insert at index 1
// Result: ["first", "second", "third"]
```

## Replacing Elements

### Overview
Replacement overwrites an existing element without changing collection size or shifting elements. Unlike insertion, no elements move in memory.

### Key Concepts

#### Using set() for Replacement
```java
ArrayList<String> al1 = new ArrayList<>();
al1.add("old1"); al1.add("old2"); al1.add("old3");

al1.set(1, "new2"); // Replace index 1
// Result: ["old1", "new2", "old3"]
```

> [!NOTE]
> `set()` returns the **old** element that was replaced.

Rules for `set()`:
- Index must be ≥ 0 and < size
- Index ≥ size throws IndexOutOfBoundsException

#### Difference: Add vs. Set
```diff
+ add(index, element): Inserts, shifts elements right, size increases
- set(index, element): Replaces existing, no shift, size unchanged
```

### Lab Demo: Replace Operations

```java
ArrayList<String> al1 = new ArrayList<>();
al1.add("A"); al1.add("B"); al1.add("C");
// ["A", "B", "C"]

String old = al1.set(1, "X");
// old = "B", al1 = ["A", "X", "C"]
```

## Sorting Elements

### Overview
The `sort()` method arranges elements in natural order (using `Comparable`) or custom order (using `Comparator`). Collections.sort() can also be used for this operation.

### Key Concepts

#### Basic Sorting with sort()
```java
ArrayList<String> al1 = new ArrayList<>();
al1.add("C"); al1.add("A"); al1.add("B");

al1.sort(null); // Natural order (alphabetical)
// Result: ["A", "B", "C"]
```

#### Custom Sorting with Comparator
```java
ArrayList<Student> students = new ArrayList<>();
// Populate students...

// Sort by fee ascending
students.sort(Comparator.comparingDouble(Student::getFee));

// Sort by course descending
students.sort(Comparator.comparing(Student::getCourse).reversed());
```

> [!NOTE]
> `sort(null)` uses natural ordering if elements implement `Comparable`. Otherwise, provide a `Comparator`.

### Lab Demo: Sorting Elements

```java
ArrayList<String> al1 = new ArrayList<>();
al1.add("zebra"); al1.add("apple"); al1.add("banana");

System.out.println("Before sort: " + al1);
al1.sort(null);
System.out.println("After sort: " + al1);
// Output: [apple, banana, zebra]
```

## Summary

### Key Takeaways
```diff
+ Store objects using add() and retrieve references with get()
+ Search objects with indexOf() requiring template objects and overridden equals()
+ Update objects by combining indexOf(), get(), and setter methods
- Never call get() without checking indexOf() returns >= 0
+ Remove first occurrence: remove(object), all occurrences: removeAll(collection)
+ Remove conditional: removeIf(predicate)
+ Insert (shift right): add(index, element), Range: 0 ≤ index ≤ size
- Replace (no shift): set(index, element), Range: 0 ≤ index < size
+ Sort with sort(null) for natural order or sort(comparator) for custom order
```

### Expert Insight
**Real-world Application**: These ArrayList operations form the foundation of data management in enterprise applications. For instance, student management systems use these methods for CRUD operations, where searching and updating student records is critical for maintaining accurate academic data.

**Expert Path**: Master the internal algorithms by implementing your own ArrayList class. Understand that `add(index, element)` requires right-shifting elements, while `remove()` requires left-shifting. Study `Collections.sort()` vs. `List.sort()` performance characteristics.

**Common Pitfalls**: 
- Forgetting to override `equals()` and `hashCode()` leads to incorrect search results
- Not checking `indexOf()` return value before `get()` causes runtime exceptions
- Confusing `add(index, element)` (insert) with `set(index, element)` (replace)
- Using `removeAll()` with large collections can be inefficient without proper collection sizing
- Attempting to modify collections during iteration without using `removeIf()` or iterators

**Lesser Known Points**: The `removeIf()` method in Java 8+ uses internal iteration and is more efficient than manual loops. `indexOf()` starts searching from index 0, while `lastIndexOf()` searches from the end backward. Capacity growth follows a specific formula (typically 1.5x growth) that affects performance when frequent insertions occur.
