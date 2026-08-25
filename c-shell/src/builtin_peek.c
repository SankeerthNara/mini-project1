#include "builtin_peek.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdbool.h>

#define CHUNK_SIZE 4096

typedef struct {
    char *text;
    bool is_non_empty;
    int line_number;
} PeekLine;

static bool is_line_empty(const char *str) {
    while (*str) {
        if (*str != ' ' && *str != '\t' && *str != '\n' && *str != '\r') return false;
        str++;
    }
    return true;
}

static void print_formatted_lines(PeekLine *lines, size_t count, bool count_flag, bool reverse_flag) {
    int non_empty_counter = 1;
    for (size_t i = 0; i < count; i++) {
        if (!is_line_empty(lines[i].text)) {
            lines[i].is_non_empty = true;
            lines[i].line_number = non_empty_counter++;
        } else {
            lines[i].is_non_empty = false;
            lines[i].line_number = 0;
        }
    }

    if (reverse_flag) {
        for (ssize_t i = (ssize_t)count - 1; i >= 0; i--) {
            if (count_flag && lines[i].is_non_empty) {
                printf("%d %s\n", lines[i].line_number, lines[i].text);
            } else {
                printf("%s\n", lines[i].text);
            }
        }
    } else {
        for (size_t i = 0; i < count; i++) {
            if (count_flag && lines[i].is_non_empty) {
                printf("%d %s\n", lines[i].line_number, lines[i].text);
            } else {
                printf("%s\n", lines[i].text);
            }
        }
    }
}

static int process_stream(FILE *fp, bool count_flag, bool reverse_flag) {
    char *line_buf = NULL;
    size_t line_cap = 0;
    ssize_t read_len;

    PeekLine *lines = NULL;
    size_t count = 0;
    size_t cap = 0;

    while ((read_len = getline(&line_buf, &line_cap, fp)) != -1) {
        if (read_len > 0 && line_buf[read_len - 1] == '\n') {
            line_buf[read_len - 1] = '\0';
        }
        if (count >= cap) {
            cap = (cap == 0) ? 32 : cap * 2;
            lines = realloc(lines, cap * sizeof(PeekLine));
        }
        lines[count].text = strdup(line_buf);
        lines[count].is_non_empty = false;
        lines[count].line_number = 0;
        count++;
    }
    free(line_buf);

    print_formatted_lines(lines, count, count_flag, reverse_flag);

    for (size_t i = 0; i < count; i++) {
        free(lines[i].text);
    }
    free(lines);
    return 0;
}

static int process_regular_file_reverse(const char *filename, bool count_flag) {
    int fd = open(filename, O_RDONLY);
    if (fd < 0) return -1;

    off_t file_size = lseek(fd, 0, SEEK_END);
    if (file_size <= 0) {
        close(fd);
        return 0;
    }

    PeekLine *lines = NULL;
    size_t count = 0;
    size_t cap = 0;

    char current_line[CHUNK_SIZE * 4];
    size_t current_len = 0;

    off_t pos = file_size;
    while (pos > 0) {
        size_t to_read = (pos >= CHUNK_SIZE) ? CHUNK_SIZE : (size_t)pos;
        pos -= to_read;
        lseek(fd, pos, SEEK_SET);

        char chunk[CHUNK_SIZE];
        ssize_t bytes = read(fd, chunk, to_read);
        if (bytes <= 0) break;

        for (ssize_t i = bytes - 1; i >= 0; i--) {
            if (chunk[i] == '\n') {
                if (pos + i + 1 == file_size && current_len == 0) {
                    continue;
                }
                char rev[CHUNK_SIZE * 4];
                for (size_t k = 0; k < current_len; k++) {
                    rev[k] = current_line[current_len - 1 - k];
                }
                rev[current_len] = '\0';

                if (count >= cap) {
                    cap = (cap == 0) ? 32 : cap * 2;
                    lines = realloc(lines, cap * sizeof(PeekLine));
                }
                lines[count++].text = strdup(rev);
                current_len = 0;
            } else {
                current_line[current_len++] = chunk[i];
            }
        }
    }

    if (current_len > 0) {
        char rev[CHUNK_SIZE * 4];
        for (size_t k = 0; k < current_len; k++) {
            rev[k] = current_line[current_len - 1 - k];
        }
        rev[current_len] = '\0';

        if (count >= cap) {
            cap = (cap == 0) ? 32 : cap * 2;
            lines = realloc(lines, cap * sizeof(PeekLine));
        }
        lines[count++].text = strdup(rev);
    }
    close(fd);

    // Number forward from 1 to N
    int line_num = 1;
    for (ssize_t i = (ssize_t)count - 1; i >= 0; i--) {
        if (!is_line_empty(lines[i].text)) {
            lines[i].is_non_empty = true;
            lines[i].line_number = line_num++;
        } else {
            lines[i].is_non_empty = false;
            lines[i].line_number = 0;
        }
    }

    // Print reversed lines
    for (size_t i = 0; i < count; i++) {
        if (count_flag && lines[i].is_non_empty) {
            printf("%d %s\n", lines[i].line_number, lines[i].text);
        } else {
            printf("%s\n", lines[i].text);
        }
        free(lines[i].text);
    }
    free(lines);
    return 0;
}

int execute_builtin_peek(const ParsedCommand *command) {
    bool count_flag = false;
    bool reverse_flag = false;

    char *files[256];
    size_t file_count = 0;

    for (size_t i = 1; i < command->arguments_count; i++) {
        const char *arg = command->arguments_list[i];
        if (arg[0] == '-' && strlen(arg) > 1 && strcmp(arg, "-") != 0) {
            for (size_t j = 1; j < strlen(arg); j++) {
                if (arg[j] == 'n') count_flag = true;
                else if (arg[j] == 'r') reverse_flag = true;
                else {
                    fprintf(stderr, "peek: invalid flag\n");
                    return -1;
                }
            }
        } else {
            files[file_count++] = (char *)arg;
        }
    }

    if (file_count == 0) {
        return process_stream(stdin, count_flag, reverse_flag);
    }

    int status = 0;
    for (size_t i = 0; i < file_count; i++) {
        if (strcmp(files[i], "-") == 0) {
            process_stream(stdin, count_flag, reverse_flag);
            continue;
        }

        struct stat st;
        if (stat(files[i], &st) != 0) {
            printf("peek: no such file or directory\n");
            status = -1;
            continue;
        }

        if (S_ISDIR(st.st_mode)) {
            printf("peek: is a directory\n");
            status = -1;
            continue;
        }

        if (reverse_flag) {
            process_regular_file_reverse(files[i], count_flag);
        } else {
            FILE *fp = fopen(files[i], "r");
            if (!fp) {
                printf("peek: no such file or directory\n");
                status = -1;
                continue;
            }
            process_stream(fp, count_flag, false);
            fclose(fp);
        }
    }

    return status;
}
