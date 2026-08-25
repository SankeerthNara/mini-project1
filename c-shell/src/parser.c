#include "parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    const ShellTokenStream *stream;
    size_t cursor;
} GrammarParserState;

static ShellToken peek_token(const GrammarParserState *state) {
    if (state->cursor < state->stream->tokens_count) {
        return state->stream->tokens_array[state->cursor];
    }
    ShellToken eof_token = {TOKEN_TYPE_END_OF_INPUT, NULL};
    return eof_token;
}

static ShellToken advance_token(GrammarParserState *state) {
    ShellToken token = peek_token(state);
    if (state->cursor < state->stream->tokens_count) {
        state->cursor++;
    }
    return token;
}

static bool parse_single_command(GrammarParserState *state, ParsedCommand *cmd) {
    cmd->arguments_list = NULL;
    cmd->arguments_count = 0;
    cmd->redirection_config.input_files = NULL;
    cmd->redirection_config.input_files_count = 0;
    cmd->redirection_config.output_files = NULL;
    cmd->redirection_config.output_files_count = 0;

    size_t arguments_capacity = 0;
    size_t input_capacity = 0;
    size_t output_capacity = 0;

    while (true) {
        ShellToken current_token = peek_token(state);

        if (current_token.token_type == TOKEN_TYPE_WORD) {
            advance_token(state);

            if (cmd->arguments_count + 1 >= arguments_capacity) {
                arguments_capacity = (arguments_capacity == 0) ? 8 : arguments_capacity * 2;
                cmd->arguments_list = realloc(cmd->arguments_list, arguments_capacity * sizeof(char *));
            }
            cmd->arguments_list[cmd->arguments_count] = strdup(current_token.token_value);
            cmd->arguments_count++;

        } else if (current_token.token_type == TOKEN_TYPE_REDIR_IN) {
            advance_token(state);
            ShellToken file_token = advance_token(state);
            if (file_token.token_type != TOKEN_TYPE_WORD) {
                return false;
            }
            if (cmd->redirection_config.input_files_count >= input_capacity) {
                input_capacity = (input_capacity == 0) ? 4 : input_capacity * 2;
                cmd->redirection_config.input_files = realloc(cmd->redirection_config.input_files,
                                                              input_capacity * sizeof(char *));
            }
            cmd->redirection_config.input_files[cmd->redirection_config.input_files_count] = strdup(file_token.token_value);
            cmd->redirection_config.input_files_count++;

        } else if (current_token.token_type == TOKEN_TYPE_REDIR_OUT_TRUNC ||
                   current_token.token_type == TOKEN_TYPE_REDIR_OUT_APPEND) {
            bool append_flag = (current_token.token_type == TOKEN_TYPE_REDIR_OUT_APPEND);
            advance_token(state);
            ShellToken file_token = advance_token(state);
            if (file_token.token_type != TOKEN_TYPE_WORD) {
                return false;
            }
            if (cmd->redirection_config.output_files_count >= output_capacity) {
                output_capacity = (output_capacity == 0) ? 4 : output_capacity * 2;
                cmd->redirection_config.output_files = realloc(cmd->redirection_config.output_files,
                                                               output_capacity * sizeof(OutputRedirectionTarget));
            }
            cmd->redirection_config.output_files[cmd->redirection_config.output_files_count].filename = strdup(file_token.token_value);
            cmd->redirection_config.output_files[cmd->redirection_config.output_files_count].is_append = append_flag;
            cmd->redirection_config.output_files_count++;

        } else {
            break;
        }
    }

    if (cmd->arguments_count == 0) {
        return false;
    }

    cmd->arguments_list = realloc(cmd->arguments_list, (cmd->arguments_count + 1) * sizeof(char *));
    cmd->arguments_list[cmd->arguments_count] = NULL;
    return true;
}

ParsedCommandGroup* parse_command_grammar(const ShellTokenStream *tokens_stream) {
    if (tokens_stream == NULL || tokens_stream->tokens_count <= 1) {
        return NULL;
    }

    GrammarParserState state;
    state.stream = tokens_stream;
    state.cursor = 0;

    ParsedCommandGroup *group = calloc(1, sizeof(ParsedCommandGroup));
    size_t pipelines_capacity = 0;

    while (peek_token(&state).token_type != TOKEN_TYPE_END_OF_INPUT) {
        if (peek_token(&state).token_type == TOKEN_TYPE_SEMICOLON ||
            peek_token(&state).token_type == TOKEN_TYPE_AMPERSAND) {
            advance_token(&state);
            continue;
        }

        CommandPipeline current_pipeline;
        current_pipeline.commands_list = NULL;
        current_pipeline.commands_count = 0;
        current_pipeline.is_background_pipeline = false;

        size_t commands_capacity = 0;

        while (true) {
            ParsedCommand cmd;
            if (!parse_single_command(&state, &cmd)) {
                fprintf(stderr, "Invalid syntax!\n");
                free_parsed_command_group(group);
                return NULL;
            }

            if (current_pipeline.commands_count >= commands_capacity) {
                commands_capacity = (commands_capacity == 0) ? 4 : commands_capacity * 2;
                current_pipeline.commands_list = realloc(current_pipeline.commands_list,
                                                         commands_capacity * sizeof(ParsedCommand));
            }
            current_pipeline.commands_list[current_pipeline.commands_count] = cmd;
            current_pipeline.commands_count++;

            if (peek_token(&state).token_type == TOKEN_TYPE_PIPE) {
                advance_token(&state);
            } else {
                break;
            }
        }

        ShellToken terminator_token = peek_token(&state);
        if (terminator_token.token_type == TOKEN_TYPE_AMPERSAND) {
            current_pipeline.is_background_pipeline = true;
            advance_token(&state);
        } else if (terminator_token.token_type == TOKEN_TYPE_SEMICOLON) {
            current_pipeline.is_background_pipeline = false;
            advance_token(&state);
        }

        if (group->pipelines_count >= pipelines_capacity) {
            pipelines_capacity = (pipelines_capacity == 0) ? 4 : pipelines_capacity * 2;
            group->pipelines_list = realloc(group->pipelines_list,
                                           pipelines_capacity * sizeof(CommandPipeline));
        }
        group->pipelines_list[group->pipelines_count] = current_pipeline;
        group->pipelines_count++;
    }

    return group;
}

void print_parsed_command_group(const ParsedCommandGroup *group) {
    if (group == NULL) return;

    for (size_t i = 0; i < group->pipelines_count; i++) {
        const CommandPipeline *pipe = &group->pipelines_list[i];
        printf("[Pipeline %zu] (Background: %s)\n", i + 1, pipe->is_background_pipeline ? "yes" : "no");

        for (size_t j = 0; j < pipe->commands_count; j++) {
            const ParsedCommand *cmd = &pipe->commands_list[j];
            printf("  Command %zu: ", j + 1);
            for (size_t k = 0; k < cmd->arguments_count; k++) {
                printf("'%s' ", cmd->arguments_list[k]);
            }
            for (size_t in = 0; in < cmd->redirection_config.input_files_count; in++) {
                printf("< '%s' ", cmd->redirection_config.input_files[in]);
            }
            for (size_t out = 0; out < cmd->redirection_config.output_files_count; out++) {
                printf("%s '%s' ", cmd->redirection_config.output_files[out].is_append ? ">>" : ">",
                       cmd->redirection_config.output_files[out].filename);
            }
            printf("\n");
        }
    }
}

void free_parsed_command_group(ParsedCommandGroup *command_group) {
    if (command_group == NULL) {
        return;
    }
    for (size_t i = 0; i < command_group->pipelines_count; i++) {
        CommandPipeline *pipe = &command_group->pipelines_list[i];
        for (size_t j = 0; j < pipe->commands_count; j++) {
            ParsedCommand *cmd = &pipe->commands_list[j];
            for (size_t k = 0; k < cmd->arguments_count; k++) {
                free(cmd->arguments_list[k]);
            }
            free(cmd->arguments_list);

            for (size_t in = 0; in < cmd->redirection_config.input_files_count; in++) {
                free(cmd->redirection_config.input_files[in]);
            }
            free(cmd->redirection_config.input_files);

            for (size_t out = 0; out < cmd->redirection_config.output_files_count; out++) {
                free(cmd->redirection_config.output_files[out].filename);
            }
            free(cmd->redirection_config.output_files);
        }
        free(pipe->commands_list);
    }
    free(command_group->pipelines_list);
    free(command_group);
}
