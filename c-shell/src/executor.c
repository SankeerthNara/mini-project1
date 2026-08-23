#include "executor.h"
#include "shell.h"
#include "builtin_hop.h"
#include "builtin_reveal.h"
#include "builtin_log.h"
#include "builtin_locate.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <time.h>

void reap_background_processes(void) {
    int status;
    pid_t pid;

    while ((pid = waitpid(-1, &status, WNOHANG)) > 0) {
        if (WIFEXITED(status)) {
            fprintf(stderr, "\nBackground process with PID %d exited normally with exit code %d\n", pid, WEXITSTATUS(status));
        } else if (WIFSIGNALED(status)) {
            fprintf(stderr, "\nBackground process with PID %d terminated by signal %d\n", pid, WTERMSIG(status));
        }
    }
}

static void execute_single_command(const ParsedCommand *cmd, bool is_background) {
    if (cmd == NULL || cmd->arguments_count == 0) {
        return;
    }

    const char *command_name = cmd->arguments_list[0];

    if (strcmp(command_name, "hop") == 0) {
        execute_builtin_hop(cmd);
        return;
    }

    if (strcmp(command_name, "reveal") == 0) {
        execute_builtin_reveal(cmd);
        return;
    }

    if (strcmp(command_name, "log") == 0) {
        execute_builtin_log(cmd);
        return;
    }

    if (strcmp(command_name, "locate") == 0) {
        execute_builtin_locate(cmd);
        return;
    }

    time_t start_time = time(NULL);

    pid_t process_id = fork();

    if (process_id < 0) {
        perror("fork");
        return;
    }

    if (process_id == 0) {
        if (is_background) {
            setpgid(0, 0);
        }

        execvp(cmd->arguments_list[0], cmd->arguments_list);
        fprintf(stderr, "ERROR: '%s' is not a valid command\n", cmd->arguments_list[0]);
        exit(EXIT_FAILURE);
    } else {
        if (is_background) {
            printf("[%d]\n", process_id);
            fflush(stdout);
        } else {
            int child_status;
            waitpid(process_id, &child_status, 0);

            time_t end_time = time(NULL);
            int duration = (int)(end_time - start_time);
            if (duration >= 2) {
                strncpy(shell_ctx.last_foreground_command, command_name, sizeof(shell_ctx.last_foreground_command) - 1);
                shell_ctx.last_foreground_command[sizeof(shell_ctx.last_foreground_command) - 1] = '\0';
                shell_ctx.last_foreground_duration_seconds = duration;
            }
        }
    }
}

void execute_command_group(const ParsedCommandGroup *command_group) {
    if (command_group == NULL) {
        return;
    }

    for (size_t i = 0; i < command_group->pipelines_count; i++) {
        const CommandPipeline *pipeline = &command_group->pipelines_list[i];
        bool is_background = pipeline->is_background_pipeline;

        for (size_t j = 0; j < pipeline->commands_count; j++) {
            execute_single_command(&pipeline->commands_list[j], is_background);
        }
    }
}
