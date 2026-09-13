#include "snoop.h"
#include "executor_utils.h"

#include <errno.h>
#include <limits.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

extern char **environ;

typedef struct
{
    long number;
    unsigned long long calls;
    double total_time;
    unsigned long long first_seen;
} SyscallStat;

typedef struct
{
    long number;
    struct timespec entry_time;
    int active;
} ActiveCall;

static const char *syscallname(long n)
{
    static const char *names[] = {
        [0] = "read", [1] = "write", [2] = "open", [3] = "close",
        [4] = "stat", [5] = "fstat", [6] = "lstat", [7] = "poll",
        [8] = "lseek", [9] = "mmap", [10] = "mprotect", [11] = "munmap",
        [12] = "brk", [13] = "rt_sigaction", [14] = "rt_sigprocmask",
        [15] = "rt_sigreturn", [16] = "ioctl", [17] = "pread64",
        [18] = "pwrite64", [19] = "readv", [20] = "writev",
        [21] = "access", [22] = "pipe", [23] = "select",
        [24] = "sched_yield", [25] = "mremap", [28] = "madvise",
        [32] = "dup", [33] = "dup2", [35] = "nanosleep",
        [39] = "getpid", [41] = "socket", [42] = "connect",
        [43] = "accept", [44] = "sendto", [45] = "recvfrom",
        [46] = "sendmsg", [47] = "recvmsg", [48] = "shutdown",
        [49] = "bind", [50] = "listen", [51] = "getsockname",
        [52] = "getpeername", [53] = "socketpair", [54] = "setsockopt",
        [55] = "getsockopt", [56] = "clone", [57] = "fork",
        [58] = "vfork", [59] = "execve", [60] = "exit",
        [61] = "wait4", [62] = "kill", [63] = "uname",
        [72] = "fcntl", [73] = "flock", [74] = "fsync", [75] = "fdatasync",
        [76] = "truncate", [77] = "ftruncate", [78] = "getdents",
        [79] = "getcwd", [80] = "chdir", [81] = "fchdir",
        [82] = "rename", [83] = "mkdir", [84] = "rmdir", [85] = "creat",
        [86] = "link", [87] = "unlink", [88] = "symlink", [89] = "readlink",
        [90] = "chmod", [91] = "fchmod", [92] = "chown", [93] = "fchown",
        [94] = "lchown", [95] = "umask", [96] = "gettimeofday",
        [97] = "getrlimit", [98] = "getrusage", [99] = "sysinfo",
        [100] = "times", [102] = "getuid", [104] = "getgid",
        [105] = "setuid", [106] = "setgid", [107] = "geteuid",
        [108] = "getegid", [110] = "getppid", [111] = "getpgrp",
        [112] = "setsid", [114] = "setreuid", [115] = "setregid",
        [117] = "setresuid", [119] = "setresgid", [131] = "sigaltstack",
        [158] = "arch_prctl", [186] = "gettid", [202] = "futex",
        [203] = "sched_setaffinity", [204] = "sched_getaffinity",
        [217] = "getdents64", [218] = "setxattr", [219] = "lsetxattr",
        [220] = "fsetxattr", [221] = "getxattr", [222] = "lgetxattr",
        [223] = "fgetxattr", [231] = "exit_group", [232] = "epoll_wait",
        [233] = "epoll_ctl", [234] = "tgkill", [257] = "openat",
        [258] = "mkdirat", [263] = "unlinkat", [267] = "readlinkat",
        [269] = "fchmodat", [272] = "unshare", [273] = "set_robust_list",
        [281] = "epoll_pwait", [288] = "accept4", [291] = "epoll_create1",
        [292] = "dup3", [293] = "pipe2", [302] = "prlimit64",
        [318] = "getrandom", [319] = "memfd_create", [322] = "execveat",
        [332] = "statx"
    };

    static char unknown[64];

    if (n >= 0 && (size_t)n < sizeof(names) / sizeof(names[0]) &&
        names[n] != NULL)
        return names[n];

    snprintf(unknown, sizeof(unknown), "syscall_%ld", n);
    return unknown;
}

static double elapsed(const struct timespec *a, const struct timespec *b)
{
    return (double)(b->tv_sec - a->tv_sec) +
           (double)(b->tv_nsec - a->tv_nsec) / 1000000000.0;
}

static int findstat(SyscallStat *stats, size_t count, long number)
{
    for (size_t i = 0; i < count; ++i)
        if (stats[i].number == number)
            return (int)i;
    return -1;
}

static int addstat(SyscallStat **stats, size_t *count, size_t *capacity,
                   long number, unsigned long long order)
{
    int existing = findstat(*stats, *count, number);
    if (existing >= 0)
        return existing;

    if (*count == *capacity)
    {
        size_t newcap = *capacity ? *capacity * 2 : 64;
        SyscallStat *tmp = realloc(*stats, newcap * sizeof(**stats));
        if (!tmp)
            return -1;
        *stats = tmp;
        *capacity = newcap;
    }

    (*stats)[*count] = (SyscallStat){
        .number = number,
        .calls = 0,
        .total_time = 0.0,
        .first_seen = order
    };

    return (int)(*count)++;
}

static int comparestats(const void *a, const void *b)
{
    const SyscallStat *x = a;
    const SyscallStat *y = b;

    if (x->calls < y->calls) return 1;
    if (x->calls > y->calls) return -1;

    if (x->first_seen < y->first_seen) return -1;
    if (x->first_seen > y->first_seen) return 1;

    return 0;
}

static void printsummary(SyscallStat *stats, size_t count)
{
    qsort(stats, count, sizeof(*stats), comparestats);

    printf("syscall       calls   time\n");

    for (size_t i = 0; i < count; ++i)
    {
        printf("%-13s %-7llu %.3fs\n",
               syscallname(stats[i].number),
               stats[i].calls,
               stats[i].total_time);
    }
}

static int validpidtext(const char *text, pid_t *pid)
{
    if (!text || !*text)
        return 0;

    long value = 0;

    for (const char *p = text; *p; ++p)
    {
        if (*p < '0' || *p > '9')
            return 0;

        if (value > (LONG_MAX - (*p - '0')) / 10)
            return 0;

        value = value * 10 + (*p - '0');

        if (value > INT_MAX)
            return 0;
    }

    if (value <= 0)
        return 0;

    *pid = (pid_t)value;
    return 1;
}

static int traceprocess(pid_t pid, int initial_stop)
{
    SyscallStat *stats = NULL;
    size_t count = 0;
    size_t capacity = 0;

    ActiveCall active = {0};
    unsigned long long order = 0;
    int entering = 1;

    if (initial_stop)
    {
        int status;

        if (waitpid(pid, &status, WUNTRACED) < 0)
            return -1;

        if (!WIFSTOPPED(status))
            return 0;
    }

    if (ptrace(PTRACE_SETOPTIONS, pid, 0,
               (void *)(long)PTRACE_O_TRACESYSGOOD) == -1)
        return -1;

    if (ptrace(PTRACE_SYSCALL, pid, 0, 0) == -1)
        return -1;

    for (;;)
    {
        int status;

        if (waitpid(pid, &status, 0) < 0)
        {
            if (errno == EINTR)
                continue;

            break;
        }

        /*
         * The process has finished.
         *
         * A terminating syscall such as exit_group may have an
         * entry stop but no syscall-exit stop. Count it here.
         */
        if (WIFEXITED(status) || WIFSIGNALED(status))
        {
            if (active.active)
            {
                struct timespec now;
                clock_gettime(CLOCK_MONOTONIC, &now);

                int index = addstat(&stats, &count, &capacity,
                                    active.number, order++);

                if (index >= 0)
                {
                    stats[index].calls++;
                    stats[index].total_time +=
                        elapsed(&active.entry_time, &now);
                }

                active.active = 0;
            }

            break;
        }

        if (!WIFSTOPPED(status))
            continue;

        int sig = WSTOPSIG(status);

        /*
         * SIGTRAP | 0x80 means a syscall entry/exit stop because
         * PTRACE_O_TRACESYSGOOD is enabled.
         */
        if (sig == (SIGTRAP | 0x80))
        {
            struct user_regs_struct regs;

            if (ptrace(PTRACE_GETREGS, pid, 0, &regs) == -1)
                break;

            long number = (long)regs.orig_rax;

            struct timespec now;
            clock_gettime(CLOCK_MONOTONIC, &now);

            if (entering)
            {
                /*
                 * Syscall entry.
                 */
                active.number = number;
                active.entry_time = now;
                active.active = 1;

                entering = 0;
            }
            else
            {
                /*
                 * Syscall exit.
                 */
                if (active.active && active.number == number)
                {
                    int index = addstat(&stats, &count, &capacity,
                                        number, order++);

                    if (index >= 0)
                    {
                        stats[index].calls++;
                        stats[index].total_time +=
                            elapsed(&active.entry_time, &now);
                    }
                }

                active.active = 0;
                entering = 1;
            }

            if (ptrace(PTRACE_SYSCALL, pid, 0, 0) == -1)
                break;

            continue;
        }

        /*
         * A plain SIGTRAP can happen around execve under ptrace.
         * It is a ptrace event, not a signal that should be delivered
         * to the traced process.
         */
        if (sig == SIGTRAP)
        {
            if (ptrace(PTRACE_SYSCALL, pid, 0, 0) == -1)
                break;

            continue;
        }

        /*
         * For an actual signal delivered to the traced process,
         * pass the signal through while continuing syscall tracing.
         */
        if (ptrace(PTRACE_SYSCALL, pid, 0, sig) == -1)
            break;
    }

    printsummary(stats, count);

    free(stats);

    return 0;
}

static int launchtrace(const ParsedCommand *command)
{
    if (command->arguments_count < 2)
        return 1;

    char *path = resolve_binary(command->arguments_list[1]);

    if (!path)
    {
        printf("snoop: command not found\n");
        return 1;
    }

    pid_t pid = fork();

    if (pid < 0)
    {
        free(path);
        return 1;
    }

    if (pid == 0)
    {
        if (ptrace(PTRACE_TRACEME, 0, 0, 0) == -1)
            _exit(127);

        raise(SIGSTOP);

        char **argv = calloc(command->arguments_count, sizeof(char *));
        if (!argv)
            _exit(127);

        for (size_t i = 1; i < command->arguments_count; ++i)
            argv[i - 1] = command->arguments_list[i];

        argv[command->arguments_count - 1] = NULL;

        execve(path, argv, environ);
        _exit(127);
    }

    free(path);

    if (traceprocess(pid, 1) < 0)
    {
        kill(pid, SIGKILL);
        waitpid(pid, NULL, 0);
        return 1;
    }

    return 0;
}

static int attachtrace(pid_t pid)
{
    if (ptrace(PTRACE_ATTACH, pid, 0, 0) == -1)
    {
        printf("snoop: no such process\n");
        return 1;
    }

    return traceprocess(pid, 1);
}

int snoop_builtin(const ParsedCommand *command)
{
    if (!command || command->arguments_count == 0 ||
        strcmp(command->arguments_list[0], "snoop") != 0)
        return 0;

    if (command->arguments_count >= 2 &&
        strcmp(command->arguments_list[1], "-p") == 0)
    {
        if (command->arguments_count != 3)
        {
            printf("snoop: invalid syntax\n");
            return 1;
        }

        pid_t pid;

        if (!validpidtext(command->arguments_list[2], &pid))
        {
            printf("snoop: no such process\n");
            return 1;
        }

        return attachtrace(pid);
    }

    if (command->arguments_count < 2)
    {
        printf("snoop: invalid syntax\n");
        return 1;
    }

    return launchtrace(command);
}
