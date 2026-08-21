#ifndef CSHELL_PARSER_H
#define CSHELL_PARSER_H

#include "lexer.h"
#include <stdbool.h>

// Stores file redirection filenames (<, >, >>)
typedef struct {
    char *input_file_redirection;
    char *output_file_redirection;
    bool is_output_append_mode;
} IORedirection;

// Represents a single command with its arguments and redirections
typedef struct {
    char **arguments_list;
    size_t arguments_count;
    IORedirection redirection_config;
} ParsedCommand;

// Represents piped commands (e.g., cmd1 | cmd2)
typedef struct {
    ParsedCommand *commands_list;
    size_t commands_count;
    bool is_background_pipeline; // true if ends with '&'
} CommandPipeline;

// Represents the whole line (commands separated by ';' or '&')
typedef struct {
    CommandPipeline *pipelines_list;
    size_t pipelines_count;
} ParsedCommandGroup;

ParsedCommandGroup* parse_command_grammar(const ShellTokenStream *tokens_stream);
void print_parsed_command_group(const ParsedCommandGroup *group);
void free_parsed_command_group(ParsedCommandGroup *command_group);

#endif
