# Section 15: Basic Unix Tools

<details open>
<summary><b>Section 15: Basic Unix Tools (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Time and Date Commands](#time-and-date-commands)
- [Calendar Command](#calendar-command)
- [Sleep Command](#sleep-command)
- [Compression with Gzip](#compression-with-gzip)
- [Decompression with Gunzip](#decompression-with-gunzip)
- [Archiving with Tar](#archiving-with-tar)
- [File Search with Find](#file-search-with-find)
- [File Search with Locate](#file-search-with-locate)
- [Summary](#summary)

## Time and Date Commands

### Overview
Date and time commands are essential for checking system clocks, scheduling tasks, and ensuring accurate timestamps in Unix environments. These commands help synchronize systems and manage time-related operations effectively.

### Key Concepts/Deep Dive
- **date Command**: Displays current date and time. Supports various formats and formatting options.
  - Basic usage: `date` to show current date/time.
  - Setting time: `date +%T -s "HH:MM:SS"` (note: may require root privileges).
  - Full options: Check `man datectl` for detailed settings including NTP, timezone.
- **time Command**: Measures execution time of commands, providing real, user, and system time metrics.
  - Usage: `time [command]` to run a command and display timing statistics.
  - Example: Increase `real` time for resource-intensive tasks.

### Lab Demos
1. Check current date/time: Run `date`.
2. Change time format: `date +%Y-%m-%d`.
3. Measure command execution: `time ls /home`.

### Tables
| Command | Purpose | Example |
|---------|---------|---------|
| date | Display/set date/time | `date` |
| time | Measure command runtime | `time tar -cvf archive.tar /path` |

> [!NOTE]
> Use `timedatectl status` for NTP and timezone details.

## Calendar Command

### Overview
The cal command provides calendar views to check dates, historical calendars, and schedule-related information. Useful for understanding calendar systems and date-related tasks.

### Key Concepts/Deep Dive
- **cal Command**: Displays current month's calendar or specific years.
  - Current month: `cal`.
  - Full year: `cal [year]` (e.g., `cal 2024`).
- Historical context: Gregorian calendar replaced Julian in 1752, missing 11 days (2-13 September 1752).

### Lab Demos
1. Show current month calendar: `cal`.
2. Show specific year: `cal 2024`.

> [!IMPORTANT]
> Research calendar reforms for deeper understanding of date systems.

## Sleep Command

### Overview
Sleep pauses command execution for specified durations, commonly used in scripts, process management, and timing controls in Unix systems.

### Key Concepts/Deep Dive
- Basic usage: `sleep [seconds]` delays for given time.
- Process management: Often used to space out tasks or simulate delays.
- Examples: `sleep 30` pauses for 30 seconds.

### Lab Demos
1. Pause for 10 seconds: `sleep 10`.
2. Use in scripts: `ls && sleep 5 && echo "done"`.

## Compression with Gzip

### Overview
Gzip compresses files to reduce size, essential for storage efficiency and faster transfers. It's faster than bzip2 but less aggressive compression.

### Key Concepts/Deep Dive
- **gzip Command**: Compresses files, changing extension (e.g., .gz).
  - Usage: `gzip [file]`.
  - Decompression: Extension changes; size reduces but may not be visible for small files.
  - Alternatives: bzip2 for better compression, cat/gzip for viewing archived content.

> [!NOTE]
> Uncompressed files can be viewed with `gunzip` or specific tools like `bzcat`.

### Lab Demos
1. Compress a file: Create `touch test.txt`, add content with `cat > test.txt`, then `gzip test.txt`.
2. Check size: `ls -lh test.txt*`.

## Decompression with Gunzip

### Overview
Gunzip decompresses gzip-compressed files, restoring original format and permissions.

### Key Concepts/Deep Dive
- **gunzip Command**: Decompresses .gz files.
  - Usage: `gunzip [file.gz]`.
  - Permissions: Preserved if compressed correctly.
  - Unsupported formats: Error for non-gz files.

### Lab Demos
1. Decompress: `gunzip test.txt.gz`.
2. Check restoration: `cat test.txt`.

## Archiving with Tar

### Overview
Tar (Tape Archive) combines multiple files into archives, with compression options for backup and distribution.

### Key Concepts/Deep Dive
- **tar Command**: Create, extract, list archives.
  - Create archive: `tar -cf archive.tar [files]` (create, file).
  - Compress (gzip): Add `-z` → `tar -czf archive.tar.gz [files]`.
  - Extract: `tar -xf archive.tar` (extract, file).
  - List contents: `tar -tf archive.tar`.
  - Preserve permissions: Add `-p`.
  - Update: Add files to existing archive.
  - Backup: Full system backups possible.

### Lab Demos
1. Create archive: `tar -cf test.tar file1 file2`.
2. Compress and archive: `tar -czf test.tar.gz file1 file2`.
3. Extract: `tar -xzf test.tar.gz`.
4. List contents: `tar -tf test.tar`.

### Tables
| Option | Purpose | Example |
|--------|---------|---------|
| -c | Create archive | `tar -c` |
| -x | Extract archive | `tar -x` |
| -t | List contents | `tar -t` |
| -z | Gzip compression | `tar -czf` |
| -p | Preserve permissions | `tar -cpzf` |

> [!IMPORTANT]
> Use `tar -tzf` to verify compressed archives without extracting.

## File Search with Find

### Overview
Find searches files/directories based on criteria like name, type, size, permissions, and modification time. Extremely powerful for system administration.

### Key Concepts/Deep Dive
- Syntax: `find [path] [options] [action]`.
  - Search by name: `-name "pattern"`.
  - Case insensitive: `-iname`.
  - By type: `-type f/d` (file/directory).
  - By size: `-size +100M` (over 100MB).
  - By permissions: `-perm 755`.
  - Recent files: `-mtime -7` (last 7 days).
  - Execute actions: `-exec rm {} \;` (delete found files).
  - Reference-based: `-newer file` (newer than specified).

### Lab Demos
1. Find files by name: `find /home -name "*.txt"`.
2. Find directories: `find / -type d -name "test"`.
3. Find large files: `find / -size +1G`.
4. Change permissions: `find /home -type f -name "*.sh" -exec chmod 755 {} \;`.

### Code Blocks
```bash
# Find and delete empty files
find /home -type f -empty -exec rm {} \;

# Find files modified in last hour
find /var/log -mtime 0
```

## File Search with Locate

### Overview
Locate uses pre-built databases for fast file searches, faster than find for full-system scans but requires database updates.

### Key Concepts/Deep Dive
- **locate Command**: Fast search using indexed databases.
  - Usage: `locate [pattern]`.
  - Update database: `updatedb`.
  - Advantage: Quicker for large filesystems.

### Lab Demos
1. Search file: `locate samba`.
2. Update DB: `sudo updatedb`.

> [!NOTE]
> Run `updatedb` periodically for accuracy.

## Summary

### Key Takeaways
```diff
! Date and time management ensures system synchronization and task scheduling
- Compression tools like gzip reduce file sizes but may alter readability
+ Archiving with tar preserves groups of files for backups and transfers
- Find command offers deep search capabilities by multiple criteria
+ Locate provides fast searches when database is up-to-date
```

### Quick Reference
- Check date/time: `date`
- Calendar: `cal`
- Compress file: `gzip file.txt`
- Create archive: `tar -czf archive.tar.gz files`
- Find files: `find /path -name "*.txt"`
- Locate files: `locate pattern`

### Expert Insight
- **Real-world Application**: Use tar with compression for database backups; find for automated log cleaning in production servers.
- **Expert Path**: Master find regex patterns and combine with xargs for complex operations; automate updatedb in cron for always-current locates.
- **Common Pitfalls**: Forget permissions preservation with tar (-p); outdated locate DB leading to missed files; ignoring case sensitivity in searches.

### Corrections Noted
- Transcript misspelled "Nehru Classes" as "Nehara Classes" in places (corrected to "Nehru Classes").
- "Younicsn" corrected to "Unix".
- "Gziping" corrected to "Gzipping".
- "Azip" likely meant "gzip" or "tar".
- Command examples corrected for accuracy (e.g., "datectl" to "timedatectl").

</details>
