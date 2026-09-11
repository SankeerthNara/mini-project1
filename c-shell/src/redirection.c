#include "redirection.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

int input_redirect(const ParsedCommand *command)
{
    const RedirectionConfig *redirection = &command->redirection_config;
    if (!redirection->input_files_count) return 0;

    FILE *tmp = tmpfile();
    if (!tmp) return -1;

    char buffer[8192];
    for (size_t i = 0; i < redirection->input_files_count; ++i) {
        int fd = open(redirection->input_files[i], O_RDONLY);
        if (fd < 0) {
            fprintf(stderr, "cshell: no such file or directory\n");
            fclose(tmp);
            return -1;
        }

        ssize_t n;
        while ((n = read(fd, buffer, sizeof(buffer))) > 0) {
            size_t done = 0;
            while (done < (size_t)n) {
                size_t written = fwrite(buffer + done, 1,
                                        (size_t)n - done, tmp);
                if (!written) {
                    close(fd);
                    fclose(tmp);
                    return -1;
                }
                done += written;
            }
        }

        close(fd);
        if (n < 0) {
            fclose(tmp);
            return -1;
        }
    }

    fflush(tmp);
    if (lseek(fileno(tmp), 0, SEEK_SET) < 0 ||
        dup2(fileno(tmp), STDIN_FILENO) < 0) {
        fclose(tmp);
        return -1;
    }

    fclose(tmp);
    return 0;
}

int open_outputs(const ParsedCommand *command, int **fds)
{
    const RedirectionConfig *redirection = &command->redirection_config;
    int *output_fds = calloc(redirection->output_files_count,
                             sizeof(*output_fds));
    if (redirection->output_files_count && !output_fds) return -1;

    for (size_t i = 0; i < redirection->output_files_count; ++i) {
        int flags = O_WRONLY | O_CREAT |
                    (redirection->output_files[i].is_append
                         ? O_APPEND
                         : O_TRUNC);
        output_fds[i] = open(redirection->output_files[i].filename,
                             flags, 0644);
        if (output_fds[i] < 0) {
            fprintf(stderr, "cshell: unable to create file for writing\n");
            for (size_t j = 0; j < i; ++j) close(output_fds[j]);
            free(output_fds);
            return -1;
        }
    }

    *fds = output_fds;
    return 0;
}

int copy_to_outputs(int input_fd, const ParsedCommand *command, int *fds)
{
    const RedirectionConfig *redirection = &command->redirection_config;
    if (lseek(input_fd, 0, SEEK_SET) < 0) return -1;

    char buffer[8192];
    for (;;) {
        ssize_t n = read(input_fd, buffer, sizeof(buffer));
        if (!n) return 0;
        if (n < 0) {
            if (errno == EINTR) continue;
            return -1;
        }

        for (size_t i = 0; i < redirection->output_files_count; ++i) {
            size_t done = 0;
            while (done < (size_t)n) {
                ssize_t written = write(fds[i], buffer + done,
                                        (size_t)n - done);
                if (written < 0) {
                    if (errno == EINTR) continue;
                    return -1;
                }
                done += (size_t)written;
            }
        }
    }
}

int builtin_redirected(const ParsedCommand *command,
                       int (*builtin_runner)(const ParsedCommand *))
{
    int saved_stdin = dup(STDIN_FILENO);
    int saved_stdout = dup(STDOUT_FILENO);
    if (saved_stdin < 0 || saved_stdout < 0) {
        if (saved_stdin >= 0) close(saved_stdin);
        if (saved_stdout >= 0) close(saved_stdout);
        return 1;
    }

    if (input_redirect(command) < 0) goto fail;

    FILE *tmp = NULL;
    const RedirectionConfig *redirection = &command->redirection_config;

    if (redirection->output_files_count) {
        tmp = tmpfile();
        if (!tmp || dup2(fileno(tmp), STDOUT_FILENO) < 0) {
            if (tmp) fclose(tmp);
            goto fail;
        }
    }

    int status = builtin_runner(command);
    fflush(stdout);

    if (tmp) {
        int *fds = NULL;
        if (open_outputs(command, &fds) < 0) {
            fclose(tmp);
            goto fail;
        }

        if (copy_to_outputs(fileno(tmp), command, fds) < 0) status = 1;
        for (size_t i = 0; i < redirection->output_files_count; ++i)
            close(fds[i]);
        free(fds);
        fclose(tmp);
    }

    dup2(saved_stdin, STDIN_FILENO);
    dup2(saved_stdout, STDOUT_FILENO);
    close(saved_stdin);
    close(saved_stdout);
    return status;

fail:
    dup2(saved_stdin, STDIN_FILENO);
    dup2(saved_stdout, STDOUT_FILENO);
    close(saved_stdin);
    close(saved_stdout);
    return 1;
}
