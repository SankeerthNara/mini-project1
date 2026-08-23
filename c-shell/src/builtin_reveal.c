#include "builtin_reveal.h"
#include "shell.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <unistd.h>

static int compare_string_entries(const void *a, const void *b) {
    const char *entry_a = *(const char **)a;
    const char *entry_b = *(const char **)b;
    return strcmp(entry_a, entry_b);
}

static void print_long_listing_entry(const char *dir_path, const char *filename) {
    char full_filepath[PATH_MAX];
    snprintf(full_filepath, sizeof(full_filepath), "%s/%s", dir_path, filename);

    struct stat file_stat;
    if (lstat(full_filepath, &file_stat) != 0) {
        perror("reveal: lstat");
        return;
    }

    char perms[11] = "----------";
    if (S_ISDIR(file_stat.st_mode)) perms[0] = 'd';
    else if (S_ISLNK(file_stat.st_mode)) perms[0] = 'l';
    else if (S_ISCHR(file_stat.st_mode)) perms[0] = 'c';
    else if (S_ISBLK(file_stat.st_mode)) perms[0] = 'b';
    else if (S_ISFIFO(file_stat.st_mode)) perms[0] = 'p';
    else if (S_ISSOCK(file_stat.st_mode)) perms[0] = 's';

    if (file_stat.st_mode & S_IRUSR) perms[1] = 'r';
    if (file_stat.st_mode & S_IWUSR) perms[2] = 'w';
    if (file_stat.st_mode & S_IXUSR) perms[3] = 'x';

    if (file_stat.st_mode & S_IRGRP) perms[4] = 'r';
    if (file_stat.st_mode & S_IWGRP) perms[5] = 'w';
    if (file_stat.st_mode & S_IXGRP) perms[6] = 'x';

    if (file_stat.st_mode & S_IROTH) perms[7] = 'r';
    if (file_stat.st_mode & S_IWOTH) perms[8] = 'w';
    if (file_stat.st_mode & S_IXOTH) perms[9] = 'x';

    struct passwd *pw = getpwuid(file_stat.st_uid);
    struct group  *gr = getgrgid(file_stat.st_gid);
    char *user_name = (pw != NULL) ? pw->pw_name : "unknown";
    char *group_name = (gr != NULL) ? gr->gr_name : "unknown";

    char time_buffer[64];
    struct tm *tm_info = localtime(&file_stat.st_mtime);
    if (tm_info != NULL) {
        strftime(time_buffer, sizeof(time_buffer), "%b %d %H:%M", tm_info);
    } else {
        strncpy(time_buffer, "Unknown Date", sizeof(time_buffer));
    }

    printf("%s %2ld %s %s %8ld %s %s\n",
           perms,
           (long)file_stat.st_nlink,
           user_name,
           group_name,
           (long)file_stat.st_size,
           time_buffer,
           filename);
}

int execute_builtin_reveal(const ParsedCommand *command) {
    bool show_all_entries = false;
    bool show_long_format = false;
    const char *target_path_argument = NULL;

    for (size_t i = 1; i < command->arguments_count; i++) {
        const char *arg = command->arguments_list[i];

        if (arg[0] == '-' && arg[1] != '\0' && strcmp(arg, "-") != 0 && strcmp(arg, "--") != 0) {
            for (size_t j = 1; arg[j] != '\0'; j++) {
                if (arg[j] == 'a') {
                    show_all_entries = true;
                } else if (arg[j] == 'l') {
                    show_long_format = true;
                } else {
                    fprintf(stderr, "reveal: invalid flag '-%c'\n", arg[j]);
                    return -1;
                }
            }
        } else {
            if (target_path_argument == NULL) {
                target_path_argument = arg;
            } else {
                fprintf(stderr, "reveal: too many directory arguments\n");
                return -1;
            }
        }
    }

    char resolved_target_path[PATH_MAX];
    if (target_path_argument == NULL || strcmp(target_path_argument, ".") == 0) {
        strncpy(resolved_target_path, ".", sizeof(resolved_target_path));
    } else if (strcmp(target_path_argument, "~") == 0) {
        strncpy(resolved_target_path, shell_ctx.startup_home_directory, sizeof(resolved_target_path));
    } else if (strcmp(target_path_argument, "-") == 0) {
        if (!shell_ctx.has_previous_working_directory) {
            fprintf(stderr, "reveal: OLDPWD not set\n");
            return -1;
        }
        strncpy(resolved_target_path, shell_ctx.previous_working_directory, sizeof(resolved_target_path));
    } else if (target_path_argument[0] == '~' && (target_path_argument[1] == '/' || target_path_argument[1] == '\0')) {
        snprintf(resolved_target_path, sizeof(resolved_target_path), "%s%s",
                 shell_ctx.startup_home_directory, target_path_argument + 1);
    } else {
        strncpy(resolved_target_path, target_path_argument, sizeof(resolved_target_path));
    }

    struct stat target_stat;
    if (stat(resolved_target_path, &target_stat) != 0) {
        perror("reveal");
        return -1;
    }

    if (!S_ISDIR(target_stat.st_mode)) {
        if (show_long_format) {
            print_long_listing_entry(".", resolved_target_path);
        } else {
            printf("%s\n", resolved_target_path);
        }
        return 0;
    }

    DIR *dir = opendir(resolved_target_path);
    if (dir == NULL) {
        perror("reveal");
        return -1;
    }

    char **entries = NULL;
    size_t entries_count = 0;
    size_t entries_capacity = 0;

    struct dirent *dp;
    while ((dp = readdir(dir)) != NULL) {
        if (!show_all_entries && dp->d_name[0] == '.') {
            continue;
        }

        if (entries_count >= entries_capacity) {
            entries_capacity = (entries_capacity == 0) ? 32 : entries_capacity * 2;
            entries = realloc(entries, entries_capacity * sizeof(char *));
        }
        entries[entries_count] = strdup(dp->d_name);
        entries_count++;
    }
    closedir(dir);

    qsort(entries, entries_count, sizeof(char *), compare_string_entries);

    for (size_t i = 0; i < entries_count; i++) {
        if (show_long_format) {
            print_long_listing_entry(resolved_target_path, entries[i]);
        } else {
            printf("%s\n", entries[i]);
        }
        free(entries[i]);
    }
    free(entries);

    return 0;
}
