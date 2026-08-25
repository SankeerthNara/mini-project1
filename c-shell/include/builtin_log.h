#ifndef CSHELL_BUILTIN_LOG_H
#define CSHELL_BUILTIN_LOG_H

#include "parser.h"

void log_command_to_history(const char *command_line);
int execute_builtin_log(const ParsedCommand *command);

#endif
