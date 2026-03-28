# Section 84: Backup Management

<details open>
<summary><b>Section 84: Backup Management (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Local Backup](#local-backup)
- [Remote Backup](#remote-backup)
- [Automated Backup](#automated-backup)

## Local Backup

### Overview
This section demonstrates how to perform backup operations within the same Linux machine using the `rsync` utility. Rsync is a powerful tool for efficient file synchronization and copying, supporting incremental backups and preserving file attributes.

### Key Concepts
Rsync (remote synchronization) is a command-line utility used for:
- Incremental file transfers
- Local file copying and synchronization
- Remote file transfers via SSH

Key options used:
- `-av`: Archive mode (preserves permissions, ownership, etc.)
- `-z`: Compress data during transfer
- `--progress`: Show progress during transfer

```bash
# Basic rsync syntax for local copy
rsync -av /source/directory/ /destination/directory/
```

> 📝 **Note**: The trailing slash on source and destination directories is important for proper copying behavior.

### Code/Config Blocks
#### Creating test data for demonstration:
```bash
# Create backup source directory
mkdir -p ~/backup-source
cd ~/backup-source

# Create test files
echo "Welcome to Nehra Classes on YouTube channel" > test1.txt
echo "2020 calendar data" >> test1.txt

# Additional test files
echo "Test content 123" > test2.txt
```

#### Rsync backup command with progress:
```bash
# Copy files locally
rsync -av --progress ~/backup-source/ ~/backup-destination/
```

> ❗ **Important**: Use absolute paths when scripting to avoid path-related issues.

## Remote Backup

### Overview
Learn to backup data from one Linux server to another using rsync over SSH, enabling secure remote file synchronization.

### Key Concepts

SSH Key Authentication is crucial for passwordless backups:
```bash
# Generate SSH key pair
ssh-keygen -t rsa

# Copy public key to remote server
ssh-copy-id root@remote-server-IP
```

Authentication method determines the rsync command syntax. With SSH keys (recommended):
```bash
# Using SSH with rsync
rsync -av --progress -e "ssh -i ~/.ssh/id_rsa" /local/path/ user@remote:/remote/path/
```

> ⚠ **Warning**: Store SSH keys securely and avoid sharing private keys.

### Code/Config Blocks
#### Server setup commands:
```bash
# Source server actions
hostnamectl set-hostname "backup-source"
# Logged out and back in to reflect hostname

# Destination server
hostnamectl set-hostname "backup-destination"
```

#### Rsync remote backup command:
```bash
# From source server to destination
rsync -av -e ssh /home/devendra/backup-source/ root@192.168.1.100:/root/backup-destination/
```

> 💡 **Real-world Tip**: Always use IP addresses or fully qualified domain names instead of hostnames for reliability.

Common rsync options for remote transfers:
- `-e`: Specify SSH connection command
- `--delete`: Remove files from destination not present in source (full sync)
- `--exclude`: Exclude specific files/patterns

#### Directory synchronization options:
```bash
# Bidirectional sync with delete
rsync -av --delete /source/ user@remote:/destination/

# Exclude certain files
rsync -av --exclude='*.log' /source/ /destination/
```

> 🛡️ **Security Note**: Use SSH keys instead of passwords for automated backups to prevent credential exposure.

## Automated Backup

### Overview
Implement automated backups using cron jobs to schedule rsync operations at specified intervals, ensuring regular data synchronization without manual intervention.

### Key Concepts
Cron is a time-based job scheduler in Linux for automating repetitive tasks.

Basic cron syntax:
```bash
* * * * * command-to-execute
# Minute Hour Day Month Weekday
```

Common cron schedules:
- `* * * * *`: Every minute
- `0 */6 * * *`: Every 6 hours  
- `0 2 * * *`: Daily at 2 AM

> 🔄 **Best Practice**: Use absolute paths in cron jobs and scripts.

### Code/Config Blocks
#### SSH key copying for automation:
```bash
# Copy SSH public key to client for passwordless SSH
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.1.100
```

#### Create automated backup script:
```bash
# Create backup script
vi /root/backup-script.sh

# Script content:
#!/bin/bash
rsync -av -e ssh /root/backup-source/ root@192.168.1.100:/root/backup-destination/

# Make executable
chmod +x /root/backup-script.sh
```

#### Cron scheduling:
```bash
# Edit crontab
crontab -e

# Add cron job for automated backup (every minute for demo)
* * * * * /root/backup-script.sh

# Check cron is running
systemctl status crond
```

Monitor cron execution:
```bash
# View cron logs
journalctl -u crond -f
```

> ⚠ **Common Pitfalls**: Ensure cron daemon is running and paths are absolute. Test scripts manually before scheduling.

### Real-world Application
In production environments:
- Use dedicated backup servers
- Implement encryption for sensitive data
- Combine with tools like Tivoli, CommVault, or Veritas NetBackup for enterprise-level backups
- Schedule backups during low-traffic hours
- Implement backup rotation and retention policies
- Monitor backup success/failure via email alerts

### Centralized Backup Tools
For organizational backup management:
- Tivoli Storage Manager (TSM): IBM solution for large-scale backups
- CommVault: Enterprise backup and recovery platform  
- Veritas NetBackup: Symantec backup solution

These provide:
- Centralized management
- Bare-metal recovery
- Deduplication
- Compliance features

## Summary

### Key Takeaways
```diff
+ Rsync is a powerful utility for local and remote backups with incremental transfer capabilities
+ SSH key authentication enables secure, passwordless remote backups  
+ Cron jobs automate backup scheduling for hands-free operations
+ Always verify backup integrity by checking file contents after transfer
+ Use absolute paths in scripts and cron jobs to prevent path resolution issues
- Never store SSH private keys or passwords in plain text files
- Avoid running backups during peak business hours to minimize performance impact
```

### Quick Reference

**Basic Rsync Commands:**
```bash
# Local backup
rsync -av /source/ /destination/

# Remote backup  
rsync -av -e ssh /source/ user@host:/destination/

# With progress
rsync -av --progress /source/ /destination/
```

**Cron Schedules:**
- `* * * * *`: Every minute
- `0 */4 * * *`: Every 4 hours
- `0 2 * * 1`: Every Monday at 2 AM

**SSH Key Setup:**
```bash
ssh-keygen -t rsa
ssh-copy-id user@remote-host
```

### Expert Insight

**Real-world Application**: In production environments, combine rsync with enterprise backup solutions for comprehensive data protection. Use RAID arrays for local redundancy and cloud storage (AWS S3, Azure Blob) for offsite backups.

**Expert Path**: Master advanced rsync features like `--link-dest` for incremental backups, and integrate with backup verification scripts. Learn LVM snapshots for consistent filesystem backups.

**Common Pitfalls**:
- Forgetting trailing slashes in directory paths
- Not testing SSH key authentication before automation
- Running backups during high-usage periods
- Overlooking file permission and ownership preservation
- Failing to verify backup completeness and integrity

</details>
