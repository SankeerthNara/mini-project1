# CS / OS Mini-Project — README

## Overview
This project contains two major systems-programming components: a modular Linux C shell and an xv6-RISC-V scheduler extension.

## C Shell
The shell covers command input/parsing, built-ins, redirection, pipelines, sequential/background execution, process groups/job control, signals, process inspection (`spy`) and syscall tracing (`snoop`).

Advanced shell work uses operating-system facilities such as `fork()`, `execve()`, `pipe()`, `dup2()`, `/proc`, process groups, `waitpid()` and `ptrace()`.

The recorded development includes successful verification of `spy`, `snoop` command mode, `snoop -p`, error handling, and `ping`.

## xv6 Scheduler
The xv6 component adds compile-time MLFQ while retaining default RR.

MLFQ uses queues 0–3 with 1/4/8/16 tick slices, strict priority, demotion after slice exhaustion, priority preservation on voluntary yield, round-robin queue 3, and a global 48-tick priority boost. `procdump()` and QLOG traces provide debugging visibility.

Build with:
```bash
make clean
make qemu
make clean
make qemu SCHEDULER=MLFQ
```

## Evaluation
The recorded comparison currently contains:

| Scheduler | n | Avg. Turnaround | Avg. Waiting | Avg. Response |
|---|---:|---:|---:|---:|
| RR | 7 | 102.43 | 69.00 | 0.00 |
| MLFQ | 7 | 101.86 | 68.71 | 0.00 |
| FIFO | 7 | Pending | Pending | Pending |

## AI-assisted development
AI was used extensively as a development/code-generation assistant. The xv6 conversation contains a direct request for “the full modified files”; AI then generated the documented `proc.h`, `proc.c`, `trap.c`, `defs.h` and Makefile changes. The C-shell work similarly contains generated executor revisions and generated `spy`/`snoop` patches.

AI output was verified through integration, compilation and runtime testing. The project record also contains real debugging cycles, so generated code was not treated as automatically correct.

## Current status
- C shell advanced functionality: implemented and tested in the recorded workflow.
- xv6 MLFQ: complete and live-verified according to the recorded status.
- RR vs MLFQ data: available.
- FIFO comparison and final three-scheduler report: pending.
