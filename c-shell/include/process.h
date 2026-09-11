#ifndef CSHELL_PROCESS_H
#define CSHELL_PROCESS_H

#include "parser.h"
#include <stdbool.h>

void run_stage(const ParsedCommand *command, size_t index, size_t count,
               const int *pipes, bool background,
               int (*builtin_runner)(const ParsedCommand *));

#endif
