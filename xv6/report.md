# xv6-RISC-V MLFQ Scheduler --- Project Report

## 2.3 Report

### 2.3.1 Implementation Summary

The scheduler extension was implemented in xv6-RISC-V with
**compile-time scheduler selection**. The original Round-Robin (RR)
scheduler remains the default when no scheduler is specified, while
`SCHEDULER=MLFQ` enables the new Multi-Level Feedback Queue scheduler.

The MLFQ implementation uses four priority queues:

  Queue   Priority     Time Slice
  ------- ---------- ------------
  0       Highest          1 tick
  1       High            4 ticks
  2       Medium          8 ticks
  3       Lowest         16 ticks

A process starts in queue 0. CPU-heavy processes are gradually moved to
lower-priority queues when they consume their complete time slice.
Processes that voluntarily block/yield before consuming their complete
slice retain their current priority. Every 48 ticks, a global priority
boost returns active processes to queue 0 to reduce starvation.

#### 1. Makefile / `SCHEDULER` Macro

The Makefile was modified so that the scheduler can be selected at build
time using the `SCHEDULER` variable.

Conceptually:

``` text
make qemu
```

builds xv6 with the original/default RR scheduler, while:

``` text
make qemu SCHEDULER=MLFQ
```

adds the compiler definition:

``` text
-DSCHEDULER_MLFQ
```

MLFQ-specific code is therefore protected by `#ifdef SCHEDULER_MLFQ`.
This keeps the original scheduler path available and allows RR and MLFQ
to be built from the same source tree. During integration, the
scheduler-specific `CFLAGS` block was placed after the final relevant
`CFLAGS` assignment so that it would not be overwritten by a later
`CFLAGS = ...` statement.

#### 2. `struct proc` Changes

The process structure in `kernel/proc.h` was extended with scheduler
bookkeeping for MLFQ:

-   `priority` --- stores the current queue number, from 0 to 3.
-   `ticks_in_slice` --- records how much of the current queue's time
    slice has been consumed.
-   `enqueue_time` --- records when the process became runnable and is
    used to provide FIFO ordering between processes at the same
    priority.

These fields are guarded by `#ifdef SCHEDULER_MLFQ`, so they are only
needed when the MLFQ scheduler is compiled.

The `enqueue_time` field avoids the need to maintain separate
linked-list queue structures. Since xv6 has a fixed process table, the
scheduler can scan the table and use the timestamp to determine which
runnable process entered the current priority level first.

#### 3. `allocproc()` Changes

`allocproc()` initializes the new scheduler state when a process is
allocated.

For a new MLFQ process:

-   priority is initialized to queue `0`;
-   `ticks_in_slice` is initialized to `0`;
-   the enqueue bookkeeping is initialized before the process becomes
    runnable.

Starting new processes in queue 0 gives newly created work the highest
priority and therefore allows it to receive CPU time quickly before the
scheduler has observed its CPU usage.

When a process later becomes runnable again, its `enqueue_time` is
updated so that its position among processes in the same queue reflects
its most recent entry into the ready state.

#### 4. Queue Selection and Preemption Logic

The MLFQ scheduler scans the xv6 process table for `RUNNABLE` processes.

Selection is performed in two stages:

1.  Select the runnable process with the **highest priority**, where
    queue 0 is highest and queue 3 is lowest.
2.  If several runnable processes are in the same queue, select the one
    with the **smallest/oldest `enqueue_time`**.

Thus, the effective selection rule is:

``` text
lowest queue number
        +
oldest enqueue_time within that queue
```

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

#### 5. Time-Slice Handling

The four MLFQ time slices are:

``` text
Queue 0 → 1 tick
Queue 1 → 4 ticks
Queue 2 → 8 ticks
Queue 3 → 16 ticks
```

Timer interrupts account for the CPU ticks consumed by the running
process. The `ticks_in_slice` field tracks consumption of the current
queue's slice.

When a process consumes its complete slice, its priority is reduced:

``` text
Queue 0 → Queue 1
Queue 1 → Queue 2
Queue 2 → Queue 3
```

A process already in queue 3 remains in queue 3 because it is the lowest
priority level.

The important distinction is that **demotion is based on consuming the
complete CPU slice, not merely on leaving the `RUNNING` state**.

#### 6. Voluntary Yield / Blocking Handling

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

``` text
Full time slice consumed → demote
Voluntary block/yield     → preserve priority
```

This behavior is a key part of the feedback mechanism.

#### 7. Priority Boosting

A global priority boost is performed every **48 ticks**.

The purpose of the boost is to prevent starvation. A CPU-bound process
can gradually move to queue 3, while continuously arriving or
interactive processes may remain in higher-priority queues. Without a
boost, the lower-priority process could potentially wait for a very long
time.

At a boost:

``` text
Active processes → Queue 0
```

The recorded implementation invokes the MLFQ boost from the
timer-interrupt path. The recorded live verification showed boosts
occurring every 48 ticks.

The boost does not mean that a process permanently remains at queue 0.
After the boost, CPU-heavy processes can again consume full slices and
be demoted according to the normal MLFQ rules.

#### 8. `procdump()` Changes

`procdump()` was extended to expose MLFQ scheduler information in
addition to normal process information.

The debugging output includes scheduler-related information such as:

-   PID;
-   process name;
-   process state;
-   current queue/priority;
-   slice consumption;
-   enqueue-order information;
-   boost-related information where applicable.

The project also used `QLOG` messages to observe important scheduler
events such as process creation and priority boosts.

These debugging facilities were useful because the scheduler's behavior
changes over time. A final process-state snapshot alone cannot show when
or why a process moved between queues. `procdump()` provides a state
snapshot, while QLOG provides a temporal trace.

------------------------------------------------------------------------

## 2.3.2 MLFQ Analysis

### Test Workload

A custom scheduler test workload was used to exercise the scheduler with
multiple processes. The recorded project state contains measurements for
**7 processes** under RR and MLFQ.

The intended MLFQ workload contains processes with different CPU-burst
behaviors:

-   short/interactive processes that voluntarily give up the CPU
    frequently;
-   longer CPU-bound processes that consume complete slices;
-   multiple processes competing at different priority levels.

This allows the feedback behavior of MLFQ to be observed.

### Expected Queue Behavior

A process starts in queue 0. If it repeatedly consumes its entire time
slice, it is gradually demoted:

``` text
Queue 0 --1 tick--> Queue 1 --4 ticks--> Queue 2 --8 ticks--> Queue 3
```

An I/O-bound process that frequently blocks before its slice expires
should normally remain at a higher priority. A CPU-bound process that
repeatedly consumes complete slices should move toward queue 3.

The recorded implementation was live-verified using `Ctrl+P`/`procdump`
and QLOG traces. The verification specifically recorded correct 1/4/8/16
tick slice behavior, 48-tick boosts, and preservation of priority on
voluntary yield.

### Priority Boost Behavior

Every 48 ticks, active processes are boosted back to queue 0. This
periodically removes accumulated priority differences and gives
lower-priority processes an opportunity to run.

The boost is particularly important for CPU-bound processes. Without it,
a process that has reached queue 3 could repeatedly lose scheduling
decisions to processes in higher queues. The boost provides a fairness
mechanism while retaining the short-term responsiveness advantages of
priority scheduling.

### Timeline / Scatter Plot

The assignment requires a timeline/scatter plot with:

-   **X-axis:** elapsed scheduler time in ticks;
-   **Y-axis:** queue ID, 0--3;
-   one color per process/PID;
-   visible queue transitions;
-   visible 48-tick priority boosts;
-   watermark using the portion of the IIIT email address before `@`.

The recorded project evidence confirms that QLOG traces were used to
verify queue transitions and 48-tick boosts, but the captured project
state does **not** contain the raw QLOG timeline data or a completed
plot-generation script. Therefore, no fabricated coordinates or process
transitions are included in this report.

The following code is provided as a reproducible plotting template once
the QLOG output has been exported to a CSV file containing `tick`,
`pid`, and `queue` columns.

``` python
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
```

**Important:** the `IIIT_USERNAME` placeholder must be replaced with the
actual portion of the student's IIIT email address before submission.

### Interpretation

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

------------------------------------------------------------------------

## 2.3.3 Comparison Results

The recorded comparison workload contains **7 processes**.

  -----------------------------------------------------------------------
  Scheduler        Number of        Average        Average        Average
                   Processes     Turnaround   Waiting Time  Response Time
                                       Time                
  ----------- -------------- -------------- -------------- --------------
  RR                       7         102.43          69.00           0.00

  MLFQ                     7         101.86          68.71           0.00

  FIFO                     7        Pending        Pending        Pending
  -----------------------------------------------------------------------

### Metric Definitions

**Turnaround Time** is the time from process arrival until process
completion.

**Waiting Time** is the total time spent waiting in the ready queue.

**Response Time** is the time from process arrival until it first
receives CPU time.

Lower values are generally preferable for all three metrics, although
response time is especially important for interactive workloads.

### Observations

For the recorded seven-process workload, MLFQ produced an average
turnaround time of **101.86 ticks**, compared with **102.43 ticks** for
RR. The recorded average waiting time was also slightly lower for MLFQ
(**68.71 ticks**) than for RR (**69.00 ticks**). Both schedulers have a
recorded average response time of **0.00 ticks** for this workload, so
the available data does not demonstrate a numerical response-time
advantage for MLFQ. MLFQ differs from RR mainly because it adapts
process priority according to CPU consumption, allowing short or
interactive processes to remain in higher-priority queues while
CPU-heavy processes move downward. RR is simpler and more predictable
because runnable processes receive repeated turns under a fixed
scheduling policy rather than changing priority levels. The 1/4/8/16
tick MLFQ slices provide increasingly longer CPU bursts at lower
priorities, while periodic boosting improves fairness for processes that
have been demoted. FIFO would provide a simpler first-come-first-served
policy but, in a non-preemptive design, a long CPU-bound process at the
front can delay all later processes. **However, FIFO results were not
present in the captured project evidence, so no numerical FIFO claim is
made here.**

### Comparison Limitations

The three-scheduler comparison required by the assignment is not fully
complete in the recorded project state because the FIFO measurement leg
is still pending. Consequently, the table above reports the verified RR
and MLFQ measurements and explicitly marks FIFO as pending rather than
inventing values.

For a final submission satisfying the complete comparison requirement,
the same seven-process workload should be run under FIFO, RR, and MLFQ,
and the three metrics should be collected using the same measurement
method.

------------------------------------------------------------------------

## Implementation Verification Summary

The recorded project verification reports that the MLFQ implementation
was compiled cleanly and live-tested. The following behaviors were
specifically verified:

-   four queues with queue 0 as the highest priority;
-   1/4/8/16 tick time slices;
-   strict priority scheduling;
-   preemption at slice boundaries;
-   demotion after complete slice consumption;
-   preservation of priority after voluntary yield/blocking;
-   48-tick periodic priority boosting;
-   extended `procdump()` information;
-   QLOG traces for observing scheduler events.

The default RR path was also retained so that the MLFQ implementation
could be compared against the original scheduler.

------------------------------------------------------------------------

## Conclusion

The xv6 scheduler was extended with a compile-time selectable MLFQ
policy while preserving the original RR scheduler as the default. The
implementation maintains four priority levels, uses different time
slices for each level, demotes CPU-heavy processes after complete
slices, preserves priority for voluntary blocking, and periodically
boosts processes to queue 0 every 48 ticks. A process-table scan
combined with `enqueue_time` provides priority selection and FIFO
ordering within each queue without requiring a separate linked-list
queue implementation. Runtime debugging through `procdump()` and QLOG
was used to verify the scheduler's behavior. The recorded seven-process
comparison shows very similar RR and MLFQ averages, with MLFQ slightly
lower in both turnaround and waiting time for this workload. The FIFO
comparison and raw timeline data are not available in the captured
project state, so they are explicitly marked as pending rather than
being fabricated.

## Appendix: Key Scheduler Constants

``` text
Queue 0: 1 tick
Queue 1: 4 ticks
Queue 2: 8 ticks
Queue 3: 16 ticks

Priority boost interval: 48 ticks

Highest priority: Queue 0
Lowest priority: Queue 3
```

## Appendix: Build Commands

### Default RR

``` bash
make clean
make qemu
```

### MLFQ

``` bash
make clean
make qemu SCHEDULER=MLFQ
```

### Debugging

Inside xv6, `Ctrl+P` can be used to inspect process state through
`procdump()`, while QLOG messages provide scheduler-event traces.
