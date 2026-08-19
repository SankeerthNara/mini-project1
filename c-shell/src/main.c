#include "shell.h"
#include "prompt.h"


ShellContext shell_ctx;

int main(void) {
    initialize_shell_prompt();

    char raw_input_line[INPUT_BUFFER_MAX];

    while (1) {
        render_shell_prompt();

        if (fgets(raw_input_line, sizeof(raw_input_line), stdin) == NULL) {
            // Clean exit on EOF (Ctrl+D)
            printf("\n");
            break;
        }

        size_t input_length = strlen(raw_input_line);
        if (input_length > 0 && raw_input_line[input_length - 1] == '\n') {
            raw_input_line[input_length - 1] = '\0';
        }

        // Ready for tokenization and parsing in A3
    }

    return 0;
}
