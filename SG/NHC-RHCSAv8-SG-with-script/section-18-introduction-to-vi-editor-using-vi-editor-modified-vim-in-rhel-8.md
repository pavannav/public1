# Section 18: Vi/Vim Editor

<details open>
<summary><b>Section 18: Vi/Vim Editor (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Vi/Vim Editor](#introduction-to-vivim-editor)
- [Editing Modes](#editing-modes)
- [Opening and Creating Files](#opening-and-creating-files)
- [Basic Navigation and Editing](#basic-navigation-and-editing)
- [Insert Mode Operations](#insert-mode-operations)
- [Deleting Characters and Words](#deleting-characters-and-words)
- [Replacing Characters](#replacing-characters)
- [Positioning the Cursor](#positioning-the-cursor)
- [Undo and Redo Operations](#undo-and-redo-operations)
- [Cutting, Copying, and Pasting Lines](#cutting-copying-and-pasting-lines)
- [Joining Lines](#joining-lines)
- [Buffer Registers](#buffer-registers)
- [Working with Multiple Files](#working-with-multiple-files)
- [Editor Options and Configuration](#editor-options-and-configuration)
- [Tutor Mode for Learning Vi](#tutor-mode-for-learning-vi)
- [Reading File Contents and Commands](#reading-file-contents-and-commands)

## Introduction to Vi/Vim Editor

### Overview
Vi, also known as Vim in its improved version, is a powerful command-line text editor that comes pre-installed in most Linux distributions. Vim (Vi IMproved) offers enhanced features and flexibility compared to the basic vi editor. It's an essential tool for any Linux administrator for file editing, configuration management, and script writing.

### Key Concepts/Deep Dive

**Vi vs Vim vs Nano:**
- `vi` is the original editor installed by default
- `vim` is the improved version with more features
- `nano` is a simpler editor, but less powerful
- Vim is preferred in production environments

To install vim if not present:
```bash
sudo apt-get install vim    # For Ubuntu/Debian
sudo yum install vim        # For CentOS/RHEL
```

Check installation:
```bash
rpm -qa | grep vim      # Lists vim packages
dpkg -l | grep vim      # For Debian systems
```

**Editor Interface:**
- Opens in command mode by default
- No visual indicators shown in editor window
- Command mode (press Esc) vs Insert mode (press i/I/a/A)

## Editing Modes

### Overview
Vi operates in two primary modes: Command mode and Insert mode. Understanding these modes is crucial for efficient editing.

### Key Concepts/Deep Dive

**Command Mode (Default):**
- Used for navigation and editing commands
- Enter from insert mode by pressing `Esc`
- All commands start here

**Insert Mode:**
- Used for text insertion and editing
- Enter by pressing `i`, `I`, `a`, `A`, etc.
- Visual indicator shows `-- INSERT --` at bottom

```bash
# Open file in vi
vi filename.txt    # Opens directly in command mode
vim filename.txt   # Opens in vim
```

## Opening and Creating Files

### Overview
Files can be created or opened using vi commands. The editor opens files in command mode by default.

### Key Concepts/Deep Dive

**Creating New Files:**
- `vi newfile.txt` creates a new empty file (if it doesn't exist)

**File Commands:**
- `:w` - Write (save) file
- `:q` - Quit
- `:wq` - Write and quit
- `:q!` - Quit without saving
- `:w newname.txt` - Save as different name

## Basic Navigation and Editing

### Overview
Cursor movement is the foundation of vi editing. All navigation happens in command mode.

### Key Concepts/Deep Dive

**Basic Movement:**
- `h` - Left
- `j` - Down  
- `k` - Up
- `l` - Right

**Character Movement:**
- `x` - Delete character under cursor
- `X` - Delete character before cursor
- `r` - Replace character
- `s` - Substitute character and enter insert mode

## Insert Mode Operations

### Overview
Different keys provide different insertion behaviors - inserting before/after cursor, at line start/end, or on new lines.

### Key Concepts/Deep Dive

**Insert Commands:**
- `i` - Insert before cursor
- `I` - Insert at beginning of line
- `a` - Append after cursor  
- `A` - Append at end of line
- `o` - Open new line below and insert
- `O` - Open new line above and insert

**Practical Usage:**
```bash
# After opening file
# Press 'i' to end enter insert mode
Welcome to Linux tutorials!
# Press Esc to return to command mode
```

## Deleting Characters and Words

### Overview
Deletion operations range from single characters to entire words or lines, all performed from command mode.

### Key Concepts/Deep Dive

**Character Deletion:**
- `x` - Delete character under cursor
- `X` - Delete character before cursor
- `dd` - Delete entire line
- `d$` - Delete from cursor to end of line
- `d0` - Delete from cursor to beginning of line

**Word Deletion:**
- `dw` - Delete word
- `d5w` - Delete 5 words
- `de` - Delete to end of word
- `db` - Delete to beginning of word

## Replacing Characters

### Overview
Character replacement can be done interactively or with single commands.

### Key Concepts/Deep Dive

**Replace Operations:**
- `r` - Replace single character (no insert mode)
- `R` - Replace multiple characters (enters replace mode)
- `xp` - Swap current character with next

**Interactive Replace:**
```
:r!echo 'hello'      # Replace current line with command output
:r filename.txt      # Read and insert file contents
```

## Positioning the Cursor

### Overview
Jump commands allow quick positioning to different locations in the file.

### Key Concepts/Deep Dive

**Line Positioning:**
- `:` + number - Jump to specific line
- `1G` or `gg` - Go to first line
- `G` - Go to last line  
- `$` - Move to end of current line
- `0` - Move to beginning of current line

**Word Hopping:**
- `w` - Forward to start of next word
- `b` - Backward to start of previous word
- `e` - Forward to end of current word

## Undo and Redo Operations

### Overview
Undo and redo operations allow reverting changes step by step.

### Key Concepts/Deep Dive

**Undo/Redo Commands:**
- `u` - Undo last change
- `U` - Undo all changes to current line
- `Ctrl + r` - Redo (undo the undo)

Note: Must be in command mode to use these commands.

## Cutting, Copying, and Pasting Lines

### Overview
Line operations for cutting, copying, and pasting are fundamental for text manipulation.

### Key Concepts/Deep Dive

**Line Operations:**
- `dd` - Cut current line
- `yy` - Copy (yank) current line
- `p` - Paste after current line
- `P` - Paste before current line

**Multiple Lines:**
- `5dd` - Delete 5 lines
- `5yy` - Copy 5 lines  
- `10p` - Paste 10 times

## Joining Lines

### Overview
Joining lines combines multiple lines into a single line.

### Key Concepts/Deep Dive

**Join Commands:**
- `J` - Join current line with next line
- `5J` - Join current line with next 5 lines

Removes newline character between lines.

## Buffer Registers

### Overview
Vi maintains multiple buffer registers for storing different pieces of text.

### Key Concepts/Deep Dive

**Named Buffers:**
- `"a` through `"z` - Named registers
- `""` - Default register

**Using Buffers:**
```
"a5dd    # Cut 5 lines to register 'a'
"A5yy    # Append 5 lines to register 'a'  
"ap      # Paste from register 'a'
```

Total of 36 buffers available (a-z, 0-9, etc.)

## Working with Multiple Files

### Overview
Vi can edit multiple files simultaneously with commands to switch between them.

### Key Concepts/Deep Dive

**Opening Multiple Files:**
```bash
vim file1.txt file2.txt file3.txt
```

**File Navigation:**
- `:n` - Next file
- `:prev` - Previous file
- `:last` - Last edited file
- `:args` - Show all open files
- `:e filename.txt` - Edit new file

**Saving Operations:**
- `:w` - Save current file
- `:wa` - Save all files (write all)
- `:wqa` - Save and quit all files

## Editor Options and Configuration

### Overview
Vi can be configured in the current session or permanently through configuration files.

### Key Concepts/Deep Dive

**Session Options:**
- `:set nu` - Show line numbers
- `:set nonu` - Hide line numbers
- `:set all` - Show all options
- `:set number` (same as nu)

**Permanent Configuration:**
Create `~/.vimrc` file:
```
set number
set autoindent
set showmatch
```

Common options:
- `number` - Line numbers
- `ignorecase` - Case insensitive search
- `hlsearch` - Highlight search results
- `incsearch` - Incremental search

## Searching in Files

### Overview
Vi provides powerful forward and backward search capabilities.

### Key Concepts/Deep Dive

**Search Commands:**
- `/pattern` - Search forward
- `?pattern` - Search backward
- `n` - Next match
- `N` - Previous match

**Search Options:**
- Case sensitive by default
- Can use regex patterns
- `/\cpattern` - Case insensitive search

## Tutor Mode for Learning Vi

### Overview
Interactive tutor mode provides step-by-step guidance for learning vi commands.

### Key Concepts/Deep Dive

**Start Tutor:**
```bash
vimtutor
```

**Tutor Structure:**
- Lessons from `vimtutor 01.txt` to `vimtutor 10.txt`
- Interactive exercises
- Covers all basic to advanced commands
- 15-minute to 2-hour completion time

**Sections Covered:**
- Movement (h, j, k, l)
- Text objects and visual mode
- Commands for editing
- Advanced movement and editing

## Reading File Contents and Commands

### Overview
Vi can read contents from other files or command outputs directly into the current document.

### Key Concepts/Deep Dive

**Reading Files:**
- `:r filename.txt` - Read file contents
- `:r! command` - Execute command and insert output

**Examples:**
```bash
:r package_list.txt    # Insert contents of package_list.txt
:r! ls -la            # Insert directory listing
:r! ps aux            # Insert process list
```

## Summary

### Key Takeaways
```diff
+ Vi is the default text editor in Linux systems
+ Vim is the enhanced version with more features
+ Command mode is default - use Esc to enter, i/I/a/A/o/O to enter insert mode  
+ Basic navigation: h/j/k/l (left/down/up/right)
+ Save with :w, quit with :q, save & quit :wq
+ Use buffers ("a-"z) for multiple text storage
+ Work with multiple files using :n, :prev commands
+ Configure permanently with ~/.vimrc file
+ Learn interactively with vimtutor command
```

### Quick Reference
| Command | Description | Example |
|---------|-------------|---------|
| `i` | Insert before cursor | `iHello` |
| `a` | Append after cursor | `a World` |
| `o` | Open new line below | `oNew line` |
| `dd` | Delete line | `dd` |
| `yy` | Copy line | `yy` |
| `p` | Paste after | `p` |
| `:w` | Save file | `:w` |
| `:q` | Quit | `:q` |
| `u` | Undo | `u` |
| `./text` | Search forward | `/vim` |

### Expert Insight
**Real-world Application**: Vi/Vim is crucial for system administration when GUI text editors aren't available. It's used for editing configuration files, scripts, and logs directly on servers via SSH connections.

**Expert Path**: Master vimtutor completely, practice regularly with real configuration files. Learn advanced features like macros, plugins, and custom key mappings for maximum productivity.

**Common Pitfalls**: 
- Entering insert mode but forgetting to press Esc - always check bottom of screen
- Using mouse or GUI shortcuts - vi works purely with keyboard commands  
- Not saving frequently - use `:w` regularly to avoid losing work
- Getting stuck in command mode - remember i/I/a/A/o/O to enter insert mode

</details>
