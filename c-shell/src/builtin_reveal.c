#include "builtin_reveal.h"
#include "shell.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/stat.h>

static int compare_strings(const void *a, const void *b) {
    const char *str1 = *(const char **)a;
    const char *str2 = *(const char **)b;
    return strcmp(str1, str2);
}

static void reveal_directory_contents(const char *dir_path, bool show_all, bool recursive, int depth) {
    DIR *dir = opendir(dir_path);
    if (!dir) return;

    struct dirent *entry;
    char **names = NULL;
    size_t count = 0;
    size_t cap = 0;

    while ((entry = readdir(dir)) != NULL) {
        if (!show_all && entry->d_name[0] == '.') {
            continue;
        }
        if (recursive && (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)) {
            continue;
        }

        if (count >= cap) {
            cap = (cap == 0) ? 16 : cap * 2;
            names = realloc(names, cap * sizeof(char *));
        }
        names[count++] = strdup(entry->d_name);
    }
    closedir(dir);

    if (count > 0) {
        qsort(names, count, sizeof(char *), compare_strings);
    }

    for (size_t i = 0; i < count; i++) {
        if (depth > 0) {
            for (int d = 0; d < depth; d++) printf("  ");
        }
        printf("%s\n", names[i]);
    }

    if (recursive) {
        for (size_t i = 0; i < count; i++) {
            char sub_path[PATH_MAX * 2];
            snprintf(sub_path, sizeof(sub_path), "%s/%s", dir_path, names[i]);

            struct stat st;
            if (stat(sub_path, &st) == 0 && S_ISDIR(st.st_mode)) {
                if (depth > 0) {
                    for (int d = 0; d < depth; d++) printf("  ");
                }
                printf("%s:\n", names[i]);
                reveal_directory_contents(sub_path, show_all, true, depth + 1);
            }
        }
    }

    for (size_t i = 0; i < count; i++) {
        free(names[i]);
    }
    free(names);
}

int execute_builtin_reveal(const ParsedCommand *command) {
    bool show_all = false;
    bool recursive = false;
    const char *target_arg = NULL;

    for (size_t i = 1; i < command->arguments_count; i++) {
        const char *arg = command->arguments_list[i];
        if (arg[0] == '-' && strlen(arg) > 1 && strcmp(arg, "-") != 0 && strcmp(arg, "--") != 0) {
            for (size_t j = 1; j < strlen(arg); j++) {
                if (arg[j] == 'a') {
                    show_all = true;
                } else if (arg[j] == 't') {
                    recursive = true;
                } else {
                    printf("reveal: invalid syntax\n");
                    return -1;
                }
            }
        } else {
            if (target_arg != NULL) {
                printf("reveal: invalid syntax\n");
                return -1;
            }
            target_arg = arg;
        }
    }

    char resolved_path[PATH_MAX];
    if (target_arg == NULL || strcmp(target_arg, ".") == 0) {
        if (getcwd(resolved_path, sizeof(resolved_path)) == NULL) return -1;
    } else if (strcmp(target_arg, "~") == 0) {
        strncpy(resolved_path, shell_ctx.startup_home_directory, sizeof(resolved_path) - 1);
        resolved_path[sizeof(resolved_path) - 1] = '\0';
    } else if (strcmp(target_arg, "..") == 0) {
        strncpy(resolved_path, "..", sizeof(resolved_path) - 1);
        resolved_path[sizeof(resolved_path) - 1] = '\0';
    } else if (strcmp(target_arg, "-") == 0) {
        if (!shell_ctx.has_previous_working_directory) {
            printf("reveal: no such directory\n");
            return -1;
        }
        strncpy(resolved_path, shell_ctx.previous_working_directory, sizeof(resolved_path) - 1);
        resolved_path[sizeof(resolved_path) - 1] = '\0';
    } else {
        strncpy(resolved_path, target_arg, sizeof(resolved_path) - 1);
        resolved_path[sizeof(resolved_path) - 1] = '\0';
    }

    struct stat st;
    if (stat(resolved_path, &st) != 0 || !S_ISDIR(st.st_mode)) {
        printf("reveal: no such directory\n");
        return -1;
    }

    reveal_directory_contents(resolved_path, show_all, recursive, 0);
    return 0;
}
