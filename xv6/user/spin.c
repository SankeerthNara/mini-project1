#include "kernel/types.h"
#include "user/user.h"

// Pure CPU-bound workload: no syscalls inside the loop, so this process
// never voluntarily gives up the CPU. Under MLFQ it can only be moved
// between queues by timer-tick preemption (slice exhaustion), which is
// exactly what you want to see march through the queues in `Ctrl+P`
// output, or as one line in the schedulertest timeline plot.
//
// Usage: spin <iterations>
// With no argument, loops a large default count (tune this to your
// clock rate so it runs for tens of seconds, long enough to see several
// demotions and at least one priority boost at 48 ticks).
int
main(int argc, char *argv[])
{
  long n = 3000000000L;
  volatile long j = 0;
  long i;

  if (argc > 1)
    n = atoi(argv[1]);

  for (i = 0; i < n; i++)
    j += i;

  printf("spin (pid %d) done, j=%ld\n", getpid(), j);
  exit(0);
}
