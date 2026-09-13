#include "jobcontrol.h"

#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>
#include <termios.h>
#include <stdlib.h>
#include <limits.h>

#define MAX_BG 256
#define MAX_PROCS_PER_JOB 256

typedef struct {
    pid_t pid;
    char command[256];
    bool stopped;
} BackgroundProcess;

typedef struct {
    unsigned long job;
    pid_t pgid;
    pid_t first_pid;
    size_t process_count;
    BackgroundProcess processes[MAX_PROCS_PER_JOB];
    char normal[512];
    char abnormal[512];
    char commandline[1024];
    size_t normal_len;
    size_t abnormal_len;
} BackgroundJob;

static BackgroundJob bg_jobs[MAX_BG];
static size_t bg_count;
static unsigned long next_job = 1;
static volatile sig_atomic_t bg_signal_pending;
static volatile sig_atomic_t resume_timeout;
static pid_t shell_pgid = -1;
static int shell_terminal = STDIN_FILENO;

static void shell_signal_handler(int sig)
{
    (void)sig;
    static const char newline[] = "\n";
    (void)write(STDOUT_FILENO, newline, sizeof(newline) - 1);
}

static void alarm_handler(int sig)
{
    (void)sig;
    resume_timeout = 1;
}

void install_shell_signal_handlers(void)
{
    struct sigaction action;
    memset(&action, 0, sizeof(action));
    action.sa_handler = shell_signal_handler;
    sigemptyset(&action.sa_mask);

    (void)sigaction(SIGINT, &action, NULL);
    (void)sigaction(SIGTSTP, &action, NULL);

    action.sa_handler = SIG_IGN;
    (void)sigaction(SIGTTOU, &action, NULL);
}

void initialize_terminal_control(void)
{
    shell_terminal = STDIN_FILENO;
    shell_pgid = getpid();

    if (setpgid(shell_pgid, shell_pgid) < 0 && errno != EACCES)
        shell_pgid = getpgrp();
    else
        shell_pgid = getpgrp();

    (void)tcsetpgrp(shell_terminal, shell_pgid);
}

void give_terminal_to(pid_t pgid)
{
    if (shell_pgid < 0) return;
    (void)tcsetpgrp(shell_terminal, pgid);
}

void reclaim_terminal(void)
{
    if (shell_pgid < 0) return;
    (void)tcsetpgrp(shell_terminal, shell_pgid);
}

static void remove_process(BackgroundJob *job, size_t index)
{
    for (size_t i = index + 1; i < job->process_count; ++i)
        job->processes[i - 1] = job->processes[i];
    --job->process_count;
}

static void remove_job(size_t index)
{
    for (size_t i = index + 1; i < bg_count; ++i)
        bg_jobs[i - 1] = bg_jobs[i];
    --bg_count;
}

static void bg_sigchld(int sig)
{
    (void)sig;

    for (size_t j = 0; j < bg_count; ++j) {
        BackgroundJob *job = &bg_jobs[j];
        size_t i = 0;

        while (i < job->process_count) {
            BackgroundProcess *process = &job->processes[i];
            int status;
            pid_t result = waitpid(process->pid, &status,
                                   WNOHANG | WUNTRACED | WCONTINUED);

            if (result != process->pid) {
                ++i;
                continue;
            }

            if (WIFSTOPPED(status)) {
                process->stopped = true;
                ++i;
                continue;
            }

            if (WIFCONTINUED(status)) {
                process->stopped = false;
                ++i;
                continue;
            }

            if (WIFEXITED(status) || WIFSIGNALED(status)) {
                if (process->pid == job->first_pid) {
                    const char *message = WIFSIGNALED(status)
                                              ? job->abnormal
                                              : job->normal;
                    size_t length = WIFSIGNALED(status)
                                        ? job->abnormal_len
                                        : job->normal_len;
                    (void)write(STDOUT_FILENO, message, length);
                }
                remove_process(job, i);
                continue;
            }

            ++i;
        }
    }

    size_t j = 0;
    while (j < bg_count) {
        if (bg_jobs[j].process_count == 0)
            remove_job(j);
        else
            ++j;
    }

    bg_signal_pending = 1;
}

void install_sigchld(void)
{
    static bool installed;
    if (installed) return;

    struct sigaction action;
    memset(&action, 0, sizeof(action));
    action.sa_handler = bg_sigchld;
    sigemptyset(&action.sa_mask);
    action.sa_flags = SA_RESTART;

    if (sigaction(SIGCHLD, &action, NULL) == 0)
        installed = true;

    struct sigaction alarm_action;
    memset(&alarm_action, 0, sizeof(alarm_action));
    alarm_action.sa_handler = alarm_handler;
    sigemptyset(&alarm_action.sa_mask);
    (void)sigaction(SIGALRM, &alarm_action, NULL);
}

static void build_job_messages(BackgroundJob *job, const pid_t *pids)
{
    char command_name[256];
    snprintf(command_name, sizeof(command_name), "%s",
             job->processes[0].command);

    int normal_length = snprintf(
        job->normal, sizeof(job->normal),
        "%s with pid %ld exited normally\n",
        command_name, (long)pids[0]);
    int abnormal_length = snprintf(
        job->abnormal, sizeof(job->abnormal),
        "%s with pid %ld exited abnormally\n",
        command_name, (long)pids[0]);

    job->normal_len = normal_length > 0 ? (size_t)normal_length : 0;
    job->abnormal_len = abnormal_length > 0 ? (size_t)abnormal_length : 0;
}

void remember_background(pid_t pgid, const pid_t *pids,
                         const CommandPipeline *pipeline)
{
    if (bg_count >= MAX_BG) return;

    BackgroundJob *job = &bg_jobs[bg_count++];
    memset(job, 0, sizeof(*job));
    job->job = next_job++;
    job->pgid = pgid;
    job->first_pid = pids[0];

    size_t count = pipeline->commands_count;
    if (count > MAX_PROCS_PER_JOB) count = MAX_PROCS_PER_JOB;
    job->process_count = count;

    job->commandline[0] = '\0';
    for (size_t i = 0; i < count; ++i) {
        const ParsedCommand *command = &pipeline->commands_list[i];
        if (i > 0) strncat(job->commandline, " | ",
                            sizeof(job->commandline) - strlen(job->commandline) - 1);
        for (size_t j = 0; j < command->arguments_count; ++j) {
            if (j > 0) strncat(job->commandline, " ",
                               sizeof(job->commandline) - strlen(job->commandline) - 1);
            strncat(job->commandline, command->arguments_list[j],
                    sizeof(job->commandline) - strlen(job->commandline) - 1);
        }

        job->processes[i].pid = pids[i];
        job->processes[i].stopped = false;

        if (pipeline->commands_list[i].arguments_count) {
            snprintf(job->processes[i].command,
                     sizeof(job->processes[i].command), "%s",
                     pipeline->commands_list[i].arguments_list[0]);
        } else {
            snprintf(job->processes[i].command,
                     sizeof(job->processes[i].command), "command");
        }
    }

    build_job_messages(job, pids);
}

int activity_builtin(const ParsedCommand *command)
{
    if (!command || command->arguments_count != 1 ||
        strcmp(command->arguments_list[0], "activities") != 0)
        return 0;

    reap_background_processes();

    for (size_t i = 0; i < bg_count; ++i) {
        const BackgroundJob *job = &bg_jobs[i];
        printf("[%lu] pgid %ld\n", job->job, (long)job->pgid);

        for (size_t j = 0; j < job->process_count; ++j) {
            const BackgroundProcess *process = &job->processes[j];
            printf("  %ld %s %s\n", (long)process->pid,
                   process->command,
                   process->stopped ? "Stopped" : "Running");
        }
    }

    fflush(stdout);
    return 1;
}

void reap_background_processes(void)
{
    bg_signal_pending = 0;
}

bool has_stopped_jobs(void)
{
    for (size_t i = 0; i < bg_count; ++i) {
        for (size_t j = 0; j < bg_jobs[i].process_count; ++j) {
            if (bg_jobs[i].processes[j].stopped) return true;
        }
    }
    return false;
}

void hangup_all_jobs(void)
{
    for (size_t i = 0; i < bg_count; ++i)
        if (bg_jobs[i].pgid > 0) (void)kill(-bg_jobs[i].pgid, SIGHUP);
}

void remember_stopped_foreground(pid_t pgid, const pid_t *pids,
                                  const CommandPipeline *pipeline)
{
    remember_background(pgid, pids, pipeline);

    if (bg_count == 0) return;
    BackgroundJob *job = &bg_jobs[bg_count - 1];
    for (size_t i = 0; i < job->process_count; ++i)
        job->processes[i].stopped = true;
}

unsigned long latest_job_number(void)
{
    return next_job - 1;
}

static BackgroundJob *find_job(unsigned long job_number)
{
    for (size_t i = 0; i < bg_count; ++i)
        if (bg_jobs[i].job == job_number)
            return &bg_jobs[i];
    return NULL;
}

static bool parse_job_number(const char *text, unsigned long *number)
{
    if (!text || text[0] != '%' || text[1] == '\0') return false;

    char *end = NULL;
    errno = 0;
    unsigned long value = strtoul(text + 1, &end, 10);
    if (errno != 0 || end == text + 1 || *end != '\0' || value == 0)
        return false;

    *number = value;
    return true;
}

static bool parse_timeout(const char *text, unsigned int *seconds)
{
    if (!text || text[0] == '\0') return false;

    char *end = NULL;
    errno = 0;
    unsigned long value = strtoul(text, &end, 10);
    if (errno != 0 || end == text || *end != '\0' || value == 0 ||
        value > UINT_MAX)
        return false;

    *seconds = (unsigned int)value;
    return true;
}

static void mark_job_running(BackgroundJob *job)
{
    for (size_t i = 0; i < job->process_count; ++i)
        job->processes[i].stopped = false;
}

static void mark_job_stopped(BackgroundJob *job)
{
    for (size_t i = 0; i < job->process_count; ++i)
        job->processes[i].stopped = true;
}

static void remove_job_by_number(unsigned long job_number)
{
    for (size_t i = 0; i < bg_count; ++i) {
        if (bg_jobs[i].job == job_number) {
            remove_job(i);
            return;
        }
    }
}

static int wait_resumed_job(BackgroundJob *job, unsigned int timeout,
                            bool use_timeout)
{
    pid_t pids[MAX_PROCS_PER_JOB];
    size_t count = job->process_count;
    pid_t pgid = job->pgid;
    unsigned long job_number = job->job;

    if (count > MAX_PROCS_PER_JOB) count = MAX_PROCS_PER_JOB;
    for (size_t i = 0; i < count; ++i)
        pids[i] = job->processes[i].pid;

    sigset_t blocked, previous;
    sigemptyset(&blocked);
    sigaddset(&blocked, SIGCHLD);
    (void)sigprocmask(SIG_BLOCK, &blocked, &previous);

    resume_timeout = 0;
    if (use_timeout) alarm(timeout);

    give_terminal_to(pgid);

    bool stopped = false;
    bool timed_out = false;
    size_t remaining = count;

    while (remaining > 0) {
        int status;
        pid_t result = waitpid(-pgid, &status, WUNTRACED);

        if (result < 0) {
            if (errno == EINTR) {
                if (resume_timeout) {
                    timed_out = true;
                    break;
                }
                continue;
            }
            if (errno == ECHILD) break;
            continue;
        }

        if (WIFSTOPPED(status)) {
            stopped = true;
            break;
        }

        if (WIFEXITED(status) || WIFSIGNALED(status)) {
            for (size_t i = 0; i < count; ++i) {
                if (pids[i] == result) {
                    pids[i] = -1;
                    if (remaining > 0) --remaining;
                    break;
                }
            }
        }

        if (resume_timeout) {
            timed_out = true;
            break;
        }
    }

    if (use_timeout) alarm(0);

    if (timed_out) {
        (void)kill(-pgid, SIGTERM);
        printf("resume: job timed out\n");
        fflush(stdout);

        while (remaining > 0) {
            int status;
            pid_t result = waitpid(-pgid, &status, 0);
            if (result < 0) {
                if (errno == EINTR) continue;
                if (errno == ECHILD) break;
                continue;
            }
            if (WIFEXITED(status) || WIFSIGNALED(status)) {
                for (size_t i = 0; i < count; ++i) {
                    if (pids[i] == result) {
                        pids[i] = -1;
                        --remaining;
                        break;
                    }
                }
            }
        }

        reclaim_terminal();
        remove_job_by_number(job_number);
        (void)sigprocmask(SIG_SETMASK, &previous, NULL);
        return 0;
    }

    reclaim_terminal();

    if (stopped) {
        mark_job_stopped(job);
    } else if (remaining == 0) {
        remove_job_by_number(job_number);
    } else {
        mark_job_running(job);
    }

    (void)sigprocmask(SIG_SETMASK, &previous, NULL);
    return 0;
}

static void print_job_command(const BackgroundJob *job)
{
    printf("%s\n", job->commandline);
    fflush(stdout);
}


static bool parse_nonnegative_integer(const char *text, unsigned long *value)
{
    if (!text || text[0] == '\0') return false;
    if (text[0] == '-') return false;

    for (const char *p = text; *p != '\0'; ++p) {
        if (*p < '0' || *p > '9') return false;
    }

    char *end = NULL;
    errno = 0;
    unsigned long parsed = strtoul(text, &end, 10);
    if (errno == ERANGE || end == text || *end != '\0') return false;

    *value = parsed;
    return true;
}

static BackgroundProcess *find_process(pid_t pid)
{
    for (size_t i = 0; i < bg_count; ++i) {
        for (size_t j = 0; j < bg_jobs[i].process_count; ++j) {
            if (bg_jobs[i].processes[j].pid == pid)
                return &bg_jobs[i].processes[j];
        }
    }
    return NULL;
}

static bool parse_ping_target(const char *text, bool *is_job,
                              unsigned long *number)
{
    if (!text || text[0] == '\0') return false;

    if (text[0] == '%') {
        if (!parse_job_number(text, number)) return false;
        *is_job = true;
        return true;
    }

    if (!parse_nonnegative_integer(text, number)) return false;
    *is_job = false;
    return true;
}

int ping_builtin(const ParsedCommand *command)
{
    if (!command || command->arguments_count < 1 ||
        strcmp(command->arguments_list[0], "ping") != 0)
        return 0;

    if (command->arguments_count != 3) {
        printf("ping: invalid syntax\n");
        return 1;
    }

    unsigned long original_signal;
    if (!parse_nonnegative_integer(command->arguments_list[2],
                                   &original_signal)) {
        printf("ping: invalid syntax\n");
        return 1;
    }

    reap_background_processes();

    bool is_job;
    unsigned long target_number;
    if (!parse_ping_target(command->arguments_list[1], &is_job,
                           &target_number)) {
        printf("ping: no such process found\n");
        return 1;
    }

    int signal_number = (int)(original_signal % 64UL);

    if (is_job) {
        BackgroundJob *job = find_job(target_number);
        if (!job) {
            printf("ping: no such process found\n");
            return 1;
        }

        if (kill(-job->pgid, signal_number) < 0) {
            printf("ping: no such process found\n");
            return 1;
        }
    } else {
        if (target_number == 0 || target_number > (unsigned long)INT_MAX) {
            printf("ping: no such process found\n");
            return 1;
        }

        pid_t pid = (pid_t)target_number;
        if (!find_process(pid)) {
            printf("ping: no such process found\n");
            return 1;
        }

        if (kill(pid, signal_number) < 0) {
            printf("ping: no such process found\n");
            return 1;
        }
    }

    printf("Sent signal %lu to %s\n", original_signal,
           command->arguments_list[1]);
    fflush(stdout);
    return 1;
}

int resume_builtin(const ParsedCommand *command)
{
    if (!command || command->arguments_count < 1 ||
        strcmp(command->arguments_list[0], "resume") != 0)
        return 0;

    if (command->arguments_count < 3 || command->arguments_count > 5) {
        printf("resume: invalid syntax\n");
        return 1;
    }

    unsigned long job_number;
    if (!parse_job_number(command->arguments_list[1], &job_number)) {
        printf("resume: invalid syntax\n");
        return 1;
    }

    const char *mode = command->arguments_list[2];
    bool foreground = strcmp(mode, "fg") == 0;
    bool background = strcmp(mode, "bg") == 0;
    unsigned int timeout = 0;
    bool use_timeout = false;

    if (!foreground && !background) {
        printf("resume: invalid syntax\n");
        return 1;
    }

    if (background) {
        if (command->arguments_count != 3) {
            printf("resume: invalid syntax\n");
            return 1;
        }
    } else if (command->arguments_count == 5) {
        if (strcmp(command->arguments_list[3], "--timeout") != 0 ||
            !parse_timeout(command->arguments_list[4], &timeout)) {
            printf("resume: invalid syntax\n");
            return 1;
        }
        use_timeout = true;
    } else if (command->arguments_count != 3) {
        printf("resume: invalid syntax\n");
        return 1;
    }

    reap_background_processes();
    BackgroundJob *job = find_job(job_number);
    if (!job) {
        printf("resume: no such job\n");
        return 1;
    }

    if (kill(-job->pgid, SIGCONT) < 0) {
        if (errno == ESRCH) {
            remove_job_by_number(job_number);
            printf("resume: no such job\n");
        } else {
            printf("resume: no such job\n");
        }
        return 1;
    }

    mark_job_running(job);

    if (background) {
        printf("[%lu] + Running ", job->job);
        print_job_command(job);
        return 1;
    }

    print_job_command(job);
    (void)wait_resumed_job(job, timeout, use_timeout);
    return 1;
}
