#include "builtin_hop.h"
#include "shell.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int hop_to_single_path(const char *target_arg) {
    char target_path[PATH_MAX];
    char current_working_dir[PATH_MAX];

    if (getcwd(current_working_dir, sizeof(current_working_dir)) == NULL) {
        perror("hop: getcwd");
        return -1;
    }

    if (target_arg == NULL || strcmp(target_arg, "~") == 0) {
        strncpy(target_path, shell_ctx.startup_home_directory, sizeof(target_path));
    } else if (strcmp(target_arg, "-") == 0) {
        if (!shell_ctx.has_previous_working_directory) {
            fprintf(stderr, "hop: OLDPWD not set\n");
            return -1;
        }
        strncpy(target_path, shell_ctx.previous_working_directory, sizeof(target_path));
    } else if (target_arg[0] == '~' && (target_arg[1] == '/' || target_arg[1] == '\0')) {
        snprintf(target_path, sizeof(target_path), "%s%s",
                 shell_ctx.startup_home_directory, target_arg + 1);
    } else {
        strncpy(target_path, target_arg, sizeof(target_path));
    }

    if (chdir(target_path) != 0) {
        perror("hop");
        return -1;
    }

    strncpy(shell_ctx.previous_working_directory, current_working_dir, sizeof(shell_ctx.previous_working_directory));
    shell_ctx.has_previous_working_directory = true;

    char resolved_dir[PATH_MAX];
    if (getcwd(resolved_dir, sizeof(resolved_dir)) != NULL) {
        printf("%s\n", resolved_dir);
    }

    return 0;
}

int execute_builtin_hop(const ParsedCommand *command) {
    if (command->arguments_count <= 1) {
        return hop_to_single_path("~");
    }

    for (size_t i = 1; i < command->arguments_count; i++) {
        if (hop_to_single_path(command->arguments_list[i]) != 0) {
            return -1;
        }
    }

    return 0;
}
