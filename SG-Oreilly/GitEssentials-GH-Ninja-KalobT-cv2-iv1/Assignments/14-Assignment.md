<details open>
<summary><b> Session 14: Unstaging a File</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding the Staging Mistake
**Objective**: Recognize when files have been accidentally staged for deletion

**Tasks**:
1. Create a file with important content
2. Stage the file for commit
3. Delete the file accidentally
4. Stage all changes with `git add .`
5. Run `git status` and identify the problem
6. Document the risk of committing this deletion

**Commands**:
```bash
echo "important config" > config.txt
git add config.txt
rm config.txt
git add .
git status
```

**Deliverable**: Status output showing deleted file staged for commit

---

## Exercise 1.2: Unstaging Files with Git Reset
**Objective**: Learn to unstage files that were accidentally added

**Tasks**:
1. Follow the scenario from Exercise 1.1
2. Use `git reset HEAD filename` to unstage the deletion
3. Verify the file is no longer staged for commit
4. Confirm the unstage message appears

**Commands**:
```bash
git reset HEAD config.txt
git status
```

**Deliverable**: Step-by-step demonstration of unstaging with before/after status

---

## Exercise 1.3: Multiple File Unstaging
**Objective**: Practice unstaging multiple files at once

**Tasks**:
1. Create multiple files
2. Delete some files accidentally
3. Stage all changes
4. Unstage specific files individually
5. Unstage remaining files all at once

**Commands**:
```bash
git reset HEAD file1.txt file2.txt file3.txt
# or reset all staged changes
git reset HEAD .
```

**Deliverable**: Demonstration of unstaging multiple files

---

## Exercise 2.1: The Git Status Safety Net
**Objective**: Develop the habit of checking status before committing

**Tasks**:
1. Create a scenario where you might accidentally commit deletions
2. Practice checking `git status` before every commit
3. Document what to look for in the status output
4. Create a mental checklist for commit safety

**Deliverable**: Personal checklist for reviewing status before commits

---

## Exercise 2.2: Recovering from Various Staging Mistakes
**Objective**: Handle different types of staging errors

**Tasks**:
1. Practice unstaging in these scenarios:
   - Accidentally staging wrong files
   - Staging files that should remain local
   - Staging large binary files by mistake
   - Staging sensitive configuration files
2. Document recovery steps for each

**Deliverable**: Recovery guide for common staging mistakes

---

## Exercise 2.3: Commit Safety Workflow
**Objective**: Establish a safe commit workflow

**Tasks**:
1. Create the following workflow:
   1. Make changes
   2. Check status
   3. Stage files
   4. Check status again
   5. Unstage any mistakes
   6. Commit with confidence
2. Practice this workflow with various scenarios
3. Document how this prevents accidents

**Deliverable**: Documented safe commit workflow with examples

---

## Exercise 3.1: Understanding HEAD in Git
**Objective**: Learn about the HEAD pointer concept

**Tasks**:
1. Research what `HEAD` represents in Git
2. Understand why we use `git reset HEAD`
3. Explore other HEAD-related commands
4. Document the concept for future reference

**Commands**:
```bash
git log --oneline -5
cat .git/HEAD
```

**Deliverable**: Written explanation of HEAD and its role in unstaging

---

## Exercise 3.2: Unstaging vs Other Reset Operations
**Objective**: Differentiate between various reset operations

**Tasks**:
1. Document the differences between:
   - `git reset HEAD` (unstage)
   - `git checkout -- file` (discard changes)
   - `git reset --hard` (dangerous reset)
2. Create safe/unsafe examples for each
3. Explain when to use each command

**Deliverable**: Comparison guide of reset operations with use cases

---

## Exercise 3.3: Building Muscle Memory
**Objective**: Practice unstaging until it becomes automatic

**Tasks**:
1. Create 10 practice scenarios involving accidental staging
2. Time yourself unstaging files correctly
3. Practice until unstaging feels natural
4. Document your practice sessions and improvement

**Deliverable**: Practice log showing improvement in unstaging speed and confidence

</details>

</details>