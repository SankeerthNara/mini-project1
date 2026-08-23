#ifndef CSHELL_PARSER_H
#define CSHELL_PARSER_H

#include "lexer.h"
#include <stdbool.h>
#include <stddef.h>

typedef struct {
    char *input_file_redirection;
    char *output_file_redirection;
    bool is_output_append_mode;
} RedirectionConfig;

typedef struct {
    char **arguments_list;
    size_t arguments_count;
    RedirectionConfig redirection_config;
} ParsedCommand;

typedef struct {
    ParsedCommand *commands_list;
    size_t commands_count;
    bool is_background_pipeline;
} CommandPipeline;

typedef struct {
    CommandPipeline *pipelines_list;
    size_t pipelines_count;
} ParsedCommandGroup;

ParsedCommandGroup *parse_command_grammar(const ShellTokenStream *token_stream);
void free_parsed_command_group(ParsedCommandGroup *group);

#endif
