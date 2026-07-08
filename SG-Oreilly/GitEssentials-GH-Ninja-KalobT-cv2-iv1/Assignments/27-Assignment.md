<details open>
<summary><b> Session 27: Create a Custom Git Alias</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding Git Aliases
**Objective**: Grasp the concept of git aliases and their benefits over text expanders

**Tasks**:
1. Document the difference between text expanders and git aliases
2. List scenarios where git aliases are preferable:
   - Cross-platform compatibility
   - Team sharing
   - No external dependencies needed
3. Explain why `git lg` is not a native git command
4. Document how aliases enhance productivity

**Documentation**:
```markdown
# Git Aliases vs Text Expanders

## Key Differences
- Text expanders: [System-wide, external tool]
- Git aliases: [Git-specific, portable]

## Advantages of Git Aliases
1. Works on any system with git
2. Can be shared via .gitconfig
3. Team members get same shortcuts
4. No additional software needed

## The 'lg' Example
'lg' is not a real git command - it's an alias that expands to a complex log command
```

**Deliverable**: Comprehensive understanding document comparing aliases to text expanders

## Exercise 1.2: Locate and Examine Git Configuration
**Objective**: Find and understand the structure of git configuration files

**Tasks**:
1. Locate your global git config file:
   - Usually at `~/.gitconfig` or `~/.config/git/config`
2. View current contents of the config file
3. Identify existing sections (user, core, etc.)
4. Note if an [alias] section already exists
5. Document the file structure and sections

**Commands**:
```bash
# Find git config location
git config --list --show-origin

# View the global config file
cat ~/.gitconfig

# Alternative location check
ls -la ~/.config/git/
```

**Deliverable**: Documentation showing git config location and current structure

## Exercise 1.3: Create Your First Git Alias
**Objective**: Add a custom alias to your git configuration

**Tasks**:
1. Open your global git config file for editing
2. Add an `[alias]` section if it doesn't exist
3. Create a simple alias first (e.g., `st = status`)
4. Test the alias works: `git st`
5. Document the process and verify functionality

**Commands**:
```bash
# Edit global config
vim ~/.gitconfig

# Add alias section
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit

# Test aliases
git st    # Should show same as git status
git co -b test-alias
git br
```

**Deliverable**: Working git aliases with documentation of creation process

## Exercise 2.1: Create the 'lg' Log Alias
**Objective**: Implement the enhanced log alias demonstrated in the session

**Tasks**:
1. Add the `lg` alias with the full log formatting from the session
2. The alias should include:
   - Color output
   - Graph visualization
   - Commit hash (abbreviated)
   - Decorations (branch/tag info)
   - Commit message
   - Relative date
   - Author name
3. Test the alias on your repository
4. Compare output with regular `git log`

**Alias Command**:
```bash
[alias]
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

**Commands**:
```bash
# Add the lg alias to your config
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Test it
git lg

# Compare with regular log
git log --oneline
```

**Deliverable**: Working `git lg` alias with visual comparison to standard log

## Exercise 2.2: Build a Custom Alias Collection
**Objective**: Create a comprehensive set of useful git aliases

**Tasks**:
1. Create aliases for common operations:
   ```ini
   [alias]
       # Status shortcuts
       st = status
       sts = status -s

       # Branch operations
       br = branch
       bra = branch -a

       # Checkout shortcuts
       co = checkout
       cob = checkout -b

       # Commit shortcuts
       ci = commit
       ca = commit -a
       amend = commit --amend

       # Log variations
       lg = [full command from 2.1]
       last = log -1 --stat

       # Diff shortcuts
       df = diff
       dc = diff --cached

       # Remote operations
       pom = push origin master
       plom = pull origin master

       # Stash operations
       save = stash save
       pop = stash pop
   ```
2. Test each alias thoroughly
3. Document the purpose of each alias
4. Create a personal alias reference guide

**Deliverable**: Comprehensive alias collection with documentation and testing evidence

## Exercise 2.3: Advanced Alias Techniques
**Objective**: Explore advanced alias capabilities including parameters

**Tasks**:
1. Create aliases that accept parameters:
   ```ini
   [alias]
       # Show specific commit
       show = log -1 --stat

       # Grep in commit messages
       grep = log --all --grep

       # Find commits by author
       author = log --all --author
   ```
2. Experiment with shell commands in aliases:
   ```ini
   [alias]
       # Alias that runs external command
       root = !pwd

       # Complex operation
       recent = !git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)'
   ```
3. Document advanced techniques and limitations

**Commands**:
```bash
# Test parameterized aliases
git grep "merge"

# Test shell command aliases
git root
git recent
```

**Deliverable**: Documentation of advanced alias techniques with working examples

## Exercise 3.1: Share Aliases with Team
**Objective**: Distribute custom aliases to team members

**Tasks**:
1. Create a shareable alias configuration file
2. Document different sharing methods:
   - Via `.gitconfig` snippets
   - Through team documentation
   - Using git include directives
3. Create an onboarding guide for new team members
4. Consider creating a team alias repository

**Sharing Methods Document**:
```markdown
# Sharing Git Aliases

## Method 1: Config Snippet
[How to share .gitconfig sections]

## Method 2: Documentation
[Copy-paste instructions for team]

## Method 3: Git Include
[Using include.path directive]

## Team Onboarding
[Step-by-step alias setup for new members]
```

**Deliverable**: Team sharing strategy with implementation guide

## Exercise 3.2: Create Project-Specific Aliases
**Objective**: Set up aliases that work within specific projects

**Tasks**:
1. Understand the difference between global and local aliases
2. Create project-specific aliases in `.git/config`
3. Document when to use each scope:
   - Global: Personal preferences across all projects
   - Local: Project-specific workflows
4. Create examples of each type

**Commands**:
```bash
# Add local (project-specific) alias
git config alias.deploy "!npm run build && npm run deploy"

# View local config
cat .git/config

# Compare scopes
git config --global --list
git config --local --list
```

**Deliverable**: Project with both global and local aliases properly configured

## Exercise 3.3: Alias Maintenance and Documentation
**Objective**: Establish practices for maintaining and documenting aliases

**Tasks**:
1. Create an alias documentation template:
   ```markdown
   # Git Aliases Reference

   ## Status & Information
   - `git st` - Quick status check
   - `git lg` - Visual commit history

   ## Branch Management
   - `git br` - List branches
   - `git cob <name>` - Create and checkout branch

   ## [Continue documenting all aliases]
   ```
2. Set up a process for:
   - Adding new aliases
   - Removing unused aliases
   - Updating existing aliases
   - Version controlling alias configurations
3. Create backup/recovery procedures

**Maintenance Workflow**:
```bash
# Export current aliases
git config --global --get-regexp alias > my-aliases.txt

# Backup global config
cp ~/.gitconfig ~/.gitconfig.backup

# Restore from backup
cp ~/.gitconfig.backup ~/.gitconfig
```

**Deliverable**: Complete alias management system with documentation and backup procedures

</details>
</details>