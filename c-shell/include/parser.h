#ifndef CSHELL_PARSER_H
#define CSHELL_PARSER_H

#include "lexer.h"
#include <stdbool.h>
#include <stddef.h>

typedef struct {
    char *filename;
    bool is_append;
} OutputRedirectionTarget;

typedef struct {
    char **input_files;
    size_t input_files_count;
    OutputRedirectionTarget *output_files;
    size_t output_files_count;
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

ParsedCommandGroup* parse_command_grammar(const ShellTokenStream *tokens_stream);
void print_parsed_command_group(const ParsedCommandGroup *group);
void free_parsed_command_group(ParsedCommandGroup *command_group);

#endif
