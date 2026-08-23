#include "shell.h"
#include "prompt.h"
#include "lexer.h"
#include "parser.h"
#include "executor.h"
#include "builtin_log.h"
#include <unistd.h>

ShellContext shell_ctx;

int main(void) {
    initialize_shell_prompt();

    char raw_input_line[INPUT_BUFFER_MAX];

    while (1) {
        render_shell_prompt();

        if (fgets(raw_input_line, sizeof(raw_input_line), stdin) == NULL) {
            printf("\n");
            break;
        }

        size_t input_length = strlen(raw_input_line);
        if (input_length > 0 && raw_input_line[input_length - 1] == '\n') {
            raw_input_line[input_length - 1] = '\0';
        }

        if (strlen(raw_input_line) == 0) {
            continue;
        }

        log_record_command(raw_input_line);

        ShellTokenStream token_stream = tokenize_input_line(raw_input_line);
        ParsedCommandGroup *parsed_group = parse_command_grammar(&token_stream);

        if (parsed_group != NULL) {
            execute_command_group(parsed_group);
            free_parsed_command_group(parsed_group);
        }

        free_token_stream(&token_stream);
    }

    return 0;
}
