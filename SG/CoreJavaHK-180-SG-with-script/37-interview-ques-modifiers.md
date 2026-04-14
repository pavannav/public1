# Session 37: Interview Ques Modifiers

## Table of Contents
- [Introduction and Motivation](#introduction-and-motivation)
- [Review of Yesterday's Accessibility Modifiers](#review-of-yesterdays-accessibility-modifiers)
- [Today's Focus: Modifiers with Static Members](#todays-focus-modifiers-with-static-members)
- [Example 1: Static Members in Same Class (Package P3)](#example-1-static-members-in-same-class-package-p3)
- [Example 2: Accessing Static Members from Another Class in Same Package](#example-2-accessing-static-members-from-another-class-in-same-package)
- [Example 3: Accessing Static Members from Another Class in Different Package](#example-3-accessing-static-members-from-another-class-in-different-package)
- [Example 4: Accessing Protected Static Members Using Subclass Reference](#example-4-accessing-protected-static-members-using-subclass-reference)
- [Example 5: Accessing Protected Static Members from Different Subclass](#example-5-accessing-protected-static-members-from-different-subclass)
- [Interview Question 1: How to Stop Other Programmers from Accessing Class Members](#interview-question-1-how-to-stop-other-programmers-from-accessing-class-members)
- [Interview Question 6: Difference Between Default and Protected](#interview-question-6-difference-between-default-and-protected)
- [Interview Question 7: Difference Between Protected and Public](#interview-question-7-difference-between-protected-and-public)
- [Interview Question 8: Applicability of Protected Modifier Rules to Static Members](#interview-question-8-applicability-of-protected-modifier-rules-to-static-members)
- [Interview Question 9: Difference Between Protected Static and Non-Static Members](#interview-question-9-difference-between-protected-static-and-non-static-members)
- [Interview Question 10: Applying All Four Modifiers to Various Programming Elements](#interview-question-10-applying-all-four-modifiers-to-various-programming-elements)
- [Subquestion: To Packages](#subquestion-to-packages)
- [Subquestion: To Outer Classes](#subquestion-to-outer-classes)
- [Why We Cannot Declare Outer Classes as Private or Protected](#why-we-cannot-declare-outer-classes-as-private-or-protected)
- [Why We Can Declare Outer Classes as Default or Public](#why-we-can-declare-outer-classes-as-default-or-public)
- [Subquestion: To Inner Classes](#subquestion-to-inner-classes)
- [Subquestion: To Variables](#subquestion-to-variables)
- [Subquestion: To Methods](#subquestion-to-methods)
- [Subquestion: To Constructors](#subquestion-to-constructors)
- [Subquestion: To Blocks](#subquestion-to-blocks)
- [Interview Question 20: Default Modifier for Local Variables, Inner Classes, and Blocks](#interview-question-20-default-modifier-for-local-variables-inner-classes-and-blocks)
- [Interview Question 21: Default Modifier for Classes and Members](#interview-question-21-default-modifier-for-classes-and-members)
- [Interview Question 22: Default Modifier for Interfaces and Members](#interview-question-22-default-modifier-for-interfaces-and-members)
- [Interview Question 23: Default Modifier for Members](#interview-question-23-default-modifier-for-members)
- [Interview Question 24: Default Modifier for Interfaces and Members](#interview-question-24-default-modifier-for-interfaces-and-members)
- [Interview Question 25: Default Modifier for Enums and Members](#interview-question-25-default-modifier-for-enums-and-members)
- [Interview Question 26: Default Modifier for Annotations and Members](#interview-question-26-default-modifier-for-annotations-and-members)
- [Other Modifiers Note](#other-modifiers-note)
- [Conclusion and Summary](#conclusion-and-summary)

## Introduction and Motivation
Encourages changing negative mindset: "I cannot" to "I will". Success comes from trying: question leads to search leads to success. Mindset shift transforms failure into success.

## Review of Yesterday's Accessibility Modifiers
Did you practice? Validators must practice, not just time-pass.

## Today's Focus: Modifiers with Static Members
Testing cases with static members. Instead of non-static, use static variables and methods.

## Example 1: Static Members in Same Class (Package P3)
Create class `F.java` with static members `a`, `b`, `c`, `d` - private, default, protected, public respectively. All are static.

- No object needed; call directly.
- Within same class, access using name (no class name or object needed).
- Put in package `P3`.
- Compile: `javac -d ./P3 F.java`
- Package P3 created successfully.
- Run: `java P3.F`
- Output: `a b c d` (all accessible within same class).

## Example 2: Accessing Static Members from Another Class in Same Package
Create `G.java` in same package `P3` extending `F`. Try accessing `F.a`, `F.b`, `F.c`, `F.d`.

- Compile: `javac -d ./P3 G.java`
- Error: `a` has private access, cannot access private static member from another class.
- Comment out `F.a`.
- Compile again: successful.
- Output: `B C D` (public, protected, default accessible in same package except private).
- Note: Same rules as non-static for private and default.

## Example 3: Accessing Static Members from Another Class in Different Package
Create `H.java` in package `P4`, import `P3.F`, no extend. Try accessing `F.a`, `F.b`, `F.c`, `F.d`.

- Compile: `javac -d ./P4 H.java`
- Errors: `a` private access, `b` not public, `c` protected access.
- Comment out all but `F.d`.
- Still errors; wrong import path.
- Correct import: `import P3.*;` in `H.java`.
- But still compilation fails for `F.d` (default not accessible from different package).
- After commenting errors, compile successful.
- Override default modifier in import? No, package P3 wrong.
- Actual package P3 exists, but for default access from different package fails.
- Import `P3.F`; still fails for `F.c` protected.
- By extending `F`, changing class to subclass.
- Compile: successful (protected accessible in subclass).
- Run: `java P4.H`
- Output: `C D` (protected and public accessible).

## Example 4: Accessing Protected Static Members Using Subclass Reference
Create `H.java` as subclass of `F`. Use `H.c`, `H.d`.

- Compile: `javac -d ./P4 H.java`
- Comment previous accesses.
- Protected static member accessible via subclass reference (not super reference).
- Compile successful.
- Run: `java P4.H`
- Output: `C D`

## Example 5: Accessing Protected Static Members from Different Subclass
Create `J.java` in `P3` extending `F`. Try accessing `F.c`, `F.d`.

- Compile: `javac -d ./P3 J.java`
- Note: Even from another subclass in same package, protected static allowed.
- Compile successful.
- Output: `C D`

## Interview Question 1: How to Stop Other Programmers from Accessing Class Members
- Private: stop from other classes.
- Default: stop from other packaged classes.
- Protected: allow only in subclasses from other packages.
- Public: allow anywhere.

Question: Why use these modifiers?

## Interview Question 6: Difference Between Default and Protected
- Same in same package.
- From other packaged classes: default not accessible; protected accessible only in subclasses.

## Interview Question 7: Difference Between Protected and Public
- In same package: same.
- From other packaged classes: protected only in subclasses; public anywhere.

## Interview Question 8: Applicability of Protected Modifier Rules to Static Members
- Yes, partially. Only one rule applies: accessible in subclass from other package.

## Interview Question 9: Difference Between Protected Static and Non-Static Members
- Same package: no difference.
- Other package: non-static protected accessible in subclass with super reference; static protected accessible in subclass with any subclass reference or super reference.

## Interview Question 10: Applying All Four Modifiers to Various Programming Elements

### Subquestion: To Packages
Not allowed; no need (no data).

### Subquestion: To Outer Classes
Private and protected not allowed; default and public allowed.

#### Why We Cannot Declare Outer Classes as Private or Protected
Private means accessible within enclosing class; outer class has no enclosing class. Protected means accessible in subclasses of enclosing class; no enforcing class exists. Thus, boundary not defined; compiler error.

#### Why We Can Declare Outer Classes as Default or Public
Default: accessible within package (package is boundary). Public: accessible anywhere.

### Subquestion: To Inner Classes
- Class-level inner classes (static and non-static): all four allowed.
- Method-level inner classes (local and anonymous): all four not allowed.

### Subquestion: To Variables
- Class-level variables (static and non-static): all four allowed.
- Method-level variables (parameters and locals): all four not allowed.

### Subquestion: To Methods
- Abstract methods: private not allowed (must be implemented by subclasses); default, protected, public allowed.
- Concrete methods: all four allowed.

### Subquestion: To Constructors
- Default constructor: same accessibility as class (default or public).
- Programmer-defined constructors: all four allowed.

### Subquestion: To Blocks
All three types (static, instance, local) cannot have any modifiers.

## Interview Question 20: Default Modifier for Local Variables, Inner Classes, and Blocks
No modifier (not default; default means package-level access, but these have narrower scope).

## Interview Question 21: Default Modifier for Classes and Members
Default (accessible within same package).

## Interview Question 22: Default Modifier for Interfaces and Members
Interface: default; members: public.

## Interview Question 23: Default Modifier for Members
(Default for classes, variables, methods, constructors, inner classes).

## Interview Question 24: Default Modifier for Interfaces and Members
(Repeated).

## Interview Question 25: Default Modifier for Enums and Members
Enum: default; named constants: public; constructors: private; variables, methods, inner classes: default.

## Interview Question 26: Default Modifier for Annotations and Members
Same as interfaces (annotation is like interface).

## Other Modifiers Note
Other modifiers (static, final, etc.) explained in respective chapters/chapters.

## Conclusion and Summary

### Key Takeaways
```diff
+ Accessibility modifiers: private, default, protected, public.
+ Applied selectively based on programming element and scope.
- Static vs non-static protected have one rule difference in other packages.
+ Outer classes: only default and public.
+ Inner classes: method-local cannot have modifiers.
+ Variables: method-local cannot have modifiers.
+ Methods: abstract cannot be private.
+ Constructors: default mirrors class accessibility.
+ Blocks: none allowed.
```

### Expert Insight

#### Real-world Application
Design APIs with modifiers to control access: private for encapsulation, public for entry points, protected for inheritance, default for package-private utilities.

#### Expert Path
Master by creating multi-package projects and testing accessibilities; understand why rules exist (enclosing boundaries).

#### Common Pitfalls
- Assuming default protects from other package subclasses.
- Applying modifiers to method-locals compiler error.
- Misusing protected static in non-subclasses.
- Assuming unnamed elements need modifiers.

Common issues: compilation errors like "modifier not allowed"; fix by correctly applying rules. Avoid by practicing with examples. Lesser known: default exists only for non-local elements.
