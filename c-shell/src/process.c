#include "process.h"
#include "executor_utils.h"
#include "redirection.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include <signal.h>
#include <string.h>

void run_stage(const ParsedCommand *command, size_t index, size_t count,
               const int *pipes, bool background,
               int (*builtin_runner)(const ParsedCommand *))
{
    (void)background;

    struct sigaction default_action;
    memset(&default_action, 0, sizeof(default_action));
    default_action.sa_handler = SIG_DFL;
    sigemptyset(&default_action.sa_mask);
    sigaction(SIGINT, &default_action, NULL);
    sigaction(SIGTSTP, &default_action, NULL);
    sigaction(SIGTTOU, &default_action, NULL);
    sigaction(SIGTTIN, &default_action, NULL);

    if (index) {
        if (dup2(pipes[(index - 1) * 2], STDIN_FILENO) < 0) _exit(1);
    }

    if (index + 1 < count &&
        !command->redirection_config.output_files_count &&
        dup2(pipes[index * 2 + 1], STDOUT_FILENO) < 0)
        _exit(1);

    for (size_t i = 0; i < 2 * (count - 1); ++i)
        close(pipes[i]);

    if (input_redirect(command) < 0) _exit(1);

    if (command->redirection_config.output_files_count) {
        int output_pipe[2];
        if (pipe(output_pipe) < 0) _exit(1);

        pid_t tee_pid = fork();
        if (tee_pid < 0) _exit(1);

        if (tee_pid == 0) {
            close(output_pipe[1]);

            int *fds = NULL;
            if (open_outputs(command, &fds) < 0) _exit(1);

            char buffer[8192];
            for (;;) {
                ssize_t n = read(output_pipe[0], buffer, sizeof(buffer));
                if (!n) break;
                if (n < 0) {
                    if (errno == EINTR) continue;
                    break;
                }

                for (size_t i = 0;
                     i < command->redirection_config.output_files_count; ++i) {
                    size_t done = 0;
                    while (done < (size_t)n) {
                        ssize_t written = write(fds[i], buffer + done,
                                                (size_t)n - done);
                        if (written < 0) {
                            if (errno == EINTR) continue;
                            _exit(1);
                        }
                        done += (size_t)written;
                    }
                }
            }

            close(output_pipe[0]);
            for (size_t i = 0;
                 i < command->redirection_config.output_files_count; ++i)
                close(fds[i]);
            free(fds);
            _exit(0);
        }

        close(output_pipe[0]);
        if (dup2(output_pipe[1], STDOUT_FILENO) < 0) _exit(1);
        close(output_pipe[1]);
    }

    if (is_builtin_command(command->arguments_list[0]))
        _exit(builtin_runner(command));

    char *binary = resolve_binary(command->arguments_list[0]);
    if (!binary) {
        fprintf(stderr, "cshell: command not found (%s)\n",
                command->arguments_list[0]);
        _exit(127);
    }

    execv(binary, command->arguments_list);
    free(binary);
    fprintf(stderr, "cshell: command not found (%s)\n",
            command->arguments_list[0]);
    _exit(127);
}
