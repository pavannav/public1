# Section 27: Process Management

<details open>
<summary><b>Section 27: Process Management (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Process Management](#introduction-to-process-management)
- [Understanding Process IDs (PID and PPID)](#understanding-process-ids-pid-and-ppid)
- [Process Types (Daemons, Zombies, and More)](#process-types-daemons-zombies-and-more)
- [Fork and Exec](#fork-and-exec)
- [Process Monitoring Commands (ps, top, pstree, etc.)](#process-monitoring-commands-ps-top-pstree-etc)
- [Killing Processes with Signals](#killing-processes-with-signals)
- [Hands-on Labs and Examples](#hands-on-labs-and-examples)
- [Summary](#summary)

## Introduction to Process Management

### Overview
Process Management in Linux involves monitoring, controlling, and manipulating running programs (processes). A process is a compiled program currently executing in the system, utilizing CPU, memory, and other resources. Understanding process management is crucial for system administrators, especially for certifications and interviews, as it ensures system stability and resource allocation. This section covers fundamentals, commands, and practical examples from the transcript.

### Key Concepts
- **Process Definition**: A process is a compiled source code (program) that is running in the system, consuming resources like RAM and CPU. It differs from a program, which is static code on disk.
- **Process Hierarchy**: Processes form a tree structure. Every process has a parent and possibly children. The root is typically the `init` process (PID 1) or `systemd` in modern systems.
- **Process States**: Processes can be in states like running (R), sleeping (S or D for uninterruptible sleep), zombie (Z), stopped (T), or idle (I). These are indicated by single characters in `ps` output.
- **Resource Utilization**: Processes use CPU, memory, and I/O. Poor management can lead to system slowdowns or hangs.

### Deep Dive
Processes are identified by unique Process IDs (PIDs). The system tracks their parent (PPID), user, terminal, command, and more. Key entities:
- **Init/Systemd**: The first process (PID 1), often called the "grandfather" of processes, with no parent. It is the ancestor of all other processes.
- **Daemons**: Background processes that start at boot and run indefinitely (e.g., `systemd`, `sshd`). They have "d" status in `ps` and don't die under normal conditions.
- **Zombie Processes**: Terminated processes waiting for parent cleanup. They don't consume resources heavily but indicate issues if persistent.

Processes can be foreground (interactive, blocking terminal) or background (non-blocking, can continue after logout).

### Code/Config Blocks
- Create a background process:
  ```bash
  sleep 100 &
  ```
- Check current process ID:
  ```bash
  echo $$
  ```
- Check parent process ID:
  ```bash
  echo $PPID
  ```

## Understanding Process IDs (PID and PPID)

### Overview
Every process has a unique Process ID (PID). The Parent Process ID (PPID) identifies the creator process. PIDs increase numerically, with lower numbers being older.

### Key Concepts
- **PID Hierarchy**: Child PIDs are higher than parent PIDs. The system assigns sequential unique IDs.
- **PPID Tracking**: Use `$PPID` to get the current shell's parent.
- **Examples**: A terminal session's shell has a PID; commands run from it have that PID as PPID.

### Deep Dive
- Command to find a process's PID by name:
  ```bash
  pidof bash
  ```
- Command to find PID of a specific process:
  ```bash
  ps -C sleep -o pid,ppid,cmd
  ```
- Verify hierarchy:
  ```bash
  ps -p $$ -o pid,ppid,cmd
  ```

## Process Types (Daemons, Zombies, and More)

### Overview
Processes vary: daemons run system-wide services, zombies are dead but not cleaned up.

### Key Concepts
- **Daemons**: Auto-start at boot, run in background (e.g., `systemd`). PID 1 is the ultimate daemon.
- **Zombies**: Terminated processes awaiting parent acknowledgment. Harmless but indicate poor cleanup. Use `ps` to find (state "Z"); kill parent if needed.
- **Forked Processes**: Create copies (fork) or replace with new programs (exec).

### Deep Dive
- Zombie prevention: Ensure parents reap children with `wait()` in programming.
- Check for zombies:
  ```bash
  ps aux | grep Z
  ```

### Code/Config Blocks
- Start a daemon-like background process:
  ```bash
  nohup sleep 1000 &
  ```
- View process tree (includes daemons):
  ```bash
  pstree -p
  ```

## Fork and Exec

### Overview
Fork creates an identical copy of a process; exec replaces it with a new program. Fork doubles processes; exec swaps the executed program.

### Key Concepts
- **Fork**: Splits a process into parent and child (same PID initially until reassigned). Used for multitasking.
- **Exec**: Overwrites current process with a new one (same PID, new program). No new process created.
- **Fork + Exec**: Common in shells (e.g., fork for background, exec for new command).

### Deep Dive
- Demo: Fork creates two identical processes; exec replaces one.
- Example commands:
  ```bash
  # Fork example (creates child)
  bash -c "echo 'Parent PID: $$'"
  # From one shell, fork to create another
  bash
  # Exec replaces shell
  exec ls
  ```

### Code/Config Blocks
- Simulate fork (in programming):
  ```c
  #include <unistd.h>
  pid_t pid = fork();
  if (pid == 0) {
      // Child process
      execvp("ls", argv);
  } else {
      // Parent process
      wait(NULL);
  }
  ```
- Background exec:
  ```bash
  exec sleep 100 &
  ```

### Lab Demos
- Run `sleep 100` in background:
  ```bash
  sleep 100 &
  ```
- Check PID, fork by opening new shell, compare PIDs.

## Process Monitoring Commands (ps, top, pstree, etc.)

### Overview
Commands like `ps`, `top`, `pstree`, `pgrep`, etc., inspect running processes.

### Key Concepts
- **ps**: Lists processes. Options: `aux` (all users), `ef` (full format). Columns: PID, PPID, user, %CPU, %MEM, status, cmd.
- **top**: Real-time monitor with CPU/memory usage, kill capability.
- **pstree**: Tree view of process hierarchy.
- **pgrep**: Search processes by name.
- **pmap/whois/top -H**: Memory/user specifics.

| Command | Description | Example |
|---------|-------------|---------|
| `ps aux` | All processes with details | `ps aux \| head -10` |
| `top` | Interactive top processes | `top` (press k to kill) |
| `pstree` | Process tree | `pstree -p` |
| `pgrep` | Find PID by name | `pgrep sleep` |
| `strace` | Trace syscalls | `strace -p <PID>` |

### Deep Dive
- Process states in `ps`: R (running), S (sleeping), D (uninterruptible), T (stopped), Z (zombie).
- `top` columns: PID, USER, %CPU, %MEM, VSZ (virtual mem), RES (physical mem), COMMAND.

### Code/Config Blocks
- List processes by user:
  ```bash
  ps -u username
  ```
- Tree for specific PID:
  ```bash
  pstree -p 1
  ```
- Monitor in top:
  ```bash
  top -p <PID>
  ```

### Lab Demos
- Run multiple `sleep` processes, monitor with `ps` and `pstree`.
- Use `top` to observe CPU usage, kill a process via `top`.

## Killing Processes with Signals

### Overview
Use `kill` with signals to terminate or control processes. Signals are system messages (e.g., SIGTERM for graceful stop).

### Key Concepts
- **Common Signals**:
  - SIGHUP (1): Reload config.
  - SIGTERM (15): Graceful kill.
  - SIGKILL (9): Force kill (kernel level).
  - SIGSTOP (19/20): Stop (pause).
  - SIGCONT (18): Resume.
- `kill` defaults to SIGTERM (15). Use `-l` for signal list.

### Deep Dive
- Force kill stubborn processes with SIGKILL.
- Stop/resume for debugging.
- Multi-signal kills: `killall` for name-based.

### Code/Config Blocks
- Graceful kill:
  ```bash
  kill <PID>
  ```
- Force kill:
  ```bash
  kill -9 <PID>
  ```
- Stop and resume:
  ```bash
  kill -STOP <PID>  # Pause
  kill -CONT <PID>   # Resume
  ```
- Kill by name:
  ```bash
  killall sleep
  ```

### Lab Demos
- Start `sleep 1000 &`, kill with `kill`, check state with `ps`.
- Force kill with `kill -9`, compare to graceful kill.

## Hands-on Labs and Examples

### Overview
Practice with background processes, monitoring, and killing.

### Lab Demos
1. Start background processes:
   ```bash
   sleep 200 &
   sleep 300 &
   ```
2. Check with `ps aux | grep sleep`.
3. Use `pstree` to view hierarchy.
4. Kill individually or by name.
5. Simulate zombie (if possible with custom script) and check with `ps`.
6. Use `top` to monitor and kill interactively.

### Common Pitfalls
- Killing wrong processes: Verify PID with `ps`.
- Ignoring signals: Use SIGKILL for stuck ones.
- Not checking parent: Zombies persist if parent doesn't reap.

## Summary

### Key Takeaways
```diff
+ Process Management Overview: Processes are running programs identified by PID/PPID, with types like daemons and zombies.
- Critical Commands: Master `ps`, `top`, `pstree`, `kill` for monitoring and control.
! Signals Usage: Use SIGTERM for graceful, SIGKILL for force. Avoid overusing force kills.
- Process Hierarchy: Understand tree structure; root has no parent.
+ Labs: Practice starting background jobs, monitoring, and killing to build expertise.
```

### Quick Reference
- `: List all processes: `ps aux`
- `: Tree view: `pstree`
- `: Real-time monitor: `top`
- `: Kill process: `kill -9 <PID>`
- `: Find PID: `pgrep <name>`
- `: Background task: `command &`

### Expert Insight
**Real-world Application**: In production, use process management to prevent server overload. For example, monitor apache/nginx processes with `top` and kill runaway ones. Automate with scripts for load balancing.
**Expert Path**: Learn advanced tools like `strace` for syscall debugging, `lsof` for file handles. Practice in labs to handle high-load scenarios. Integrate with tools like systemd for service management.
**Common Pitfalls**: Forgetting PPID leads to orphan processes. Mismanaging daemons causes boot issues. Always signal lists (`kill -l`) and verify with `ps` before killing.

</details>
