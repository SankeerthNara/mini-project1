#ifndef CSHELL_REDIRECTION_H
#define CSHELL_REDIRECTION_H

#include "parser.h"

int input_redirect(const ParsedCommand *command);
int open_outputs(const ParsedCommand *command, int **fds);
int copy_to_outputs(int input_fd, const ParsedCommand *command, int *fds);
int builtin_redirected(const ParsedCommand *command,
                       int (*builtin_runner)(const ParsedCommand *));

#endif
