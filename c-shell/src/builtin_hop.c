#include "builtin_hop.h"
#include "shell.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <time.h>

#define FRECENCY_FILE_NAME ".cshell_frecency"
#define MAX_FRECENCY_ENTRIES 512

typedef struct {
    char path[PATH_MAX];
    double score;
    time_t last_accessed;
} FrecencyEntry;

static void get_frecency_filepath(char *dest, size_t size) {
    snprintf(dest, size, "%s/%s", shell_ctx.startup_home_directory, FRECENCY_FILE_NAME);
}

static size_t load_frecency_db(FrecencyEntry *entries) {
    char fpath[PATH_MAX];
    get_frecency_filepath(fpath, sizeof(fpath));
    FILE *fp = fopen(fpath, "r");
    if (!fp) return 0;

    size_t count = 0;
    while (count < MAX_FRECENCY_ENTRIES &&
           fscanf(fp, "%s %lf %ld", entries[count].path, &entries[count].score, &entries[count].last_accessed) == 3) {
        count++;
    }
    fclose(fp);
    return count;
}

static void save_frecency_db(const FrecencyEntry *entries, size_t count) {
    char fpath[PATH_MAX];
    get_frecency_filepath(fpath, sizeof(fpath));
    FILE *fp = fopen(fpath, "w");
    if (!fp) return;

    for (size_t i = 0; i < count; i++) {
        fprintf(fp, "%s %.4lf %ld\n", entries[i].path, entries[i].score, entries[i].last_accessed);
    }
    fclose(fp);
}

static void update_frecency_record(const char *target_path) {
    FrecencyEntry entries[MAX_FRECENCY_ENTRIES];
    size_t count = load_frecency_db(entries);
    time_t now = time(NULL);

    int match_idx = -1;
    for (size_t i = 0; i < count; i++) {
        if (strcmp(entries[i].path, target_path) == 0) {
            match_idx = (int)i;
            break;
        }
    }

    if (match_idx != -1) {
        entries[match_idx].score += 1.0;
        entries[match_idx].last_accessed = now;
    } else if (count < MAX_FRECENCY_ENTRIES) {
        strncpy(entries[count].path, target_path, sizeof(entries[count].path) - 1);
        entries[count].path[sizeof(entries[count].path) - 1] = '\0';
        entries[count].score = 1.0;
        entries[count].last_accessed = now;
        count++;
    }

    save_frecency_db(entries, count);
}

static double calculate_effective_score(const FrecencyEntry *entry, time_t now, const char *query) {
    double age_hours = difftime(now, entry->last_accessed) / 3600.0;
    if (age_hours < 0) age_hours = 0;
    double base = entry->score / (1.0 + 0.05 * age_hours);

    const char *last_slash = strrchr(entry->path, '/');
    const char *basename = last_slash ? last_slash + 1 : entry->path;

    if (strcmp(basename, query) == 0) {
        return base * 10000.0;
    } else if (strstr(basename, query) != NULL) {
        return base * 100.0;
    }
    return base * 0.001;
}

static bool frecency_lookup(const char *query, const char *current_cwd, char *best_path) {
    FrecencyEntry entries[MAX_FRECENCY_ENTRIES];
    size_t count = load_frecency_db(entries);
    if (count == 0) return false;

    time_t now = time(NULL);
    double highest_score = -1.0;
    int best_index = -1;

    for (size_t i = 0; i < count; i++) {
        if (strstr(entries[i].path, query) != NULL) {
            struct stat st;
            if (stat(entries[i].path, &st) == 0 && S_ISDIR(st.st_mode)) {
                double eff_score = calculate_effective_score(&entries[i], now, query);
                if (eff_score > highest_score) {
                    highest_score = eff_score;
                    best_index = (int)i;
                }
            }
        }
    }

    if (best_index != -1) {
        strncpy(best_path, entries[best_index].path, PATH_MAX - 1);
        best_path[PATH_MAX - 1] = '\0';
        return true;
    }
    return false;
}

static int change_directory(const char *target_dir) {
    char current_cwd[PATH_MAX];
    if (getcwd(current_cwd, sizeof(current_cwd)) == NULL) return -1;

    if (chdir(target_dir) != 0) {
        return -1;
    }

    strncpy(shell_ctx.previous_working_directory, current_cwd, sizeof(shell_ctx.previous_working_directory) - 1);
    shell_ctx.previous_working_directory[sizeof(shell_ctx.previous_working_directory) - 1] = '\0';
    shell_ctx.has_previous_working_directory = true;

    char new_cwd[PATH_MAX];
    if (getcwd(new_cwd, sizeof(new_cwd)) != NULL) {
        update_frecency_record(new_cwd);
    }
    return 0;
}

int execute_builtin_hop(const ParsedCommand *command) {
    if (command->arguments_count <= 1) {
        if (change_directory(shell_ctx.startup_home_directory) != 0) {
            printf("hop: no such directory\n");
            return -1;
        }
        return 0;
    }

    int overall_status = 0;

    for (size_t i = 1; i < command->arguments_count; i++) {
        const char *arg = command->arguments_list[i];

        if (strcmp(arg, "~") == 0) {
            if (change_directory(shell_ctx.startup_home_directory) != 0) {
                printf("hop: no such directory\n");
                overall_status = -1;
            }
        } else if (strcmp(arg, ".") == 0) {
            continue;
        } else if (strcmp(arg, "..") == 0) {
            if (change_directory("..") != 0) {
                printf("hop: no such directory\n");
                overall_status = -1;
            }
        } else if (strcmp(arg, "-") == 0) {
            if (!shell_ctx.has_previous_working_directory) {
                continue;
            }
            if (change_directory(shell_ctx.previous_working_directory) != 0) {
                printf("hop: no such directory\n");
                overall_status = -1;
            }
        } else {
            // Check if current directory's basename already matches the query exactly
            char current_cwd[PATH_MAX];
            if (getcwd(current_cwd, sizeof(current_cwd)) != NULL) {
                const char *last_slash = strrchr(current_cwd, '/');
                const char *base = last_slash ? last_slash + 1 : current_cwd;
                if (strcmp(base, arg) == 0) {
                    // Already in target directory
                    update_frecency_record(current_cwd);
                    continue;
                }
            }

            // 1. Direct path
            if (change_directory(arg) == 0) {
                continue;
            }

            // 2. Frecency lookup
            char frecency_path[PATH_MAX];
            if (frecency_lookup(arg, current_cwd, frecency_path)) {
                if (change_directory(frecency_path) == 0) {
                    continue;
                }
            }

            printf("hop: no such directory\n");
            overall_status = -1;
        }
    }

    return overall_status;
}
