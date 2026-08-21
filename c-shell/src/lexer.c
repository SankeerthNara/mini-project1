#include "lexer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static void append_token_to_stream(ShellTokenStream *stream, ShellTokenType type, const char *value) {
    if (stream->tokens_count >= stream->tokens_capacity) {
        if (stream->tokens_capacity == 0) {
            stream->tokens_capacity = 16;
        } else {
            stream->tokens_capacity = stream->tokens_capacity * 2;
        }
        stream->tokens_array = realloc(stream->tokens_array, stream->tokens_capacity * sizeof(ShellToken));
    }

    stream->tokens_array[stream->tokens_count].token_type = type;
    if (value != NULL) {
        stream->tokens_array[stream->tokens_count].token_value = strdup(value);
    } else {
        stream->tokens_array[stream->tokens_count].token_value = NULL;
    }
    stream->tokens_count++;
}

ShellTokenStream tokenize_input_line(const char *raw_input_line) {
    ShellTokenStream stream;
    stream.tokens_array = NULL;
    stream.tokens_count = 0;
    stream.tokens_capacity = 0;

    size_t index = 0;
    size_t total_length = strlen(raw_input_line);

    while (index < total_length) {
        if (isspace((unsigned char)raw_input_line[index])) {
            index++;
            continue;
        }

        if (raw_input_line[index] == ';') {
            append_token_to_stream(&stream, TOKEN_TYPE_SEMICOLON, ";");
            index++;
        } else if (raw_input_line[index] == '&') {
            append_token_to_stream(&stream, TOKEN_TYPE_AMPERSAND, "&");
            index++;
        } else if (raw_input_line[index] == '|') {
            append_token_to_stream(&stream, TOKEN_TYPE_PIPE, "|");
            index++;
        } else if (raw_input_line[index] == '<') {
            append_token_to_stream(&stream, TOKEN_TYPE_REDIR_IN, "<");
            index++;
        } else if (raw_input_line[index] == '>') {
            if (index + 1 < total_length && raw_input_line[index + 1] == '>') {
                append_token_to_stream(&stream, TOKEN_TYPE_REDIR_OUT_APPEND, ">>");
                index += 2;
            } else {
                append_token_to_stream(&stream, TOKEN_TYPE_REDIR_OUT_TRUNC, ">");
                index++;
            }
        } else {
            size_t start_index = index;

            while (index < total_length && !isspace((unsigned char)raw_input_line[index])) {
                char ch = raw_input_line[index];
                if (ch == ';' || ch == '&' || ch == '|' || ch == '<' || ch == '>') {
                    break;
                }
                index++;
            }

            size_t word_length = index - start_index;
            char *word_string = malloc(word_length + 1);
            memcpy(word_string, raw_input_line + start_index, word_length);
            word_string[word_length] = '\0';

            append_token_to_stream(&stream, TOKEN_TYPE_WORD, word_string);
            free(word_string);
        }
    }

    append_token_to_stream(&stream, TOKEN_TYPE_END_OF_INPUT, NULL);
    return stream;
}

void free_token_stream(ShellTokenStream *stream) {
    if (stream == NULL) {
        return;
    }
    for (size_t i = 0; i < stream->tokens_count; i++) {
        if (stream->tokens_array[i].token_value != NULL) {
            free(stream->tokens_array[i].token_value);
        }
    }
    free(stream->tokens_array);
    stream->tokens_array = NULL;
    stream->tokens_count = 0;
    stream->tokens_capacity = 0;
}
