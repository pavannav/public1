<details open>
<summary><b> Session 37: Adding Tags to Your Commits</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Exercise 1.1: Understanding Git Tagging Concepts
**Objective**: Learn the purpose and benefits of git tagging for milestone marking

**Tasks**:
1. Research how tags differ from branches in git
2. Understand tagging use cases for versioning and releases
3. Identify scenarios where tags provide advantages over commit hashes

**Deliverable**: Document explaining tagging concepts and when to use tags vs branches

---

## Exercise 1.2: Creating Your First Tag
**Objective**: Practice basic tag creation on the current commit

**Tasks**:
1. View commit history to identify a milestone commit
2. Create a lightweight tag using `git tag`
3. Verify the tag appears in commit history and tag list

**Commands**:
```bash
git log --oneline
git tag v1.0.0
git log --oneline
git tag
```

**Deliverable**: Successfully created tag visible in both commit log and tag listing

---

## Exercise 1.3: Viewing and Managing Tags
**Objective**: Learn tag listing and basic management operations

**Tasks**:
1. List all tags in the repository
2. Understand tag sorting (alphabetical vs chronological)
3. Identify specific commits associated with tags

**Commands**:
```bash
git tag
git show v1.0.0
git log --oneline --decorate
```

**Deliverable**: Comprehensive tag inventory with commit associations documented

---

## Exercise 2.1: Pushing Tags to Remote Repository
**Objective**: Learn how to share tags with the remote repository

**Tasks**:
1. Create local tags that are not yet on remote
2. Push a single tag to origin
3. Verify tag appearance on GitHub/GitLab

**Commands**:
```bash
git tag v1.1.0
git push origin v1.1.0
# Verify on GitHub web interface
```

**Deliverable**: Tag successfully pushed and visible in remote repository interface

---

## Exercise 2.2: Bulk Tag Pushing
**Objective**: Practice efficient methods for pushing multiple tags

**Tasks**:
1. Create multiple local tags
2. Use `git push origin --tags` to push all tags at once
3. Verify all tags appear in remote repository

**Commands**:
```bash
git tag v1.2.0
git tag v1.3.0
git push origin --tags
```

**Deliverable**: Multiple tags successfully pushed with bulk operation

---

## Exercise 2.3: Checking Out Tags for Historical Reference
**Objective**: Practice using tags to access specific versions of code

**Tasks**:
1. Checkout a tag to view code at that milestone
2. Understand detached HEAD state when checking out tags
3. Return safely to a branch from tag checkout

**Commands**:
```bash
git checkout v1.0.0
git status  # Note: detached HEAD state
git checkout master  # Return to branch
```

**Deliverable**: Successfully navigated between tagged versions and back to active development

---

## Exercise 3.1: Tagging Historical Commits
**Objective**: Practice tagging commits that are not the current HEAD

**Tasks**:
1. Checkout earlier commits in detached HEAD state
2. Create tags on historical commits for important milestones
3. Push historical tags to remote repository

**Commands**:
```bash
git checkout [earlier-commit-hash]
git tag v0.9.0
git push origin v0.9.0
git checkout master
```

**Deliverable**: Historical commits successfully tagged and pushed to remote

---

## Exercise 3.2: Deleting Local and Remote Tags
**Objective**: Learn safe tag deletion practices for both local and remote

**Tasks**:
1. Delete a local tag using `git tag -d`
2. Delete the corresponding remote tag using `git push origin --delete`
3. Verify tag removal from both local and remote repositories

**Commands**:
```bash
git tag -d unwanted-tag
git push origin --delete unwanted-tag
git tag
```

**Deliverable**: Tags successfully removed from both local and remote repositories

---

## Exercise 3.3: Tag-Based Development Workflow
**Objective**: Implement a complete tag-based release workflow

**Tasks**:
1. Create a realistic versioning scheme (semantic versioning)
2. Tag release candidates and final releases
3. Practice the complete workflow: tag creation, pushing, checkout, and cleanup
4. Document a release tagging strategy for team use

**Deliverable**: Complete release workflow documentation with semantic versioning strategy and tag lifecycle management

</details>
</details>