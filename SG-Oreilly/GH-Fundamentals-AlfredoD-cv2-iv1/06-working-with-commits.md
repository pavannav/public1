# Section 6: Working with Commits

<details open>
<summary><b>Section 6: Working with Commits (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Understanding Commits](#understanding-commits)
- [Commit Granularity](#commit-granularity)
- [Single vs Multiple File Changes](#single-vs-multiple-file-changes)
- [Working with Pull Request Commits](#working-with-pull-request-commits)
- [Commit Review and Modification](#commit-review-and-modification)
- [Summary](#summary)

## Understanding Commits

### Overview
A commit represents a fundamental concept in Git version control - it captures a point-in-time snapshot of changes made to a repository. This section explores how commits function as the core building blocks of version history and how they enable effective collaboration and code management.

### Key Concepts

#### What is a Commit?
- **Definition**: A commit is a change representing a point-in-time modification to the repository
- **Purpose**: Captures and preserves the state of files and directories at a specific moment
- **Visual Representation**: GitHub displays commits with timestamps (e.g., "2 years ago") and detailed change information

#### Commit Structure
- **Changes Display**: Each commit shows specific modifications including:
  - Line additions (marked with `+`)
  - Line deletions (marked with `-`)
  - Modified content within the same line
- **File Statistics**: Shows summary of changes (e.g., "1 file changed, 4 additions, 3 deletions")
- **Diff Visualization**: Uses color coding (green for additions, red for deletions) to highlight changes

#### Examples of Commit Changes
```diff
- old line content
+ new line content with modifications
```

### Commit Granularity

#### Decision Factors
- **Granularity Choice**: Developers must decide how to group changes into commits
- **Flexibility**: Changes can be grouped together or split into separate commits
- **Logical Grouping**: Decisions should reflect logical units of work

#### Grouping Strategies
- **Single Commit Approach**: Group multiple related changes into one commit
- **Multiple Commit Approach**: Create separate commits for distinct changes
- **Example**: In a single file, you could:
  - Create one commit with 4 additions and 3 deletions combined
  - OR create three separate commits for different changes

### Single vs Multiple File Changes

#### Single File Commits
- **Statistical Display**: Shows "1 file changed, 4 additions, 3 deletions"
- **Change Tracking**: Tracks all modifications within that individual file
- **Commit Simplicity**: Represents a focused set of changes

#### Multiple File Commits
- **Cross-File Changes**: A single commit can affect multiple files simultaneously
- **Example Scenario**: Updating README documentation while modifying code in the same commit
- **Consistency**: Ensures related changes across files are captured together

### Working with Pull Request Commits

#### Pull Request Commit Structure
- **Contributor Actions**: Contributors can make multiple commits within a single pull request
- **Historical Record**: Each commit represents a specific point in the development process
- **Example Case**: A contributor made 5 separate commits including:
  1. README updates
  2. Code flag additions
  3. Additional modifications

#### Files Changed View
- **Aggregated View**: The "Files changed" tab shows all commits as if they were a single comprehensive change
- **Behind the Scenes**: Maintains the individual commit history (e.g., 5 commits)
- **Merge Information**: Displays the proposal of multiple commits for merging

### Commit Review and Modification

#### Review Process
- **Selective Review**: Reviewers can evaluate individual commits within a pull request
- **Change Approval**: Specific commits can be approved while others require modification
- **Feedback Mechanism**: Reviewers can provide observations and request changes

#### Modification Capabilities
- **Post-Commit Changes**: Commits can be modified even after initial creation
- **Flexibility**: Works whether you're dealing with single or multiple commits
- **Iterative Improvement**: Allows for refinement based on feedback

## Summary

### Key Takeaways
```diff
+ Commits represent point-in-time changes that capture repository modifications
+ Granularity decisions determine how changes are grouped into commits
+ Single commits can affect multiple files, and multiple commits can be part of one pull request
+ Review processes allow for selective approval and modification of individual commits
```

### Quick Reference
| Concept | Description |
|---------|-------------|
| **Commit** | Point-in-time change or group of changes |
| **Granularity** | Level of detail in grouping changes |
| **Files Changed** | Aggregated view of all commits in a PR |
| **Review** | Process of evaluating and approving commits |

### Expert Insights

#### Real-world Application
In production environments, commits serve as the primary mechanism for tracking code evolution, enabling team collaboration, and maintaining a reliable audit trail. Well-structured commits facilitate code reviews, debugging, and feature rollbacks when necessary.

#### Expert Path
- Master the art of commit message writing to create clear, descriptive histories
- Learn advanced techniques like interactive rebasing to refine commit history
- Understand when to squash commits versus maintaining granular history
- Practice reviewing commits individually within larger pull requests

#### Common Pitfalls
- Creating overly large commits that combine unrelated changes
- Writing vague or non-descriptive commit messages
- Not considering the review process when structuring commits
- Failing to maintain logical grouping that tells a coherent story of changes

#### Lesser-Known Facts
- The aggregated "Files changed" view in pull requests can hide the true complexity of the development process
- Individual commits within a pull request can be selectively reviewed and approved
- Even single-line changes require both addition and deletion markers in the diff view
- Commit granularity decisions impact not just technical implementation but also team communication and code review efficiency
</details>