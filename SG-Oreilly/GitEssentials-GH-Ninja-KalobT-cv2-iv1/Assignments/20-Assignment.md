<details open>
<summary><b> Session 20: Seeing Your Git History</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Basic Git Log Usage
**Objective**: Master the fundamental `git log` command to view commit history

**Tasks**:
1. Navigate to your Git repository
2. Execute `git log` to view full commit history
3. Identify and note the following in each commit entry:
   - Commit hash
   - Author name and email
   - Commit date
   - Commit message
4. Practice navigating with arrow keys, J/K, and page up/down

**Commands**:
```bash
git log
```

**Deliverable**: Screenshot or text output showing at least 5 commit entries with all components clearly identified

## Exercise 1.2: Compare Local vs Remote History
**Objective**: Use git log to verify local code matches GitHub repository

**Tasks**:
1. Run `git log --oneline` to see condensed view
2. Note the most recent commit hash and message
3. Open your GitHub repository in browser
4. Navigate to commits section
5. Compare the latest commit message with your local log
6. Document whether your local is up-to-date with remote

**Commands**:
```bash
git log --oneline
```

**Deliverable**: Written comparison confirming local and remote history match (or don't match)

## Exercise 1.3: Navigation Practice in Git Log
**Objective**: Master navigation controls within git log output

**Tasks**:
1. View full git log output
2. Practice using each navigation method:
   - Down arrow (move down one line)
   - Up arrow (move up one line)
   - J key (move down)
   - K key (move up)
   - Page Down (if available)
   - Page Up (if available)
3. Exit using 'Q' key
4. Re-enter and verify you can scroll through all commits

**Commands**:
```bash
git log
# Use navigation keys, then press 'q' to quit
```

**Deliverable**: Confirmation of successful navigation through entire commit history

## Exercise 2.1: Advanced Log Formatting
**Objective**: Create custom log formats for better readability

**Tasks**:
1. Create a custom log alias using `git config`
2. Format to show: abbreviated hash, date (short), author name, message
3. Create another format showing just hash and message in one line
4. Test both formats on your repository

**Commands**:
```bash
git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
git hist
git log --oneline --decorate
```

**Deliverable**: Screenshots of custom formatted log outputs

## Exercise 2.2: Filter Commit History
**Objective**: Use git log options to filter and search history

**Tasks**:
1. Show last 5 commits only
2. Search for commits containing specific keywords in messages
3. Show commits by specific author
4. Display commits within date range
5. Combine filters (e.g., author + date range)

**Commands**:
```bash
git log -5
git log --grep="merge"
git log --author="Your Name"
git log --since="2024-01-01" --until="2024-01-31"
git log --author="Your Name" --since="1 week ago"
```

**Deliverable**: Output showing filtered results for each command

## Exercise 2.3: Branch Comparison with Git Log
**Objective**: Use git log to identify differences between branches

**Tasks**:
1. Create a feature branch with new commits
2. Use git log to compare master vs feature branch
3. Identify commits unique to each branch
4. Document which commits would be merged

**Commands**:
```bash
git checkout master
git log --oneline feature-branch..master
git log --oneline master..feature-branch
git log --oneline --all --graph --decorate
```

**Deliverable**: Analysis document showing branch divergence points

## Exercise 3.1: Create Commit History Report
**Objective**: Generate a comprehensive commit history analysis

**Tasks**:
1. Create a script that generates a weekly commit report
2. Include: total commits, commits per author, most active days
3. Format output as a readable report
4. Save to a file in your repository

**Commands**:
```bash
#!/bin/bash
echo "# Weekly Commit Report" > commit-report.md
echo "## Generated: $(date)" >> commit-report.md
echo "" >> commit-report.md
echo "### Total Commits This Week" >> commit-report.md
git log --since="1 week ago" --oneline | wc -l >> commit-report.md
echo "" >> commit-report.md
echo "### Commits by Author" >> commit-report.md
git log --since="1 week ago" --format="%an" | sort | uniq -c | sort -rn >> commit-report.md
```

**Deliverable**: Generated commit report markdown file

## Exercise 3.2: Visual Commit Graph Analysis
**Objective**: Master the git log graph visualization

**Tasks**:
1. View full commit graph with all branches
2. Identify merge points in the history
3. Trace the development flow through branches
4. Document the branching and merging patterns

**Commands**:
```bash
git log --all --graph --decorate --oneline
git log --all --graph --decorate --oneline --simplify-by-decoration
```

**Deliverable**: Annotated graph showing branch/merge history

## Exercise 3.3: Git Log Integration Workflow
**Objective**: Integrate git log into daily development workflow

**Tasks**:
1. Create a workflow document that includes:
   - Daily routine using git log commands
   - Pre-push verification steps
   - Post-merge history verification
   - Weekly history review process
2. Implement this workflow in your current project
3. Document any insights gained

**Workflow Document Structure**:
```markdown
# Git Log Daily Workflow

## Morning Routine
1. [Commands to check overnight changes]

## Pre-Commit Checks
1. [Verify recent history]

## Pre-Push Verification
1. [Compare with remote]

## Weekly Review
1. [Generate reports]
```

**Deliverable**: Complete workflow documentation with practical implementation evidence

</details>
</details>