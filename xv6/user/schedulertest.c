#include "kernel/types.h"
#include "user/user.h"

// schedulertest: spawns a fixed, repeatable mix of child processes to
// exercise whichever scheduler the kernel was built with (FIFO, RR, or
// MLFQ -- see the SCHEDULER Makefile macro).
//
// The kernel does all the actual instrumentation:
//   - every process, at exit, prints one "STAT ..." line (arrival,
//     first_run, completion, turnaround, waiting, running, response
//     ticks) -- see kexit() in kernel/proc.c. This works for all three
//     schedulers, since it only depends on fields tracked unconditionally.
//   - under SCHEDULER=MLFQ specifically, every queue transition (new
//     process, demotion on slice exhaustion, priority boost) prints one
//     "QLOG tick=... pid=... q=... event=..." line -- see yield(),
//     userinit()/fork(), and mlfq_boost() in kernel/proc.c.
//
// This program's only job is to create a mixed, repeatable workload:
// some children are CPU-bound (pure busy loops, never yield voluntarily,
// so they can only be preempted by the timer), others are I/O-bound
// (short CPU bursts interleaved with a voluntary pause()).
//
// To capture the log for analysis, redirect QEMU's serial output to a
// file when you run this (see the report notes / README), then run
// schedulertest from the xv6 shell, then quit qemu (Ctrl+A, X) once it
// prints "schedulertest: all children done". The saved file will
// contain interleaved STAT/QLOG lines you can grep and feed to the
// Python plotting script.
//
// Usage: schedulertest [num_cpu_bound] [num_io_bound]
int
main(int argc, char *argv[])
{
  int ncpu = 3;
  int nio = 3;
  int i, pid;

  if (argc > 1)
    ncpu = atoi(argv[1]);
  if (argc > 2)
    nio = atoi(argv[2]);

  printf("schedulertest: start, %d cpu-bound + %d io-bound children, uptime=%d\n",
         ncpu, nio, uptime());

  // CPU-bound children: pure busy loops of varying length, so you can
  // tell them apart in the timeline (different total runtimes).
  for (i = 0; i < ncpu; i++) {
    pid = fork();
    if (pid < 0) {
      printf("schedulertest: fork failed\n");
      exit(1);
    }
    if (pid == 0) {
      char *args[3];
      char nbuf[16];
      // stagger the burst length: 300M, 600M, 900M, ... iterations
      long n = 300000000L * (i + 1);
      // spin.c parses argv[1] with atoi, so build the string by hand
      // (no snprintf in xv6's ulib).
      int k = 0;
      long v = n;
      char tmp[16];
      int t = 0;
      if (v == 0) {
        tmp[t++] = '0';
      }
      while (v > 0) {
        tmp[t++] = '0' + (v % 10);
        v /= 10;
      }
      while (t > 0)
        nbuf[k++] = tmp[--t];
      nbuf[k] = 0;

      args[0] = "spin";
      args[1] = nbuf;
      args[2] = 0;
      exec("spin", args);
      printf("schedulertest: exec spin failed\n");
      exit(1);
    }
  }

  // I/O-bound children: short CPU bursts + voluntary pause(), so they
  // should stay at a low (high-priority) queue under MLFQ.
  for (i = 0; i < nio; i++) {
    pid = fork();
    if (pid < 0) {
      printf("schedulertest: fork failed\n");
      exit(1);
    }
    if (pid == 0) {
      char *args[4];
      args[0] = "iobound";
      args[1] = "40"; // rounds
      args[2] = "4";  // pause ticks per round
      args[3] = 0;
      exec("iobound", args);
      printf("schedulertest: exec iobound failed\n");
      exit(1);
    }
  }

  // Reap all children (both loops combined).
  for (i = 0; i < ncpu + nio; i++) {
    wait(0);
  }

  printf("schedulertest: all children done, uptime=%d\n", uptime());
  exit(0);
}
