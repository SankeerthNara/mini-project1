#include "lexer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void free_token_stream(ShellTokenStream *stream) {
    if (stream == NULL || stream->tokens_array == NULL) {
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
}

static void append_token(ShellTokenStream *stream, ShellTokenType type, const char *value) {
    stream->tokens_array = realloc(stream->tokens_array, (stream->tokens_count + 1) * sizeof(ShellToken));
    stream->tokens_array[stream->tokens_count].token_type = type;
    stream->tokens_array[stream->tokens_count].token_value = value ? strdup(value) : NULL;
    stream->tokens_count++;
}

ShellTokenStream tokenize_input_line(const char *input_line) {
    ShellTokenStream stream;
    stream.tokens_array = NULL;
    stream.tokens_count = 0;

    if (input_line == NULL) {
        append_token(&stream, TOKEN_TYPE_END_OF_INPUT, NULL);
        return stream;
    }

    size_t i = 0;
    size_t len = strlen(input_line);

    while (i < len) {
        if (isspace((unsigned char)input_line[i])) {
            i++;
            continue;
        }

        if (input_line[i] == ';') {
            append_token(&stream, TOKEN_TYPE_SEMICOLON, ";");
            i++;
            continue;
        }

        if (input_line[i] == '&') {
            append_token(&stream, TOKEN_TYPE_AMPERSAND, "&");
            i++;
            continue;
        }

        if (input_line[i] == '|') {
            append_token(&stream, TOKEN_TYPE_PIPE, "|");
            i++;
            continue;
        }

        if (input_line[i] == '<') {
            append_token(&stream, TOKEN_TYPE_REDIR_IN, "<");
            i++;
            continue;
        }

        if (input_line[i] == '>') {
            if (i + 1 < len && input_line[i + 1] == '>') {
                append_token(&stream, TOKEN_TYPE_REDIR_OUT_APPEND, ">>");
                i += 2;
            } else {
                append_token(&stream, TOKEN_TYPE_REDIR_OUT_TRUNC, ">");
                i++;
            }
            continue;
        }

        char word_buffer[4096];
        size_t word_len = 0;
        char in_quote = '\0';

        while (i < len) {
            char c = input_line[i];

            if (in_quote != '\0') {
                if (c == in_quote) {
                    in_quote = '\0';
                    i++;
                } else if (c == '\\' && i + 1 < len) {
                    i++;
                    char next = input_line[i];
                    if (next == 'n') word_buffer[word_len++] = '\n';
                    else if (next == 't') word_buffer[word_len++] = '\t';
                    else if (next == 'r') word_buffer[word_len++] = '\r';
                    else if (next == '\\') word_buffer[word_len++] = '\\';
                    else if (next == in_quote) word_buffer[word_len++] = in_quote;
                    else {
                        word_buffer[word_len++] = '\\';
                        word_buffer[word_len++] = next;
                    }
                    i++;
                } else {
                    word_buffer[word_len++] = c;
                    i++;
                }
            } else {
                if (c == '\'' || c == '"') {
                    in_quote = c;
                    i++;
                } else if (isspace((unsigned char)c) || c == ';' || c == '&' || c == '|' || c == '<' || c == '>') {
                    break;
                } else if (c == '\\' && i + 1 < len) {
                    i++;
                    char next = input_line[i];
                    if (next == 'n') word_buffer[word_len++] = '\n';
                    else if (next == 't') word_buffer[word_len++] = '\t';
                    else if (next == 'r') word_buffer[word_len++] = '\r';
                    else word_buffer[word_len++] = next;
                    i++;
                } else {
                    word_buffer[word_len++] = c;
                    i++;
                }
            }
        }

        word_buffer[word_len] = '\0';
        append_token(&stream, TOKEN_TYPE_WORD, word_buffer);
    }

    append_token(&stream, TOKEN_TYPE_END_OF_INPUT, NULL);
    return stream;
}
