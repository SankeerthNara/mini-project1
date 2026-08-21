#ifndef CSHELL_LEXER_H
#define CSHELL_LEXER_H

#include <stddef.h>

// Different types of tokens our shell can recognize
typedef enum {
    TOKEN_TYPE_WORD,
    TOKEN_TYPE_SEMICOLON,         // ;
    TOKEN_TYPE_AMPERSAND,         // &
    TOKEN_TYPE_PIPE,              // |
    TOKEN_TYPE_REDIR_IN,          // <
    TOKEN_TYPE_REDIR_OUT_TRUNC,   // >
    TOKEN_TYPE_REDIR_OUT_APPEND,  // >>
    TOKEN_TYPE_END_OF_INPUT       // Marks the end of line
} ShellTokenType;

// Represents a single token
typedef struct {
    ShellTokenType token_type;
    char *token_value;
} ShellToken;

// A simple dynamic list of tokens
typedef struct {
    ShellToken *tokens_array;
    size_t tokens_count;
    size_t tokens_capacity;
} ShellTokenStream;

// Functions for breaking a string into tokens
ShellTokenStream tokenize_input_line(const char *raw_input_line);
void free_token_stream(ShellTokenStream *stream);

#endif
