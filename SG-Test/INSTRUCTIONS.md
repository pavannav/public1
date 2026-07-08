# Assignment Generation Instructions

## Overview
This document provides instructions for generating assignment files from training transcript files. There are two different formats based on the source transcript location.

---

## Format 1: Session-N Format (RHCSA Training)

### Source Location
- Transcripts: `/root/public1/Transcripts/NHC-RHCSAv8/`
- File naming pattern: `Session-XX-[Topic-Description].txt`
- Example: `Session-30-Disk-Management-in-Linux-Managing-Storage-in-RHEL-8.txt`

### Output Location
- Assignments: `/root/public1/SG-Test/NHC-RHELv8/`
- File naming: `Session-XX-Assignment.md`

### Summary Format
```
<details open>
<summary><b> Section [N]: [Full Topic Name from Filename]</b></summary>
```

### Example Summary
```
<details open>
<summary><b> Section 30: Disk Management in Linux - Managing Storage in RHEL-8</b></summary>
```

---

## Format 2: Section-N Format (Linux Networking Training)

### Source Location
- Transcripts: `/root/public1/Transcripts/Oreilly-Transcripts/LinuxNetworking-DaveP/`
- File naming pattern: `[N.N]-[Topic-Description].txt`
- Example: `7.1-Introduction-to-systemd-and-the-networkd-service.txt`

### Output Location
- Assignments: `/root/public1/SG-Test/LinuxNetworking/`
- File naming: `Section-XX-Assignment.md`

### Summary Format
```
<details open>
<summary><b> Section [N]: [Section Topic Name]</b></summary>
```

### Example Summary
```
<details open>
<summary><b> Section 07: systemd-networkd and Netplan Configuration</b></summary>
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
- Set-01 is initially populated with exercises
- Set-02, Set-03, etc. remain empty until requested
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
- Check transcript location to determine format
- Use Session-N format for NHC-RHCSAv8 transcripts
- Use Section-N format for LinuxNetworking transcripts

### Step 2: Read All Related Transcripts
- For Session-N: Read the single transcript file
- For Section-N: Read all files in that section (e.g., 7.1 through 7.8)

### Step 3: Create Assignment File
- Create appropriate directory if needed
- Generate filename based on format rules
- Apply correct HTML wrapper
- Populate Set-01 with comprehensive exercises

### Step 4: Set Management
- Initial creation: Populate only Set-01
- On request for more practice: Create Set-02
- Continue with Set-03, Set-04 as requested

---

## Directory Structure

```
/root/public1/SG-Test/
├── INSTRUCTIONS.md (this file)
├── NHC-RHELv8/
│   ├── Session-01-Assignment.md
│   ├── Session-02-Assignment.md
│   └── ...
├── LinuxNetworking/
│   ├── Section-01-Assignment.md
│   ├── Section-02-Assignment.md
│   └── ...
└── [Other training directories as added]
```

---

## Notes

1. **Topic Extraction**: For Session format, extract topic from filename after the session number
2. **Section Topics**: For Section format, create appropriate section-level topic names based on content
3. **Exercise Count**: Typically 9-12 exercises per Set-01 (3 levels × 3-4 exercises)
4. **Command Accuracy**: All commands in exercises should be verified against the transcript content
5. **Progressive Difficulty**: Exercises should build from basic to advanced concepts covered in transcripts