#include "parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Tracks where we are in the token stream
typedef struct {
    const ShellTokenStream *stream;
    size_t cursor;
} GrammarParserState;

// Look at the current token without consuming it
static ShellToken peek_token(const GrammarParserState *state) {
    if (state->cursor < state->stream->tokens_count) {
        return state->stream->tokens_array[state->cursor];
    }
    ShellToken eof_token = {TOKEN_TYPE_END_OF_INPUT, NULL};
    return eof_token;
}

// Consume current token and move cursor forward
static ShellToken advance_token(GrammarParserState *state) {
    ShellToken token = peek_token(state);
    if (state->cursor < state->stream->tokens_count) {
        state->cursor++;
    }
    return token;
}

// Parses a single command along with its arguments and redirection flags
static bool parse_single_command(GrammarParserState *state, ParsedCommand *cmd) {
    cmd->arguments_list = NULL;
    cmd->arguments_count = 0;
    cmd->redirection_config.input_file_redirection = NULL;
    cmd->redirection_config.output_file_redirection = NULL;
    cmd->redirection_config.is_output_append_mode = false;

    size_t arguments_capacity = 0;

    while (true) {
        ShellToken current_token = peek_token(state);

        if (current_token.token_type == TOKEN_TYPE_WORD) {
            advance_token(state);

            // Add argument word to command list
            if (cmd->arguments_count + 1 >= arguments_capacity) {
                if (arguments_capacity == 0) {
                    arguments_capacity = 8;
                } else {
                    arguments_capacity = arguments_capacity * 2;
                }
                cmd->arguments_list = realloc(cmd->arguments_list, arguments_capacity * sizeof(char *));
            }
            cmd->arguments_list[cmd->arguments_count] = strdup(current_token.token_value);
            cmd->arguments_count++;

        } else if (current_token.token_type == TOKEN_TYPE_REDIR_IN) {
            advance_token(state); // consume '<'
            ShellToken file_token = advance_token(state); // next token must be a file name
            if (file_token.token_type != TOKEN_TYPE_WORD) {
                return false;
            }
            if (cmd->redirection_config.input_file_redirection != NULL) {
                free(cmd->redirection_config.input_file_redirection);
            }
            cmd->redirection_config.input_file_redirection = strdup(file_token.token_value);

        } else if (current_token.token_type == TOKEN_TYPE_REDIR_OUT_TRUNC ||
                   current_token.token_type == TOKEN_TYPE_REDIR_OUT_APPEND) {
            bool append_flag = (current_token.token_type == TOKEN_TYPE_REDIR_OUT_APPEND);
            advance_token(state); // consume '>' or '>>'
            ShellToken file_token = advance_token(state); // next token must be a file name
            if (file_token.token_type != TOKEN_TYPE_WORD) {
                return false;
            }
            if (cmd->redirection_config.output_file_redirection != NULL) {
                free(cmd->redirection_config.output_file_redirection);
            }
            cmd->redirection_config.output_file_redirection = strdup(file_token.token_value);
            cmd->redirection_config.is_output_append_mode = append_flag;

        } else {
            // Hit a separator (;, &, |) or EOF
            break;
        }
    }

    // A command must have at least one argument (the command name itself)
    if (cmd->arguments_count == 0) {
        return false;
    }

    // Null-terminate the arguments list for execvp compatibility later
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
        // Skip leading or extra separators (; or &)
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

        // Parse commands connected by pipes '|'
        while (true) {
            ParsedCommand cmd;
            if (!parse_single_command(&state, &cmd)) {
                fprintf(stderr, "Invalid syntax!\n");
                free_parsed_command_group(group);
                return NULL;
            }

            if (current_pipeline.commands_count >= commands_capacity) {
                if (commands_capacity == 0) {
                    commands_capacity = 4;
                } else {
                    commands_capacity = commands_capacity * 2;
                }
                current_pipeline.commands_list = realloc(current_pipeline.commands_list,
                                                         commands_capacity * sizeof(ParsedCommand));
            }
            current_pipeline.commands_list[current_pipeline.commands_count] = cmd;
            current_pipeline.commands_count++;

            // If next token is pipe '|', advance and continue loop
            if (peek_token(&state).token_type == TOKEN_TYPE_PIPE) {
                advance_token(&state);
            } else {
                break;
            }
        }

        // Check how this pipeline ends (& or ;)
        ShellToken terminator_token = peek_token(&state);
        if (terminator_token.token_type == TOKEN_TYPE_AMPERSAND) {
            current_pipeline.is_background_pipeline = true;
            advance_token(&state);
        } else if (terminator_token.token_type == TOKEN_TYPE_SEMICOLON) {
            current_pipeline.is_background_pipeline = false;
            advance_token(&state);
        }

        // Add this pipeline to group
        if (group->pipelines_count >= pipelines_capacity) {
            if (pipelines_capacity == 0) {
                pipelines_capacity = 4;
            } else {
                pipelines_capacity = pipelines_capacity * 2;
            }
            group->pipelines_list = realloc(group->pipelines_list,
                                           pipelines_capacity * sizeof(CommandPipeline));
        }
        group->pipelines_list[group->pipelines_count] = current_pipeline;
        group->pipelines_count++;
    }

    return group;
}

// Pretty prints the parsed tree so you can verify it in terminal
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
            if (cmd->redirection_config.input_file_redirection != NULL) {
                printf("< '%s' ", cmd->redirection_config.input_file_redirection);
            }
            if (cmd->redirection_config.output_file_redirection != NULL) {
                printf("%s '%s' ", cmd->redirection_config.is_output_append_mode ? ">>" : ">",
                       cmd->redirection_config.output_file_redirection);
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
            if (cmd->redirection_config.input_file_redirection != NULL) {
                free(cmd->redirection_config.input_file_redirection);
            }
            if (cmd->redirection_config.output_file_redirection != NULL) {
                free(cmd->redirection_config.output_file_redirection);
            }
        }
        free(pipe->commands_list);
    }
    free(command_group->pipelines_list);
    free(command_group);
}
