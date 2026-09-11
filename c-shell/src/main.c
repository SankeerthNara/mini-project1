#include "shell.h"
#include "prompt.h"
#include "lexer.h"
#include "parser.h"
#include "executor.h"
#include "builtin_log.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

ShellContext shell_ctx;

static void init_shell(void) {
    if (getcwd(shell_ctx.startup_home_directory, sizeof(shell_ctx.startup_home_directory)) == NULL) {
        perror("getcwd");
        exit(EXIT_FAILURE);
    }
    shell_ctx.has_previous_working_directory = false;
    shell_ctx.previous_working_directory[0] = '\0';
    shell_ctx.last_foreground_command[0] = '\0';
    shell_ctx.last_foreground_duration_seconds = 0;
}

int main(void) {
    init_shell();
    install_shell_signal_handlers();
    initialize_terminal_control();

    char *line = NULL;
    size_t line_cap = 0;
    bool stopped_eof_seen = false;

    while (true) {
        reap_background_processes();
        display_shell_prompt();

        errno = 0;
        ssize_t read_bytes = getline(&line, &line_cap, stdin);
        if (read_bytes == -1) {
            if (errno == EINTR) continue;

            if (has_stopped_jobs() && !stopped_eof_seen) {
                printf("cshell: there are stopped jobs\n");
                fflush(stdout);
                stopped_eof_seen = true;
                clearerr(stdin);
                continue;
            }

            hangup_all_jobs();
            printf("\n");
            break;
        }

        stopped_eof_seen = false;

        if (read_bytes > 0 && line[read_bytes - 1] == '\n') {
            line[read_bytes - 1] = '\0';
        }

        if (strlen(line) == 0) {
            continue;
        }

        ShellTokenStream tokens = tokenize_input_line(line);
        ParsedCommandGroup *command_group = parse_command_grammar(&tokens);

        if (command_group != NULL) {
            log_command_to_history(line);
            execute_command_group(command_group);
            free_parsed_command_group(command_group);
        }

        free_token_stream(&tokens);
    }

    free(line);
    return 0;
}
