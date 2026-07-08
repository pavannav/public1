<details open>
<summary><b> Session 25: Viewing File Differences</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Basic Git Diff Usage
**Objective**: Master the fundamental `git diff` command to see changes before committing

**Tasks**:
1. Modify an existing file in your repository (e.g., README.md)
2. Add some new content to the file
3. Run `git status` to confirm the file is modified
4. Execute `git diff <filename>` to see the changes
5. Identify the color coding: red for deletions, green for additions

**Commands**:
```bash
vim README.md  # or use any editor
# Add some new content
git status
git diff README.md
```

**Deliverable**: Screenshot showing git diff output with color-coded changes (red/green)

## Exercise 1.2: Interpret Git Diff Output
**Objective**: Understand what git diff shows between last commit and current state

**Tasks**:
1. Create a file with initial content
2. Commit the file
3. Modify the file significantly (change lines, add new lines, remove lines)
4. Run `git diff` and analyze each section:
   - Lines starting with `-` (red) = deleted content
   - Lines starting with `+` (green) = added content
   - Context lines without prefix = unchanged
5. Document your understanding of the diff format

**Commands**:
```bash
echo "Initial content line 1" > diff-test.txt
echo "Initial content line 2" >> diff-test.txt
git add diff-test.txt
git commit -m "Add initial diff test file"
# Edit the file
vim diff-test.txt
git diff diff-test.txt
```

**Deliverable**: Annotated diff output explaining each type of change shown

## Exercise 1.3: Personal Workflow Integration
**Objective**: Establish git diff as part of your commit workflow

**Tasks**:
1. Modify multiple files in your project
2. Create a workflow checklist:
   - Run `git status` to see modified files
   - Run `git diff <file>` for each modified file
   - Review changes line by line
   - Decide whether to proceed with commit or continue editing
3. Document this as your personal pre-commit review process

**Commands**:
```bash
git status
git diff file1.txt
git diff file2.txt
# Review each diff carefully
git add file1.txt file2.txt
git commit -m "Commit after diff review"
```

**Deliverable**: Documented personal workflow checklist for pre-commit reviews

## Exercise 2.1: Git Smart Diff Behavior
**Objective**: Understand how git detects actual content changes vs formatting

**Tasks**:
1. Create a test demonstrating git's intelligence:
   - Create a file with "Lorem ipsum" text
   - Commit it
   - Replace the text with identical "Lorem ipsum" (delete and re-add same content)
   - Run git diff and observe that git recognizes no actual change
2. Document this behavior with explanation

**Commands**:
```bash
echo "Lorem ipsum dolor sit amet" > smart-test.txt
git add smart-test.txt
git commit -m "Add smart test file"
# Delete and re-add identical content
git diff smart-test.txt  # Should show no changes
```

**Deliverable**: Demonstration and explanation of git's change detection intelligence

## Exercise 2.2: Diff Various File Types
**Objective**: Practice using git diff on different types of files

**Tasks**:
1. Create and modify various file types:
   - Text file (.txt)
   - Markdown file (.md)
   - Configuration file (.json, .yaml, or .conf)
   - Code file (.js, .py, .html, etc.)
2. Run git diff on each type
3. Note any differences in how changes are displayed
4. Create a summary of observations

**Commands**:
```bash
# Create different file types
echo "Sample text" > test.txt
echo '{"key": "value"}' > test.json
echo "console.log('hello');" > test.js

# Modify each and diff
git diff test.txt
git diff test.json
git diff test.js
```

**Deliverable**: Comparative analysis of git diff output across different file types

## Exercise 2.3: Diff Workflow Decision Points
**Objective**: Use git diff to make informed commit decisions

**Tasks**:
1. Make several changes to a file including:
   - Intentional changes you want to keep
   - Accidental changes or notes you want to remove
2. Use git diff to review all changes
3. Decide which changes to keep vs discard
4. Either:
   - Edit the file to remove unwanted changes, or
   - Proceed with clean changes only
5. Document your decision-making process

**Commands**:
```bash
# Make mixed changes (good and bad)
vim messy-file.txt
git diff messy-file.txt
# Review and decide
# Either clean up or commit based on review
git status
```

**Deliverable**: Documented decision process with before/after diff examples

## Exercise 3.1: Advanced Diff Options
**Objective**: Explore additional git diff options and formats

**Tasks**:
1. Experiment with different diff options:
   - `git diff --stat` (summary of changes)
   - `git diff --name-only` (just filenames)
   - `git diff -U<context>` (more/less context lines)
   - `git diff --color-words` (word-level highlighting)
2. Apply each to the same set of changes
3. Document which format is most useful for different scenarios

**Commands**:
```bash
git diff --stat
git diff --name-only
git diff -U5  # 5 lines of context
git diff --color-words
```

**Deliverable**: Comparison of different diff formats with use case recommendations

## Exercise 3.2: Pre-Commit Diff Checklist
**Objective**: Create a systematic approach to reviewing changes

**Tasks**:
1. Develop a comprehensive pre-commit checklist:
   - [ ] Run git status to identify all changes
   - [ ] Run git diff on each modified file
   - [ ] Review all additions (green lines)
   - [ ] Review all deletions (red lines)
   - [ ] Check for accidental changes (debug code, TODOs)
   - [ ] Verify no sensitive information added
   - [ ] Confirm changes align with commit message
2. Apply this checklist to a set of changes
3. Document findings and any issues caught

**Checklist Template**:
```markdown
# Pre-Commit Diff Review Checklist

## Files Modified
- [ ] List all modified files from git status

## Content Review
- [ ] Reviewed all additions
- [ ] Reviewed all deletions
- [ ] No debug/test code left in
- [ ] No sensitive data exposed
- [ ] Changes are focused and related

## Final Verification
- [ ] Ready to stage files
- [ ] Commit message prepared
```

**Deliverable**: Completed checklist with evidence of thorough review process

## Exercise 3.3: Collaborative Diff Review Simulation
**Objective**: Practice using diff for code review scenarios

**Tasks**:
1. Create a scenario simulating code review:
   - Make changes as if implementing a feature
   - Include both the feature code and some issues
2. Generate a diff as if preparing for review
3. Document what a reviewer would look for:
   - Code quality
   - Consistency
   - Potential bugs
   - Documentation needs
4. "Review" your own diff and note improvements needed

**Commands**:
```bash
# Make feature-like changes with some issues
git diff > feature-review.diff
# Analyze the diff as a reviewer would
cat feature-review.diff
```

**Deliverable**: Simulated code review with findings and improvement suggestions based on diff analysis

</details>
</details>