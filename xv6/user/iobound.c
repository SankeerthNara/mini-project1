#include "kernel/types.h"
#include "user/user.h"

// I/O-bound workload: does a short CPU burst, then voluntarily blocks
// with pause() (a real sleep()-based syscall, not a timer preemption),
// repeatedly. Under MLFQ this should stay in a low queue number (high
// priority) across Ctrl+P snapshots, because voluntary blocking leaves
// priority unchanged -- unlike spin.c, which gets demoted every time it
// exhausts a slice.
//
// Usage: iobound <rounds> <pause_ticks>
int
main(int argc, char *argv[])
{
  int rounds = 50;
  int pause_ticks = 5;
  volatile long j = 0;
  int r;
  long i;

  if (argc > 1)
    rounds = atoi(argv[1]);
  if (argc > 2)
    pause_ticks = atoi(argv[2]);

  for (r = 0; r < rounds; r++) {
    // small CPU burst, short enough to fit in one queue-0 slice
    for (i = 0; i < 200000; i++)
      j += i;
    pause(pause_ticks);
  }

  printf("iobound (pid %d) done, j=%ld\n", getpid(), j);
  exit(0);
}
