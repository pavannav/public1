# Assignment Generation Instructions

## Overview
This document provides instructions for generating assignment files from training transcript files. There are two different formats based on the source transcript location.

---
# There are 2 types of file formats

## Format 1: Session-N Format

- File naming pattern: `Session-XX-[Topic-Description].txt`
- Example: `Session-12-Disk-Management-in-RHEL-8.txt`

### Output file naming

- File naming: `Session-XX-Assignment.md`

### Summary Format
```
<details open>
<summary><b> Section [N]: [Full Topic Name from Filename]</b></summary>
```

### Example Summary
```
<details open>
<summary><b> Session 12: Disk Management in RHEL-8</b></summary>
```

---

## Format 2: Section-N Format 

- File naming pattern: `[N.N]-[Topic-Description].txt`
- Example: `4.1-Introduction-to-systemd.txt`, `4.8-restarting-systemd.txt`

### Output file naming
- File naming: `Section-XX-Assignment.md`

### Summary Format
```
<details open>
<summary><b> Section [N]: [Section Topic Name]</b></summary>
```

### Example Summary
```
<details open>
<summary><b> Section 04: systemd </b></summary>
```

---

## HTML Wrapper Structure (Both Formats)

### Required Format
```
<details open>
<summary><b> Section [N]: [Topic/Section Name]</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

[Exercise content here]

</details>
</details>
```

### Key Points
- Start with `<details open>` (main container)
- First `<summary>` contains the Section number and topic/section name
- Assignment-01 is initially populated with exercises
- Assignment-02, Assignment-03, etc. remain empty until requested
- Always close with `</details></details>`

---

## Assignment Content Guidelines

### Exercise Structure
1. **Beginner Level** (Exercises 1.1, 1.2, 1.3)
   - Basic concept understanding
   - Simple command usage
   - Documentation tasks

2. **Intermediate Level** (Exercises 2.1, 2.2, 2.3)
   - Configuration tasks
   - Service management
   - Troubleshooting basics

3. **Advanced Level** (Exercises 3.1, 3.2, 3.3)
   - Complex scenarios
   - Automation/scripts
   - Production-like situations

### Exercise Components
Each exercise should include:
- **Objective**: Clear learning goal
- **Tasks**: Specific actionable items
- **Commands**: Practical CLI examples where relevant
- **Deliverable**: Expected output or documentation

---

## Process Workflow

### Step 1: Identify Format Type
- When asked to process a session or section 
- Identify whether transcripts are in file format 1 or format 2


### Step 2: Read All Related Transcripts
- For Format 1: Read the single transcript file
- For Format 2: Read all files in that section (e.g., 5.1 through 5.8)

### Step 3: Create Assignment File
- Generate filename based on format rules if file is not already there
- Apply correct HTML wrapper
- Populate Assignment-01 with comprehensive exercises

### Step 4: Assignments Management
- Initial creation: Populate only Assignment-01
- On request for more practice: Create Assignment-02
- Continue with Assignment-03, Assignment-04 as requested

---

## Notes

1. **Topic Extraction**: For Format 1, extract topic from filename after the session number
2. **Section Topics**: For Format 2, create appropriate section-level topic names based on content
3. **Progressive Difficulty**: Exercises should be at different complexity levels from beginner to expert and cover all the important things around the concepts covered.
4. **Command Accuracy**: All commands in exercises should be verified against the transcript content
5. Please create a comprehensive list of exercises for the topics covered in the Session/section.

