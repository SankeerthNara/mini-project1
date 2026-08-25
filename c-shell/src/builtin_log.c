#include "builtin_log.h"
#include "shell.h"
#include "lexer.h"
#include "parser.h"
#include "executor.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define LOG_FILE_NAME ".cshell_log"
#define MAX_LOG_ENTRIES 15

static void get_log_filepath(char *dest, size_t size) {
    snprintf(dest, size, "%s/%s", shell_ctx.startup_home_directory, LOG_FILE_NAME);
}

static size_t read_log_entries(char entries[MAX_LOG_ENTRIES][4096]) {
    char fpath[PATH_MAX];
    get_log_filepath(fpath, sizeof(fpath));

    FILE *fp = fopen(fpath, "r");
    if (!fp) return 0;

    size_t count = 0;
    char buffer[4096];
    while (count < MAX_LOG_ENTRIES && fgets(buffer, sizeof(buffer), fp)) {
        size_t len = strlen(buffer);
        if (len > 0 && buffer[len - 1] == '\n') {
            buffer[len - 1] = '\0';
        }
        strncpy(entries[count], buffer, 4095);
        entries[count][4095] = '\0';
        count++;
    }
    fclose(fp);
    return count;
}

static void write_log_entries(char entries[MAX_LOG_ENTRIES][4096], size_t count) {
    char fpath[PATH_MAX];
    get_log_filepath(fpath, sizeof(fpath));

    FILE *fp = fopen(fpath, "w");
    if (!fp) return;

    for (size_t i = 0; i < count; i++) {
        fprintf(fp, "%s\n", entries[i]);
    }
    fclose(fp);
}

void log_command_to_history(const char *command_line) {
    if (command_line == NULL || strlen(command_line) == 0) return;

    // Do not log commands containing "log"
    if (strstr(command_line, "log") != NULL) return;

    char entries[MAX_LOG_ENTRIES][4096];
    size_t count = read_log_entries(entries);

    // Avoid logging duplicates sequentially
    if (count > 0 && strcmp(entries[count - 1], command_line) == 0) {
        return;
    }

    if (count < MAX_LOG_ENTRIES) {
        strncpy(entries[count], command_line, 4095);
        entries[count][4095] = '\0';
        count++;
    } else {
        for (size_t i = 0; i < MAX_LOG_ENTRIES - 1; i++) {
            strncpy(entries[i], entries[i + 1], 4096);
        }
        strncpy(entries[MAX_LOG_ENTRIES - 1], command_line, 4095);
        entries[MAX_LOG_ENTRIES - 1][4095] = '\0';
    }

    write_log_entries(entries, count);
}

int execute_builtin_log(const ParsedCommand *command) {
    char entries[MAX_LOG_ENTRIES][4096];
    size_t count = read_log_entries(entries);

    if (command->arguments_count == 1) {
        for (size_t i = 0; i < count; i++) {
            printf("%s\n", entries[i]);
        }
        return 0;
    }

    if (strcmp(command->arguments_list[1], "purge") == 0) {
        char fpath[PATH_MAX];
        get_log_filepath(fpath, sizeof(fpath));
        unlink(fpath);
        return 0;
    }

    if (strcmp(command->arguments_list[1], "execute") == 0) {
        if (command->arguments_count < 3) {
            printf("log: invalid syntax\n");
            return -1;
        }

        int index = atoi(command->arguments_list[2]);
        if (index < 1 || (size_t)index > count) {
            printf("log: invalid index\n");
            return -1;
        }

        // 1 is the most recent (last stored entry)
        const char *target_command = entries[count - index];
        ShellTokenStream tokens = tokenize_input_line(target_command);
        ParsedCommandGroup *group = parse_command_grammar(&tokens);

        if (group != NULL) {
            execute_command_group(group);
            free_parsed_command_group(group);
        }

        free_token_stream(&tokens);
        return 0;
    }

    printf("log: invalid syntax\n");
    return -1;
}
