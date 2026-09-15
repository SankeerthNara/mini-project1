xv6 MLFQ Scheduler

Overview

This project extends xv6-RISC-V with a compile-time selectable Multi-Level Feedback Queue (MLFQ) scheduler while preserving the original Round-Robin (RR) scheduler as the default.

Build

# Default RR
make clean
make qemu

# MLFQ
make clean
make qemu SCHEDULER=MLFQ

MLFQ policy

Four priority queues are used:

Queue

Time slice

0

1 tick

1

4 ticks

2

8 ticks

3

16 ticks

Queue 0 is highest priority. New processes enter queue 0. A process that consumes its complete slice is demoted to the next queue; queue 3 remains round-robin. Voluntary yield/I/O preserves priority. Every 48 ticks, active processes are boosted to queue 0.

Main changes

kernel/proc.h: MLFQ bookkeeping such as priority, ticks_in_slice, and enqueue_time.

kernel/proc.c: process initialization, runnable enqueue tracking, strict-priority selection, FIFO tie-breaking, slice/demotion logic, priority boost and extended procdump().

kernel/trap.c: timer integration for the 48-tick boost.

kernel/defs.h: declaration of the boost helper.

Makefile: compile-time scheduler selection.

Debugging

Ctrl+P invokes procdump() and the implementation also uses QLOG traces to observe queue transitions.

Current verification

The recorded project status says MLFQ is DONE, with correct 1/4/8/16-tick demotion, 48-tick boosting and voluntary-yield priority preservation, verified through clean compilation and live Ctrl+P/QLOG traces.

Scheduler comparison

A common six-process workload was used for the scheduler comparison. The workload contains three CPU-bound and three I/O-bound processes.

Scheduler

n

Avg. Turnaround

Avg. Waiting

Avg. Response

FIFO

6

87.83

80.67

0.00

MLFQ

6

86.33

80.33

0.00

Round Robin

6

88.00

81.17

0.00

MLFQ gives the lowest average turnaround and waiting time in this
workload. FIFO is simple but can allow a long CPU-bound process to
delay later processes. Round Robin improves fairness through
time-slicing, while MLFQ adapts priority according to CPU usage and
periodically boosts lower-priority processes to prevent starvation.
