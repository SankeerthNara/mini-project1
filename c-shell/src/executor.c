#include "executor.h"
#include "shell.h"
#include "builtin_hop.h"
#include "builtin_reveal.h"
#include "builtin_peek.h"
#include "builtin_locate.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/stat.h>
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

static int is_executable_file(const char *path) {
    struct stat st;
    if (stat(path, &st) == 0) {
        if (S_ISREG(st.st_mode) && (access(path, X_OK) == 0)) {
            return 1;
        }
    }
    return 0;
}

static char *resolve_executable_path(const char *command_name) {
    if (command_name == NULL || strlen(command_name) == 0) {
        return NULL;
    }

    if (command_name[0] == '%') {
        const char *search_name = command_name + 1;
        char *path_env = getenv("PATH");
        if (path_env != NULL) {
            char *path_copy = strdup(path_env);
            if (path_copy != NULL) {
                char *token = strtok(path_copy, ":");
                while (token != NULL) {
                    char candidate[PATH_MAX * 2];
                    snprintf(candidate, sizeof(candidate), "%s/%s", token, search_name);
                    if (is_executable_file(candidate)) {
                        char *res = strdup(candidate);
                        free(path_copy);
                        return res;
                    }
                    token = strtok(NULL, ":");
                }
                free(path_copy);
            }
        }
        return NULL;
    }

    if (strchr(command_name, '/') != NULL) {
        if (is_executable_file(command_name)) {
            return strdup(command_name);
        }
        return NULL;
    }

    char cwd[PATH_MAX];
    if (getcwd(cwd, sizeof(cwd)) != NULL) {
        char local_path[PATH_MAX * 2];
        snprintf(local_path, sizeof(local_path), "%s/%s", cwd, command_name);
        if (is_executable_file(local_path)) {
            return strdup(local_path);
        }
    }

    char *path_env = getenv("PATH");
    if (path_env != NULL) {
        char *path_copy = strdup(path_env);
        if (path_copy != NULL) {
            char *token = strtok(path_copy, ":");
            while (token != NULL) {
                char candidate[PATH_MAX * 2];
                snprintf(candidate, sizeof(candidate), "%s/%s", token, command_name);
                if (is_executable_file(candidate)) {
                    char *res = strdup(candidate);
                    free(path_copy);
                    return res;
                }
                token = strtok(NULL, ":");
            }
            free(path_copy);
        }
    }

    return NULL;
}

static bool setup_multi_input_redirection(const RedirectionConfig *redir) {
    if (redir->input_files_count == 0) {
        return true;
    }

    for (size_t i = 0; i < redir->input_files_count; i++) {
        int fd = open(redir->input_files[i], O_RDONLY);
        if (fd < 0) {
            fprintf(stderr, "cshell: no such file or directory\n");
            return false;
        }
        close(fd);
    }

    int in_pipe[2];
    if (pipe(in_pipe) < 0) {
        perror("pipe");
        return false;
    }

    for (size_t i = 0; i < redir->input_files_count; i++) {
        int fd = open(redir->input_files[i], O_RDONLY);
        if (fd >= 0) {
            char buffer[4096];
            ssize_t bytes_read;
            while ((bytes_read = read(fd, buffer, sizeof(buffer))) > 0) {
                ssize_t total_written = 0;
                while (total_written < bytes_read) {
                    ssize_t written = write(in_pipe[1], buffer + total_written, bytes_read - total_written);
                    if (written <= 0) break;
                    total_written += written;
                }
            }
            close(fd);
        }
    }
    close(in_pipe[1]);

    if (dup2(in_pipe[0], STDIN_FILENO) < 0) {
        perror("dup2");
        close(in_pipe[0]);
        return false;
    }
    close(in_pipe[0]);

    return true;
}

static bool setup_multi_output_redirection(const RedirectionConfig *redir, int *tee_child_pid) {
    if (redir->output_files_count == 0) {
        *tee_child_pid = -1;
        return true;
    }

    for (size_t i = 0; i < redir->output_files_count; i++) {
        int flags = O_WRONLY | O_CREAT | (redir->output_files[i].is_append ? O_APPEND : O_TRUNC);
        int fd = open(redir->output_files[i].filename, flags, 0644);
        if (fd < 0) {
            fprintf(stderr, "cshell: unable to create file for writing\n");
            return false;
        }
        close(fd);
    }

    int out_pipe[2];
    if (pipe(out_pipe) < 0) {
        perror("pipe");
        return false;
    }

    pid_t tee_pid = fork();
    if (tee_pid < 0) {
        perror("fork");
        close(out_pipe[0]);
        close(out_pipe[1]);
        return false;
    }

    if (tee_pid == 0) {
        close(out_pipe[1]);

        int *target_fds = malloc(redir->output_files_count * sizeof(int));
        for (size_t i = 0; i < redir->output_files_count; i++) {
            int flags = O_WRONLY | O_CREAT | (redir->output_files[i].is_append ? O_APPEND : O_TRUNC);
            target_fds[i] = open(redir->output_files[i].filename, flags, 0644);
        }

        char buffer[4096];
        ssize_t bytes_read;
        while ((bytes_read = read(out_pipe[0], buffer, sizeof(buffer))) > 0) {
            for (size_t i = 0; i < redir->output_files_count; i++) {
                if (target_fds[i] >= 0) {
                    ssize_t total_written = 0;
                    while (total_written < bytes_read) {
                        ssize_t written = write(target_fds[i], buffer + total_written, bytes_read - total_written);
                        if (written <= 0) break;
                        total_written += written;
                    }
                }
            }
        }

        for (size_t i = 0; i < redir->output_files_count; i++) {
            if (target_fds[i] >= 0) close(target_fds[i]);
        }
        free(target_fds);
        close(out_pipe[0]);
        exit(0);
    } else {
        close(out_pipe[0]);
        if (dup2(out_pipe[1], STDOUT_FILENO) < 0) {
            perror("dup2");
            close(out_pipe[1]);
            return false;
        }
        close(out_pipe[1]);
        *tee_child_pid = tee_pid;
        return true;
    }
}

static int run_single_builtin_if_matched(const ParsedCommand *cmd) {
    if (cmd == NULL || cmd->arguments_count == 0) return 0;
    const char *name = cmd->arguments_list[0];

    if (strcmp(name, "hop") == 0) return execute_builtin_hop(cmd);
    if (strcmp(name, "reveal") == 0) return execute_builtin_reveal(cmd);
    if (strcmp(name, "peek") == 0) return execute_builtin_peek(cmd);
    if (strcmp(name, "locate") == 0) return execute_builtin_locate(cmd);

    return -2;
}

static void execute_pipeline(const CommandPipeline *pipeline) {
    size_t num_cmds = pipeline->commands_count;
    if (num_cmds == 0) return;

    if (num_cmds == 1) {
        const ParsedCommand *cmd = &pipeline->commands_list[0];

        if (cmd->redirection_config.input_files_count == 0 && 
            cmd->redirection_config.output_files_count == 0) {
            int builtin_res = run_single_builtin_if_matched(cmd);
            if (builtin_res != -2) return;
        }

        char *resolved_bin = resolve_executable_path(cmd->arguments_list[0]);
        if (resolved_bin == NULL && run_single_builtin_if_matched(cmd) == -2) {
            const char *display_name = (cmd->arguments_list[0][0] == '%') ? cmd->arguments_list[0] + 1 : cmd->arguments_list[0];
            fprintf(stderr, "cshell: command not found (%s)\n", display_name);
            return;
        }

        time_t start_time = time(NULL);
        pid_t pid = fork();

        if (pid == 0) {
            if (pipeline->is_background_pipeline) setpgid(0, 0);

            if (!setup_multi_input_redirection(&cmd->redirection_config)) exit(EXIT_FAILURE);

            int tee_pid = -1;
            if (!setup_multi_output_redirection(&cmd->redirection_config, &tee_pid)) exit(EXIT_FAILURE);

            int b_res = run_single_builtin_if_matched(cmd);
            if (b_res != -2) {
                fflush(stdout);
                if (tee_pid > 0) waitpid(tee_pid, NULL, 0);
                exit(b_res == 0 ? EXIT_SUCCESS : EXIT_FAILURE);
            }

            execv(resolved_bin, cmd->arguments_list);
            exit(EXIT_FAILURE);
        } else if (pid > 0) {
            if (resolved_bin) free(resolved_bin);

            if (pipeline->is_background_pipeline) {
                printf("[%d]\n", pid);
                fflush(stdout);
            } else {
                int status;
                waitpid(pid, &status, 0);
                time_t end_time = time(NULL);
                int duration = (int)(end_time - start_time);
                if (duration >= 2) {
                    strncpy(shell_ctx.last_foreground_command, cmd->arguments_list[0], sizeof(shell_ctx.last_foreground_command) - 1);
                    shell_ctx.last_foreground_command[sizeof(shell_ctx.last_foreground_command) - 1] = '\0';
                    shell_ctx.last_foreground_duration_seconds = duration;
                }
            }
        }
        return;
    }

    int (*pipes)[2] = malloc((num_cmds - 1) * sizeof(int[2]));
    for (size_t i = 0; i < num_cmds - 1; i++) {
        if (pipe(pipes[i]) < 0) {
            perror("pipe");
            free(pipes);
            return;
        }
    }

    pid_t *pids = malloc(num_cmds * sizeof(pid_t));

    for (size_t i = 0; i < num_cmds; i++) {
        const ParsedCommand *cmd = &pipeline->commands_list[i];
        char *resolved_bin = resolve_executable_path(cmd->arguments_list[0]);
        bool is_builtin = (run_single_builtin_if_matched(cmd) != -2);

        pids[i] = fork();

        if (pids[i] == 0) {
            if (pipeline->is_background_pipeline) setpgid(0, 0);

            if (i > 0) {
                dup2(pipes[i - 1][0], STDIN_FILENO);
            }
            if (i < num_cmds - 1) {
                dup2(pipes[i][1], STDOUT_FILENO);
            }

            for (size_t p = 0; p < num_cmds - 1; p++) {
                close(pipes[p][0]);
                close(pipes[p][1]);
            }

            if (!setup_multi_input_redirection(&cmd->redirection_config)) exit(EXIT_FAILURE);

            int tee_pid = -1;
            if (!setup_multi_output_redirection(&cmd->redirection_config, &tee_pid)) exit(EXIT_FAILURE);

            if (is_builtin) {
                int b_res = run_single_builtin_if_matched(cmd);
                fflush(stdout);
                if (tee_pid > 0) waitpid(tee_pid, NULL, 0);
                exit(b_res == 0 ? EXIT_SUCCESS : EXIT_FAILURE);
            }

            if (resolved_bin == NULL) {
                const char *disp = (cmd->arguments_list[0][0] == '%') ? cmd->arguments_list[0] + 1 : cmd->arguments_list[0];
                fprintf(stderr, "cshell: command not found (%s)\n", disp);
                exit(127);
            }

            execv(resolved_bin, cmd->arguments_list);
            exit(EXIT_FAILURE);
        }

        if (resolved_bin) free(resolved_bin);
    }

    for (size_t i = 0; i < num_cmds - 1; i++) {
        close(pipes[i][0]);
        close(pipes[i][1]);
    }
    free(pipes);

    if (pipeline->is_background_pipeline) {
        printf("[%d]\n", pids[num_cmds - 1]);
        fflush(stdout);
    } else {
        for (size_t i = 0; i < num_cmds; i++) {
            int status;
            waitpid(pids[i], &status, 0);
        }
    }

    free(pids);
}

void execute_command_group(const ParsedCommandGroup *command_group) {
    if (command_group == NULL || command_group->pipelines_count == 0) {
        return;
    }

    // Only execute first command group per Part C constraint
    execute_pipeline(&command_group->pipelines_list[0]);
}
