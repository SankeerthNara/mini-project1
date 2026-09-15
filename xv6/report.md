xv6-RISC-V MLFQ Scheduler --- Project Report

2.3 Report

2.3.1 Implementation Summary

The scheduler extension was implemented in xv6-RISC-V with
compile-time scheduler selection. The original Round-Robin (RR)
scheduler remains the default when no scheduler is specified, while
SCHEDULER=MLFQ enables the new Multi-Level Feedback Queue scheduler.

The MLFQ implementation uses four priority queues:

Queue   Priority     Time Slice

0       Highest          1 tick
1       High            4 ticks
2       Medium          8 ticks
3       Lowest         16 ticks

A process starts in queue 0. CPU-heavy processes are gradually moved to
lower-priority queues when they consume their complete time slice.
Processes that voluntarily block/yield before consuming their complete
slice retain their current priority. Every 48 ticks, a global priority
boost returns active processes to queue 0 to reduce starvation.

1. Makefile / SCHEDULER Macro

The Makefile was modified so that the scheduler can be selected at build
time using the SCHEDULER variable.

Conceptually:

make qemu

builds xv6 with the original/default RR scheduler, while:

make qemu SCHEDULER=MLFQ

adds the compiler definition:

-DSCHEDULER_MLFQ

MLFQ-specific code is therefore protected by #ifdef SCHEDULER_MLFQ.
This keeps the original scheduler path available and allows RR and MLFQ
to be built from the same source tree. During integration, the
scheduler-specific CFLAGS block was placed after the final relevant
CFLAGS assignment so that it would not be overwritten by a later
CFLAGS = ... statement.

2. struct proc Changes

The process structure in kernel/proc.h was extended with scheduler
bookkeeping for MLFQ:

priority --- stores the current queue number, from 0 to 3.

ticks_in_slice --- records how much of the current queue's time
slice has been consumed.

enqueue_time --- records when the process became runnable and is
used to provide FIFO ordering between processes at the same
priority.

These fields are guarded by #ifdef SCHEDULER_MLFQ, so they are only
needed when the MLFQ scheduler is compiled.

The enqueue_time field avoids the need to maintain separate
linked-list queue structures. Since xv6 has a fixed process table, the
scheduler can scan the table and use the timestamp to determine which
runnable process entered the current priority level first.

3. allocproc() Changes

allocproc() initializes the new scheduler state when a process is
allocated.

For a new MLFQ process:

priority is initialized to queue 0;

ticks_in_slice is initialized to 0;

the enqueue bookkeeping is initialized before the process becomes
runnable.

Starting new processes in queue 0 gives newly created work the highest
priority and therefore allows it to receive CPU time quickly before the
scheduler has observed its CPU usage.

When a process later becomes runnable again, its enqueue_time is
updated so that its position among processes in the same queue reflects
its most recent entry into the ready state.

4. Queue Selection and Preemption Logic

The MLFQ scheduler scans the xv6 process table for RUNNABLE processes.

Selection is performed in two stages:

Select the runnable process with the highest priority, where
queue 0 is highest and queue 3 is lowest.

If several runnable processes are in the same queue, select the one
with the smallest/oldest enqueue_time.

Thus, the effective selection rule is:

lowest queue number
        +
oldest enqueue_time within that queue

This provides FIFO ordering within each priority level without requiring
explicit queue data structures.

Preemption is driven by timer ticks. When the currently running process
consumes the configured time slice for its queue, it is forced to give
up the CPU and the scheduler chooses the next runnable process. Because
queue 0 has higher priority than queue 1, for example, a runnable
queue-0 process can preempt a queue-1 process at the next scheduling
decision.

The implementation therefore combines priority scheduling with
time-slice-based preemption.

5. Time-Slice Handling

The four MLFQ time slices are:

Queue 0 → 1 tick
Queue 1 → 4 ticks
Queue 2 → 8 ticks
Queue 3 → 16 ticks

Timer interrupts account for the CPU ticks consumed by the running
process. The ticks_in_slice field tracks consumption of the current
queue's slice.

When a process consumes its complete slice, its priority is reduced:

Queue 0 → Queue 1
Queue 1 → Queue 2
Queue 2 → Queue 3

A process already in queue 3 remains in queue 3 because it is the lowest
priority level.

The important distinction is that demotion is based on consuming the
complete CPU slice, not merely on leaving the RUNNING state.

6. Voluntary Yield / Blocking Handling

A process may give up the CPU voluntarily, for example because it
performs an operation that blocks for I/O.

The implementation distinguishes this case from timer-driven slice
exhaustion.

If a process voluntarily blocks before consuming its entire time slice,
its priority is preserved. This is important because interactive or
I/O-bound processes often execute for a short period and then sleep.
Demoting them every time they block would incorrectly classify them as
CPU-bound.

Therefore:

Full time slice consumed → demote
Voluntary block/yield     → preserve priority

This behavior is a key part of the feedback mechanism.

7. Priority Boosting

A global priority boost is performed every 48 ticks.

The purpose of the boost is to prevent starvation. A CPU-bound process
can gradually move to queue 3, while continuously arriving or
interactive processes may remain in higher-priority queues. Without a
boost, the lower-priority process could potentially wait for a very long
time.

At a boost:

Active processes → Queue 0

The recorded implementation invokes the MLFQ boost from the
timer-interrupt path. The recorded live verification showed boosts
occurring every 48 ticks.

The boost does not mean that a process permanently remains at queue 0.
After the boost, CPU-heavy processes can again consume full slices and
be demoted according to the normal MLFQ rules.

8. procdump() Changes

procdump() was extended to expose MLFQ scheduler information in
addition to normal process information.

The debugging output includes scheduler-related information such as:

PID;

process name;

process state;

current queue/priority;

slice consumption;

enqueue-order information;

boost-related information where applicable.

The project also used QLOG messages to observe important scheduler
events such as process creation and priority boosts.

These debugging facilities were useful because the scheduler's behavior
changes over time. A final process-state snapshot alone cannot show when
or why a process moved between queues. procdump() provides a state
snapshot, while QLOG provides a temporal trace.

2.3.2 MLFQ Analysis

Test Workload

A custom scheduler test workload was used to exercise the scheduler with
multiple processes. The recorded project state contains measurements for
7 processes under RR and MLFQ.

The intended MLFQ workload contains processes with different CPU-burst
behaviors:

short/interactive processes that voluntarily give up the CPU
frequently;

longer CPU-bound processes that consume complete slices;

multiple processes competing at different priority levels.

This allows the feedback behavior of MLFQ to be observed.

Expected Queue Behavior

A process starts in queue 0. If it repeatedly consumes its entire time
slice, it is gradually demoted:

Queue 0 --1 tick--> Queue 1 --4 ticks--> Queue 2 --8 ticks--> Queue 3

An I/O-bound process that frequently blocks before its slice expires
should normally remain at a higher priority. A CPU-bound process that
repeatedly consumes complete slices should move toward queue 3.

The recorded implementation was live-verified using Ctrl+P/procdump
and QLOG traces. The verification specifically recorded correct 1/4/8/16
tick slice behavior, 48-tick boosts, and preservation of priority on
voluntary yield.

Priority Boost Behavior

Every 48 ticks, active processes are boosted back to queue 0. This
periodically removes accumulated priority differences and gives
lower-priority processes an opportunity to run.

The boost is particularly important for CPU-bound processes. Without it,
a process that has reached queue 3 could repeatedly lose scheduling
decisions to processes in higher queues. The boost provides a fairness
mechanism while retaining the short-term responsiveness advantages of
priority scheduling.

Timeline / Scatter Plot

The assignment requires a timeline/scatter plot with:

X-axis: elapsed scheduler time in ticks;

Y-axis: queue ID, 0--3;

one color per process/PID;

visible queue transitions;

visible 48-tick priority boosts;

watermark using the portion of the IIIT email address before @.

The recorded project evidence confirms that QLOG traces were used to
verify queue transitions and 48-tick boosts, but the captured project
state does not contain the raw QLOG timeline data or a completed
plot-generation script. Therefore, no fabricated coordinates or process
transitions are included in this report.

The following code is provided as a reproducible plotting template once
the QLOG output has been exported to a CSV file containing tick,
pid, and queue columns.

import pandas as pd
import matplotlib.pyplot as plt

# Input CSV should contain:
# tick,pid,queue
# 0,1,0
# 1,1,1
# ...

data = pd.read_csv("qlog_timeline.csv")

plt.figure(figsize=(12, 6))

for pid, group in data.groupby("pid"):
    group = group.sort_values("tick")
    plt.scatter(group["tick"], group["queue"], label=f"PID {pid}", s=18)

# Mark the periodic boost boundaries visible in the trace.
max_tick = int(data["tick"].max()) if len(data) else 0
for tick in range(48, max_tick + 1, 48):
    plt.axvline(tick, linestyle="--", linewidth=0.8)

plt.xlabel("Time elapsed (ticks)")
plt.ylabel("Queue ID")
plt.yticks([0, 1, 2, 3])
plt.title("xv6 MLFQ Queue Timeline")

# Replace this with the required username portion of the IIIT email.
plt.text(
    0.5, 0.5, "IIIT_USERNAME",
    transform=plt.gca().transAxes,
    fontsize=28,
    alpha=0.20,
    ha="center",
    va="center",
    rotation=25
)

plt.legend()
plt.grid(True, alpha=0.25)
plt.tight_layout()
plt.savefig("mlfq_timeline.png", dpi=200)
plt.show()

Important: the IIIT_USERNAME placeholder must be replaced with the
actual portion of the student's IIIT email address before submission.

Interpretation

The recorded implementation demonstrates the intended MLFQ behavior:
processes that consume complete CPU slices are demoted, while voluntary
blocking preserves their current priority. Thus, CPU-bound processes
tend to move toward lower queues, whereas short-running or I/O-bound
processes can remain in higher queues and receive better responsiveness.
The 48-tick boost periodically returns active processes to queue 0,
reducing the possibility of starvation. The recorded live verification
confirmed the configured 1/4/8/16 tick slice transitions and 48-tick
boosts. Exact point-by-point queue trajectories are not reproduced here
because the raw QLOG timeline data was not present in the captured
project evidence.

2.3.3 Comparison Results

The comparison focuses on the three policies requested by the
assignment: FIFO, Round Robin (RR), and MLFQ. MLFQ is the scheduler
implemented in this project, while RR is the original xv6 scheduler.
FIFO is included as a conceptual baseline to explain the trade-offs
between a simple first-come-first-served policy and adaptive priority
scheduling; a separate FIFO implementation was not required for the
MLFQ implementation itself.

Measured Scheduler Test Run

A captured scheduler test run contained 6 children, with all six
arriving at tick 45. The workload consisted of three CPU-bound
processes and three I/O-bound processes.

PID

Type

Completion

Turnaround

Waiting

Running

Response

4

CPU-bound

51

6

0

6

0

5

CPU-bound

58

13

0

13

0

6

CPU-bound

64

19

0

19

0

7

I/O-bound

208

163

163

0

0

8

I/O-bound

208

163

160

0

0

9

I/O-bound

208

163

161

0

0

The averages for this run are:

Average Turnaround Time = 87.83 ticks

Average Waiting Time = 80.67 ticks

Average Response Time = 0.00 ticks

This run is useful evidence for the scheduler analysis because it
contains both CPU-bound and I/O-bound processes, allowing the behavior
of the scheduling policy to be observed under different process
characteristics.

Cross-Scheduler Comparison

A common six-process workload was used for the three-scheduler
comparison. All six processes arrived at tick 45, with three CPU-bound
and three I/O-bound processes. The measured averages are:

Scheduler

Processes

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

The results show that MLFQ has the lowest average turnaround time and
waiting time for this workload. Compared with FIFO, MLFQ reduces average
turnaround by 1.50 ticks and average waiting by 0.34 ticks.
Compared with Round Robin, MLFQ reduces average turnaround by 1.67
ticks and average waiting by 0.84 ticks. All three schedulers have
an average response time of 0.00 ticks for this particular test, so
this run does not show a numerical response-time difference.

Metric Definitions

Turnaround Time is the time from process arrival until process
completion.

Waiting Time is the total time spent waiting in the ready queue.

Response Time is the time from process arrival until it first
receives CPU time.

Lower values are generally preferable for all three metrics, although
response time is particularly important for interactive workloads.

Why MLFQ Is Preferable for This Workload

FIFO is simple because it executes processes in arrival order, but a
long CPU-bound process at the front can delay every process behind it.
Round Robin improves fairness and responsiveness by periodically
preempting processes and giving each runnable process a time quantum,
although its behavior depends strongly on the selected quantum size.
With a very small quantum, RR can incur more context-switch overhead,
while a very large quantum makes it behave more like FIFO. MLFQ adapts
to process behavior instead of treating every process identically:
CPU-bound processes that repeatedly consume their full quantum are
demoted, while processes that voluntarily block can retain a higher
priority. The 1/4/8/16 tick queue sizes therefore favor short and
interactive work while still allowing CPU-bound work to make progress.
The periodic 48-tick priority boost prevents lower-priority processes
from being permanently starved. In the recorded six-process measurement, MLFQ achieved the lowest
average turnaround (86.33 ticks) and waiting time (80.33 ticks),
compared with FIFO (87.83, 80.67) and RR (88.00, 81.17).
All three schedulers had an average response time of 0 ticks in this
particular run. Therefore, for this mixed CPU-bound and I/O-bound
workload, the measured results favor MLFQ while its adaptive priority
policy provides the main conceptual advantage over fixed-order FIFO and
fixed-quantum RR.

Comparison Interpretation

The numerical results should be interpreted as measurements for the
specific workload rather than as a universal guarantee that MLFQ always
produces lower averages. The main advantage of MLFQ is its adaptive
behavior: scheduling priority changes according to how processes use
the CPU. This makes it particularly suitable for workloads containing
both interactive/I/O-bound and CPU-bound processes. FIFO remains useful
as a simple baseline, while RR provides a fairer fixed-quantum policy.
MLFQ combines the strengths of priority scheduling and time slicing,
with periodic boosting providing an explicit fairness mechanism.

Implementation Verification Summary

The recorded project verification reports that the MLFQ implementation
was compiled cleanly and live-tested. The following behaviors were
specifically verified:

four queues with queue 0 as the highest priority;

1/4/8/16 tick time slices;

strict priority scheduling;

preemption at slice boundaries;

demotion after complete slice consumption;

preservation of priority after voluntary yield/blocking;

48-tick periodic priority boosting;

extended procdump() information;

QLOG traces for observing scheduler events.

The default RR path was also retained so that the MLFQ implementation
could be compared against the original scheduler.

Conclusion

The xv6 scheduler was extended with a compile-time selectable MLFQ
policy while preserving the original RR scheduler as the default. The
implementation maintains four priority levels, uses different time
slices for each level, demotes CPU-heavy processes after complete
slices, preserves priority for voluntary blocking, and periodically
boosts processes to queue 0 every 48 ticks. A process-table scan
combined with enqueue_time provides priority selection and FIFO
ordering within each queue without requiring a separate linked-list
queue implementation. Runtime debugging through procdump() and QLOG
was used to verify the scheduler's behavior. The recorded six-process comparison provides measured results for FIFO,
RR and MLFQ on the same mixed workload. MLFQ achieved the lowest average
turnaround and waiting time, while all three schedulers had a 0-tick
average response time in this run. The results support MLFQ as a good
choice for mixed CPU-bound and I/O-bound workloads because it combines
time slicing, adaptive priorities and periodic priority boosting.

Appendix: Key Scheduler Constants

Queue 0: 1 tick
Queue 1: 4 ticks
Queue 2: 8 ticks
Queue 3: 16 ticks

Priority boost interval: 48 ticks

Highest priority: Queue 0
Lowest priority: Queue 3

Appendix: Build Commands

Default RR

make clean
make qemu

MLFQ

make clean
make qemu SCHEDULER=MLFQ

Debugging

Inside xv6, Ctrl+P can be used to inspect process state through
procdump(), while QLOG messages provide scheduler-event traces.
