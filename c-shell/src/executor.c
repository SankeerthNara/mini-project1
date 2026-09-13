#include "executor.h"
#include "executor_utils.h"
#include "redirection.h"
#include "process.h"
#include "jobcontrol.h"
#include "spy.h"
#include "snoop.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>
#include <signal.h>

static const char *pipeline_command_name(const CommandPipeline *pipeline)
{
    static char name[1024];
    name[0] = '\0';

    if (!pipeline) return name;

    for (size_t i = 0; i < pipeline->commands_count; ++i) {
        const ParsedCommand *command = &pipeline->commands_list[i];
        for (size_t j = 0; j < command->arguments_count; ++j) {
            if (i > 0 && j == 0) strncat(name, " |", sizeof(name) - strlen(name) - 1);
            if (j > 0 || (i > 0)) strncat(name, " ", sizeof(name) - strlen(name) - 1);
            strncat(name, command->arguments_list[j], sizeof(name) - strlen(name) - 1);
        }
    }

    return name;
}

static int run_pipeline(const CommandPipeline *pipeline,
                        bool *failed_to_start)
{
    if (failed_to_start) *failed_to_start = false;
    if (!pipeline || !pipeline->commands_count) return 0;

    if (pipeline->commands_count == 1) {
        const ParsedCommand *command = &pipeline->commands_list[0];
        if (!command->arguments_count) return 0;

                if (activity_builtin(command)) return 0;
        if (resume_builtin(command)) return 0;
        if (spy_builtin(command)) return 0;

        if (strcmp(command->arguments_list[0], "snoop") == 0) {
            snoop_builtin(command);
            return 0;
        }
        if (is_builtin_command(command->arguments_list[0])) {
            if (command->redirection_config.input_files_count ||
                command->redirection_config.output_files_count)
                return builtin_redirected(command, run_builtin_command);
            return run_builtin_command(command);
        }

        char *path = resolve_binary(command->arguments_list[0]);
        if (!path) {
            fprintf(stderr, "cshell: command not found (%s)\n",
                    command->arguments_list[0]);
            if (failed_to_start) *failed_to_start = true;
            return 127;
        }
        free(path);
    }

    size_t count = pipeline->commands_count;
    size_t pipe_count = count - 1;
    int *pipes = calloc(pipe_count * 2, sizeof(*pipes));
    pid_t *pids = calloc(count, sizeof(*pids));
    if (!pids || (pipe_count && !pipes)) {
        free(pipes);
        free(pids);
        return 1;
    }

    for (size_t i = 0; i < pipe_count; ++i) {
        if (pipe(pipes + i * 2) < 0) {
            for (size_t j = 0; j < i * 2; ++j) close(pipes[j]);
            free(pipes);
            free(pids);
            return 1;
        }
    }

    pid_t pgid = 0;
    size_t made = 0;
    for (; made < count; ++made) {
        pids[made] = fork();
        if (pids[made] < 0) {
            for (size_t i = 0; i < pipe_count * 2; ++i)
                close(pipes[i]);
            for (size_t i = 0; i < made; ++i)
                waitpid(pids[i], NULL, 0);
            free(pipes);
            free(pids);
            return 1;
        }

        if (pids[made] == 0) {
            if (made == 0) pgid = getpid();
            if (setpgid(0, pgid) < 0) _exit(1);
            run_stage(&pipeline->commands_list[made], made, count,
                      pipes, false, run_builtin_command);
        }

        if (made == 0) pgid = pids[made];
        if (setpgid(pids[made], pgid) < 0 && errno != EACCES) {
            for (size_t i = 0; i < pipe_count * 2; ++i)
                close(pipes[i]);
            for (size_t i = 0; i < made + 1; ++i)
                kill(pids[i], SIGTERM);
            for (size_t i = 0; i < made + 1; ++i)
                waitpid(pids[i], NULL, 0);
            free(pipes);
            free(pids);
            return 1;
        }
    }

    for (size_t i = 0; i < pipe_count * 2; ++i)
        close(pipes[i]);

    give_terminal_to(pgid);

    int result = 0;
    bool stopped = false;
    int last_status = 0;

    for (size_t i = 0; i < count; ++i) {
        int status;
        if (waitpid(pids[i], &status, WUNTRACED) < 0) continue;

        if (WIFSTOPPED(status)) {
            stopped = true;
            break;
        }

        if (i == count - 1) last_status = status;
    }

    reclaim_terminal();

    if (stopped) {
        remember_stopped_foreground(pgid, pids, pipeline);
        printf("[%lu] + Stopped %s\n", latest_job_number(),
               pipeline_command_name(pipeline));
        fflush(stdout);
    } else {
        if (WIFEXITED(last_status)) result = WEXITSTATUS(last_status);
        else if (WIFSIGNALED(last_status))
            result = 128 + WTERMSIG(last_status);

        for (size_t i = 0; i < count; ++i) {
            int status;
            while (waitpid(pids[i], &status, 0) < 0 && errno == EINTR) {}
        }
    }

    free(pipes);
    free(pids);
    return result;
}

static int launch_background(const CommandPipeline *pipeline)
{
    if (!pipeline || !pipeline->commands_count) return 0;

    size_t count = pipeline->commands_count;
    size_t pipe_count = count - 1;
    int *pipes = calloc(pipe_count * 2, sizeof(*pipes));
    pid_t *pids = calloc(count, sizeof(*pids));
    int gate[2] = {-1, -1};

    if (!pids || (pipe_count && !pipes) || pipe(gate) < 0) {
        free(pipes);
        free(pids);
        if (gate[0] >= 0) close(gate[0]);
        if (gate[1] >= 0) close(gate[1]);
        return -1;
    }

    for (size_t i = 0; i < pipe_count; ++i) {
        if (pipe(pipes + i * 2) < 0) {
            for (size_t j = 0; j < i * 2; ++j) close(pipes[j]);
            free(pipes);
            free(pids);
            close(gate[0]);
            close(gate[1]);
            return -1;
        }
    }

    pid_t pgid = 0;
    size_t made = 0;
    for (; made < count; ++made) {
        pids[made] = fork();
        if (pids[made] < 0) {
            for (size_t i = 0; i < pipe_count * 2; ++i)
                close(pipes[i]);
            for (size_t i = 0; i < made; ++i)
                kill(pids[i], SIGTERM);
            close(gate[0]);
            close(gate[1]);
            free(pipes);
            free(pids);
            return -1;
        }

        if (pids[made] == 0) {
            if (made == 0) pgid = getpid();
            if (setpgid(0, pgid) < 0) _exit(1);

            close(gate[1]);
            char start_byte;
            if (read(gate[0], &start_byte, 1) != 1) _exit(1);
            close(gate[0]);

            run_stage(&pipeline->commands_list[made], made, count,
                      pipes, true, run_builtin_command);
        }

        if (made == 0) pgid = pids[made];
        if (setpgid(pids[made], pgid) < 0 && errno != EACCES) {
            for (size_t i = 0; i < pipe_count * 2; ++i)
                close(pipes[i]);
            for (size_t i = 0; i < made + 1; ++i)
                kill(pids[i], SIGTERM);
            close(gate[0]);
            close(gate[1]);
            for (size_t i = 0; i < made + 1; ++i)
                waitpid(pids[i], NULL, 0);
            free(pipes);
            free(pids);
            return -1;
        }
    }

    for (size_t i = 0; i < pipe_count * 2; ++i)
        close(pipes[i]);
    close(gate[0]);

    remember_background(pgid, pids, pipeline);

    unsigned long job = latest_job_number();
    printf("[%lu] %ld\n", job, (long)pids[0]);
    fflush(stdout);

    char release[256];
    memset(release, 1, count);
    (void)write(gate[1], release, count);
    close(gate[1]);

    free(pipes);
    free(pids);
    return 0;
}

void execute_command_group(const ParsedCommandGroup *group)
{
    if (!group) return;
    install_sigchld();

    for (size_t i = 0; i < group->pipelines_count; ++i) {
        const CommandPipeline *pipeline = &group->pipelines_list[i];

        if (pipeline->is_background_pipeline) {
            if (launch_background(pipeline) < 0)
                fprintf(stderr,
                        "cshell: unable to launch background command\n");
            continue;
        }

        bool failed_to_start = false;
        (void)run_pipeline(pipeline, &failed_to_start);
        if (failed_to_start) break;
    }
}
