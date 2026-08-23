#ifndef CSHELL_BUILTIN_LOG_H
#define CSHELL_BUILTIN_LOG_H

#include "parser.h"

// Logs a raw input line into the history file if it meets the criteria
void log_record_command(const char *raw_command_line);

// Executes the builtin 'log' command variants (print, purge, execute)
int execute_builtin_log(const ParsedCommand *command);

#endif
