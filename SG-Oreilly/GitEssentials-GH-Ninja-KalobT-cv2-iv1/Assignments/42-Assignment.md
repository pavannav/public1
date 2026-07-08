<details open>
<summary><b> Session 42: Creating Your First File</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding Dual File Creation Methods
**Objective**: Learn the two primary methods for creating files in GitHub repositories

**Tasks**:
1. Research the advantages and disadvantages of GitHub web interface vs local editing
2. Understand the workflow differences between direct web editing and local development
3. Identify scenarios where each method is most appropriate

**Deliverable**: Document comparing web interface vs local editing workflows with use case scenarios

---

## Exercise 1.2: GitHub Web Interface File Creation
**Objective**: Master creating files directly on GitHub using the web interface

**Tasks**:
1. Navigate to your GitHub Pages repository
2. Use the "Create new file" button to create index.html
3. Add basic HTML content and commit with descriptive message

**Commands/Steps**:
```
GitHub Interface Actions:
1. Click "Create new file" button
2. File name: index.html
3. Content: <h1>Hello World</h1>
4. Commit message: "First hello world commit"
5. Commit directly to master branch
```

**Deliverable**: Successfully created index.html via GitHub web interface with commit visible in repository history

---

## Exercise 1.3: Local Repository Synchronization
**Objective**: Practice syncing remote changes to local development environment

**Tasks**:
1. Execute git pull to synchronize local repository
2. Verify new files appear in local directory and code editor
3. Confirm commit history includes web-created commits

**Commands**:
```bash
git pull origin master
git log --oneline
ls -la
# Open in VS Code to verify file presence
```

**Deliverable**: Successfully synchronized local repository with web-created files and confirmed commit history

---

## Exercise 2.1: Local HTML File Development
**Objective**: Practice developing HTML files locally with proper structure and responsiveness

**Tasks**:
1. Expand basic index.html with proper HTML5 structure
2. Add responsive design considerations and language attributes
3. Include body content with heading elements

**Commands**:
```html
<!-- index.html structure -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portfolio Site</title>
</head>
<body>
    <h1>This was edited locally</h1>
</body>
</html>
```

**Deliverable**: Properly structured HTML5 file with responsive design elements and semantic markup

---

## Exercise 2.2: Code Editor Integration Workflow
**Objective**: Establish efficient local development workflow using code editors

**Tasks**:
1. Open repository in preferred code editor (VS Code recommended)
2. Verify automatic detection of repository files
3. Practice file editing and saving workflow

**Commands**:
```bash
# From repository directory
code .  # Opens in VS Code
# Or manually open the folder in your preferred editor
```

**Deliverable**: Established code editor workflow with repository files accessible and editable

---

## Exercise 2.3: Content Iteration and Local Changes
**Objective**: Practice making iterative changes to locally developed files

**Tasks**:
1. Modify the locally created HTML file with additional content
2. Practice the save workflow and verify changes persist
3. Prepare files for the next step of pushing to remote

**Deliverable**: Modified HTML file with additional content ready for git push workflow

---

## Exercise 3.1: Commit History Analysis
**Objective**: Understand how different editing methods contribute to commit history

**Tasks**:
1. Analyze the commit history showing both web and local contributions
2. Document the commit messages and their relationship to workflow methods
3. Understand how git tracks changes regardless of editing method

**Commands**:
```bash
git log --oneline --graph
git log --pretty=format:"%h - %an, %ar : %s"
```

**Deliverable**: Documented commit history analysis showing mixed web/local editing contributions

---

## Exercise 3.2: File Management Best Practices
**Objective**: Develop best practices for managing files across web and local environments

**Tasks**:
1. Create guidelines for when to use web interface vs local editing
2. Establish naming conventions and file organization strategies
3. Plan content strategy for portfolio development

**Deliverable**: Best practices guide covering file management strategies and workflow decisions

---

## Exercise 3.3: Preparation for Git Push Workflow
**Objective**: Prepare local changes for the upcoming git push lesson

**Tasks**:
1. Ensure all local changes are saved and ready for staging
2. Review current repository state and pending changes
3. Document current working state for continuity with next lesson

**Commands**:
```bash
git status
git diff
# Verify all changes are properly saved locally
```

**Deliverable**: Repository state documentation showing readiness for git push operations in the next lesson

</details>
</details>