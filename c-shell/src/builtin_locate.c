#include "builtin_locate.h"
#include "shell.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

static int is_executable_regular_file(const char *path) {
    struct stat st;
    if (stat(path, &st) == 0) {
        if (S_ISREG(st.st_mode) && (access(path, X_OK) == 0)) {
            return 1;
        }
    }
    return 0;
}

static int locate_single_filename(const char *filename) {
    int matches_found = 0;
    char current_working_dir[PATH_MAX];

    if (getcwd(current_working_dir, sizeof(current_working_dir)) != NULL) {
        char local_filepath[PATH_MAX * 2];
        snprintf(local_filepath, sizeof(local_filepath), "%s/%s", current_working_dir, filename);

        if (is_executable_regular_file(local_filepath)) {
            printf("%s\n", local_filepath);
            matches_found++;
        }
    }

    char *path_env = getenv("PATH");
    if (path_env != NULL) {
        char *path_copy = strdup(path_env);
        if (path_copy != NULL) {
            char *token = strtok(path_copy, ":");
            while (token != NULL) {
                char candidate_path[PATH_MAX * 2];
                snprintf(candidate_path, sizeof(candidate_path), "%s/%s", token, filename);

                if (is_executable_regular_file(candidate_path)) {
                    printf("%s\n", candidate_path);
                    matches_found++;
                }

                token = strtok(NULL, ":");
            }
            free(path_copy);
        }
    }

    if (matches_found == 0) {
        printf("locate: command not found (%s)\n", filename);
    }

    return (matches_found > 0) ? 0 : -1;
}

int execute_builtin_locate(const ParsedCommand *command) {
    if (command->arguments_count <= 1) {
        printf("locate: invalid syntax\n");
        return -1;
    }

    int overall_status = 0;
    for (size_t i = 1; i < command->arguments_count; i++) {
        if (locate_single_filename(command->arguments_list[i]) != 0) {
            overall_status = -1;
        }
    }

    return overall_status;
}
