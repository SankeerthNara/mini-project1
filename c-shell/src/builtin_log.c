#include "builtin_log.h"
#include "shell.h"
#include "lexer.h"
#include "executor.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_LOG_ENTRIES 15

static void get_log_file_path(char *output_path, size_t max_size) {
    snprintf(output_path, max_size, "%s/.cshell_log", shell_ctx.startup_home_directory);
}

static size_t read_all_log_entries(char entries[MAX_LOG_ENTRIES][INPUT_BUFFER_MAX]) {
    char log_filepath[PATH_MAX];
    get_log_file_path(log_filepath, sizeof(log_filepath));

    FILE *file = fopen(log_filepath, "r");
    if (file == NULL) {
        return 0;
    }

    size_t count = 0;
    char line_buffer[INPUT_BUFFER_MAX];
    while (count < MAX_LOG_ENTRIES && fgets(line_buffer, sizeof(line_buffer), file) != NULL) {
        size_t len = strlen(line_buffer);
        if (len > 0 && line_buffer[len - 1] == '\n') {
            line_buffer[len - 1] = '\0';
        }
        if (strlen(line_buffer) > 0) {
            strncpy(entries[count], line_buffer, INPUT_BUFFER_MAX - 1);
            entries[count][INPUT_BUFFER_MAX - 1] = '\0';
            count++;
        }
    }

    fclose(file);
    return count;
}

static void write_all_log_entries(char entries[MAX_LOG_ENTRIES][INPUT_BUFFER_MAX], size_t count) {
    char log_filepath[PATH_MAX];
    get_log_file_path(log_filepath, sizeof(log_filepath));

    FILE *file = fopen(log_filepath, "w");
    if (file == NULL) {
        perror("log: fopen");
        return;
    }

    for (size_t i = 0; i < count; i++) {
        fprintf(file, "%s\n", entries[i]);
    }

    fclose(file);
}

void log_record_command(const char *raw_command_line) {
    if (raw_command_line == NULL || strlen(raw_command_line) == 0) {
        return;
    }

    if (strstr(raw_command_line, "log") != NULL) {
        return;
    }

    char entries[MAX_LOG_ENTRIES][INPUT_BUFFER_MAX];
    size_t count = read_all_log_entries(entries);

    if (count > 0 && strcmp(entries[count - 1], raw_command_line) == 0) {
        return;
    }

    if (count < MAX_LOG_ENTRIES) {
        strncpy(entries[count], raw_command_line, INPUT_BUFFER_MAX - 1);
        entries[count][INPUT_BUFFER_MAX - 1] = '\0';
        count++;
    } else {
        for (size_t i = 0; i < MAX_LOG_ENTRIES - 1; i++) {
            strncpy(entries[i], entries[i + 1], INPUT_BUFFER_MAX);
        }
        strncpy(entries[MAX_LOG_ENTRIES - 1], raw_command_line, INPUT_BUFFER_MAX - 1);
        entries[MAX_LOG_ENTRIES - 1][INPUT_BUFFER_MAX - 1] = '\0';
    }

    write_all_log_entries(entries, count);
}

int execute_builtin_log(const ParsedCommand *command) {
    char entries[MAX_LOG_ENTRIES][INPUT_BUFFER_MAX];
    size_t count = read_all_log_entries(entries);

    if (command->arguments_count == 1) {
        for (size_t i = 0; i < count; i++) {
            printf("%s\n", entries[i]);
        }
        return 0;
    }

    if (strcmp(command->arguments_list[1], "purge") == 0) {
        char log_filepath[PATH_MAX];
        get_log_file_path(log_filepath, sizeof(log_filepath));
        FILE *file = fopen(log_filepath, "w");
        if (file != NULL) {
            fclose(file);
        }
        return 0;
    }

    if (strcmp(command->arguments_list[1], "execute") == 0) {
        if (command->arguments_count < 3) {
            fprintf(stderr, "log: expected index after 'execute'\n");
            return -1;
        }

        int index = atoi(command->arguments_list[2]);
        if (index < 1 || (size_t)index > count) {
            fprintf(stderr, "log: invalid index %d (must be 1 to %zu)\n", index, count);
            return -1;
        }

        char command_to_run[INPUT_BUFFER_MAX];
        strncpy(command_to_run, entries[count - index], sizeof(command_to_run));

        ShellTokenStream tokens = tokenize_input_line(command_to_run);
        ParsedCommandGroup *group = parse_command_grammar(&tokens);
        if (group != NULL) {
            execute_command_group(group);
            free_parsed_command_group(group);
        }
        free_token_stream(&tokens);
        return 0;
    }

    fprintf(stderr, "log: invalid argument '%s'\n", command->arguments_list[1]);
    return -1;
}
