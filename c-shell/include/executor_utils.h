#ifndef CSHELL_EXECUTOR_UTILS_H
#define CSHELL_EXECUTOR_UTILS_H

#include "parser.h"
#include <stdbool.h>

bool is_builtin_command(const char *name);
int run_builtin_command(const ParsedCommand *command);
char *resolve_binary(const char *name);

#endif
