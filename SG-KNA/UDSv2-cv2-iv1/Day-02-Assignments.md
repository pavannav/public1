# Day-02 Assignments: Computer Fundamentals and Tool Setup

## Learning Objectives
- Understand computer fundamentals and architecture
- Identify input/output devices and their roles
- Understand CPU operations and system memory hierarchy
- Set up development tools and understand their purpose
- Establish foundation for data science environment

---

## Beginner Level

### Exercise 1: Computer Basics Identification
**Objective:** Identify basic computer components
1. List 5 input devices and explain what type of input each accepts
2. List 5 output devices and describe the type of output they produce
3. Explain in 2-3 sentences: Why is a smartphone considered a computer?

### Exercise 2: Input/Output Flow Understanding
**Objective:** Trace data flow through a computer system
For each scenario, identify what serves as input device, processing unit, and output device:
- Typing a document and printing it
- Recording audio and playing it back
- Taking a photo and viewing it on screen
- Scanning a QR code and displaying information

### Exercise 3: Simple Calculator Analogy
**Objective:** Understand the input-process-output model
Create a table showing how a basic calculator follows the computer model:
| Operation | Input | Process | Output |
|-----------|-------|---------|--------|
| 5 + 3 | ? | ? | ? |
| Square root of 16 | ? | ? | ? |

---

## Intermediate Level

### Exercise 4: Memory Hierarchy Analysis
**Objective:** Understand different memory types and their purposes
1. Compare and contrast:
   - CPU Cache (L1, L2, L3)
   - RAM
   - Hard Drive/SSD Storage
   Create a comparison table with: Size, Speed, Cost, Persistence, and Use Case

2. Why does CPU have very limited memory (measured in MB) compared to RAM (measured in GB)?

### Exercise 5: System Specifications Audit
**Objective:** Analyze your own computer system
1. Check your system specifications:
   - CPU model and number of cores
   - RAM amount and type
   - Storage types and capacities
   - Cache sizes if available

2. Research what each specification means for:
   - Running Python programs
   - Processing large datasets
   - Running multiple applications simultaneously

### Exercise 6: Device Categorization Challenge
**Objective:** Classify modern devices and interfaces
Categorize the following as Input, Output, or Both (I/O):
- Touchscreen
- USB drive
- Network card
- Webcam
- Headphones with microphone
- Graphics card
Explain your reasoning for the "Both" categories.

---

## Advanced Level

### Exercise 7: Performance Impact Analysis
**Objective:** Understand how hardware affects software performance
1. A program needs to process 1 million data points. Analyze:
   - How much data can fit in CPU cache vs RAM?
   - What happens when data exceeds RAM capacity?
   - How does storage speed affect loading times?

2. Research and explain:
   - Why do data scientists need more RAM than developers?
   - How does CPU speed affect machine learning training?

### Exercise 8: Tool Ecosystem Mapping
**Objective:** Understand why specific tools are chosen for data science
Create a mind map or diagram showing:
- Python → Jupyter → Data Analysis workflow
- Why Jupyter over other Python IDEs?
- How does the browser-based interface work?
- Connection between local Python installation and cloud notebooks

### Exercise 9: Binary and Processing Understanding
**Objective:** Connect hardware concepts to data representation
1. Explain how text typed on a keyboard becomes binary for CPU processing
2. Research ASCII/Unicode and explain how characters are represented
3. Calculate: If each character takes 1 byte, how many characters can your CPU cache store?

---

## Expert Level

### Exercise 10: Architecture Design Challenge
**Objective:** Design optimal systems for data science workloads
Design a computer configuration for:
- A data scientist working with 100GB datasets daily
- Requirements: Process in <30 minutes, multiple models training simultaneously
Justify your choices for:
- CPU cores and cache size
- RAM amount and type
- Storage configuration (multiple drives?)
- Any specialized hardware (GPU?)

### Exercise 11: Bottleneck Identification
**Objective:** Diagnose performance issues in data processing
Given symptoms, identify the likely bottleneck:
1. "Loading a 5GB CSV takes 10 minutes"
2. "Python crashes with MemoryError on large datasets"
3. "Calculations are slow despite having 32GB RAM"
4. "Jupyter notebook becomes unresponsive with many outputs"

For each, suggest hardware or configuration solutions.

### Exercise 12: Future-Proofing Analysis
**Objective:** Evaluate technology trends
Research and write a 500-word analysis on:
- How will quantum computers change our understanding of "processing"?
- Impact of cloud computing on local hardware requirements
- Edge computing: When might your laptop's CPU not be sufficient?
- Will traditional input/output devices become obsolete?

---

## Practical Setup Tasks

### Task A: Environment Verification
1. Verify Python installation:
   ```bash
   python --version
   pip list
   ```
2. Check Jupyter installation:
   ```bash
   jupyter --version
   jupyter notebook --generate-config
   ```

### Task B: System Monitoring
1. Install system monitoring tools:
   - Windows: Task Manager/Resource Monitor
   - Mac: Activity Monitor
   - Linux: `htop`, `top`, or `sysstat`

2. Monitor while running a simple Python script that:
   - Reads a large file
   - Performs calculations
   - Writes output

### Task C: Documentation
Create a personal reference document:
- Your system specifications
- Python and Jupyter versions
- Common commands for your OS
- Links to installation guides for reference

---

## Submission Guidelines
- Complete at least 2 exercises from each level
- Document your answers clearly with explanations
- Include screenshots for practical tasks
- Note any questions or concepts needing clarification

## Resources
- Computer Architecture basics
- Python official documentation
- Jupyter notebook user guide
- System specifications lookup tools