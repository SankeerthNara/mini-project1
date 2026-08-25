#ifndef CSHELL_BUILTIN_PEEK_H
#define CSHELL_BUILTIN_PEEK_H

#include "parser.h"

// Executes the 'peek' command with line numbering (-n) and reverse order (-r)
int execute_builtin_peek(const ParsedCommand *command);

#endif
