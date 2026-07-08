<details open>
<summary><b> Session 22: How to Get Updates from GitHub</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding Git Fetch vs Git Pull
**Objective**: Distinguish between `git fetch` and `git pull` behaviors

**Tasks**:
1. First, ensure repository is clean and up to date
2. Run `git pull origin master` when already current
3. Document the "Already up to date" message
4. Note the purpose of pull command from session context

**Commands**:
```bash
git status
git pull origin master
```

**Deliverable**: Screenshot showing current state with explanation of pull behavior

## Exercise 1.2: Create Remote Divergence Scenario
**Objective**: Set up a test case to demonstrate fetch functionality

**Tasks**:
1. Edit a file directly on GitHub (rename and modify content)
2. Example: Change `empty-file.txt` to `not-empty-file.md`
3. Add markdown content with lorem ipsum text
4. Commit directly to master branch on GitHub
5. Verify the commit appears in GitHub but not locally

**Commands**:
```bash
# Edit on GitHub through web interface
git log --oneline -3
```

**Deliverable**: GitHub commit view showing new commit not present locally

## Exercise 1.3: Demonstrate Git Fetch Behavior
**Objective**: Show that fetch downloads but doesn't apply changes

**Tasks**:
1. Before fetch, document current state:
   - List files with `ls -la`
   - Check `git log --oneline -3`
2. Execute `git fetch origin master`
3. Verify after fetch:
   - Files remain unchanged locally
   - Log still shows old commits only
4. Document that changes exist but aren't applied

**Commands**:
```bash
ls -la
git log --oneline -3
git fetch origin master
ls -la
git log --oneline -3
```

**Deliverable**: Before/after comparison proving fetch downloads without applying

## Exercise 2.1: Install and Configure Git LG Alias
**Objective**: Set up enhanced git log visualization for better branch tracking

**Tasks**:
1. Add the git-lg alias to your git configuration
2. Test the alias to view commit tree
3. Identify HEAD position vs origin/master
4. Document the visual difference between local and remote

**Commands**:
```bash
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git lg
```

**Deliverable**: Screenshot of git lg showing branch divergence visualization

## Exercise 2.2: Analyze Branch Divergence with Git LG
**Objective**: Use visualization to understand repository state

**Tasks**:
1. Run `git lg` to see full commit tree
2. Identify:
   - Current HEAD position
   - Local master branch position
   - origin/master position
   - The commit that exists only on remote
3. Document the "one commit ahead" state visually

**Commands**:
```bash
git lg
```

**Deliverable**: Annotated git lg output showing branch positions and divergence

## Exercise 2.3: Complete the Sync with Pull After Fetch
**Objective**: Demonstrate that pull after fetch results in fast-forward

**Tasks**:
1. After fetch, note you're one commit behind
2. Execute `git pull origin master`
3. Observe this is a fast-forward (no merge needed)
4. Verify files have been updated
5. Run `git lg` to see updated positions

**Commands**:
```bash
git pull origin master
ls -la not-empty-file.md
cat not-empty-file.md
git lg
```

**Deliverable**: Evidence showing fast-forward occurred and files updated

## Exercise 3.1: Fetch and Merge Workflow
**Objective**: Manually execute what git pull does in two steps

**Tasks**:
1. Create another remote change on GitHub
2. Use fetch to download without applying
3. Review the changes that would be merged
4. Manually merge origin/master into local master
5. Document the equivalence: pull = fetch + merge

**Commands**:
```bash
# Make change on GitHub first
git fetch origin master
git merge origin/master
# OR directly: git pull origin master (equivalent)
```

**Deliverable**: Step-by-step documentation showing fetch + merge = pull

## Exercise 3.2: Decision Matrix for Fetch vs Pull
**Objective**: Create guidelines for when to use each command

**Tasks**:
1. Document scenarios for using git fetch:
   - Previewing changes without applying
   - Checking remote state before deciding to merge
   - Working offline with remote info
2. Document scenarios for using git pull:
   - Wanting latest code immediately
   - Standard sync workflow
   - When you're ready to integrate changes
3. Create decision flowchart

**Documentation**:
```markdown
# Fetch vs Pull Decision Guide

## Use Git Fetch When:
- [List scenarios from experience]

## Use Git Pull When:
- [List scenarios from experience]

## Decision Flowchart:
[Visual representation]
```

**Deliverable**: Comprehensive decision guide for command selection

## Exercise 3.3: Advanced Fetch Scenarios
**Objective**: Explore fetch capabilities beyond basic usage

**Tasks**:
1. Fetch all remotes and branches: `git fetch --all`
2. Fetch and prune deleted branches: `git fetch --prune`
3. Fetch specific branch without affecting others
4. Create tracking branches from fetched refs
5. Document all fetch options and their purposes

**Commands**:
```bash
git fetch --all
git branch -r  # List remote branches
git fetch origin feature-branch:refs/remotes/origin/feature-branch
git branch -a
```

**Deliverable**: Documentation of advanced fetch techniques with examples

</details>
</details>