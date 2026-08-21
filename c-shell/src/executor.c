#include "executor.h"
#include "builtin_hop.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

static void execute_single_command(const ParsedCommand *cmd) {
    if (cmd == NULL || cmd->arguments_count == 0) {
        return;
    }

    const char *command_name = cmd->arguments_list[0];

    if (strcmp(command_name, "hop") == 0) {
        execute_builtin_hop(cmd);
        return;
    }

    pid_t process_id = fork();

    if (process_id < 0) {
        perror("fork");
        return;
    }

    if (process_id == 0) {
        execvp(cmd->arguments_list[0], cmd->arguments_list);
        fprintf(stderr, "ERROR: '%s' is not a valid command\n", cmd->arguments_list[0]);
        exit(EXIT_FAILURE);
    } else {
        int child_status;
        waitpid(process_id, &child_status, 0);
    }
}

void execute_command_group(const ParsedCommandGroup *command_group) {
    if (command_group == NULL) {
        return;
    }

    for (size_t i = 0; i < command_group->pipelines_count; i++) {
        const CommandPipeline *pipeline = &command_group->pipelines_list[i];

        for (size_t j = 0; j < pipeline->commands_count; j++) {
            execute_single_command(&pipeline->commands_list[j]);
        }
    }
}
