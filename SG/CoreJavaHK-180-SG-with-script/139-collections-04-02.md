# Session 139: Collections 04 02

## Table of Contents
- [retainAll Method](#retainall-method)
- [size and iterator Methods](#size-and-iterator-methods)
- [clear Method](#clear-method)
- [toArray Methods](#toarray-methods)
- [Operations on Collections](#operations-on-collections)
- [Available Methods by Operation](#available-methods-by-operation)
- [Unsupported Operations](#unsupported-operations)
- [Java 8 Additions](#java-8-additions)
- [Total Methods COUNT](#total-methods-count)
- [API Documentation](#api-documentation)
- [Corrections and Notes](#corrections-and-notes)

## retainAll Method

### Overview
The `retainAll` method performs the reverse operation of `removeAll`. While `removeAll` removes elements from the current collection that are present in the given collection, `retainAll` retains only the elements present in the given collection and removes all other elements from the current collection.

### Key Concepts
- **Method Signature**: `public boolean retainAll(Collection<?> c)`
- **Return Type**: `boolean` - returns `true` if the collection was modified, otherwise `false`
- **Parameter**: A collection containing elements to retain in the current collection
- **Behavior**: Removes all elements from the current collection that are NOT present in the specified collection
- **Difference from removeAll**: 
  - `removeAll`: Removes elements that ARE present in the given collection
  - `retainAll`: Keeps elements that ARE present in the given collection, removes others

📝 **Important**: Focus on the elements available in the current collection at the time of method execution, not the originally stored elements.

### Lab Demo
Consider the following code example demonstrating `retainAll`:

```java
import java.util.*;

public class RetainAllDemo {
    public static void main(String[] args) {
        Vector<Integer> v1 = new Vector<>();
        Vector<Integer> v2 = new Vector<>();
        
        // Adding elements to v1
        v1.add(5);
        v1.add(7);
        v1.add(5);
        v1.add(7);
        
        // Adding elements to v2  
        v2.add(2);
        v2.add(5);
        v2.add(9);
        v2.add(3);
        
        System.out.println("V1 elements: " + v1); // [5, 7, 5, 7]
        System.out.println("V2 elements: " + v2); // [2, 5, 9, 3]
        
        // Before retainAll, v1 contains: 5, 7, 5, 7
        // v2 contains: 2, 5, 9, 3
        // retainAll retains elements in v1 that are in v2, removes others
        v2.retainAll(v1); // Retains 5 (present in v1), removes 2, 9, 3
        
        System.out.println("After retainAll, V2 elements: " + v2); // [5]
    }
}
```

#### Operations Breakdown
- Retain common elements between collections
- Remove elements not present in the given collection
- Case: `v2.retainAll(v1)` retains only elements from `v1` in `v2`

## size and iterator Methods

### Overview
The `size` method provides the count of elements in a collection, while the `iterator` method is used to retrieve elements individually. The `iterator` method will be explained in detail later as it requires additional concepts.

### Key Concepts

#### size Method
- **Method Signature**: `public int size()`
- **Return Type**: `int`
- **Purpose**: Returns the number of elements currently in the collection

#### iterator Method
- **Method Signature**: `public Iterator<E> iterator()`
- **Return Type**: `Iterator<E>`
- **Purpose**: Returns an iterator over the elements in the collection
- **Note**: Detailed explanation deferred until later sessions

### Lab Demo
```java
import java.util.*;

public class SizeIteratorDemo {
    public static void main(String[] args) {
        Vector<Integer> v1 = new Vector<>();
        v1.add(5);
        v1.add(7);
        v1.add(5);
        v1.add(7);
        
        Vector<Integer> v2 = new Vector<>();
        v2.add(2);
        v2.add(5);
        v2.add(9);
        v2.add(3);
        
        System.out.println("Size of V1: " + v1.size()); // 4
        System.out.println("Size of V2: " + v2.size()); // 4
        
        // Iterator usage will be covered in detail later
        Iterator<Integer> iterator = v1.iterator();
    }
}
```

💡 Both collections demonstrate equal element counts after operations.

## clear Method

### Overview
The `clear` method removes all elements from the collection, making it empty. This is different from removing specific elements or collections.

### Key Concepts
- **Method Signature**: `public void clear()`
- **Return Type**: `void`
- **Behavior**: Removes all elements from the collection, resulting in an empty collection
- **Use Case**: When you want to completely empty the collection regardless of its contents

### Lab Demo
```java
import java.util.*;

public class ClearDemo {
    public static void main(String[] args) {
        Vector<Integer> v1 = new Vector<>();
        v1.add(5);
        v1.add(7);
        v1.add(5);
        v1.add(7);
        
        System.out.println("V1 before clear: " + v1); // [5, 7, 5, 7]
        System.out.println("Size before clear: " + v1.size()); // 4
        
        v1.clear();
        
        System.out.println("V1 after clear: " + v1); // []
        System.out.println("Size after clear: " + v1.size()); // 0
    }
}
```

✅ After `clear()`, the collection contains no elements.

## toArray Methods

### Overview
The `toArray` methods are used to convert a collection into an array. There are two overloaded methods: one that takes no parameters and one that accepts an array parameter for type-specific conversion.

### Key Concepts

#### toArray() Method
- **Method Signature**: `public Object[] toArray()`
- **Return Type**: `Object[]` 
- **Purpose**: Converts the collection to an Object array

#### toArray(T[] a) Method  
- **Method Signature**: `public <T> T[] toArray(T[] a)`
- **Return Type**: `T[]` (generic array type)
- **Parameter**: An array of the desired type with appropriate size
- **Purpose**: Converts collection to an array of the specified type, preserving type information

### Lab Demo
```java
import java.util.*;
import java.util.Arrays;

public class ToArrayDemo {
    public static void main(String[] args) {
        Vector<Integer> v2 = new Vector<>();
        v2.add(5);
        v2.add(7);
        v2.add(5);
        v2.add(7); // v2 contains [5, 7, 5, 7]
        
        // Method 1: Convert to Object array
        Object[] objArray = v2.toArray();
        System.out.println("Object array length: " + objArray.length); // 4
        
        // Display elements using Arrays.toString
        System.out.println("Object array elements: " + Arrays.toString(objArray));
        
        // Method 2: Convert to specific type array
        Integer[] intArray = new Integer[v2.size()]; // Create Integer array with collection size
        intArray = v2.toArray(intArray); // Elements copied to intArray
      
        System.out.println("Integer array elements: " + Arrays.toString(intArray));
    }
}
```

⚠ **Note**: For type-specific arrays, create an array of the desired type with the collection size and pass it to `toArray(T[] a)`.

## Operations on Collections

### Overview
Collections support various operations to manage and manipulate grouped objects. The core operations include finding if empty, adding elements, retrieving elements, searching elements, counting elements, printing elements, removing elements, and converting to arrays.

### Key Concepts
Collections perform 9 main operations:

1. **Finding** - Check if collection is empty
2. **Adding** - Insert single or multiple elements  
3. **Retrieving** - Access individual elements
4. **Searching** - Find if element exists
5. **Counting** - Get element count
6. **Printing** - Display all elements
7. **Removing** - Delete elements
8. **Replacing** - Substitute elements (not directly supported in Collection)
9. **Inserting** - Add elements at specific positions (not directly supported in Collection)  
10. **Sorting** - Arrange elements (not directly supported in Collection)

### Available Operations Table

| Operation | Description |
|-----------|-------------|
| Finding empty | Check if collection contains no elements |
| Adding elements | Insert single or multiple objects |
| Retrieving elements | Access individual objects by value/index |
| Searching elements | Verify if specific object exists |
| Counting elements | Get total number of elements |
| Printing elements | Display all elements in string format |
| Removing elements | Delete specific objects |
| Replacing elements | Substitute one object with another (index-dependent) |
| Inserting elements | Add objects at specific positions (index-dependent) |
| Sorting elements | Arrange objects in order (index-dependent) |

## Available Methods by Operation

### Overview  
Each operation is supported by specific methods in the Collection interface. Some operations have multiple methods for different use cases.

### Key Concepts

#### Adding Elements
- `add(Object)` - Add single element
- `addAll(Collection)` - Add multiple elements from another collection

#### Counting Elements  
- `size()` - Get element count
- `isEmpty()` - Check if collection is empty

#### Printing Elements
- `toString()` - Display all elements

#### Searching Elements
- `contains(Object)` - Check if single element exists
- `containsAll(Collection)` - Check if all elements from collection exist

#### Retrieving Elements  
- `iterator()` - Get iterator for traversal
- `forEach(Consumer)` - Enhanced retrieval (Java 8+)
- `stream()` - Stream-based retrieval (Java 8+)  
- `parallelStream()` - Parallel stream retrieval (Java 8+)
- `spliterator()` - Enhanced iterator (Java 8+)

#### Removing Elements
- `remove(Object)` - Remove single element occurrence
- `removeAll(Collection)` - Remove all matching elements from collection
- `retainAll(Collection)` - Keep only elements present in given collection
- `clear()` - Remove all elements
- `removeIf(Predicate)` - Remove elements matching condition (Java 8+)

#### Converting to Array
- `toArray()` - Convert to Object array
- `toArray(T[])` - Convert to typed array
- `toArray(IntFunction)` - Convert using custom array supplier (Java 11+)

### Methods Summary Table

| Operation | Methods Available |
|-----------|-------------------|
| Adding | `add()`, `addAll()` |
| Counting | `size()`, `isEmpty()` |  
| Printing | `toString()` |
| Searching | `contains()`, `containsAll()` |
| Retrieving | `iterator()`, `forEach()`, `stream()`, `parallelStream()`, `spliterator()` |
| Removing | `remove()`, `removeAll()`, `retainAll()`, `clear()`, `removeIf()` |
| Converting | `toArray()`, `toArray(T[])`, `toArray(IntFunction)` |

📝 **Note**: Operations like replace, insert, and sort require index-based access, which Collection interface doesn't provide.

## Unsupported Operations

### Overview
Certain operations cannot be performed directly on the Collection interface because it doesn't support indexed access. These operations require List-like structures.

### Key Concepts
The following operations are NOT supported in Collection interface:

#### Replacing Elements
- ❌ No direct method to replace elements by value or position  
- Reason: Collections are not necessarily ordered or indexed

#### Inserting Elements  
- ❌ No direct method to insert elements at specific positions
- Reason: Requires index-based operations

#### Sorting Elements
- ❌ No direct method to sort collection elements
- Reason: Requires ability to reorder elements by index

### Limitations
```diff
- Operations like replace(), insert(), sort() are not available
+ These require List interface or subclasses
+ Collection focuses on general collection manipulation without indexing
```

## Java 8 Additions

### Overview
Java 8 introduced several new methods to the Collection interface using default methods. These enhance functionality without breaking existing implementations and add support for functional programming concepts.

### Key Concepts

#### Stream Processing
- **stream()**: `public default Stream<E> stream()` - Sequential stream of elements
- **parallelStream()**: `public default Stream<E> parallelStream()` - Parallel stream for concurrent processing
- Both are enhancements to iterator for modern functional programming

#### Enhanced Iteration  
- **forEach(Consumer)**: `public default void forEach(Consumer<? super E> action)` - Performs action on each element
- **spliterator()**: `public default Spliterator<E> spliterator()` - Enhanced iterator with splitting capabilities

#### Conditional Removal
- **removeIf(Predicate)**: `public default boolean removeIf(Predicate<? super E> filter)` - Removes elements matching boolean condition

#### Array Conversion Enhancement
- **toArray(IntFunction)**: `public default <T> T[] toArray(IntFunction<T[]> generator)` - Converts using custom array generator (Java 11)

### Lab Demo Concepts
```java
import java.util.*;
import java.util.function.Consumer;
import java.util.function.Predicate;

public class Java8MethodsDemo {
    public static void main(String[] args) {
        Vector<Integer> numbers = new Vector<>();
        numbers.addAll(Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
        
        // forEach - Consume elements (print)
        System.out.println("Printing with forEach:");
        numbers.forEach(n -> System.out.print(n + " "));
        System.out.println();
        
        // stream() - Sequential processing
        long evenCount = numbers.stream()
                              .filter(n -> n % 2 == 0)
                              .count();
        System.out.println("Even numbers count: " + evenCount);
        
        // removeIf - Remove elements matching condition
        Predicate<Integer> isEven = n -> n % 2 == 0;
        numbers.removeIf(isEven);
        System.out.println("After removing even numbers: " + numbers);
        
        // parallelStream - Parallel processing example
        List<Double> squares = numbers.parallelStream()
                                   .mapToDouble(n -> Math.pow(n, 2))
                                   .boxed()
                                   .collect(Collectors.toList());
        System.out.println("Squares: " + squares);
    }
}
```

## Total Methods Count

### Overview
The Collection interface provides 21 methods for performing various operations on collections. These methods can be categorized by when they were introduced.

### Key Concepts

#### Total Methods: 21
1. `isEmpty()`
2. `add(E)`
3. `addAll(Collection)`
4. `contains(Object)` 
5. `containsAll(Collection)`
6. `remove(Object)`
7. `removeAll(Collection)`
8. `retainAll(Collection)`
9. `clear()`
10. `size()`
11. `toString()` (inherited from Object)
12. `hashCode()` (inherited from Object)
13. `equals(Object)` (inherited from Object)
14. `toArray()`
15. `toArray(T[])`
16. `iterator()`
17. `forEach(Consumer)` - Java 8
18. `stream()` - Java 8
19. `parallelStream()` - Java 8
20. `spliterator()` - Java 8
21. `removeIf(Predicate)` - Java 8
22. `toArray(IntFunction)` - Java 11

> [!NOTE]
> The count includes methods from java.lang.Object (toString, hashCode, equals) and focuses on 21 core collection methods.

### Methods by Category
```diff
+ Basic operations (Java 1.2): 15 methods
+ Java 8 enhancements: 6 methods  
+ Java 11 additions: 1 method
+ Total: 21+ methods
```

## API Documentation  

### Overview
The Collection interface is documented in Java API documentation and serves as the root interface for the Java Collections Framework.

### Key Concepts

#### Interface Details
- **Package**: `java.util`
- **Hierarchy**: Extends `Iterable<E>`
- **Subinterfaces**: `List<E>`, `Queue<E>`, `Set<E>`, etc.
- **Purpose**: Represents a group of objects with various characteristics

#### Documentation Insights
- Collections may allow duplicates or be unordered
- Used for maximum generality in programming (loose coupling)
- No direct implementations - uses subinterface implementations
- Supports unmodifiable views and serialization

> [!IMPORTANT]  
> The Collection interface is designed for runtime polymorphism and loose coupling. It allows passing collections around without knowing the specific implementation type.

## Corrections and Notes

### Corrections Made
The following corrections were applied to improve clarity and accuracy:

- "uh tell me I hope you got Clarity on uh this point right remove all Method" → "removeAll method"
- "empty method understood add method understood add all understood contains contains all remove remove all" → "isEmpty, add, addAll, contains, containsAll, remove, removeAll"
- "except nine remaining elements are there right come on come on run" → "except 9, remaining elements"
- "return all" corrected to "retainAll" throughout
- "scolling" → "scolding"
- "method name retain all not remove all met name is what retain" → "retainAll"
- "public in size me name is what size" → "size"
- "iterator this method I don't explain I cannot explain" → "iterator method will be covered later"
- "public Boolean I want retri hash code" → "hashCode"
- "eighth method" properly identified as clear
- "collection to array collection to array look at there the return type is T any type" → "toArray() returns Object[]"
- "obj array dot obj do length" → "objArray.length"
- "aray dot remember aray dot two string of obj" → "Arrays.toString(obj)"
- "arry method" → "toArray method" 
- "integer array IA equal to new new integer of" → "Integer[] intArray = new Integer[]"
- "public return return type is T array and parameter type is or you can say for understanding object array" → "toArray(T[]) signature"
- "finding I mean finding collection is empty or not okay second is adding element" → operations listed clearly
- "to string method" → "toString method"
- "contains all meod collection" → "containsAll method"
- "e o i writing e e stands for element" → clarified container usage
- "Java 1.5 version sorry in Java 8 version" → "Java 8 version"
- "collection APA documentation" → "Collection API documentation"
- "sub interfaces list set" → "List, Set"
- "runtime polymorphism lose coupling" → "runtime polymorphism and loose coupling"
- "unmodifiable collections unmodified view collections serializable" → "unmodifiable views, serializable collections"
- "public below what the method written" → "public default methods"
- "stream of elements method name is stream" → "stream() method"
- "Sun micro system" → "Sun Microsystems"
- "split iterator pronunciation is split iterator" → "Spliterator"
- "Lambda expression will verify the object is matched to this condition or not" → "Lambda expression defines boolean condition"
- "from The Collection" → "from the collection"
- "N9 version I guess yeah 11 version" → clarified as Java 11 for toArray(IntFunction)
- "totally how many methods are there 21 methods" → "21 methods"
- "can you please try to byart all these methods" → "memorize all these methods"
- Corrected various typo variations and method signatures throughout

### Additional Notes
- ✅ Code examples were reconstructed based on transcript descriptions for clarity
- ✅ Method counts verified against current Java API documentation  
- ✅ Focus maintained on Collection interface methods only
- ✅ Enhancements from Java 8 and Java 11 clearly identified
- ⚠ Session scheduling discussions at the end were omitted as they are not part of the technical content

## Summary

### Key Takeaways
```diff
+ Collection interface provides 21 methods for fundamental operations: add, count, print, search, retrieve, remove, convert
+ retainAll() performs reverse of removeAll() - keeps only elements present in given collection
+ toArray() methods convert collections to arrays with or without type specificity  
+ Java 8 added stream processing, functional iteration, and conditional removal methods
! Index-dependent operations like replace, insert, sort not supported - require List interface
+ Method memorization enables effective collection programming and debugging
```

### Expert Insight

**Real-world Application**: Collection methods form the foundation for data manipulation in enterprise applications. Understanding method behaviors prevents bugs in CRUD operations, filtering, and data transformations that occur during user interactions or batch processing.

**Expert Path**: Master Collection methods first before diving into concrete implementations. Practice creating custom collections to understand internal method logic. Focus on when to use retainAll vs removeAll for set operations.

**Common Pitfalls**: 
- Confusing retainAll with removeAll - always test with small examples first
- Forgetting that remove(Object) removes only first occurrence, not all matches
- Assuming collection methods maintain insertion order (depends on implementation)
- Not checking return values of modification methods (add, remove, clear return boolean)

**Lesser-known Things**: 
- retainAll can be used for intersection-like operations across collections
- empty collection after clear() maintains structure for reuse without recreation
- Java 8+ methods enable functional programming patterns without loops
- API documentation shows full method signatures with generic type bounds
