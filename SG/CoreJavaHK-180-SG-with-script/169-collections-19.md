# Session 169: Collections 19

**[Table of Contents](#table-of-contents)**

- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
This session focuses on advanced concepts of TreeSet in Java Collections Framework, specifically the rules for storing objects, implementing comparators, and sorting logic. It emphasizes the requirement for objects to be comparable either through the Comparable interface or custom Comparator. The instructor reviews sorting algorithms for different data types and provides practical examples with Lambda expressions.

## Key Concepts/Deep Dive

### Rules for Storing Objects in TreeSet
- Objects must be **homogeneous** and **comparable**.
- Basic rule: The object must be a comparable type or a custom comparator must be supplied.
- TreeSet uses two interfaces for sorting:
  1. **Comparable**: For default sorting order.
  2. **Comparator**: For custom sorting logic.
- If no comparator is provided and the object doesn't implement Comparable, a `ClassCastException` occurs: `java.lang.ClassCastException: class C cannot be cast to class java.lang.Comparable`.

### Comparator Implementation
- **Comparable Interface**: Implement `compareTo(Object obj)` method.
- **Comparator Interface**: Implement `compare(Object o1, Object o2)` method.
- Can be provided via Lambda expressions for concise syntax.

#### Sorting Algorithms
- **compareTo/compare method rules**:
  - Return **negative** number: Current object is smaller (place left).
  - Return **positive** number: Current object is bigger (place right).
  - Return **zero**: Objects are equal (duplicate, may not store).

- **Ascending order by int property**: `currentValue - argumentValue`
- **Descending order by int property**: `argumentValue - currentValue`
- **Insertion order including duplicates**: Return positive number.
- **Reverse insertion order**: Return negative number.
- Only store first object: Return zero.

#### Handling Different Data Types
- **Int properties**: Direct subtraction works.
- **Double properties**: Cannot typecast to int directly. Use conditionals:
  ```
  double diff = obj1.getDoubleProp() - obj2.getDoubleProp();
  if (diff < 0) return -1;
  else if (diff > 0) return 1;
  else return 0;
  ```
- **String properties**: Convert to hashcode (int) then subtract: `obj1.getStringProp().hashCode() - obj2.getStringProp().hashCode()`

### Class Example: C Class
- Properties: `private int i; private double d; private String s;`
- Constructor and getters/setters generated.
- Demonstrates sorting by `i` (ascending), `d` (with conditionals), `s` (with hashCode).

| Property | Type | Sorting Approach | Example Return Value |
|----------|------|------------------|---------------------|
| i | int | Direct subtraction | `c1.getI() - c2.getI()` |
| d | double | Conditional logic | -1, 0, or 1 based on difference |
| s | String | HashCode subtraction | `c1.getS().hashCode() - c2.getS().hashCode()` |

### Additional Notes
- TreeSet does not have a default ascending order; it uses the Comparable interface or supplied Comparator.
- Comparator is checked first in `add()` method. If null, falls back to Comparable.

### Review of Previous Collections Concepts
#### Object Storage Rules
- **List**: Override `equals()` method.
- **Set/HashMap**: Override `equals()` and `hashCode()`.
- **NavigableSet/NavigableMap (TreeSet/TreeMap)**: Override `compareTo()` or use `compare()` method.

#### Collection Operations
| Operation | Supported Collections | Required Methods | Notes |
|-----------|----------------------|------------------|-------|
| Add | List, Set, Map, NavigableSet, NavigableMap | Equals (optional for List); Equals + HashCode (Set/Map); Compare/CompareTo (Sorted) | |
| Search | All | Equals (List); Equals + HashCode (Set/Map); Compare/CompareTo (Sorted) | Mandatory for sorted collections |
| Remove | All | Same as Search | |
| Insert | List only | None | Index-based |
| Replace | List only | None | Index-based |
| Retrieve | All | Varies | Multiple approaches: get(), cursors, forEach, streams, etc. |

#### Retrieval Approaches (8 methods mentioned, partially covered)
1. `get()` method
2. Cursors (Enumeration, Iterator, ListIterator)
3. Enhanced for loop / forEach method
4. Stream API
5. Spliterator
6. (Others not yet covered in transcript)

### Collections Hierarchy and History
- **Java 1.0**: Vector, Hashtable, Enumeration
- **Java 1.2**: Collections Framework (List, Set, Map hierarchies)
- **Java 1.4/1.5/1.6/1.7/1.8/1.9/1.10**: Enhancements (generics, concurrency, factory methods like `of()`)
- **Two formats**: Array-based (List, Set) vs. Key-Value (Map)

### Projects Covered
1. **Employee Salary Project**: Add employees, display in table format (Name in uppercase).
2. **Student Database Project**: Transfer student data from DB to collection, retrieve by course.

- **Java Bean Convention**: For DB mapping
  - DB Table → Java Class
  - DB Columns → Java Fields
  - DB Rows → Java Instances

## Lab Demos

### Demo 1: Storing Objects in TreeSet Without Comparator
- **Objective**: Demonstrate the requirement for Comparable or Comparator.
- **Code**:
  ```java
  public class C {
      private int i;
      private double d;
      private String s;

      // Constructor, getters, setters
      public C(int i, double d, String s) {
          this.i = i;
          this.d = d;
          this.s = s;
      }
      // Getters...
  }

  // In main:
  TreeSet<C> ts = new TreeSet<>();
  ts.add(new C(5, 7.5, "abc"));
  ts.add(new C(6, 8.6, "bcd"));
  // Exception: ClassCastException - C cannot be cast to Comparable
  ```
- **Output**: Compilation error or runtime ClassCastException.
- **Steps**: 
  1. Create class C with int, double, String properties.
  2. Attempt to add objects to TreeSet.
  3. Observe exception due to no Comparable implementation.

### Demo 2: Sorting by Int Property Using Comparator
- **Objective**: Use Lambda to sort by int property (ascending).
- **Code**:
  ```java
  TreeSet<C> ts = new TreeSet<>((c1, c2) -> c1.getI() - c2.getI());
  ts.add(new C(5, 7.5, "abc"));
  ts.add(new C(6, 8.6, "bcd"));
  ts.add(new C(7, 8.7, "cde"));
  System.out.println(ts); // [5, 6, 7]
  ```
- **Output**: Objects stored in ascending order of `i`.
- **Steps**:
  1. Define Comparator using Lambda comparing `getI()`.
  2. Add objects with different values.
  3. Print TreeSet to verify order.

### Demo 3: Sorting by Double Property (With Conditionals)
- **Objective**: Handle double precision for correct comparison.
- **Code**:
  ```java
  TreeSet<C> ts = new TreeSet<>((c1, c2) -> {
      double diff = c1.getD() - c2.getD();
      if (diff < 0) return -1;
      else if (diff > 0) return 1;
      else return 0;
  });
  ts.add(new C(1, 8.2, "a"));
  ts.add(new C(2, 8.3, "b"));
  ts.add(new C(3, 8.4, "c"));
  System.out.println(ts); // Sorted by d: 8.2, 8.3, 8.4
  ```
- **Output**: Correct sorting; avoids zero due to floating point precision.
- **Steps**:
  1. Use conditional logic instead of direct subtraction.
  2. Add objects with close double values.
  3. Verify no duplicates stored incorrectly.

### Demo 4: Sorting by String Property Using HashCode
- **Objective**: Convert String to int for comparison.
- **Code**:
  ```java
  TreeSet<C> ts = new TreeSet<>((c1, c2) -> c1.getS().hashCode() - c2.getS().hashCode());
  ts.add(new C(1, 1.0, "a"));
  ts.add(new C(2, 2.0, "b"));
  ts.add(new C(3, 3.0, "c"));
  System.out.println(ts); // Sorted lexically by hashCode
  ```
- **Output**: "a", "b", "c" in order.
- **Steps**:
  1. Subtract hashCodes of Strings.
  2. Add objects with different String properties.
  3. Observe lexical ordering.

### Demo 5: Employee Salary Table (List as Transferable Object)
- **Objective**: Implement basic CRUD on List.
- **Code**:
  ```java
  class Employee {
      String name;
      double salary;
      // Constructor, getters
  }

  List<Employee> employees = new ArrayList<>();
  employees.add(new Employee("John", 50000));
  employees.add(new Employee("Jane", 60000));
  employees.add(new Employee("Bob", 55000));

  // Display in table
  System.out.println("Name\tSalary");
  for (Employee e : employees) {
      System.out.println(e.getName().toUpperCase() + "\t" + e.getSalary());
  }
  ```
- **Output**: Table format with uppercase names.
- **Steps**:
  1. Create Employee class.
  2. Add instances to ArrayList.
  3. Iterate and print in tabulated format.

### Demo 6: Student Retrieval from Collection as Mini DB
- **Objective**: Simulate DB operations with Collections.
- **Code** (Simplified):
  ```java
  class Student { // Java Bean
      int id;
      String name, course;
      // Constructor, getters/setters
  }

  List<Student> students = new ArrayList<>();
  // Add students from "DB"

  // Retrieve by course
  String queryCourse = "Core Java";
  List<Student> result = students.stream()
      .filter(s -> s.getCourse().equals(queryCourse))
      .collect(Collectors.toList());
  result.forEach(System.out::println);
  ```
- **Output**: Filtered students.
- **Steps**:
  1. Map DB table to Java class.
  2. Store instances in List.
  3. Use Stream API for querying.

## Summary

### Key Takeaways
```diff
+ TreeSet mandates Comparable implementation or Comparator supply for object storage
+ Comparator checked first; falls back to Comparable if null
+ Sorting logic: Negative (left), Positive (right), Zero (equal/no store)
+ Int: Direct subtract; Double/String: Use conditionals/hashCode
+ Collections map DB tables/rows to classes/instances
- Misspelling: 'Treet' → 'TreeSet' (corrected throughout)
- Misspelling: 'comparative' → 'compare' (method/function name)
- Misspelling: 'subass' → 'subclass'
- Misspelling: 'preset' → 'present'
- Misspelling: 'jerox' → 'xerox' (material reference)
- Misspelling: 'curses' → 'queues' (upcoming topic)
- All corrections applied; original transcript contained typos in technical terms.
```

### Expert Insight
**Real-world Application**:  
TreeSet is ideal for sorted data structures in applications like priority queues, leaderboard rankings, or log aggregation where insertion order and uniqueness matter. Use custom comparators for complex sorting in enterprise apps (e.g., sorting by multiple fields in employee directories).

**Expert Path**:  
Master comparators by studying `Comparator.comparing()` and method chaining. Practice with generics and functional interfaces. Deepen knowledge by implementing custom collections exploring source code of TreeSet for node balancing algorithms.

**Common Pitfalls**:  
- Forgetting Comparable leads to ClassCastException; always implement or provide Comparator.
- Typecasting doubles directly causes precision issues; use explicit comparators.
- HashCode-based String sorting may not be truly lexical; consider `String.compareTo()` for accuracy.
- Not overriding equals/hashCode in sorted collections breaks search/remove operations.

**Common Issues with Resolution and How to Avoid**:
- **Issue**: Floating-point comparison returns 0 unexpectedly → **Resolution**: Use epsilon check or directional comparisons (if diff > epsi return 1 else if diff < -epsi return -1 else 0). Avoid: Always use conditionals for floats.
- **Issue**: Mutable keys cause inconsistency → **Resolution**: Use immutable keys. Avoid: Modify keys after insertion.
- **Issue**: Performance hit with large datasets → **Resolution**: Consider alternatives like TreeMap if balanced binary trees are too slow. Avoid: Overuse of custom comparators on frequent changes.

**Lesser Known Things**:  
TreeSet uses Red-Black trees internally for self-balancing, ensuring O(log n) operations. Comparator<T> in Java 8+ supports functional interfaces, allowing concise Lambdas; TreeSet doesn't allow null elements (unlike some libraries); custom comparators can throw exceptions if inconsistent (violates transitivity), leading to undefined behavior.
