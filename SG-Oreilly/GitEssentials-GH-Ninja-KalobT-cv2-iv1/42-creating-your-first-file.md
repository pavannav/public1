# Session 42: Creating Your First File

<details open>
<summary><b>Session 42: Creating Your First File (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

1. [How to Create Your First File](#how-to-create-your-first-file)
2. [Viewing Commit History](#viewing-commit-history)
3. [Editing Files Locally with VS Code](#editing-files-locally-with-vs-code)

## How to Create Your First File

### Overview

This module covers the process of creating your first new file in a GitHub repository and committing it. Two primary methods are demonstrated: creating files directly on GitHub's web interface and creating files locally using a code editor like VS Code.

### Creating Files Directly on GitHub

GitHub provides a simple web-based method for creating files without needing local setup:

- Click the "Add file" dropdown button in the repository
- Select "Create new file"
- Name the file (e.g., `index.html`)
- Add content directly in the text editor (e.g., `<h1>Hello World</h1>`)
- Use the preview feature to verify the rendered output
- Scroll down and provide a commit message (e.g., "first hello world commit")
- Click the green "Commit new file" button

### GitHub's Web Editor Features

- **Live Preview**: Shows how markdown or HTML will render before committing
- **Commit Message Required**: All changes must include a descriptive message
- **Direct Repository Updates**: Changes appear immediately in the repository

## Viewing Commit History

### Overview

After creating files, GitHub displays a visual commit history that helps track changes over time.

### Accessing Commit History

- Navigate to the repository's main page
- View commit history listed in the top-right area
- Each commit shows the message and timestamp
- Click on individual commits to see:
  - Specific file changes
  - Diff views showing exactly what was added/modified
  - Previous versions of files

### Benefits of Commit History

- Visual timeline of all repository changes
- Easy navigation between different versions
- Ability to review what changed in each commit
- Foundation for understanding git's version control capabilities

## Editing Files Locally with VS Code

### Overview

This section demonstrates how to sync GitHub repositories to your local machine and edit files using VS Code, providing a more professional development workflow.

### Setting Up Local Development

#### Pulling from GitHub

```bash
git pull origin master
```

After pulling:
- Run `git log --oneline` to verify all commits are present
- The repository folder now exists locally on your computer
- All files including newly created ones appear in VS Code's file explorer

#### Repository Structure Understanding

- GitHub repositories are essentially folders stored in the cloud
- `git pull` synchronizes the cloud version with your local copy
- The local folder maintains bidirectional sync capability with GitHub

### Editing HTML Files

With the repository open in VS Code:

1. Open the `index.html` file from the file explorer
2. Replace basic content with proper HTML5 structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>This was edited</h1>
</body>
</html>
```

### Key HTML5 Elements Explained

- `<!DOCTYPE html>`: Declares HTML5 document type
- `<html lang="en">`: Root element with language specification
- `<head>`: Contains metadata including:
  - Character encoding (`<meta charset="UTF-8">`)
  - Viewport settings for responsive design
- `<body>`: Contains visible page content

### Workflow Transition

After saving local changes, the next step involves using Git commands to push these changes from your computer back to GitHub, enabling true local development workflows.

## Summary

### Key Takeaways

```diff
+ GitHub allows direct file creation through its web interface
+ All changes require commit messages for tracking
+ Local development with VS Code provides professional editing capabilities
+ git pull synchronizes remote changes to local repositories
+ HTML5 requires specific structure for proper rendering
- Editing large files directly on GitHub is not recommended
```

### Quick Reference

```bash
# Pull latest changes from GitHub
git pull origin master

# View recent commit history
git log --oneline
```

### Expert Insights

**Real-world Application**: Professional developers rarely edit files directly on GitHub. Instead, they maintain local copies in code editors like VS Code for better productivity, syntax highlighting, and debugging capabilities.

**Expert Path**: Master the complete workflow of creating files locally, committing changes with meaningful messages, and pushing to GitHub. This forms the foundation of modern software development practices.

**Common Pitfalls**:
- Creating files with incorrect extensions or naming conventions
- Forgetting to pull before making local edits (causing merge conflicts)
- Writing incomplete HTML structures without proper head/body sections
- Not using semantic HTML5 elements

**Lesser-Known Facts**: GitHub's web editor actually creates a commit behind the scenes, making it functionally equivalent to running `git add`, `git commit`, and `git push` from the command line.

</details>